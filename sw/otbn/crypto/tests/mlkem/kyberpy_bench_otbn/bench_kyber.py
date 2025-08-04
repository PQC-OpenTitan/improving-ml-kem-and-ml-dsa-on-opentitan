# Copyright "Towards ML-KEM & ML-DSA on OpenTitan" Authors
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import os
from multiprocessing import Pool
import sqlite3
import time

from kyberpy.src.kyber_py.ml_kem import ML_KEM_512, ML_KEM_768, ML_KEM_1024
from otbn_interface import mlkem_keypair_otbn, mlkem_encaps_otbn, mlkem_decaps_otbn
from create_db import create_db

NPROC = 1
ITERATIONS = 1

DATABASE_PATH = os.path.realpath(os.path.dirname(os.path.realpath(__file__)) +
                                 '../../../../../../../kyber_bench.db')

def bench_mlkem_keypair(operation, ref):
    d = os.urandom(32)
    z = os.urandom(32)

    ek, dk = ref._keygen_internal(d, z)

    ek_otbn, dk_otbn, stat_data = mlkem_keypair_otbn(d + z, operation)

    if ek != ek_otbn:
        print("Error: Encaps key do not match!!!")
        print(ek)
        print(ek_otbn)
        return -1
    if dk != dk_otbn:
        print("Error: Decaps keys do not match!!!")
        print(dk)
        print(dk_otbn)
        return -1
    print("Iteration done")

    return stat_data


def bench_mlkem_encaps(operation, ref):
    d = os.urandom(32)
    z = os.urandom(32)
    m = os.urandom(32)

    ek, dk = ref._keygen_internal(d, z)
    K, c = ref._encaps_internal(ek, m)

    c_otbn, K_otbn, stat_data = mlkem_encaps_otbn(m, ek, operation)

    if c != c_otbn:
        print("Error: Ciphertext does not match!!!")
        print(c)
        print(c_otbn)
        return -1
    if K != K_otbn:
        print("Error: Key does not match!!!")
        print(K)
        print(K_otbn)
        return -1
    print("Iteration done")

    return stat_data


def bench_mlkem_decaps(operation, ref):
    d = os.urandom(32)
    z = os.urandom(32)
    m = os.urandom(32)

    ek, dk = ref._keygen_internal(d, z)
    K, c = ref._encaps_internal(ek, m)
    K_prime = ref.decaps(dk, c)

    K_prime_otbn, stat_data = mlkem_decaps_otbn(c, dk, operation)

    if K_prime != K_prime_otbn:
        print("Error: Shared key does not match!!!")
        print(K_prime)
        print(K_prime_otbn)
        return -1
    print("Iteration done")

    return stat_data


def run_bench(operation: str):
    if __name__ == "sw.otbn.crypto.tests.mlkem.kyberpy_bench_otbn.bench_kyber":
        print(DATABASE_PATH)
        con = sqlite3.connect(DATABASE_PATH)
        cur = con.cursor()
        create_db(cur)
        print(f"Benchmark {operation}")

        # select funciton
        if "keypair" in operation:
            func = bench_mlkem_keypair
        elif "encap" in operation:
            func = bench_mlkem_encaps
        elif "decap" in operation:
            func = bench_mlkem_decaps
        else:
            print("No function detected")
            exit(-1)

        if "mlkem512" in operation:
            ref_func = ML_KEM_512
        elif "mlkem768" in operation:
            ref_func = ML_KEM_768
        elif "mlkem1024" in operation:
            ref_func = ML_KEM_1024
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
