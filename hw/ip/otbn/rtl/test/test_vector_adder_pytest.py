# Copyright Ruben Niederhagen and Hoang Nguyen Hien Pham - authors of
# "Improving ML-KEM & ML-DSA on OpenTitan - Efficient Multiplication Vector Instructions for OTBN"
# (https://eprint.iacr.org/2025/2028)
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import os
import random
import pytest
import cocotb
from cocotb_test.simulator import run
from cocotb.triggers import Timer

from hw_model import reference_vector_adder, mask
from constants import VecType
from constants import WLEN, DLEN, SLEN, HLEN

@cocotb.test()
async def run_vector_adder_test(dut):
    """Run reference_vector_adder and all vector adders on same inputs and compare their results.
    """
    num_tests = int(os.environ.get("NUM_TESTS", 1024))
    for _ in range(num_tests):
        word_mode = VecType(int(os.environ.get("WORD_MODE")))
        addition = int(os.environ.get("ADDITION"))

        # Generate random inputs
        a = random.getrandbits(WLEN)
        b = random.getrandbits(WLEN)
        print(f"b: {format(b, '064x')}")

        # If testing subtraction, we negate b before passing it to reference model and DUT.
        if not addition:
            b = mask(~b, WLEN)

        # If testing subtraction, cin = 1.
        cin = ~addition & 1

        # Assign inputs
        dut.A.value = a
        dut.B.value = b
        dut.word_mode.value = word_mode
        dut.cin.value = cin

        await Timer(1, units="ns")  # allow evaluation

        # Get expected results
        cout_expected, sum_expected  = reference_vector_adder(a, b, addition, word_mode)
        # Get actual results
        sum_actual = mask(dut.res.value.integer, WLEN)
        cout_actual = dut.cout.value.integer

        print(f"a: {format(a, '064x')}")
        print(f"b: {format(b, '064x')}")
        print(f"word_mode: {word_mode}")
        print(f"addition: {addition}")
        print(f"cin: {cin}")

        if word_mode == VecType.H16:
            size = HLEN
            num_words = WLEN // HLEN
        elif word_mode == VecType.S32:
            size = SLEN
            num_words = WLEN // SLEN
            cout_actual = sum(((cout_actual >> (i * 2 + 1)) & 1) << i for i in range(num_words))
        elif word_mode == VecType.D64:
            size = DLEN
            num_words = WLEN // DLEN
            cout_actual = sum(((cout_actual >> (i * 4 + 3)) & 1) << i for i in range(num_words))
        else: # word_mode == VecType.V256
            size = WLEN
            num_words = WLEN // WLEN
            cout_actual = cout_actual >> 15

        hex_size = size >> 2
        for i in range(num_words):
            exp = mask(sum_expected >> (i * size), size)
            act = mask(sum_actual >> (i * size), size)
            assert act == exp, (
                f"ERROR SUM: mismatch at word {i}: "
                f"actual={format(act, f'0{hex_size}x')} expected={format(exp, f'0{hex_size}x')}\n"
                f"sum_act = {format(sum_actual, '064x')}\n"
                f"sum_exp = {format(sum_expected, '064x')}\n"
            )

        assert cout_expected == cout_actual, (
            f"ERROR COUT: {bin(cout_expected)} != {bin(cout_actual)}"
        )

# === Pytest hook ===

ADDERS = [
    "buffer_bit",
    "brent_kung",
    "sklansky",
    "kogge_stone",
    "csa_carry4"
]

@pytest.mark.parametrize(
    "variant, word_mode, addition",
    [
        (adder, i, a) for a in [0, 1]
        for i in [VecType.H16, VecType.S32, VecType.D64, VecType.V256] for adder in ADDERS
    ]
)

def test_vector_adder_sim(variant, word_mode, addition):
    """Run different testcases on simulated design.
    """
    num_tests = 4096

    verilog_pkgs = [
        "../../prim/rtl/prim_mubi_pkg.sv",
        "../../prim/rtl/prim_secded_pkg.sv",
        "../../prim/rtl/prim_util_pkg.sv",
        "../../lc_ctrl/rtl/lc_ctrl_state_pkg.sv",
        "../../lc_ctrl/rtl/lc_ctrl_reg_pkg.sv",
        "../../lc_ctrl/rtl/lc_ctrl_pkg.sv",
        "../../otp_ctrl/rtl/otp_ctrl_pkg.sv",
        "otbn_pkg.sv"
    ]

    vivado_prim = [
        "bn_vec_core/CARRY4.v",
        "bn_vec_core/LUT6_2.v"
    ]

    extra_args = [
        "-I../../../../prim/rtl/",
        "-I../../../../otp_ctrl/rtl/",
        "-I../../../../prim_generic/rtl/"
    ]

    run(
        toplevel=variant,
        module="test_vector_adder_pytest",
        toplevel_lang="verilog",
        testcase="run_vector_adder_test",
        simulator="verilator",
        sim_build=f"sim_build/{variant}-{addition}",
        extra_args=extra_args,
        verilog_sources=verilog_pkgs + vivado_prim + [f"bn_vec_core/{variant}.sv"],
        extra_env={
            "WORD_MODE": str(int(word_mode)),
            "ADDITION":  str(addition),
            "NUM_TESTS": str(num_tests)
        },
        # waves=True,
        # plus_args=["--trace"]  # enable trace all in verilator simulation
    )
