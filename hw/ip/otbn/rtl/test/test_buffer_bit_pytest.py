import os
import random
import pytest
import cocotb
from cocotb_test.simulator import run
from cocotb.triggers import Timer

from hw_model import reference_vector_addition

MODE_32 = 0
MODE_16 = 1
MODE_256 = 2


@cocotb.test()
async def run_buffer_bit_test(dut):
    """Run reference_vector_addition and buffer_bit module on the same inputs
    and compare the results."""
    num_tests = int(os.environ.get("NUM_TESTS", 1024))
    for _ in range(num_tests):
        word_mode = int(os.environ.get("WORD_MODE"))
        addition = int(os.environ.get("ADDITION"))

        vector_en = 0 if word_mode == MODE_256 else 1
        vector_type = 0 if word_mode == MODE_32 else 1

        random.seed(0)  # For reproducibility
        in_a = random.getrandbits(256)
        in_b = random.getrandbits(256)
        if not addition:
            in_b = ~in_b & ((1 << 256) - 1)
        print(f"in_b: {format(in_b, '064x')}")
        cin = ~addition & 1
        b_invert = 0 if addition else 1

        # Assign inputs
        dut.A.value = in_a
        dut.B.value = in_b
        dut.vector_en.value = vector_en
        dut.word_mode.value = vector_type
        dut.b_invert.value = b_invert
        dut.cin.value = cin

        await Timer(1, units="ns")  # allow evaluation

        # Get result
        sum_expected = reference_vector_addition(in_a, in_b, addition, word_mode)
        sum_expected = reference_vector_addition(in_a, in_b, addition, word_mode)
        sum_out = dut.sum.value.integer
        sum_out = (sum_out >> 1) & ((1 << 256) - 1)

        print(f"in_a: {format(in_a, '064x')}")
        print(f"in_b: {format(in_b, '064x')}")
        print(f"vector_en: {vector_en}")
        print(f"vector_type: {vector_type}")
        print(f"word_mode: {word_mode}")
        print(f"addition: {addition}")
        print(f"b_invert: {b_invert}")
        print(f"cin: {cin}")
        print(f"sum_expected: {format(sum_expected, '064x')}")
        print(f"sum out:      {format(sum_out, '064x')}")

        num_words = 1
        mask = (1 << 256) - 1
        size = 256
        if word_mode == MODE_32:
            num_words = 8
            mask = (1 << 32) - 1
            size = 32
        elif word_mode == MODE_16:
            num_words = 16
            mask = (1 << 16) - 1
            size = 16

        for i in range(num_words):
            exp = (sum_expected >> (i * size)) & mask
            act = (sum_out >> (i * size)) & mask
            assert act == exp, (
                f"sum mismatch at word {i}: A={format(in_a, '064x')} B={format(in_b, '064x')}\n"
                f"expected={format(exp, '08x')} actual={format(act, '08x')}\n"
            )

# === Pytest hook ===

@pytest.mark.parametrize(
    "variant, word_mode, addition",
    [("buffer_bit", i, 1) for i in [MODE_16, MODE_32, MODE_256]] +
    [("buffer_bit", i, 0) for i in [MODE_16, MODE_32, MODE_256]]
)
def test_cond_sub_sim(variant, word_mode, addition):
    """Run buffer_bit test with different testcases."""
    num_tests = 4096
    run(
        toplevel="buffer_bit",
        module="test_buffer_bit_pytest",
        toplevel_lang="verilog",
        testcase="run_buffer_bit_test",
        simulator="verilator",
        sim_build=f"sim_build/{variant}-{addition}",
        verilog_sources=[f"bn_vec_core/{variant}.sv"],
        extra_env={
            "WORD_MODE": str(word_mode),
            "ADDITION": str(addition),
            "NUM_TESTS": str(num_tests)
        },
        #waves=True,
        #plus_args=["--trace"]  # enable trace all in verilator simulation
    )
