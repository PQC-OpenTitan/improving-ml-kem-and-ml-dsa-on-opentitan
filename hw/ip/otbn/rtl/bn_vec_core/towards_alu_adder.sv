// Copyright "Towards ML-KEM & ML-DSA on OpenTitan" Authors
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
// Modified by Ruben Niederhagen and Hoang Nguyen Hien Pham - authors of
// "Improving ML-KEM & ML-DSA on OpenTitan - Efficient Multiplication Vector Instructions for OTBN"
// (https://eprint.iacr.org/2025/2028)
// Copyright Ruben Niederhagen and Hoang Nguyen Hien Pham.

module towards_alu_adder
  import otbn_pkg::*;
(
  input  logic [16:0] A [15:0],
  input  logic [16:0] B [15:0],

  input  logic [1:0]   word_mode,   // 00: scalar, 11: vec32, 10: vec16
  input  logic         cin,
  output logic [255:0] sum,
  output logic [15:0]  cout
);
  logic [16:0] adder_x_op_a_blanked [15:0];
  logic [16:0] adder_x_op_b_blanked [15:0];

  logic [15:0] adder_x_vcarry_in;

  for (genvar i=0; i<16; ++i) begin
    assign adder_x_op_a_blanked[i] = A[i];
    assign adder_x_op_b_blanked[i][16:1] = B[i][16:1];
    assign adder_x_op_b_blanked[i][0] = adder_x_vcarry_in[i];
  end

  logic  adder_selvector_i;
  logic  adder_vector_i;
  assign adder_selvector_i = word_mode[0];
  assign adder_vector_i = word_mode[1];

  logic adder_x_carry_in_blanked;
  assign adder_x_carry_in_blanked = cin;

  logic [15:0] adder_x_carry_out;
  logic [15:0] adder_x_sum [15:0];
  logic [15:0] adder_x_carry_in_unused;

  for (genvar i=0; i<16; ++i) begin
    // Depending on mode, select carry input for the 16-bit adders
    assign adder_x_vcarry_in[i] =
        adder_vector_i ?
            (adder_selvector_i ? adder_x_carry_in_blanked : ((i%2==0) ? adder_x_carry_in_blanked : adder_x_carry_out[i-1])) :
            ((i==0) ? adder_x_carry_in_blanked : adder_x_carry_out[i-1]);


    assign {adder_x_carry_out[i],adder_x_sum[i],adder_x_carry_in_unused[i]} =
        adder_x_op_a_blanked[i] + adder_x_op_b_blanked[i];

    // Combine all sums to 256-bit vector
    assign sum[i*16+:16] = adder_x_sum[i][15:0];
  end

  assign cout = adder_x_carry_out;

endmodule
