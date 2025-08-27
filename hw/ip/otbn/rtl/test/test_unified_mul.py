import random
import os
import cocotb
from cocotb_test.simulator import run
from cocotb.triggers import RisingEdge
from cocotb.triggers import Timer
import cocotb_test.simulator
import pytest

from hw_model import reference_prod, WLEN, DLEN
from hw_model import MODE_64
from hw_model import MODE_32
from hw_model import MODE_16


@cocotb.test()
async def run_unified_test(dut):
    """Randomized test for unified multiplier in all data_types."""

    for data_type in [MODE_16, MODE_32, MODE_64]:
        for _ in range(32):
            A = random.getrandbits(WLEN)
            B = random.getrandbits(WLEN)

            dut.word_mode.value = data_type
            dut.word_sel_A.value = random.randint(0, 3)
            dut.word_sel_B.value = random.randint(0, 3)
            dut.half_sel.value = random.randint(0, 1)
            dut.lane_mode.value = random.randint(0, 1) if data_type != 0b00 else 0
            dut.lane_word_32.value = random.randint(0, 1)
            dut.lane_word_16.value = random.randint(0, 1)
            dut.A.value = A
            dut.B.value = B

            await Timer(1, units="ns")  # allow evaluation

            result = int(dut.result.value)

            print(data_type, dut.word_sel_A.value, dut.word_sel_B.value, dut.half_sel.value, dut.lane_mode.value, dut.lane_word_32.value, dut.lane_word_16.value)


            expected = reference_prod(A, B, data_type, 
                          dut.word_sel_A.value, dut.word_sel_B.value, dut.half_sel.value, dut.lane_mode.value, dut.lane_word_32.value, dut.lane_word_16.value)

            print("data_type:", data_type)

            if data_type == MODE_64:
                # 64x64 data_type
                out = result & ((1 << (2 * DLEN)) - 1)

                assert out == expected, f"64x64 FAIL: A={A}, B={B}, got={out}, expected={expected}"

            elif data_type == MODE_32:
                # 4x 32x32 data_type
                out = result & ((1 << (WLEN)) - 1)

                assert out == expected, f"32x32 FAIL: A={A}, B={B}, got={out}, expected={expected}"

            elif data_type == MODE_16:
                # 16x 16x16 data_type
                out = result & ((1 << (WLEN)) - 1)

                assert out == expected, f"16x16 FAIL: A={A}, B={B}, got={hex(out)}, expected={hex(expected)}"


def test_unified_mult_build():
    run(
        toplevel="unified_mul",
        module="test_unified_mul",
        toplevel_lang="verilog",
        testcase="run_unified_test",
        simulator="verilator",
        sim_build=f"sim_build/unified_mul",
        verilog_sources=["bn_vec_core/unified_mul.sv"],
        #waves=True,
        #plus_args=["--trace"]  # enable trace all in verilator simulation
    )

