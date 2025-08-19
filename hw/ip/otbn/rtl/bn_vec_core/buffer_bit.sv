// This module implements a buffered-bit adder which performs a 256-bit addition
// (original BN-ALU addition) for base bignum instructions (such as BN.ADD/SUB,
// BN.ADDM/SUBM, etc.), 8 32-bit additions for BN.{ADDV,SUBV}(.m).8S and 16 16-bit
// additions for BN.{ADDV,SUBV}(.m).16H.
// The adder is meant to replace Adder X and Adder Y in BN-ALU. So it can either
// compute in_A + in_B (A + B) or in_A + ~in_B + 1 (A + B + cin).

module buffer_bit #(
  parameter int WLEN = 256
) (
  input logic [WLEN-1:0]  A,
  input logic [WLEN-1:0]  B,
  input logic             vector_en,
  input logic             word_mode, // 1: vec16, 0: vec32
  input logic             b_invert,
  input logic             cin,
  output logic [WLEN+1:0] sum,
  output logic [15:0]     cout
);

  logic [WLEN+14:0] A_buffed;
  logic [WLEN+14:0] B_buffed;
  logic [WLEN+15:0] R_buffed;

  genvar i;

  generate
    for (i = 0; i < 16; i++) begin
      assign A_buffed[i*17 +: 16] = A[i*16 +: 16];
      assign B_buffed[i*17 +: 16] = B[i*16 +: 16];
    end

    for (i = 0; i < 15; i += 2) begin
      assign A_buffed[i*17 + 16] =
          (vector_en == 1'b0) ? 1'b0 : (word_mode & b_invert);
      assign B_buffed[i*17 + 16] =
          (vector_en == 1'b0) ? 1'b1 : ((word_mode & b_invert) ^ (~word_mode));
    end

    for (i = 1; i < 15; i += 2) begin
      assign A_buffed[i*17 + 16] = (vector_en == 1'b0) ? 1'b0 : b_invert;
      assign B_buffed[i*17 + 16] = (vector_en == 1'b0) ? 1'b1 : b_invert;
    end
  endgenerate

  assign R_buffed = A_buffed + B_buffed + {271'b0, cin};

  generate
    for(i = 0; i < 16; i++) begin
      assign sum[(i*16 + 1) +: 16] = R_buffed[i*17 +: 16];
      assign cout[i] = R_buffed[i*17 + 16];
    end
  endgenerate

  assign sum[WLEN + 1] = cout[15];

endmodule
