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

from hw_model import reference_non_vector_adder, mask
from constants import WLEN

@cocotb.test()
async def run_non_vector_adder_test(dut):
    """Run reference_non_vector_adder and all non-vector adders on same inputs
       and compare their results.
    """
    num_tests = int(os.environ.get("NUM_TESTS", 1024))
    for _ in range(num_tests):
        addition = int(os.environ.get("ADDITION"))

        # Generate random inputs
        a = random.getrandbits(WLEN)
        b = random.getrandbits(WLEN)

        # If testing subtraction, we negate b before passing it to the reference model and DUT.
        if not addition:
            b = mask(~b, WLEN)

        # If testing subtraction, cin = 1.
        cin = ~addition & 1

        # Assign inputs
        dut.A.value = a
        dut.B.value = b
        dut.cin.value = cin

        await Timer(1, units="ns")  # allow evaluation

        # Get expected results
        sum_expected, cout_expected = reference_non_vector_adder(a, b, cin)
        # Get actual results
        sum_actual = dut.res.value.integer
        cout_actual = dut.cout.value.integer

        print(f"a: {format(a, '064x')}")
        print(f"b: {format(b, '064x')}")
        print(f"addition: {addition}")
        print(f"cin: {cin}")

        assert sum_actual == sum_expected, (
            "ERROR SUM:\n"
            f"sum_act = {format(sum_actual, '064x')}\n"
            f"sum_exp = {format(sum_expected, '064x')}\n"
        )

        assert cout_actual == cout_expected, (
            f"ERROR COUT: {bin(cout_expected)} != {bin(cout_actual)}"
        )

# === Pytest hook ===

ADDERS = [
    "ref_add",
    "brent_kung_256",
    "sklansky_256",
    "kogge_stone_256"
]

@pytest.mark.parametrize(
    "variant, addition",
    [(adder, a) for a in [0, 1] for adder in ADDERS]
)

def test_non_vector_adder_sim(variant, addition):
    """Run different testcases on simulated design.
    """
    num_tests = 4096
    run(
        toplevel=variant,
        module="test_non_vector_adder_pytest",
        toplevel_lang="verilog",
        testcase="run_non_vector_adder_test",
        simulator="verilator",
        sim_build=f"sim_build/{variant}",
        verilog_sources=[f"bn_vec_core/{variant}.sv"],
        extra_env={
            "ADDITION": str(addition),
            "NUM_TESTS": str(num_tests)
        },
        #waves=True,
        #plus_args=["--trace"]  # enable trace all in verilator simulation
    )
