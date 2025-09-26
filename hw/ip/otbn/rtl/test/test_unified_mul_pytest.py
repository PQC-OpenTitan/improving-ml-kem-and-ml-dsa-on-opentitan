import os
from random import randint, getrandbits

import cocotb
from cocotb_test.simulator import run
from cocotb.triggers import Timer
import pytest

from hw_model import reference_prod, mask
from constants import ModeMul
from constants import WLEN, DLEN, SLEN, HLEN


@cocotb.test()
async def run_unified_mul_test(dut):
    """Run reference_prod and the unified multiplier on same inputs and compare their results.
    """
    num_tests = int(os.environ.get("NUM_TESTS", 1024))
    for _ in range(num_tests):
        word_mode = int(os.environ.get("WORD_MODE"))
        acch_en = int(os.environ.get("BNMULV_ACCH"))

        # Generate random inputs
        a = getrandbits(WLEN)
        b = getrandbits(WLEN)
        word_sel_a = randint(0, 3)
        word_sel_b = randint(0, 3)
        half_sel = randint(0, 1)
        lane_mode = randint(0, 1) if word_mode != 0b00 else 0
        lane_word_32 = randint(0, 1)
        lane_word_16 = randint(0, 1)
        data_type_64_shift = randint(0, 3)
        exec_mode = randint(0, 2)

        # Assign inputs
        dut.word_mode.value = word_mode
        dut.word_sel_A.value = word_sel_a
        dut.word_sel_B.value = word_sel_b
        dut.half_sel.value = half_sel
        dut.lane_mode.value = lane_mode
        dut.lane_word_32.value = lane_word_32
        dut.lane_word_16.value = lane_word_16
        dut.A.value = a
        dut.B.value = b
        dut.data_type_64_shift.value = data_type_64_shift
        if acch_en:
            dut.exec_mode.value = exec_mode

        await Timer(1, units="ns")  # allow evaluation

        # Get expected result
        prod_expected = reference_prod(
            a, b, word_mode, word_sel_a, word_sel_b,
            half_sel, lane_mode, lane_word_32, lane_word_16, data_type_64_shift,
            acch_en, exec_mode
        )
        # Get actual result
        result = int(dut.result.value)

        print(f"a: {format(a, '064x')}")
        print(f"b: {format(b, '064x')}")
        print(f"word_mode: {word_mode}")
        print(f"word_sel_A: {word_sel_a}")
        print(f"word_sel_B: {word_sel_b}")
        print(f"half_sel: {half_sel}")
        print(f"lane_mode: {lane_mode}")
        print(f"lane_word_32: {lane_word_32}")
        print(f"lane_word_16: {lane_word_16}")
        print(f"exec_mode: {exec_mode}")
        print(f"data_type_64_shift: {data_type_64_shift}")
        print(f"BNMULV_ACCH: {acch_en}")

        if word_mode == ModeMul.MODE_64:
            num_words = 1
            mask_size = 2 * DLEN
            res_size = 2 * DLEN
        elif word_mode == ModeMul.MODE_32:
            res_size = 2 * SLEN
            num_words = WLEN // res_size
            mask_size = 2 * WLEN if acch_en else WLEN
        else: # word_mode == ModeMul.MODE_16:
            res_size = 2 * HLEN
            num_words = WLEN // res_size
            mask_size = 2 * WLEN if acch_en else WLEN

        prod_actual = mask(result, mask_size)

        hex_size = res_size >> 2
        for i in range(num_words):
            exp = mask(prod_expected >> (i * res_size), res_size)
            act = mask(prod_actual >> (i * res_size), res_size)
            assert act == exp, (
                f"ERROR PROD: mismatch at word {i}: "
                f"actual={format(act, f'0{hex_size}x')} expected={format(exp, f'0{hex_size}x')}\n"
                f"prod_act = {format(prod_actual, '0128x')}\n"
                f"prod_exp = {format(prod_expected, '0128x')}\n"

            )

# === Pytest hook ===

@pytest.mark.parametrize(
    "top, wallace, acch, word_mode", 
    [
        ("unified_mul", w, a, i) for w in [0, 1] for a in [0, 1]
        for i in [ModeMul.MODE_16, ModeMul.MODE_32, ModeMul.MODE_64]
    ] +
    [
        ("mul_dsp", w, a, i) for w in [0] for a in [0, 1]
        for i in [ModeMul.MODE_16, ModeMul.MODE_32, ModeMul.MODE_64]
    ]
)

def test_unified_mul_sim(top, wallace, acch, word_mode):
    """Run different testcases on simulated design.
    """
    num_tests = 4096
    extra_args = ["--timing"]
    if wallace:
        extra_args.append("-DWALLACE")
    if acch:
        extra_args.append("-DBNMULV_ACCH")

    vivado_prim = ["bn_vec_core/DSP48E1.v"]

    run(
        toplevel=top,
        module="test_unified_mul_pytest",
        toplevel_lang="verilog",
        testcase="run_unified_mul_test",
        simulator="verilator",
        extra_args=extra_args,
        sim_build=f"sim_build/{top}",
        verilog_sources=vivado_prim + [f"bn_vec_core/{top}.sv"],
        extra_env={
            "NUM_TESTS": str(num_tests),
            "WORD_MODE": str(int(word_mode)),
            "BNMULV_ACCH": str(acch)
        }
        #waves=True,
        #plus_args=["--trace"]  # enable trace all in verilator simulation
    )
