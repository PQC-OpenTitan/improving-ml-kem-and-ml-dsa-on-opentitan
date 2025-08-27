import random
import pytest
import cocotb
from cocotb_test.simulator import run
from cocotb.triggers import ReadOnly
from cocotb.triggers import Timer
import os

from hw_model import reference_cond_sub
from hw_model import reference_sum

MODE_16 = 0
MODE_32 = 1


@cocotb.test()
async def run_cond_sub_test(dut):
  for i in range(1024):
    word_mode = int(os.environ.get("WORD_MODE"))

    A = random.getrandbits(256)
    B = random.getrandbits(256)

#    A = random.getrandbits(16 + word_mode*16) #256)
#    B = random.getrandbits(16 + word_mode*16) #256)

#    v = random.getrandbits(16)

#    A = (v << 16) + random.getrandbits(16)
#    B = (v << 16) + random.getrandbits(16)

#    B = 0xffffffff ^ Bn
#    for i in range(32):
#      B = (B << 1) | (1 ^ ((Bn >> i) & 1))

#    B = (B << 16) + random.getrandbits(16)

    cin = 1

    # Assign inputs
    dut.A.value = A
    dut.B.value = B
    dut.word_mode.value = word_mode
    dut.cin.value = cin

    await Timer(1, units="ns")  # allow evaluation

    # Get result
    sum_expected, cout_expected = reference_cond_sub(A, B, word_mode, cin)
    #sum_expected, cout_expected = reference_sum(A, B+cin, 2+word_mode, cin)

    sum_out = dut.sum.value.integer
    cout_out = dut.cout.value.integer

    print(f"\nsum out:  {bin(sum_out)}\nexpected: {bin(sum_expected)}")
    print(f"\nsum out:  {format(sum_out, '064x')}\nexpected: {format(sum_expected, '064x')}")

    assert sum_out == sum_expected, f"sum mismatch: word_mode={word_mode} A={format(A, '064x')} B={format(B, '064x')} cin={cin}"

# === Pytest hook ===

@pytest.mark.parametrize(
    "variant, word_mode",
    [("cond_sub", i) for i in [MODE_16, MODE_32]] +
    [("cond_sub_buffer_bit", i) for i in [MODE_16, MODE_32]]
)
def test_cond_sub_sim(variant, word_mode):
    run(
        toplevel=f"{variant}",
        module="test_cond_sub_pytest",
        toplevel_lang="verilog",
        testcase="run_cond_sub_test",
        simulator="verilator",
        sim_build=f"sim_build/{variant}",
        verilog_sources=[f"bn_vec_core/{variant}.sv"],
        extra_env={
            "WORD_MODE": str(word_mode)
        },
        #waves=True,
        #plus_args=["--trace"]  # enable trace all in verilator simulation
    )
