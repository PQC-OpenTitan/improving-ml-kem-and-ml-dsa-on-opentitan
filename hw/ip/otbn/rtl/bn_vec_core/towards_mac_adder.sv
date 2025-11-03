// Copyright "Towards ML-KEM & ML-DSA on OpenTitan" Authors
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
// Modified by Ruben Niederhagen and Hoang Nguyen Hien Pham - authors of
// "Improving ML-KEM & ML-DSA on OpenTitan - Efficient Multiplication Vector Instructions for OTBN"
// (https://eprint.iacr.org/2025/2028)
// Copyright Ruben Niederhagen and Hoang Nguyen Hien Pham.

module towards_mac_adder
  import otbn_pkg::*;
(
  input  logic [255:0] A,
  input  logic [255:0] B,
  input  logic [1:0]   word_mode,   // 00: scalar, 11: vec32, 10: vec16
  input  logic         cin,
  output logic [255:0] sum,
  output logic [7:0]   cout
);

  logic [255:0] adder_op_a;
  logic [255:0] adder_op_b;

  assign adder_op_a = A;
  assign adder_op_b = B;

  // Splitt 256-bit addition into 16 x 16-bit additions
  logic  adder_x_carry_in;
  assign adder_x_carry_in = cin;

  logic  adder_x_op_b_invert;
  assign adder_x_op_b_invert = 'b0;

  logic [WLEN:0] adder_x_res;
  logic [31:0]   adder_x_op_a [7:0];
  logic [32:0]   adder_x_op_b [7:0];
  logic [32:0]   adder_x_op_a_blanked [7:0];
  logic [32:0]   adder_x_op_b_blanked [7:0];
  logic [7:0]    adder_x_vcarry_in;
  logic [31:0]   adder_x_sum [7:0];
  logic [7:0]    adder_x_carry_out;
  logic [7:0]    adder_x_carry2mux;
  logic [7:0]    unused_adder_x_carry2mux;
  logic [7:0]    adder_x_carry_in_unused;

  assign adder_x_carry2mux = 'b0;
  assign unused_adder_x_carry2mux = adder_x_carry2mux;

  logic adder_selvector_i;
  logic adder_vector_i;

  assign adder_selvector_i = word_mode[0];
  assign adder_vector_i    = word_mode[1];

  // For Kyber :    32-bit + 16-bit addition
  // For Dilitihum: 64-bit + 32-bit addition
  // Support for 32-bit additions(Kyber) and 64-bit additions(Dilitihum)
  for (genvar i = 0; i < 8; ++i) begin
    // Depending on mode, select carry input for the 16-bit adders
    assign adder_x_vcarry_in[i] = adder_vector_i ?
        (adder_selvector_i ? adder_x_carry_in : ((i%2 == 0) ? adder_x_carry_in : adder_x_carry_out[i - 1])) :
        ((i == 0) ? adder_x_carry_in : adder_x_carry_out[i-1]);

    assign adder_x_op_a[i] = adder_op_a[i*32 +: 32];

    // // SEC_CM: DATA_REG_SW.SCA
    // prim_blanker #(.Width(33)) u_adder_op_a_blanked (
    //   .in_i ({adder_x_op_a[i], 1'b1}),
    //   .en_i (1'b1),
    //   .out_o(adder_x_op_a_blanked[i])
    // );

    assign adder_x_op_a_blanked[i] = {adder_x_op_a[i], 1'b1};

    assign adder_x_op_b[i] = {adder_x_op_b_invert ? ~adder_op_b[i*32 +: 32] : adder_op_b[i*32 +: 32],
                              adder_x_vcarry_in[i]};

    // // SEC_CM: DATA_REG_SW.SCA
    // prim_blanker #(.Width(33)) u_adder_op_b_blanked (
    //   .in_i (adder_x_op_b[i]),
    //   .en_i (1'b1),
    //   .out_o(adder_x_op_b_blanked[i])
    // );

    assign adder_x_op_b_blanked[i] = adder_x_op_b[i];

    assign {adder_x_carry_out[i], adder_x_sum[i], adder_x_carry_in_unused[i]} =
        adder_x_op_a_blanked[i] + adder_x_op_b_blanked[i];

    // Combine all sums to 256-bit vector
    assign adder_x_res[1 + i*32 +: 32] = adder_x_sum[i][31:0];
  end

  // The LSb of the adder results are unused.
  logic unused_adder_x_res_lsb;
  assign unused_adder_x_res_lsb = adder_x_res[0];
  assign adder_x_res[0]         = 1'b0;
  assign sum                    = adder_x_res[WLEN:1];
  assign cout                   = adder_x_carry_out;

endmodule
