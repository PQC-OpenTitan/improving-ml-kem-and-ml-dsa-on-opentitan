
import cocotb
from cocotb_test.simulator import run
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, Join, First, ReadOnly
from dataclasses import dataclass
import random

from hw_model import mac_model, mac_bignum_operation_t, mac_predec_bignum_t, mac_acc


async def reset_dut(dut):
    dut.rst_ni.value = 0
    await RisingEdge(dut.clk_i)
    dut.rst_ni.value = 1
    await RisingEdge(dut.clk_i)


@cocotb.test()
async def mac_test(dut):
    cocotb.start_soon(Clock(dut.clk_i, 10, units="ns").start())
    await reset_dut(dut)

    for i in range(32):

        await FallingEdge(dut.clk_i)

        operand_a = random.getrandbits(256)
        operand_b = random.getrandbits(256)

        operand_a_qw_sel = random.randint(0, 3)
        operand_b_qw_sel = random.randint(0, 3)
        wr_hw_sel_upper = 0 #random.randint(0, 1)
        pre_acc_shift_imm = 0 #random.randint(0, 3)
        shift_acc = 0 # random.randint(0, 1)
        zero_acc = 1 if i==0 else random.randint(0, 1)

        data_type = random.randint(0, 2)

        sel = random.randint(0, 1) if data_type != 0b00 else 0

        lane_mode = random.randint(0, 1) if data_type != 0b00 else 0
        lane_index = 0 if lane_mode == 0 else random.randint(0, 15) if data_type == 0b10 else random.randint(0, 3) if data_type == 0b01 else 0

        exec_mode = random.randint(0, 2) if data_type != 0b00 else 0

        op = mac_bignum_operation_t(
            operand_a         = operand_a,
            operand_b         = operand_b,
            operand_a_qw_sel  = operand_a_qw_sel,
            operand_b_qw_sel  = operand_b_qw_sel,
            wr_hw_sel_upper   = wr_hw_sel_upper,
            pre_acc_shift_imm = pre_acc_shift_imm,
            zero_acc          = zero_acc,
            shift_acc         = shift_acc,
            data_type         = data_type,
            sel               = sel,
            lane_mode         = lane_mode,
            lane_index        = lane_index,
            exec_mode         = exec_mode
        )

        predec = mac_predec_bignum_t(
            op_en=1,
            acc_rd_en=0 if zero_acc else 1
        )

        dut.operation_i.value = op.to_Logic()

        dut.mac_predec_bignum_i.value = predec.to_Logic()

        dut.mac_en_i.value = 1
        dut.mac_commit_i.value = 1

        dut.urnd_data_i.value = 0
        dut.sec_wipe_acc_urnd_i.value = 0
        dut.sec_wipe_running_i.value = 0
        dut.ispr_acc_wr_data_intg_i.value = 0
        dut.ispr_acc_wr_en_i.value = 0


        acc_val = mac_acc()

        print(op, predec, hex(mac_acc()) == hex(dut.acc_no_intg_q.value.integer))
        print(hex(mac_acc()))
        print(hex(dut.acc_no_intg_q.value.integer))
        print(hex(mac_acc() ^ dut.acc_no_intg_q.value.integer))

        expected = mac_model(op, predec)


        await RisingEdge(dut.clk_i)

        print(hex(mac_acc()))
        print(hex(dut.acc_no_intg_q.value.integer))

        result = dut.operation_result_o.value.integer

        assert result == expected, (
            f"Random test {i} failed:\n"
            f"  operand_a = {operand_a:#x}\n"
            f"  operand_b = {operand_b:#x}\n"
            f"  acc       = {acc_val:#x}\n"
            f"  expected  = {expected:#x}\n"
            f"  got       = {result:#x}"
        )


def test_mod_mul_runner():
    verilog_sources = ["../../prim/rtl/prim_mubi_pkg.sv", "../../prim/rtl/prim_secded_pkg.sv", "../../prim/rtl/prim_util_pkg.sv", "../../lc_ctrl/rtl/lc_ctrl_state_pkg.sv", "../../lc_ctrl/rtl/lc_ctrl_reg_pkg.sv", "../../lc_ctrl/rtl/lc_ctrl_pkg.sv", "../../otp_ctrl/rtl/otp_ctrl_pkg.sv","otbn_pkg.sv", "bn_vec_core/unified_mul.sv", "bn_vec_core/brent_kung_adder_256_double.sv", "otbn_mac_bignum.sv", "../../prim_generic/rtl/prim_and2.sv"]

    run(
        toplevel="otbn_mac_bignum",
        module="test_mac_random_manual",
        toplevel_lang="verilog",
        testcase="mac_test",
        simulator="verilator",
        extra_args=["-I../../../../prim/rtl/", 
                    "-I../../../../otp_ctrl/rtl/",
                    "-I../../../../prim_generic/rtl/"],
        sim_build=f"sim_build/otbn_mac_bignum",
        verilog_sources=verilog_sources,
        waves=True,
        plus_args=["--trace"]  # enable trace all in verilator simulation
    )

