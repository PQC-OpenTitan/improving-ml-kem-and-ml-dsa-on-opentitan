import random
import pytest
import cocotb
from cocotb_test.simulator import run
from cocotb.triggers import ReadOnly
from cocotb.triggers import Timer
import os

from hw_model import reference_sum
from hw_model import MODE_64
from hw_model import MODE_32
from hw_model import MODE_16


@cocotb.test()
async def run_adder_test(dut):
  for i in range(16):
    A = random.getrandbits(256)
    B = random.getrandbits(256)

    word_mode = int(os.environ.get("WORD_MODE"))

    if os.environ.get("TEST_CIN") == "yes":
      cin = random.randint(0, 1) if word_mode == 0 else 0
    else:
      cin = 0

    # Assign inputs
    dut.A.value = A
    dut.B.value = B
    dut.word_mode.value = word_mode
    dut.cin.value = cin

    await Timer(1, units="ns")  # allow evaluation

    # Get result
    sum_expected, cout_expected = reference_sum(A, B, word_mode, cin)

    sum_out = dut.sum.value.integer
    cout_out = dut.cout.value.integer

    print(f"\nsum out:  {bin(sum_out)}\nexpected: {bin(sum_expected)}")
    print(f"\nsum out:  {hex(sum_out)}\nexpected: {hex(sum_expected)}")
    print(f"\ndiff:     {sum_out ^ sum_expected:256b}")

    assert sum_out == sum_expected, f"sum mismatch: word_mode={word_mode} A={hex(A)} B={hex(B)} cin={cin}"
    if word_mode == 0:
        assert cout_out == cout_expected, f"cout mismatch in scalar word_mode"
    else:
        assert cout_out == 0, f"cout must be 0 in vector word_mode"

# === Pytest hook ===

@pytest.mark.parametrize(
    "variant,word_mode,test_cin",
    [("ref_add", MODE_64, "yes")] +
    [("ref_vec_add", MODE_64, "yes")] +
    [("brent_kung_adder_256_mode0_only", MODE_64, "yes")] +
    [("brent_kung_adder_256", i, "yes") for i in [MODE_16, MODE_32, MODE_64]] +
    [("sklansky_adder_256_mode0_only", MODE_64, "yes")] +
    [("sklansky_adder_256", i, "yes") for i in [MODE_16, MODE_32, MODE_64]] +
    [("kogge_stone_adder_256", i, "yes") for i in [MODE_16, MODE_32, MODE_64]] +
    [("csa_adder_256", i, "yes") for i in [MODE_16, MODE_32, MODE_64]] #+
    #[("buffer_bit", i, "yes") for i in [MODE_16, MODE_32, MODE_64]]
)
def test_adder_sim(variant, word_mode, test_cin):
    run(
        toplevel=variant,
        module="test_adder_pytest",
        toplevel_lang="verilog",
        testcase="run_adder_test",
        simulator="verilator",
        sim_build=f"sim_build/{variant}",
        verilog_sources=[f"bn_vec_core/{variant}.sv"],
        extra_env={
            "WORD_MODE": str(word_mode),
            "TEST_CIN": test_cin,
        },
        #waves=True,
        #plus_args=["--trace"]  # enable trace all in verilator simulation
    )

