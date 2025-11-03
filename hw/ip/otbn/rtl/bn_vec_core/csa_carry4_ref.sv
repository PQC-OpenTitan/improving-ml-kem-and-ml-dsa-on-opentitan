// Copyright Ruben Niederhagen and Hoang Nguyen Hien Pham - authors of
// "Improving ML-KEM & ML-DSA on OpenTitan - Efficient Multiplication Vector Instructions for OTBN"
// (https://eprint.iacr.org/2025/2028)
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// This module implements a Carry-Select vectorized adder which performs a
// 256-bit addition (original BN-ALU addition) for base bignum instructions
// (such as BN.ADD/SUB, BN.ADDM/SUBM, etc.), 8 32-bit additions for
// BN.{ADDV,SUBV}(.m).8S and 16 16-bit additions for BN.{ADDV,SUBV}(.m).16H. It
// uses CARRY4 modules of Xilinx. It mimics how Vivado synthesizes 256-bit addition:
// - The bottom 128 bits [127:0] use a regular CARRY4 chain with cin
// - The top 128 bits [255:128] have two independent CARRY4 chains:
//   one with carry_in = 0, one with carry_in = 1.
// All these in total three 128-bit additions are performed in parallel.
// Depending on the cout of the low adder either the result of the carry_in = 0
// or that of carry_in = 1 top adder is returned as overall result.

// The adder is meant to replace Adder X and Adder Y in BN-ALU. So it can either
// compute in_A + in_B (A + B) or in_A + ~in_B + 1 (A + B + cin).

module csa_carry4_ref
  import otbn_pkg::*;
(
  input logic [WLEN-1:0]  A,
  input logic [WLEN-1:0]  B,
  input vec_type_e        word_mode,
  input logic             cin,
  output logic [WLEN-1:0] res,
  output logic [15:0]     cout
);
  // Pre-compute bitwise terms
  logic [WLEN-1:0] S_all;
  logic [WLEN-1:0] DI_all;

  assign S_all  = A ^ B;
  assign DI_all = A & B;

  // Build S, DI
  logic [WLEN-1:0] S;
  logic [WLEN-1:0] DI;

  genvar i;
  generate
    for(i = 0; i < 16; i++) begin
      assign S[i*16 +: 15]  = S_all[i*16 +: 15];
      assign DI[i*16 +: 15] = DI_all[i*16 +: 15];
    end

    for(i = 1; i < 17; i++) begin
      assign S[i*16 - 1]  = (word_mode == VecType_h16) ? (((i*16) % 16) == 0 ? 1'b0 : S_all[i*16 - 1]) :
                            (word_mode == VecType_s32) ? (((i*16) % 32) == 0 ? 1'b0 : S_all[i*16 - 1]) :
                            (word_mode == VecType_d64) ? (((i*16) % 64) == 0 ? 1'b0 : S_all[i*16 - 1]) :
                            S_all[i*16 - 1];
      assign DI[i*16 - 1] = (word_mode == VecType_h16) ? (((i*16) % 16) == 0 ? cin : DI_all[i*16 - 1]) :
                            (word_mode == VecType_s32) ? (((i*16) % 32) == 0 ? cin : DI_all[i*16 - 1]) :
                            (word_mode == VecType_d64) ? (((i*16) % 64) == 0 ? cin : DI_all[i*16 - 1]) :
                            DI_all[i*16 - 1];
    end
  endgenerate

  // First CARRY4 chain with bottom 128-bit
  logic [3:0] O  [0:63];
  /* verilator lint_off UNOPTFLAT */
  logic [3:0] CO [0:63];
  /* verilator lint_on UNOPTFLAT */

  generate
    for(i = 0; i < 32; i++) begin : gen_c_lo
      CARRY4 c_lo (
        .CI    ((i == 0) ? 1'b0 : CO[i - 1][3]),
        .CYINIT((i == 0) ? cin : 1'b0),
        .DI    (DI[i*4 +: 4]),
        .S     (S[i*4 +: 4]),
        .O     (O[i]),
        .CO    (CO[i]));
    end
  endgenerate

  // Second CARRY4 chain with top 128-bit: when cin = 0
  logic [3:0] O_HI0  [0:31];
  logic [3:0] CO_HI0 [0:31];

  generate
    for(i = 0; i < 32; i++) begin : gen_c_hi_0
      CARRY4 c_hi_0 (
        .CI    ((i == 0) ? 1'b0 : CO_HI0[i - 1][3]),
        .CYINIT(1'b0),
        .DI    (DI[(i + 32)*4 +: 4]),
        .S     (S[(i + 32)*4 +: 4]),
        .O     (O_HI0[i]),
        .CO    (CO_HI0[i]));
    end
  endgenerate

  // Second CARRY4 chain with top 128-bit: when cin = 1
  logic [3:0] O_HI1  [0:31];
  logic [3:0] CO_HI1 [0:31];
  
  generate
    for(i = 0; i < 32; i++) begin : gen_c_hi_1
      CARRY4 c_hi_1 (
        .CI    ((i == 0) ? 1'b1 : CO_HI1[i - 1][3]),
        .CYINIT(1'b0),
        .DI    (DI[(i + 32)*4 +: 4]),
        .S     (S[(i + 32)*4 +: 4]),
        .O     (O_HI1[i]),
        .CO    (CO_HI1[i]));
    end
  endgenerate

  // Reconstruct CI for top 128 bits
  logic [3:0] CI_HI0;
  logic [3:0] CI_HI1;
  assign CI_HI0 = {4 {CO[31][3] == 0}};
  assign CI_HI1 = {4 {CO[31][3] == 1}};

  generate
    for(i = 0; i < 32; i++) begin
      assign O[i + 32] = (CI_HI0 & O_HI0[i]) ^ (CI_HI1 & O_HI1[i]);
      assign CO[i + 32] = (CI_HI0 & CO_HI0[i]) ^ (CI_HI1 & CO_HI1[i]);
    end
  endgenerate

  // Reconstruct final output and cout
  logic [15:0] SFIX;
  generate
    for(i = 0; i < 16; i++) begin
      assign res[i*16 +: 15] = {O[i*4 + 3][2:0], O[i*4 + 2], O[i*4 + 1], O[i*4]};
      assign SFIX[i] = S_all[(i + 1)*16 - 1] ^ CO[i*4 + 3][2];
      assign cout[i] = (S_all[(i + 1)*16 - 1] & CO[i*4 + 3][2]) | DI_all[(i + 1)*16 - 1];
    end

    for(i = 1; i < 17; i++) begin
      assign res[i*16 - 1] =
          (word_mode == VecType_h16) ? (((i*16) % 16) == 0 ? SFIX[i - 1] : O[(i-1)*4 + 3][3]) :
          (word_mode == VecType_s32) ? (((i*16) % 32) == 0 ? SFIX[i - 1] : O[(i-1)*4 + 3][3]) :
          (word_mode == VecType_d64) ? (((i*16) % 64) == 0 ? SFIX[i - 1] : O[(i-1)*4 + 3][3]) :
          O[(i-1)*4 + 3][3];
    end
  endgenerate
endmodule
