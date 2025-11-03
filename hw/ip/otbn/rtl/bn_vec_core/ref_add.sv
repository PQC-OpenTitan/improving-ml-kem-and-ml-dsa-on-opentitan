// Copyright Ruben Niederhagen and Hoang Nguyen Hien Pham - authors of
// "Improving ML-KEM & ML-DSA on OpenTitan - Efficient Multiplication Vector Instructions for OTBN"
// (https://eprint.iacr.org/2025/2028)
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

module ref_add (
  input  logic [255:0] A,
  input  logic [255:0] B,
  input  logic [1:0]   word_mode,   // 00: scalar, 11: vec32, 10: vec16
  input  logic         cin,
  output logic [255:0] res,
  output logic         cout
);

  logic [256:0] C;

  assign C = A + B + {255'b0, cin};

  assign res = C[255:0];
  assign cout = C[256];

endmodule

