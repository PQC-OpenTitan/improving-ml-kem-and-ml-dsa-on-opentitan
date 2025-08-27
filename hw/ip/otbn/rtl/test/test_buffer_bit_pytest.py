import os
import random
import pytest
import cocotb
from cocotb_test.simulator import run
from cocotb.triggers import Timer

from hw_model import reference_vector_addition
from hw_model import VecType

@cocotb.test()
async def run_buffer_bit_test(dut):
    """Run reference_vector_addition and buffer_bit module on the same inputs
    and compare the results."""
    num_tests = int(os.environ.get("NUM_TESTS", 1024))
    for _ in range(num_tests):
        word_mode = VecType(int(os.environ.get("WORD_MODE")))
        addition = int(os.environ.get("ADDITION"))

        random.seed(0)  # For reproducibility
        in_a = random.getrandbits(256)
        in_b = random.getrandbits(256)
        print(f"in_b: {format(in_b, '064x')}")
        if not addition:
            in_b = ~in_b & ((1 << 256) - 1)
        cin = ~addition & 1
        b_invert = 0 if addition else 1

        # Assign inputs
        dut.A.value = in_a
        dut.B.value = in_b
        dut.word_mode.value = word_mode
        dut.b_invert.value = b_invert
        dut.cin.value = cin

        await Timer(1, units="ns")  # allow evaluation

        # Get result
        sum_expected = reference_vector_addition(in_a, in_b, addition, word_mode)
        sum_expected = reference_vector_addition(in_a, in_b, addition, word_mode)
        sum_out = dut.res.value.integer
        sum_out = sum_out & ((1 << 256) - 1)

        print(f"in_a: {format(in_a, '064x')}")
        print(f"in_b: {format(in_b, '064x')}")
        print(f"word_mode: {word_mode}")
        print(f"addition: {addition}")
        print(f"b_invert: {b_invert}")
        print(f"cin: {cin}")
        print(f"sum_expected: {format(sum_expected, '064x')}")
        print(f"sum out:      {format(sum_out, '064x')}")

        num_words = 1
        mask = (1 << 256) - 1
        size = 256
        if word_mode == VecType.h16:
            num_words = 16
            mask = (1 << 16) - 1
            size = 16
        elif word_mode == VecType.s32:
            num_words = 8
            mask = (1 << 32) - 1
            size = 32
        elif word_mode == VecType.d64:
            num_words = 4
            mask = (1 << 64) - 1
            size = 64

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
    [("buffer_bit", i, a) for a in [0,1] for i in [VecType.h16, VecType.s32, VecType.d64, VecType.v256]] +
    [("brent_kung", i, a) for a in [0,1] for i in [VecType.h16, VecType.s32, VecType.d64, VecType.v256]] +
    [("sklansky", i, a) for a in [0,1] for i in [VecType.h16, VecType.s32, VecType.d64, VecType.v256]]
)
def test_buffer_bit_sim(variant, word_mode, addition):
    """Run buffer_bit test with different testcases."""
    num_tests = 4096

    verilog_pkgs = ["../../prim/rtl/prim_mubi_pkg.sv",
                    "../../prim/rtl/prim_secded_pkg.sv",
                    "../../prim/rtl/prim_util_pkg.sv",
                    "../../lc_ctrl/rtl/lc_ctrl_state_pkg.sv",
                    "../../lc_ctrl/rtl/lc_ctrl_reg_pkg.sv",
                    "../../lc_ctrl/rtl/lc_ctrl_pkg.sv",
                    "../../otp_ctrl/rtl/otp_ctrl_pkg.sv",
                    "otbn_pkg.sv"]

    run(
        toplevel=variant,
        module="test_buffer_bit_pytest",
        toplevel_lang="verilog",
        testcase="run_buffer_bit_test",
        simulator="verilator",
        sim_build=f"sim_build/{variant}-{addition}",
        extra_args=["-I../../../../prim/rtl/",
                    "-I../../../../otp_ctrl/rtl/",
                    "-I../../../../prim_generic/rtl/",
                    "-DBNMULV"],
        verilog_sources=verilog_pkgs + [f"bn_vec_core/{variant}.sv"],
        extra_env={
            "WORD_MODE": str(int(word_mode)),
            "ADDITION":  str(addition),
            "NUM_TESTS": str(num_tests)
        },
        #waves=True,
        #plus_args=["--trace"]  # enable trace all in verilator simulation
    )
