// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

`include "prim_assert.sv"

module otbn_mac_bignum
  import otbn_pkg::*;
(
  input logic clk_i,
  input logic rst_ni,

  input mac_bignum_operation_t operation_i,
  input logic                  mac_en_i,
  input logic                  mac_commit_i,

  output logic [WLEN-1:0] operation_result_o,
  output flags_t          operation_flags_o,
  output flags_t          operation_flags_en_o,
  output logic            operation_intg_violation_err_o,

`ifdef TOWARDS_MAC
  output logic            operation_mulv_done_o,
`endif

  input  mac_predec_bignum_t mac_predec_bignum_i,
  output logic               predec_error_o,

  input  logic [WLEN-1:0] urnd_data_i,
  input  logic            sec_wipe_acc_urnd_i,
`ifdef TOWARDS_MAC
  input  logic            sec_wipe_tmp_urnd_i,
`endif
  input  logic            sec_wipe_running_i,
  output logic            sec_wipe_err_o,

`ifdef BNMULV_ACCH
  output logic [ExtWLEN-1:0] ispr_acch_intg_o,
  input  logic [ExtWLEN-1:0] ispr_acch_wr_data_intg_i,
  input  logic               ispr_acch_wr_en_i,
`endif

  output logic [ExtWLEN-1:0] ispr_acc_intg_o,
  input  logic [ExtWLEN-1:0] ispr_acc_wr_data_intg_i,
  input  logic               ispr_acc_wr_en_i
);
  // The MAC operates on quarter-words, QWLEN gives the number of bits in a quarter-word.
  localparam int unsigned QWLEN = WLEN / 4;

`ifdef BNMULV_ACCH
  logic [2*WLEN-1:0] adder_op_a;
  logic [2*WLEN-1:0] adder_op_b;
  logic [2*WLEN-1:0] adder_result;
`else
  logic [WLEN-1:0] adder_op_a;
  logic [WLEN-1:0] adder_op_b;
  logic [WLEN-1:0] adder_result;
`endif

  logic [1:0]      adder_result_hw_is_zero;

`ifdef BNMULV_ACCH
  logic [2*WLEN-1:0] mul_res_shifted;
`else
  logic [WLEN-1:0]   mul_res_shifted;
`endif

  logic [ExtWLEN-1:0] acc_intg_d;
  logic [ExtWLEN-1:0] acc_intg_q;
  logic [WLEN-1:0]    acc_blanked;
  logic               acc_en;

`ifdef BNMULV_ACCH
  logic [ExtWLEN-1:0] acch_intg_d;
  logic [ExtWLEN-1:0] acch_intg_q;
  logic [WLEN-1:0]    acch_blanked;
  logic               acch_en;
`endif

  logic [WLEN-1:0] operand_a_blanked, operand_b_blanked;

  logic expected_acc_rd_en, expected_op_en;

`ifdef TOWARDS_MAC
  logic [QWLEN-1:0]  mul_op_a;
  logic [QWLEN-1:0]  mul_op_b;
  logic [WLEN/2-1:0] mul_res;

  logic [ExtWLEN/4-1:0] res_tmp_intg_d;
  logic [ExtWLEN/4-1:0] res_tmp_intg_q;
  logic [QWLEN-1:0]     res_tmp_blanked;

  logic [ExtWLEN/2-1:0] p_tmp_intg_d;
  logic [ExtWLEN/2-1:0] p_tmp_intg_q;
  logic [WLEN/2-1:0]    p_tmp_blanked;

  logic expected_mulv_en;
  mulv_type_t expected_type;

  // SEC_CM: DATA_REG_SW.SCA
  prim_blanker #(.Width(WLEN)) u_operand_a_blanker (
    .in_i (operation_i.operand_a),
    .en_i (mac_predec_bignum_i.op_en | operation_i.mac_mulv_en),
    .out_o(operand_a_blanked)
  );

  // SEC_CM: DATA_REG_SW.SCA
  prim_blanker #(.Width(WLEN)) u_operand_b_blanker (
    .in_i (operation_i.operand_b),
    .en_i (mac_predec_bignum_i.op_en | operation_i.mac_mulv_en),
    .out_o(operand_b_blanked)
  );

  // Extract QWLEN multiply operands from WLEN operand inputs based on chosen quarter word from the
  // instruction (operand_[a|b]_qw_sel).
  always_comb begin
    mul_op_a = '0;
    mul_op_b = '0;

    unique case (operation_i.operand_a_qw_sel)
      2'd0: mul_op_a = operand_a_blanked[QWLEN*0+:QWLEN];
      2'd1: mul_op_a = operand_a_blanked[QWLEN*1+:QWLEN];
      2'd2: mul_op_a = operand_a_blanked[QWLEN*2+:QWLEN];
      2'd3: mul_op_a = operand_a_blanked[QWLEN*3+:QWLEN];
      default: mul_op_a = '0;
    endcase

    unique case (operation_i.operand_b_qw_sel)
      2'd0: mul_op_b = operand_b_blanked[QWLEN*0+:QWLEN];
      2'd1: mul_op_b = operand_b_blanked[QWLEN*1+:QWLEN];
      2'd2: mul_op_b = operand_b_blanked[QWLEN*2+:QWLEN];
      2'd3: mul_op_b = operand_b_blanked[QWLEN*3+:QWLEN];
      default: mul_op_b = '0;
    endcase
  end
`else
  // SEC_CM: DATA_REG_SW.SCA
  prim_blanker #(.Width(WLEN)) u_operand_a_blanker (
    .in_i (operation_i.operand_a),
    .en_i (mac_predec_bignum_i.op_en),
    .out_o(operand_a_blanked)
  );

  // SEC_CM: DATA_REG_SW.SCA
  prim_blanker #(.Width(WLEN)) u_operand_b_blanker (
    .in_i (operation_i.operand_b),
    .en_i (mac_predec_bignum_i.op_en),
    .out_o(operand_b_blanked)
  );
`endif


  `ASSERT_KNOWN_IF(OperandAQWSelKnown, operation_i.operand_a_qw_sel, mac_en_i)
  `ASSERT_KNOWN_IF(OperandBQWSelKnown, operation_i.operand_b_qw_sel, mac_en_i)

  // The reset signal is not used for any registers in this module but for assertions.  As those
  // assertions are not visible to EDA tools working with the synthesizable subset of the code
  // (e.g., Verilator), they cause lint errors in some of those tools.  Prevent these errors by
  // assigning the reset signal to a signal that is okay to be unused.
  logic unused_ok;
  assign unused_ok = ^(rst_ni);

`ifdef TOWARDS_MAC
  // Operands and results for first multiplier
  // Computes p = op0_i * op1_i;
  logic [WLEN-1:0] op0, op1;
  assign op0 = operand_a_blanked;

  // Replace multiplication with custom multiplier
  logic [QWLEN-1:0] mux2mul_op_a;
  logic [QWLEN-1:0] mux2mul_op_b;

  // Select op1 depening on lane and lane_idx
  logic [WLEN-1:0] multiplier_op_lane;
  logic [15:0]     lane16 [15:0];
  logic [31:0]     lane32 [7:0];
  logic [WLEN-1:0] multiplier_op_lane16;
  logic [WLEN-1:0] multiplier_op_lane32;

  generate;
    for (genvar i = 0; i < 16; ++i) begin : g_lane16
      assign lane16[i] = operand_b_blanked[i*16 +: 16];
    end : g_lane16

    for (genvar i = 0; i < 8; ++i) begin : g_lane32
      assign lane32[i] = operand_b_blanked[i*32 +: 32];
    end : g_lane32
  endgenerate

  always_comb begin
    for (int i = 0; i < 16; ++i) begin
      multiplier_op_lane16[i*16 +: 16] = lane16[operation_i.lane_idx];
    end
    for (int i = 0; i < 8; ++i) begin
      multiplier_op_lane32[i*32 +: 32] = lane32[operation_i.lane_idx[2:0]];
    end      
  end

  assign multiplier_op_lane = operation_i.vector_type[0] ? multiplier_op_lane16 : multiplier_op_lane32;

  assign op1 = operation_i.vector_type[1] ? multiplier_op_lane : operand_b_blanked;

  // Stall state register
  logic [1:0] stall_state;
  always_ff @(posedge clk_i) begin
    if (operation_i.mac_mulv_en & operation_i.vector_type[2]) begin
      if (stall_state == 2'b10) begin
        stall_state <= '0;
      end else begin
        stall_state <= stall_state + 1;
      end
    end else begin
      stall_state <= '0;
    end
  end

  // Stall state qword_sel register
  logic [1:0] stall_state_qwsel;
  always_ff @(posedge clk_i) begin
    if (operation_i.mac_mulv_en & ((stall_state == 2'b10) | !operation_i.vector_type[2])) begin
      if (stall_state_qwsel == 2'b11) begin
        stall_state_qwsel <= '0;
      end else begin
        stall_state_qwsel <= stall_state_qwsel + 1;
      end
    end else if(!operation_i.mac_mulv_en) begin
      stall_state_qwsel <= '0;
    end
  end

  always_comb begin
    operation_mulv_done_o = 1'b0;
    if (operation_i.mac_mulv_en & ((stall_state == 2'b10) | !operation_i.vector_type[2])) begin
      if (stall_state_qwsel == 2'b11) begin
        operation_mulv_done_o = 1'b1;
      end else begin
        operation_mulv_done_o = 1'b0;
      end
    end else begin
        operation_mulv_done_o = 1'b0;      
    end
  end
  

  // Select input of multiplier depending on stall state
  logic [QWLEN-1:0] r2mul_16;
  logic [QWLEN-1:0] r2mul_32;
  logic [QWLEN-1:0] r2mul;

  logic [QWLEN-1:0] q2mul_16;
  logic [QWLEN-1:0] q2mul_32;
  logic [QWLEN-1:0] q2mul;

  for (genvar i=0; i<4; ++i) begin
    assign r2mul_16[i*16+:16] = operation_i.mod[47:32];
    assign q2mul_16[i*16+:16] = operation_i.mod[15:0];
  end

  for (genvar i=0; i<2; ++i) begin
    assign r2mul_32[i*32+:32] = operation_i.mod[63:32];
    assign q2mul_32[i*32+:32] = operation_i.mod[31:0];
  end

  /************************************
  * 1: compute p=a*b and [p]_l,
  * 2: compute m=[p*R]_l,
  * 3: compute t=[m*q+p]^l,
  * 4: compute t-q if necessary.
  ************************************/
  always_comb begin
    mux2mul_op_a = '0;
    unique case (stall_state)
      2'd0: mux2mul_op_a = op0[stall_state_qwsel*64 +: 64];
      2'd1: mux2mul_op_a = res_tmp_blanked;
      2'd2: mux2mul_op_a = res_tmp_blanked;
    default : mux2mul_op_a = '0;
    endcase
  end

  assign r2mul = operation_i.vector_type[0] ? r2mul_16 : r2mul_32;
  assign q2mul = operation_i.vector_type[0] ? q2mul_16 : q2mul_32;

  always_comb begin
    mux2mul_op_b = '0;
    unique case (stall_state)
      2'd0: mux2mul_op_b = op1[stall_state_qwsel*64 +: 64];
      2'd1: mux2mul_op_b = r2mul;
      2'd2: mux2mul_op_b = q2mul;
    default : mux2mul_op_b = '0;
    endcase
  end
  logic [QWLEN-1:0] multiplier_op_a;
  logic [QWLEN-1:0] multiplier_op_b;

  assign multiplier_op_a = operation_i.mac_mulv_en ? mux2mul_op_a : mul_op_a;
  assign multiplier_op_b = operation_i.mac_mulv_en ? mux2mul_op_b : mul_op_b;

  // assign mul_res = mul_op_a * mul_op_b;
  otbn_mul U_MUL (
    .multiplier_op_a_i     (multiplier_op_a),
    .multiplier_op_b_i     (multiplier_op_b),
    .multiplier_vector_i   (operation_i.mac_mulv_en),
    .multiplier_selvector_i(operation_i.vector_type[0]),
    .multiplier_res_o      (mul_res)
  );

  // Shift the QWLEN multiply result into a WLEN word before accumulating using the shift amount
  // supplied in the instruction (pre_acc_shift_imm).
  always_comb begin
    mul_res_shifted = '0;

    unique case (operation_i.pre_acc_shift_imm)
      2'd0: mul_res_shifted = {{QWLEN * 2{1'b0}}, mul_res};
      2'd1: mul_res_shifted = {{QWLEN{1'b0}}, mul_res, {QWLEN{1'b0}}};
      2'd2: mul_res_shifted = {mul_res, {QWLEN * 2{1'b0}}};
      2'd3: mul_res_shifted = {mul_res[63:0], {QWLEN * 3{1'b0}}};
      default: mul_res_shifted = '0;
    endcase
  end

  `ASSERT_KNOWN_IF(PreAccShiftImmKnown, operation_i.pre_acc_shift_imm, mac_en_i)

  logic [15:0] red_16 [3:0];
  logic [31:0] red_32 [1:0];

  always_comb begin
    for (int i = 0; i < 4; ++i) begin
      red_16[i] = mul_res[i*32 +: 16];
    end

    for (int i = 0; i < 2; ++i) begin
      red_32[i] = mul_res[i*64 +: 32];
    end
  end

  logic [QWLEN-1:0] trunc_result;
  logic [QWLEN-1:0] trunc_result_16;
  logic [QWLEN-1:0] trunc_result_32;

  generate;
    for (genvar i = 0; i < 4; ++i) begin : g_shift16_p
      assign trunc_result_16[i*16 +: 16] = red_16[i];
    end : g_shift16_p

    for (genvar i = 0; i < 2; ++i) begin : g_shift32_p
      assign trunc_result_32[i*32 +: 32] = red_32[i];
    end : g_shift32_p
  endgenerate

  assign trunc_result = operation_i.vector_type[0] ? trunc_result_16 : trunc_result_32;

  // Add register for intermediate result
  // ECC encode and decode of accumulator register
  logic [QWLEN-1:0]              res_tmp_no_intg_d;
  logic [QWLEN-1:0]              res_tmp_no_intg_q;
  logic [ExtWLEN/4-1:0]          res_tmp_intg_calc;
  logic [BaseWordsPerWLEN/2-1:0] res_tmp_intg_err;
  logic [BaseWordsPerWLEN/2-1:0] unused_res_tmp_intg_err;

  assign unused_res_tmp_intg_err = res_tmp_intg_err;

  for (genvar i_word = 0; i_word < BaseWordsPerWLEN/4; i_word++) begin : g_res_tmp_words
    prim_secded_inv_39_32_enc i_secded_enc (
      .data_i (res_tmp_no_intg_d[i_word*32 +: 32]),
      .data_o (res_tmp_intg_calc[i_word*39 +: 39])
    );
    prim_secded_inv_39_32_dec i_secded_dec (
      .data_i     (res_tmp_intg_q[i_word*39 +: 39]),
      .data_o     (/* unused because we abort on any integrity error */),
      .syndrome_o (/* unused */),
      .err_o      (res_tmp_intg_err[i_word*2 +: 2])
    );
    assign res_tmp_no_intg_q[i_word*32 +: 32] = res_tmp_intg_q[i_word*39 +: 32];
  end

  // Select intermediate results
  always_comb begin
    res_tmp_no_intg_d = '0;
    unique case (1'b1)
      // Non-encoded inputs have to be encoded before writing to the register.
      sec_wipe_tmp_urnd_i: begin
        res_tmp_no_intg_d = urnd_data_i[63:0];
        res_tmp_intg_d    = res_tmp_intg_calc;
      end
      default: begin
        for (int i = 0; i < 2; ++i) begin
          res_tmp_no_intg_d[i*32 +: 32] = operation_i.vector_type[0] ? {red_16[2*i + 1],red_16[2*i]} : red_32[i];
        end
        res_tmp_intg_d = res_tmp_intg_calc;
      end
    endcase
  end

  always_ff @(posedge clk_i) begin
    if (operation_i.mac_mulv_en) begin
      res_tmp_intg_q <= res_tmp_intg_d;
    end
  end

  // Add register for intermediate result
  // ECC encode and decode of accumulator register
  logic [WLEN/2-1:0]           p_tmp_no_intg_d;
  logic [WLEN/2-1:0]           p_tmp_no_intg_q;
  logic [ExtWLEN/2-1:0]        p_tmp_intg_calc;
  logic [BaseWordsPerWLEN-1:0] p_tmp_intg_err;
  logic [BaseWordsPerWLEN-1:0] unused_p_tmp_intg_err;

  assign unused_p_tmp_intg_err = p_tmp_intg_err;

  for (genvar i_word = 0; i_word < BaseWordsPerWLEN/2; i_word++) begin : g_p_tmp_words
    prim_secded_inv_39_32_enc i_secded_enc (
      .data_i (p_tmp_no_intg_d[i_word*32 +: 32]),
      .data_o (p_tmp_intg_calc[i_word*39 +: 39])
    );
    prim_secded_inv_39_32_dec i_secded_dec (
      .data_i     (p_tmp_intg_q[i_word*39+:39]),
      .data_o     (/* unused because we abort on any integrity error */),
      .syndrome_o (/* unused */),
      .err_o      (p_tmp_intg_err[i_word*2 +: 2])
    );
    assign p_tmp_no_intg_q[i_word*32 +: 32] = p_tmp_intg_q[i_word*39 +: 32];
  end

  always_comb begin
    p_tmp_intg_d = '0;
    unique case (1'b1)
      // Non-encoded inputs have to be encoded before writing to the register.
      sec_wipe_tmp_urnd_i: begin
        p_tmp_no_intg_d = urnd_data_i[255:128];
        p_tmp_intg_d    = p_tmp_intg_calc;
      end
      default: begin
        if ((operation_i.mac_mulv_en) & (stall_state == 2'b0)) begin
          p_tmp_no_intg_d = mul_res;
          p_tmp_intg_d    = p_tmp_intg_calc;
        end else begin
          p_tmp_no_intg_d = '0;
          p_tmp_intg_d    = p_tmp_intg_calc;
        end
      end
    endcase
  end

  always_ff @(posedge clk_i) begin
    if ((operation_i.mac_mulv_en) & (stall_state ==2'b0)) begin
      p_tmp_intg_q <= p_tmp_intg_d;
    end
  end

  // SEC_CM: DATA_REG_SW.SCA
  // acc_rd_en is so if .Z set in MULQACC (zero_acc) so accumulator reads as 0
  prim_blanker #(.Width(WLEN/2)) u_p_blanker (
    .in_i (p_tmp_no_intg_q),
    .en_i (mac_predec_bignum_i.mac_mulv_en),
    .out_o(p_tmp_blanked)
  );

  // SEC_CM: DATA_REG_SW.SCA
  prim_blanker #(.Width(QWLEN)) u_res_tmp_blanker (
    .in_i (res_tmp_no_intg_q),
    .en_i (mac_predec_bignum_i.mac_mulv_en),
    .out_o(res_tmp_blanked)
  );
`endif

`ifdef BNMULV
  unified_mul mul (
    .word_mode         ({operation_i.mulv, operation_i.data_type}), // 00 = 64x64, 11 = 4x32x32, 10 = 16x16x16
    .word_sel_A        (operation_i.operand_a_qw_sel),
    .word_sel_B        (operation_i.operand_b_qw_sel),
    `ifdef BNMULV_ACCH
    .exec_mode         (operation_i.exec_mode),
    `endif
    .half_sel          (operation_i.sel),
    .lane_mode         (operation_i.lane_mode),
    .lane_word_32      (operation_i.lane_word_32),
    .lane_word_16      (operation_i.lane_word_16),
    .A                 (operand_a_blanked),
    .B                 (operand_b_blanked),
    .data_type_64_shift(operation_i.pre_acc_shift_imm),
    .result            (mul_res_shifted)
  );
`else
  `ifndef TOWARDS_MAC
  otbn_bignum_mul mul (
    .A                 (operand_a_blanked),
    .B                 (operand_b_blanked),
    .word_sel_A        (operation_i.operand_a_qw_sel),
    .word_sel_B        (operation_i.operand_b_qw_sel),
    .data_type_64_shift(operation_i.pre_acc_shift_imm),
    .result            (mul_res_shifted)
  );
  `endif
`endif

  `ASSERT_KNOWN_IF(PreAccShiftImmKnown, operation_i.pre_acc_shift_imm, mac_en_i)

  // ECC encode and decode of accumulator register
  logic [WLEN-1:0]                acc_no_intg_d;
  logic [WLEN-1:0]                acc_no_intg_q;
  logic [ExtWLEN-1:0]             acc_intg_calc;
  logic [2*BaseWordsPerWLEN-1:0]  acc_intg_err;
  for (genvar i_word = 0; i_word < BaseWordsPerWLEN; i_word++) begin : g_acc_words
    prim_secded_inv_39_32_enc i_secded_enc (
      .data_i (acc_no_intg_d[i_word*32+:32]),
      .data_o (acc_intg_calc[i_word*39+:39])
    );
    prim_secded_inv_39_32_dec i_secded_dec (
      .data_i     (acc_intg_q[i_word*39+:39]),
      .data_o     (/* unused because we abort on any integrity error */),
      .syndrome_o (/* unused */),
      .err_o      (acc_intg_err[i_word*2+:2])
    );
    assign acc_no_intg_q[i_word*32+:32] = acc_intg_q[i_word*39+:32];
  end

`ifdef BNMULV_ACCH
  // ECC encode and decode of accumulator high register
  logic [WLEN-1:0]                acch_no_intg_d;
  logic [WLEN-1:0]                acch_no_intg_q;
  logic [ExtWLEN-1:0]             acch_intg_calc;
  // logic [2*BaseWordsPerWLEN-1:0]  acch_intg_err;  // FIX ME!
  for (genvar i_word = 0; i_word < BaseWordsPerWLEN; i_word++) begin : g_acch_words
    prim_secded_inv_39_32_enc i_secdedh_enc (
      .data_i (acch_no_intg_d[i_word*32+:32]),
      .data_o (acch_intg_calc[i_word*39+:39])
    );
    prim_secded_inv_39_32_dec i_secdedh_dec (
      .data_i     (acch_intg_q[i_word*39+:39]),
      .data_o     (/* unused because we abort on any integrity error */),
      .syndrome_o (/* unused */),
      .err_o      (/* FIX ME!! acch_intg_err[i_word*2+:2] */)
    );
    assign acch_no_intg_q[i_word*32+:32] = acch_intg_q[i_word*39+:32];
  end
`endif

  // Propagate integrity error only if accumulator register is used: `acc_intg_q` flows into
  // `operation_result_o` via `acc`, `adder_op_b`, and `adder_result` iff the MAC is enabled and the
  // current operation does not zero the accumulation register.
  logic acc_used;
  assign acc_used = mac_en_i & ~operation_i.zero_acc;
`ifdef BNMULV_ACCH
  assign operation_intg_violation_err_o = acc_used & |(acc_intg_err); // FIX ME - add acch
`else
  assign operation_intg_violation_err_o = acc_used & |(acc_intg_err);
`endif

  // Accumulator logic

  // SEC_CM: DATA_REG_SW.SCA
  // acc_rd_en is so if .Z set in MULQACC (zero_acc) so accumulator reads as 0
`ifdef TOWARDS_MAC
  logic mulv_acc_en;
  assign mulv_acc_en = operation_i.mac_mulv_en & ((stall_state == 2'b10) | !(operation_i.vector_type[2]));

  prim_blanker #(.Width(WLEN)) u_acc_blanker (
    .in_i (acc_no_intg_q),
    .en_i (mac_predec_bignum_i.acc_rd_en | mulv_acc_en),
    .out_o(acc_blanked)
  );
`else
  prim_blanker #(.Width(WLEN)) u_acc_blanker (
    .in_i (acc_no_intg_q),
    .en_i (mac_predec_bignum_i.acc_rd_en),
    .out_o(acc_blanked)
  );
`endif

`ifdef BNMULV_ACCH
  prim_blanker #(.Width(WLEN)) u_acch_blanker (
    .in_i (acch_no_intg_q),
    .en_i (mac_predec_bignum_i.acc_rd_en & operation_i.mulv),
    .out_o(acch_blanked)
  );
`endif

`ifdef TOWARDS_MAC
  // Add shifted multiplier result to current accumulator.
  assign adder_op_a = (operation_i.mac_mulv_en) ? {128'b0, mul_res} : mul_res_shifted;
  assign adder_op_b = (operation_i.mac_mulv_en) ? {128'b0, p_tmp_blanked} : acc_blanked;

  /* verilator lint_off UNUSEDSIGNAL */
  logic [7:0]    adder_x_carry_out;
  /* verilator lint_on UNUSEDSIGNAL */

  towards_mac_adder adder (
    .A(adder_op_a),
    .B(adder_op_b),
    .word_mode({operation_i.mac_mulv_en, operation_i.vector_type[0]}),
    .cin(1'b0),
    .sum(adder_result),
    .cout(adder_x_carry_out)
  );

  logic [31:0]   adder_x_sum [7:0];

  for (genvar i = 0; i < 8; ++i) begin
    assign adder_x_sum[i][31:0] = adder_result[i*32 +: 32];
  end
`endif // TOWARDS_MAC

`ifndef TOWARDS_MAC
  // Add shifted multiplier result to current accumulator.
  assign adder_op_a = mul_res_shifted;

  `ifdef BNMULV_ACCH
  assign adder_op_b = {acch_blanked, acc_blanked};
  `else
  assign adder_op_b = acc_blanked;
  `endif
`endif

`ifdef BNMULV
  vec_type_e mode;
  assign mode = operation_i.mulv ? (operation_i.data_type == 1'b0 ? VecType_s32 : VecType_d64) :
                                   VecType_v256;

  `ifndef MAC_ADDER
    `define MAC_ADDER buffer_bit
  `endif

  `MAC_ADDER adder (
    .A        (adder_op_a[WLEN-1:0]),
    .B        (adder_op_b[WLEN-1:0]),
    .word_mode(mode),
    .cin      (1'b0),
    .res      (adder_result[WLEN-1:0]),
    .cout     ()
  );

  `ifdef BNMULV_ACCH
  `MAC_ADDER adder16 (
    .A        (operation_i.mulv ? adder_op_a[WLEN+:WLEN] : 256'b0),
    .B        (operation_i.mulv ? adder_op_b[WLEN+:WLEN] : 256'b0),
    .word_mode(operation_i.data_type == 1'b0 ? VecType_s32 : VecType_d64),
    .cin      (1'b0),
    .res      (adder_result[WLEN+:WLEN]),
    .cout     ()
  );
  `endif
`else
  `ifndef TOWARDS_MAC
  assign adder_result = adder_op_a + adder_op_b;
  `endif
`endif

  // Split zero check between the two halves of the result. This is used for flag setting (see
  // below).
  assign adder_result_hw_is_zero[0] = adder_result[WLEN/2-1:0] == 'h0;
  assign adder_result_hw_is_zero[1] = adder_result[WLEN/2+:WLEN/2] == 'h0;

  always_comb begin
`ifdef BNMULV
    case (operation_i.mulv)
      1'b0 : begin
`endif
        operation_flags_o.L    = adder_result[0];
        // L is always updated for .WO, and for .SO when writing to the lower half-word
        operation_flags_en_o.L = operation_i.shift_acc ? ~operation_i.wr_hw_sel_upper : 1'b1;
      
        // For .SO M is taken from the top-bit of shifted out half-word, otherwise it is taken from the
        // top-bit of the full result.
        operation_flags_o.M    = operation_i.shift_acc ? adder_result[WLEN/2-1] :
                                                          adder_result[WLEN-1];
        // M is always updated for .WO, and for .SO when writing to the upper half-word.
        operation_flags_en_o.M = operation_i.shift_acc ? operation_i.wr_hw_sel_upper : 1'b1;
      
        // For .SO Z is calculated from the shifted out half-word, otherwise it is calculated on the full
        // result.
        operation_flags_o.Z    = operation_i.shift_acc ? adder_result_hw_is_zero[0] :
                                                          &adder_result_hw_is_zero;
      
        // Z is updated for .WO. For .SO updates are based upon result and half-word:
        // - When writing to lower half-word always update Z.
        // - When writing to upper half-word clear Z if result is non-zero otherwise leave it alone.
        operation_flags_en_o.Z =
            operation_i.shift_acc & operation_i.wr_hw_sel_upper ? ~adder_result_hw_is_zero[0] : 1'b1;
`ifdef BNMULV
      end
      default: begin
        operation_flags_o.L    = 1'b0;
        operation_flags_en_o.L = 1'b0;
        operation_flags_o.M    = 1'b0;
        operation_flags_en_o.M = 1'b0;
        operation_flags_o.Z    = 1'b0;
        operation_flags_en_o.Z = 1'b0;
      end
    endcase
`endif
  end

  // MAC never sets the carry flag
  assign operation_flags_o.C    = 1'b0;
  assign operation_flags_en_o.C = 1'b0;

`ifdef TOWARDS_MAC
  // Select if reduced or truncated result is selected as output
  logic [QWLEN-1:0] multiplier_result_red;
  logic [QWLEN-1:0] multiplier_result_trunc;
  logic [QWLEN-1:0] multiplier_result;
`endif

  always_comb begin
    acc_no_intg_d = '0;
    unique case (1'b1)
      // Non-encoded inputs have to be encoded before writing to the register.
      sec_wipe_acc_urnd_i: begin
        acc_no_intg_d = urnd_data_i;
        acc_intg_d = acc_intg_calc;
      end
      default: begin
        // If performing an ACC ISPR write the next accumulator value is taken from the ISPR write
        // data, otherwise it is drawn from the adder result. The new accumulator can be optionally
        // shifted right by one half-word (shift_acc).
        if (ispr_acc_wr_en_i) begin
          acc_intg_d = ispr_acc_wr_data_intg_i;
        end else begin
`ifdef TOWARDS_MAC
          if ((operation_i.mac_mulv_en) & ((stall_state == 2'b10) | !operation_i.vector_type[2])) begin
            unique case (stall_state_qwsel)
              2'd0: acc_no_intg_d = {acc_no_intg_q[WLEN-1:64], multiplier_result};
              2'd1: acc_no_intg_d = {acc_no_intg_q[WLEN-1:128], multiplier_result, acc_no_intg_q[63:0]};
              2'd2: acc_no_intg_d = {acc_no_intg_q[WLEN-1:192], multiplier_result, acc_no_intg_q[127:0]};
              2'd3: acc_no_intg_d = {multiplier_result, acc_no_intg_q[191:0]};
              default: acc_no_intg_d = '0;
            endcase
            acc_intg_d = acc_intg_calc;
          end else begin
            acc_no_intg_d = operation_i.shift_acc ? {{QWLEN*2{1'b0}}, adder_result[QWLEN*2+:QWLEN*2]}
                                                  : adder_result;
            acc_intg_d = acc_intg_calc;
          end
`else
          acc_no_intg_d = operation_i.shift_acc ? {{(QWLEN*2){1'b0}}, adder_result[QWLEN*2+:QWLEN*2]}
                                                  : adder_result[0+:WLEN];
          acc_intg_d = acc_intg_calc;
`endif
        end
      end
    endcase
  end

`ifdef BNMULV_ACCH
  always_comb begin
    acch_no_intg_d = '0;
    unique case (1'b1)
      // Non-encoded inputs have to be encoded before writing to the register.
      sec_wipe_acc_urnd_i: begin   // FIX ME!
        acch_no_intg_d = urnd_data_i;   // FIX ME!
        acch_intg_d = acch_intg_calc;
      end
      default: begin
        if (ispr_acch_wr_en_i) begin
          acch_intg_d = ispr_acch_wr_data_intg_i;
        end else begin
          acch_no_intg_d = adder_result[WLEN+:WLEN];
          acch_intg_d = acch_intg_calc;
        end
      end
    endcase
  end
`endif

  // Only write to accumulator if the MAC is enabled or an ACC ISPR write is occuring or secure
  // wipe of the internal state is occuring.
`ifdef TOWARDS_MAC
  assign acc_en = (mac_en_i & mac_commit_i) | ispr_acc_wr_en_i | sec_wipe_acc_urnd_i | mulv_acc_en;
`else
  assign acc_en = (mac_en_i & mac_commit_i) | ispr_acc_wr_en_i | sec_wipe_acc_urnd_i;
`endif
`ifdef BNMULV_ACCH
  assign acch_en = (mac_en_i & mac_commit_i & operation_i.mulv) | ispr_acch_wr_en_i | sec_wipe_acc_urnd_i;  // FIX ME acch
`endif

  always_ff @(posedge clk_i) begin
    if (acc_en) begin
      acc_intg_q <= acc_intg_d;
    end
`ifdef BNMULV_ACCH
    if (acch_en) begin
      acch_intg_q <= acch_intg_d;
    end
`endif
  end

  assign ispr_acc_intg_o = acc_intg_q;

`ifdef TOWARDS_MAC
  logic [32:0] s16 [7:0];
  logic [64:0] s32 [1:0];

  logic [16:0] t16 [7:0];
  logic [32:0] t32 [1:0];

  // Extract t from s for LOG_R=DATA_WIDTH = 16(32)
  // Computes t = s[LOG_R+DATA_WIDTH:LOG_R];
  generate;
    for (genvar i = 0; i < 4; ++i) begin : g_t_16
      assign s16[i] = {adder_x_carry_out[i],adder_x_sum[i]};
      assign t16[i] = s16[i][32:16];
    end : g_t_16

    for (genvar i = 0; i < 2; ++i) begin : g_t_32
      assign s32[i] = {adder_x_carry_out[2*i + 1],adder_x_sum[2*i + 1],adder_x_sum[2*i]};
      assign t32[i] = s32[i][64:32];
    end : g_t_32
  endgenerate

  logic [16:0] t [15:0];
  
  for (genvar i = 0; i < 4; ++i) begin
    assign t[i] = operation_i.vector_type[0] ?
        t16[i] : ((i%2 == 0) ? t32[i >> 1][16:0] : {1'b0, t32[i >> 1][32:17]});   
  end

  // Conditional subtraction if t needs to be reduced via carry select subtractor
  // Splitt 256-bit addition into 16 x 16-bit additions
  // Computes (q_i <= t) ? t : t-q_i
  logic [16:0] subtractor_op_a [15:0];
  logic [17:0] subtractor_op_b [15:0];

  logic [17:0] subtractor_op_a_blanked [15:0];
  logic [17:0] subtractor_op_b_blanked [15:0];

  logic [15:0] subtractor_carry_in;
  logic [16:0] subtractor_sum [15:0];
  logic [15:0] subtractor_carry_out;
  logic [15:0] subtractor_carry_in_unused;

  logic subtractor_carry_i;
  assign subtractor_carry_i = 1'b1;

  logic subtractor_en_i;
  assign subtractor_en_i = 1'b1;
  
  // Select t or t-q
  logic [3:0] tq_cond_16;
  logic [3:0] tq_cond_32;

  for (genvar i = 0; i < 4; ++i) begin
    assign tq_cond_16[i] = ({1'b0,operation_i.mod[15:0]} <= t16[i]) ? 1'b1 : 1'b0;
  end

  for (genvar i = 0; i < 2; ++i) begin
    assign tq_cond_32[2*i] = ({1'b0,operation_i.mod[31:0]} <= t32[i]) ? 1'b1 : 1'b0;
    assign tq_cond_32[2*i + 1] = ({1'b0,operation_i.mod[31:0]}  <= t32[i]) ? 1'b1 : 1'b0;
  end

  for (genvar i = 0; i < 16; ++i) begin
    // Depending on mode, select carry input for the 32-bit subtractors
    assign subtractor_carry_in[i] = operation_i.vector_type[0] ?
        subtractor_carry_i : ((i%2 == 0) ? subtractor_carry_i : subtractor_carry_out[i - 1]);
    
    assign subtractor_op_a[i] = t[i];

    // SEC_CM: DATA_REG_SW.SCA
    prim_blanker #(.Width(18)) u_subtractor_op_a_blanked (
    .in_i ({subtractor_op_a[i], 1'b1}),
    .en_i (subtractor_en_i),
    .out_o(subtractor_op_a_blanked[i])
    );

    assign subtractor_op_b[i] = operation_i.vector_type[0] ?
        {1'b1, ~q2mul[(i%2)*16+:16], subtractor_carry_in[i]} : 
        (i%2 == 0) ? {~q2mul[16:0], subtractor_carry_in[i]} : {2'b11,~q2mul[31:17], subtractor_carry_in[i]};

    // SEC_CM: DATA_REG_SW.SCA
    prim_blanker #(.Width(18)) u_subtractor_op_b_blanked (
    .in_i (subtractor_op_b[i]),
    .en_i (subtractor_en_i),
    .out_o(subtractor_op_b_blanked[i])
    );

    assign {subtractor_carry_out[i], subtractor_sum[i], subtractor_carry_in_unused[i]} =
        subtractor_op_a_blanked[i] + subtractor_op_b_blanked[i];  
  end

  // Select if 16-bit or 32-bit results
  logic [3:0] tq_cond;
  assign tq_cond = operation_i.vector_type[0] ? tq_cond_16 : tq_cond_32;

  always_comb begin
    for (int i = 0; i < 4; ++i) begin
      multiplier_result_trunc[16*i +: 16] = trunc_result[16*i +: 16];
      if (tq_cond[i] == 1'b1) begin
        multiplier_result_red[16*i +: 16] = operation_i.vector_type[0] ?
            subtractor_sum[i][15:0] :
            ((i%2 == 0) ? subtractor_sum[i][15:0] : {subtractor_sum[i][14:0], subtractor_sum[i-1][16]});
      end else begin
        multiplier_result_red[16*i +: 16] = operation_i.vector_type[0] ?
            t[i][15:0] : ((i%2 == 0) ? t[i][15:0] : {t[i][14:0], t[i-1][16]});
      end
    end
  end

  assign multiplier_result =
      operation_i.vector_type[2] ? multiplier_result_red : multiplier_result_trunc;

  // The operation result is taken directly from the adder, shift_acc only applies to the new value
  // written to the accumulator.
  assign operation_result_o = operation_i.mac_mulv_en ?
      {multiplier_result, acc_no_intg_q[191:0]} : adder_result;
`endif

`ifdef BNMULV_ACCH
  assign ispr_acch_intg_o = acch_intg_q;
`endif

  // The operation result is taken directly from the adder, shift_acc only applies to the new value
  // written to the accumulator.
`ifdef BNMULV
  always_comb begin
    case (operation_i.mulv)
      1'b0 : begin
        operation_result_o = adder_result[WLEN-1:0];
      end
      default: begin
        case (operation_i.exec_mode)
          2'b00 : begin
            `ifdef BNMULV_ACCH
            case (operation_i.data_type)
              1'b1 : begin
                operation_result_o = {adder_result[384 + 64*operation_i.sel +: 64],
                                      adder_result[256 + 64*operation_i.sel +: 64],
                                      adder_result[128 + 64*operation_i.sel +: 64],
                                      adder_result[      64*operation_i.sel +: 64]};
              end
              1'b0 : begin
                operation_result_o = {adder_result[448 + 32*operation_i.sel +: 32],
                                      adder_result[384 + 32*operation_i.sel +: 32],
                                      adder_result[320 + 32*operation_i.sel +: 32],
                                      adder_result[256 + 32*operation_i.sel +: 32],
                                      adder_result[192 + 32*operation_i.sel +: 32],
                                      adder_result[128 + 32*operation_i.sel +: 32],
                                      adder_result[ 64 + 32*operation_i.sel +: 32],
                                      adder_result[      32*operation_i.sel +: 32]};
              end
              default: begin
                operation_result_o = {WLEN{1'b0}};   // ERROR!
              end
            endcase
            `else
            operation_result_o = adder_result;
            `endif
          end
          2'b01 : begin
            case (operation_i.data_type)
              1'b1 : begin
                case (operation_i.sel)
                  `ifdef BNMULV_ACCH
                  1'b0: begin
                    operation_result_o = {operand_a_blanked[224+:32], adder_result[384+:32],
                                          operand_a_blanked[160+:32], adder_result[256+:32],
                                          operand_a_blanked[ 96+:32], adder_result[128+:32],
                                          operand_a_blanked[ 32+:32], adder_result[  0+:32]};
                  end
                  1'b1: begin
                    operation_result_o = {adder_result[384+64+:32], operand_a_blanked[192+:32],
                                          adder_result[256+64+:32], operand_a_blanked[128+:32],
                                          adder_result[128+64+:32], operand_a_blanked[ 64+:32],
                                          adder_result[  0+64+:32], operand_a_blanked[  0+:32]};
                  end
                  `else
                  1'b0: begin
                    operation_result_o = {operand_a_blanked[224+:32], adder_result[192+:32],
                                          operand_a_blanked[160+:32], adder_result[128+:32],
                                          operand_a_blanked[ 96+:32], adder_result[ 64+:32],
                                          operand_a_blanked[ 32+:32], adder_result[  0+:32]};
                  end
                  1'b1: begin
                    operation_result_o = {adder_result[192+:32], operand_a_blanked[192+:32],
                                          adder_result[128+:32], operand_a_blanked[128+:32],
                                          adder_result[ 64+:32], operand_a_blanked[ 64+:32],
                                          adder_result[  0+:32], operand_a_blanked[  0+:32]};
                  end
                  `endif
                endcase
              end
              1'b0 : begin
                `ifdef BNMULV_ACCH
                operation_result_o = {adder_result[480+:16], adder_result[448+:16],
                                      adder_result[416+:16], adder_result[384+:16],
                                      adder_result[352+:16], adder_result[320+:16],
                                      adder_result[288+:16], adder_result[256+:16],
                                      adder_result[224+:16], adder_result[192+:16],
                                      adder_result[160+:16], adder_result[128+:16],
                                      adder_result[ 96+:16], adder_result[ 64+:16],
                                      adder_result[ 32+:16], adder_result[  0+:16]};
                `else
                case (operation_i.sel)
                  1'b0: begin
                    operation_result_o = {operand_a_blanked[240+:16], adder_result[224+:16],
                                          operand_a_blanked[208+:16], adder_result[192+:16],
                                          operand_a_blanked[176+:16], adder_result[160+:16],
                                          operand_a_blanked[144+:16], adder_result[128+:16],
                                          operand_a_blanked[112+:16], adder_result[ 96+:16],
                                          operand_a_blanked[ 80+:16], adder_result[ 64+:16],
                                          operand_a_blanked[ 48+:16], adder_result[ 32+:16],
                                          operand_a_blanked[ 16+:16], adder_result[  0+:16]};
                  end
                  1'b1: begin
                    operation_result_o = {adder_result[224+:16], operand_a_blanked[224+:16],
                                          adder_result[192+:16], operand_a_blanked[192+:16],
                                          adder_result[160+:16], operand_a_blanked[160+:16],
                                          adder_result[128+:16], operand_a_blanked[128+:16],
                                          adder_result[ 96+:16], operand_a_blanked[ 96+:16],
                                          adder_result[ 64+:16], operand_a_blanked[ 64+:16],
                                          adder_result[ 32+:16], operand_a_blanked[ 32+:16],
                                          adder_result[  0+:16], operand_a_blanked[  0+:16]};
                  end
                endcase
                `endif
              end
              default: begin
                operation_result_o = {WLEN{1'b0}};   // ERROR!
              end
            endcase
          end
          2'b10, 2'b11 : begin
            case (operation_i.data_type)
              1'b1 : begin
                case (operation_i.sel)
                  `ifdef BNMULV_ACCH
                  1'b0: begin
                    operation_result_o = {operand_a_blanked[224+:32], adder_result[416+:32],
                                          operand_a_blanked[160+:32], adder_result[288+:32],
                                          operand_a_blanked[ 96+:32], adder_result[160+:32],
                                          operand_a_blanked[ 32+:32], adder_result[ 32+:32]};
                  end
                  1'b1: begin
                    operation_result_o = {adder_result[416+64+:32], operand_a_blanked[192+:32],
                                          adder_result[288+64+:32], operand_a_blanked[128+:32],
                                          adder_result[160+64+:32], operand_a_blanked[ 64+:32],
                                          adder_result[ 32+64+:32], operand_a_blanked[  0+:32]};
                  end
                  `else
                  1'b0: begin
                    operation_result_o = {operand_a_blanked[224+:32], adder_result[192+32+:32],
                                          operand_a_blanked[160+:32], adder_result[128+32+:32],
                                          operand_a_blanked[ 96+:32], adder_result[ 64+32+:32],
                                          operand_a_blanked[ 32+:32], adder_result[  0+32+:32]};
                  end
                  1'b1: begin
                    operation_result_o = {adder_result[192+32+:32], operand_a_blanked[192+:32],
                                          adder_result[128+32+:32], operand_a_blanked[128+:32],
                                          adder_result[ 64+32+:32], operand_a_blanked[ 64+:32],
                                          adder_result[  0+32+:32], operand_a_blanked[  0+:32]};
                  end
                  `endif
                endcase
              end
              1'b0 : begin
                `ifdef BNMULV_ACCH
                operation_result_o = {adder_result[496+:16], adder_result[464+:16],
                                      adder_result[432+:16], adder_result[400+:16],
                                      adder_result[368+:16], adder_result[336+:16],
                                      adder_result[304+:16], adder_result[272+:16],
                                      adder_result[240+:16], adder_result[208+:16],
                                      adder_result[176+:16], adder_result[144+:16],
                                      adder_result[112+:16], adder_result[ 80+:16],
                                      adder_result[ 48+:16], adder_result[ 16+:16]};
                `else
                case (operation_i.sel)
                  1'b0: begin
                    operation_result_o = {operand_a_blanked[240+:16], adder_result[224+16+:16],
                                          operand_a_blanked[208+:16], adder_result[192+16+:16],
                                          operand_a_blanked[176+:16], adder_result[160+16+:16],
                                          operand_a_blanked[144+:16], adder_result[128+16+:16],
                                          operand_a_blanked[112+:16], adder_result[ 96+16+:16],
                                          operand_a_blanked[ 80+:16], adder_result[ 64+16+:16],
                                          operand_a_blanked[ 48+:16], adder_result[ 32+16+:16],
                                          operand_a_blanked[ 16+:16], adder_result[  0+16+:16]};
                  end
                  1'b1: begin
                    operation_result_o = {adder_result[224+16+:16], operand_a_blanked[224+:16],
                                          adder_result[192+16+:16], operand_a_blanked[192+:16],
                                          adder_result[160+16+:16], operand_a_blanked[160+:16],
                                          adder_result[128+16+:16], operand_a_blanked[128+:16],
                                          adder_result[ 96+16+:16], operand_a_blanked[ 96+:16],
                                          adder_result[ 64+16+:16], operand_a_blanked[ 64+:16],
                                          adder_result[ 32+16+:16], operand_a_blanked[ 32+:16],
                                          adder_result[  0+16+:16], operand_a_blanked[  0+:16]};
                  end
                endcase
                `endif
              end
              default: begin
                operation_result_o = {WLEN{1'b0}};   // ERROR!
              end
            endcase
          end
          default: begin
            operation_result_o = adder_result[WLEN-1:0];
          end
        endcase
      end
    endcase
  end
`else
  `ifndef TOWARDS_MAC
  assign operation_result_o = adder_result;
  `endif
`endif

`ifdef BNMULV
  assign expected_op_en     = mac_en_i | operation_i.mulv;
`else
  assign expected_op_en     = mac_en_i;
`endif

`ifdef TOWARDS_MAC
  assign expected_acc_rd_en = ~operation_i.mac_mulv_en & (~operation_i.zero_acc & mac_en_i);
  assign expected_type      = operation_i.vector_type;
  assign expected_mulv_en   = operation_i.mac_mulv_en;

  // SEC_CM: CTRL.REDUN
  assign predec_error_o = |{expected_op_en     != mac_predec_bignum_i.op_en,
                            expected_acc_rd_en != mac_predec_bignum_i.acc_rd_en,
                            expected_type      != mac_predec_bignum_i.mulv_type,
                            expected_mulv_en   != mac_predec_bignum_i.mac_mulv_en};
`else
  assign expected_acc_rd_en = ~operation_i.zero_acc & mac_en_i;

  // SEC_CM: CTRL.REDUN
  assign predec_error_o = |{expected_op_en     != mac_predec_bignum_i.op_en,
                            expected_acc_rd_en != mac_predec_bignum_i.acc_rd_en};
`endif

`ifdef BNMULV_ACCH
  assign sec_wipe_err_o = sec_wipe_acc_urnd_i & ~sec_wipe_running_i; // FIX ME acch
`else
  assign sec_wipe_err_o = sec_wipe_acc_urnd_i & ~sec_wipe_running_i;
`endif

  `ASSERT(NoISPRAccWrAndMacEn, ~(ispr_acc_wr_en_i & mac_en_i))
`ifdef BNMULV_ACCH
  `ASSERT(NoISPRAccHWrAndMacEn, ~(ispr_acch_wr_en_i & mac_en_i))
`endif
endmodule
