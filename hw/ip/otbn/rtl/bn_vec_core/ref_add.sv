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

