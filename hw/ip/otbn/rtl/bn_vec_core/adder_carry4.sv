// This module implements a vectorized adder which performs a 256-bit addition
// (original BN-ALU addition) for base bignum instructions (such as BN.ADD/SUB,
// BN.ADDM/SUBM, etc.), 8 32-bit additions for BN.{ADDV,SUBV}(.m).8S and 16 16-bit
// additions for BN.{ADDV,SUBV}(.m).16H. It uses CARRY4 modules of Xilinx.
// The adder is meant to replace Adder X and Adder Y in BN-ALU. So it can either
// compute in_A + in_B (A + B) or in_A + ~in_B + 1 (A + B + cin).

`ifdef BNMULV
module adder_carry4
    import otbn_pkg::*;
(
  input logic [WLEN-1:0]  A,
  input logic [WLEN-1:0]  B,
  input vec_type_e        word_mode,
  input logic             b_invert,
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
      assign DI[i*16 - 1] = (word_mode == VecType_h16) ? (((i*16) % 16) == 0 ? b_invert : DI_all[i*16 - 1]) :
                            (word_mode == VecType_s32) ? (((i*16) % 32) == 0 ? b_invert : DI_all[i*16 - 1]) :
                            (word_mode == VecType_d64) ? (((i*16) % 64) == 0 ? b_invert : DI_all[i*16 - 1]) :
                            DI_all[i*16 - 1];
    end
  endgenerate

  // Use CARRY4
  logic [3:0] O  [0:63];
  logic [3:0] CO [0:63];

  CARRY4 c0 (.CI(1'b0), .CYINIT(cin), .DI(DI[3:0]), .S(S[3:0]), .O(O[0]), .CO(CO[0]));
  generate
    for(i = 1; i < 64; i++) begin : gen_c
      CARRY4 c (.CI(CO[i - 1][3]), .CYINIT(1'b0), .DI(DI[i*4 +: 4]), .S(S[i*4 +: 4]), .O(O[i]), .CO(CO[i]));
    end
  endgenerate

  // Reconstruct outputs
  logic [15:0] SFIX;
  generate
    for(i = 0; i < 16; i++) begin
      assign res[i*16 +: 15] = {O[i*4 + 3][2:0], O[i*4 + 2], O[i*4 + 1], O[i*4]};
    end

    for(i = 1; i < 17; i++) begin
      assign SFIX[i - 1] =  S_all[i*16 - 1] ^ CO[(i-1)*4 + 3][2];
      assign cout[i - 1] = (S_all[i*16 - 1] & CO[(i-1)*4 + 3][2]) | DI_all[i*16 - 1];
      assign res[i*16 - 1] =
          (word_mode == VecType_h16) ? (((i*16) % 16) == 0 ? SFIX[i - 1] : O[(i-1)*4 + 3][3]) :
          (word_mode == VecType_s32) ? (((i*16) % 32) == 0 ? SFIX[i - 1] : O[(i-1)*4 + 3][3]) :
          (word_mode == VecType_d64) ? (((i*16) % 64) == 0 ? SFIX[i - 1] : O[(i-1)*4 + 3][3]) :
          O[(i-1)*4 + 3][3];
    end
  endgenerate
endmodule
`endif
