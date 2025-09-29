# Copyright "Towards ML-KEM & ML-DSA on OpenTitan" Authors
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import os
from multiprocessing import Pool
import sqlite3
import time
from dilithiumpy.src.dilithium_py.ml_dsa.default_parameters import ML_DSA_44, ML_DSA_65, ML_DSA_87
from otbn_interface import key_pair_otbn, sign_otbn, verify_otbn
from create_db import create_db

NPROC = 1
ITERATIONS = 1

CTX=b"\x00"*4+b"\x11"*4+b"\x22"*4+b"\x33"*4+b"\x44"*4+b"\x55"*4+b"\x66"*4+b"\x77"*4
CTXLEN = 32

DATABASE_PATH = os.path.realpath(os.path.dirname(os.path.realpath(__file__)) +
                                 '../../../../../../../mldsa_bench.db')


def bench_key_pair(operation, ref):
    rand = os.urandom(32)
    # reference computation
    # use internal keygen to pass randomness
    pk, sk = ref._keygen_internal(rand)
    pk_otbn, sk_otbn, stat_data = key_pair_otbn(rand, operation)

    if pk != pk_otbn:
        print("Error: pks dont match!!!")
        print(pk.hex())
        print(pk_otbn.hex())
        print(f"rand = {rand}")
        return -1
    if sk != sk_otbn:
        print("Error: sks dont match!!!")
        print(sk.hex())
        print(sk_otbn.hex())
        print(f"rand = {rand}")
        return -1
    print("Iteration done")
    return stat_data


def bench_sign(operation, ref):
    rand = os.urandom(32)
    msg = os.urandom(64)
    # reference keys
    # use internal keygen to pass randomness
    _, sk = ref._keygen_internal(rand)
    # reference computation
    sig = None
    sig_otbn = None

    sig = ref.sign(sk, msg, ctx=CTX, deterministic=True)
    sig_otbn, _, _, stat_data = sign_otbn(sk, msg, operation)

    if sig != sig_otbn:
        print(rand)
        print(msg)
        print("Error: sigs do not match!!!")
        print(sig.hex())
        print(sig_otbn.hex())
        return -1
    print("Iteration done")
    return stat_data


def bench_verify(operation, ref):
    rand = os.urandom(32)
    msg = os.urandom(64)
    # reference keys
    # use internal keygen to pass randomness
    pk, sk = ref._keygen_internal(rand)
    # reference signature
    sig = ref.sign(sk, msg, ctx=CTX, deterministic=True)

    # reference computation
    verify_out = ref.verify(pk, msg, sig, ctx=CTX)

    verify_out_otbn, stat_data = verify_otbn(pk, msg, sig, operation)

    if verify_out != verify_out_otbn:
        print("Error: verify results do not match!!!")
        print(rand)
        print(msg)
        print(verify_out)
        print(verify_out_otbn)
        return -1
    print("Iteration done")
    return stat_data


def run_bench(operation: str):
    if __name__ == "sw.otbn.crypto.tests.mldsa.dilithiumpy_bench_otbn.bench_dilithium":
        con = sqlite3.connect(DATABASE_PATH)
        cur = con.cursor()
        create_db(cur)
        print(f"Benchmark {operation}")

        # select funciton
        if "keypair" in operation:
            func = bench_key_pair
        elif "sign" in operation:
            func = bench_sign
        elif "verify" in operation:
            func = bench_verify
        else:
            print("No function detected")
            exit(-1)
        
        if "mldsa44" in operation:
            ref_func = ML_DSA_44
        elif "mldsa65" in operation:
            ref_func = ML_DSA_65
        elif "mldsa87" in operation:
            ref_func = ML_DSA_87
        else:
            print("No ref function detected")
            exit(-1)

        results = []
        start_time = int(time.time())
        for _ in range(ITERATIONS // NPROC):
            with Pool(NPROC) as p:
                results += p.starmap(func, [(operation, ref_func)]*NPROC)
        end_time = int(time.time())

        if -1 in results:
            print("Error in Computation")
            exit(-1)

        cur.execute(f"INSERT INTO benchmark (start_time, end_time, iterations, operation) VALUES({start_time}, {end_time}, {ITERATIONS}, '{operation}')")
        current_benchmark_id = cur.lastrowid
        for result in results:
            if result == -1:
                continue
            cur.execute(f"INSERT INTO benchmark_iteration (benchmark_id) VALUES({current_benchmark_id})")
            current_benchmark_iteration_id = cur.lastrowid
            cur.execute(f"INSERT INTO cycles (cycles, benchmark_iteration_id) VALUES({result['insn_count'] + result['stall_count']}, {current_benchmark_iteration_id})")
            cur.execute(f"INSERT INTO stalls (stalls, benchmark_iteration_id) VALUES({result['stall_count']}, {current_benchmark_iteration_id})")
            for func_name, per_instr_data in result["func_instrs"].items():
                for instr_name, cyc_stall in per_instr_data.items():
                    cur.execute(f"INSERT INTO func_instrs (func_name, instr_name, instr_count, stall_count, benchmark_iteration_id) VALUES('{func_name}', '{instr_name}', {cyc_stall[0]}, {cyc_stall[1]}, {current_benchmark_iteration_id})")
            for callee_func_name, caller_data in result["func_calls"].items():
                for caller_func_name, call_count in caller_data.items():
                    cur.execute(f"INSERT INTO func_calls (caller_func_name, callee_func_name, call_count, benchmark_iteration_id) VALUES('{caller_func_name}', '{callee_func_name}', {call_count}, {current_benchmark_iteration_id})")
        con.commit()
