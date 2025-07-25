import pytest

import cocotb
from cocotb_test.simulator import run
from cocotb.triggers import Timer

from hw_model import reference_prod

from random import randint, choice

@cocotb.test()
async def run_full_broadcast_modes(dut):
  """Unified test for all broadcast levels."""
  for _ in range(32):
    ## 16×16 vector-scalar broadcast

    half_sel = choice([None, 0, 1])

    dut.mode.value = 0b011 if half_sel == None else 0b100 if half_sel == 0 else 0b101
    dut.a_word_sel.value = 1
    dut.b_word_sel.value = 1
    dut.b_word32_sel.value = 0
    dut.b_word16_sel.value = 1
    dut.is_scalar_broadcast.value = 0

    dut.op_a.value = randint(0, (1 << 256)-1)
    dut.op_b.value = randint(0, (1 << 256)-1)

    await Timer(1, units="ns")
  
#    print("a:", hex(dut.op_a.value))
#    print("b:", hex(dut.op_b.value))
  
    expected = reference_prod(int(dut.op_a.value), int(dut.op_b.value), 0b10, None, None, half_sel)
  
    print("exp:", hex(expected))
  
    got = int(dut.result.value)

    print("got:", hex(got))

    assert got == expected, f"16×16 cross-word failed: got {got}"


  for i in range(16):
    ## 16×16 vector-scalar broadcast
    dut.mode.value = 0b11
    dut.a_word_sel.value = 1
    dut.b_word_sel.value = (i >> 2)
    dut.b_word32_sel.value = (i >> 1) & 1
    dut.b_word16_sel.value = i & 1
    dut.is_scalar_broadcast.value = 1

    dut.op_a.value = randint(0, (1 << 256)-1)
    dut.op_b.value = randint(0, (1 << 256)-1)

    await Timer(1, units="ns")
  
#    print("i:", i)
#    print("a:", hex(dut.op_a.value))
#    print("b:", hex(dut.op_b.value))
  
    expected = reference_prod(int(dut.op_a.value), int(dut.op_b.value), 0b10, None, None, None, 1, i)
  
#    print("exp:", hex(expected))
  
    got = int(dut.result.value)

#    print("got:", hex(got))

    assert got == expected, f"16×16 broadcast failed: got {got}"


  for _ in range(32):
      ## 64×64 arbitrary word pair
      dut.mode.value = 0b00
      #sel = randint(0,3)
      dut.a_word_sel.value = randint(0,3)
      dut.b_word_sel.value = randint(0,3)
      dut.b_word32_sel.value = 0
      dut.b_word16_sel.value = 0
      dut.is_scalar_broadcast.value = 1
  
#      dut.op_a.value = (5 << (64*i)) << (16*0)
#      dut.op_b.value = (7 << (64*i)) << (16*0)

      dut.op_a.value = randint(0, (1 << 256)-1)
      dut.op_b.value = randint(0, (1 << 256)-1)

      await Timer(1, units="ns")
  
#      print("a:", hex(dut.op_a.value))
#      print("b:", hex(dut.op_b.value))
  
      expected = reference_prod(int(dut.op_a.value), int(dut.op_b.value), int(dut.mode.value), int(dut.a_word_sel.value), int(dut.b_word_sel.value), int(dut.b_word32_sel.value))
  
#      print("exp:", hex(expected))
  
      got = int(dut.result.value)

#      print("got:", hex(got))

      assert got == expected, f"64×64 cross-word failed: got {got}"

  for _ in range(32):

    ## 32×32 vector-scalar broadcast

    dut.mode.value = 0b01
    dut.a_word_sel.value = 0
    dut.b_word_sel.value = 0
    dut.b_word32_sel.value = 0
    dut.b_word16_sel.value = 0
    dut.is_scalar_broadcast.value = 0

    # dut.op_a.value = 5 << (64*0)
    # dut.op_b.value = 7 << (64*0)

    dut.op_a.value = randint(0, (1 << 256)-1)
    dut.op_b.value = randint(0, (1 << 256)-1)


    await Timer(1, units="ns")

#    print("a:", hex(dut.op_a.value))
#    print("b:", hex(dut.op_b.value))

    expected = reference_prod(dut.op_a.value, dut.op_b.value, 0b11, None, None, 0)

#    print("exp:", hex(expected))

    got = int(dut.result.value)

#    print("got:", hex(got))

    assert got == expected, f"32×32 even lanes failed: got {got}"

  for _ in range(32):

    ## 32×32 vector-scalar broadcast

    dut.mode.value = 0b10
    dut.a_word_sel.value = 0
    dut.b_word_sel.value = 0
    dut.b_word32_sel.value = 0
    dut.b_word16_sel.value = 0
    dut.is_scalar_broadcast.value = 0

    # dut.op_a.value = 5 << (64*0)
    # dut.op_b.value = 7 << (64*0)

    dut.op_a.value = randint(0, (1 << 256)-1)
    dut.op_b.value = randint(0, (1 << 256)-1)


    await Timer(1, units="ns")

#    print("a:", hex(dut.op_a.value))
#    print("b:", hex(dut.op_b.value))

    expected = reference_prod(dut.op_a.value, dut.op_b.value, 0b11, None, None, 1)

#    print("exp:", hex(expected))

    got = int(dut.result.value)

#    print("got:", hex(got))

    assert got == expected, f"32×32 odd lanes failed: got {got}"


  for _ in range(32):

    ## 32×32 vector-scalar broadcast

    scalar = randint(0, 7)

    dut.mode.value = 0b01
    dut.a_word_sel.value = 0
    dut.b_word_sel.value = (scalar >> 1)
    dut.b_word32_sel.value = (scalar >> 0) & 1
    dut.b_word16_sel.value = 0 #(scalar >> 1) & 1
    dut.is_scalar_broadcast.value = 1

    # dut.op_a.value = 5 << (64*0)
    # dut.op_b.value = 7 << (64*0)

    dut.op_a.value = randint(0, (1 << 256)-1)
    dut.op_b.value = randint(0, (1 << 256)-1)


    await Timer(1, units="ns")

#    print("i:", scalar)
#    print("a:", hex(dut.op_a.value))
#    print("b:", hex(dut.op_b.value))

    expected = reference_prod(dut.op_a.value, dut.op_b.value, 0b11, None, None, 0, 1, scalar)

#    print("exp:", hex(expected))

    got = int(dut.result.value)

#    print("got:", hex(got))

    assert got == expected, f"32×32 scalar even lanes failed: got {got}"

  for _ in range(32):

    ## 32×32 vector-scalar broadcast

    scalar = randint(0, 7)

    dut.mode.value = 0b10
    dut.a_word_sel.value = 0
    dut.b_word_sel.value = (scalar >> 1)
    dut.b_word32_sel.value = (scalar >> 0) & 1
    dut.b_word16_sel.value = 0
    dut.is_scalar_broadcast.value = 1

    # dut.op_a.value = 5 << (64*0)
    # dut.op_b.value = 7 << (64*0)

    dut.op_a.value = randint(0, (1 << 256)-1)
    dut.op_b.value = randint(0, (1 << 256)-1)


    await Timer(1, units="ns")

#    print("i:", scalar)
#    print("a:", hex(dut.op_a.value))
#    print("b:", hex(dut.op_b.value))

    expected = reference_prod(dut.op_a.value, dut.op_b.value, 0b11, None, None, 1, 1, scalar)

#    print("exp:", hex(expected))

    got = int(dut.result.value)

#    print("got:", hex(got))

    assert got == expected, f"32×32 scalar odd lanes failed: got {got}"



def test_unified_mult_build():
    run(
        toplevel="simd_multiplier_unit",
        module="test_simd_multiplier_unit_pytest",
        toplevel_lang="verilog",
        testcase="run_full_broadcast_modes",
        simulator="verilator",
        sim_build=f"sim_build/diagonal_shift_mul",
        compile_args = ['-Wno-WIDTHEXPAND', '-Wno-WIDTHTRUNC'],
        verilog_sources=[
          "bn_vec_core/simd_multiplier_unit.sv",
          #"bn_vec_core/B_word_select_broadcast.sv",
          #"bn_vec_core/diagonal_tiled_simd.sv"
        ],
        waves=True,
        plus_args=["--trace"]  # enable trace all in verilator simulation
    )

