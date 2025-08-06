// Vector CPA with bit propagate/kill insertion adder based conditional subtraction.
// A - B >= 0 ? A - B : A

module cond_sub (
  input  logic [255:0] A,
  input  logic [255:0] B,
  input  logic         word_mode,   // 0: vec16, 1: vec32
  input  logic         cin,
  output logic [255:0] sum,
  output logic         cout
);
  logic [270:0] A_buffed;
  logic [270:0] B_buffed;
  logic [271:0] R_buffed;

  genvar i;

  // Compute A - B = A + ~B + 1
  generate
    for (i = 0; i < 16; i++) begin
      assign A_buffed[i*17 +: 16] = A[i*16 +: 16];
      assign B_buffed[i*17 +: 16] = ~B[i*16 +: 16];
    end

    for (i = 0; i < 15; i += 2) begin
      assign A_buffed[i*17 + 16] = (word_mode == 1'b0) ? 1'b1 : 1'b0;
      assign B_buffed[i*17 + 16] = 1'b1;
    end

    for (i = 1; i < 15; i += 2) begin
      assign A_buffed[i*17 + 16] = 1'b1;
      assign B_buffed[i*17 + 16] = 1'b1;
    end
  endgenerate

  assign R_buffed = A_buffed + B_buffed + 271'b1;

  // Compute R = A - B >= 0 ? A - B : A
  // If A - B >= 0, the top bit (buffer bit) will be set. Otherwise, it's clear.
  generate
    for (i = 0; i < 16; i += 2) begin
      assign sum[i*16 +: 16] =
          (word_mode == 1'b0 ? R_buffed[i*17 + 16] == 1'b1 : R_buffed[(i + 1)* 17 + 16] == 1'b1) ?
              R_buffed[i*17 +: 16] : A[i*16 +: 16];
      assign sum[(i + 1)*16 +: 16] = R_buffed[(i + 1)*17 + 16] == 1'b1 ?
          R_buffed[(i + 1)*17 +: 16] : A[(i + 1)*16 +: 16];
    end
  endgenerate

  assign cout = 1'b0;

endmodule