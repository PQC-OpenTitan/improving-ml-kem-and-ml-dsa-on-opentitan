module sklansky
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

    logic [255:0] g, p;

/* verilator lint_off UNUSEDSIGNAL */
    logic [255:0] g_0, p_0;
    logic [255:0] g_s1, p_s1;
    logic [255:0] g_s2, p_s2;
    logic [255:0] g_s3, p_s3;
    logic [255:0] g_s4, p_s4;
    logic [255:0] g_s5, p_s5;
    logic [255:0] g_s6, p_s6;
    logic [255:0] g_s7, p_s7;
    logic [255:0] g_s8, p_s8;
    logic [255:0] carry;
/* verilator lint_on UNUSEDSIGNAL */

    assign g = A & B;
    assign p = A ^ B;

    assign g_0[0] = g[0]  | (p[0] & cin);
    assign p_0[0] = 1'b0;

    genvar i;
    generate
        for (i = 1; i < 256; i = i + 1) begin : setup
            assign g_0[i] = g[i];
            assign p_0[i] = p[i];
        end

        // Stage 1 (distance = 1)
        for (i = 0; i < 256; i = i + 1) begin : stage_1
            if ((i % 2) == 1) begin
                assign g_s1[i] = g_0[i] | (p_0[i] & g_0[i - (i%2) + 0]);
                assign p_s1[i] = p_0[i] & p_0[i - (i%2) + 0];
            end else begin
                assign g_s1[i] = g_0[i];
                assign p_s1[i] = p_0[i];
            end
        end

        // Stage 2 (distance = 2)
        for (i = 0; i < 256; i = i + 1) begin : stage_2
            if ((i % 4) >= 2) begin
                assign g_s2[i] = g_s1[i] | (p_s1[i] & g_s1[i - (i%4) + 1]);
                assign p_s2[i] = p_s1[i] & p_s1[i - (i%4) + 1];
            end else begin
                assign g_s2[i] = g_s1[i];
                assign p_s2[i] = p_s1[i];
            end
        end

        // Stage 3 (distance = 4)
        for (i = 0; i < 256; i = i + 1) begin : stage_3
            if ((i % 8) >= 4) begin
                assign g_s3[i] = g_s2[i] | (p_s2[i] & g_s2[i - (i%8) + 3]);
                assign p_s3[i] = p_s2[i] & p_s2[i - (i%8) + 3];
            end else begin
                assign g_s3[i] = g_s2[i];
                assign p_s3[i] = p_s2[i];
            end
        end

        // Stage 4 (distance = 8)
        for (i = 0; i < 256; i = i + 1) begin : stage_4
            if ((i % 16) >= 8) begin
                assign g_s4[i] = g_s3[i] | (p_s3[i] & g_s3[i - (i%16) + 7]);
                assign p_s4[i] = p_s3[i] & p_s3[i - (i%16) + 7];
            end else begin
                assign g_s4[i] = g_s3[i];
                assign p_s4[i] = p_s3[i];
            end
        end

        // Stage 5 (distance = 16)
        for (i = 0; i < 256; i = i + 1) begin : stage_5
            if ((i % 32) >= 16) begin
                assign g_s5[i] = (word_mode != VecType_h16) ? g_s4[i] | (p_s4[i] & g_s4[i - (i%32) + 15])  : g_s4[i] | (p_s4[i] & b_invert);
                assign p_s5[i] = (word_mode != VecType_h16) ? p_s4[i] & p_s4[i - (i%32) + 15]              : 1'b0;
            end else begin
                assign g_s5[i] = g_s4[i];
                assign p_s5[i] = p_s4[i];
            end
        end

        // Stage 6 (distance = 32)
        for (i = 0; i < 256; i = i + 1) begin : stage_6
            if ((i % 64) >= 32) begin
                assign g_s6[i] = ((word_mode != VecType_h16) & (word_mode != VecType_s32)) ? g_s5[i] | (p_s5[i] & g_s5[i - (i%64) + 31]) : g_s5[i] | (p_s5[i] & b_invert);
                assign p_s6[i] = ((word_mode != VecType_h16) & (word_mode != VecType_s32)) ? p_s5[i] & p_s5[i - (i%64) + 31]             : 1'b0;
            end else begin
                assign g_s6[i] = g_s5[i];
                assign p_s6[i] = p_s5[i];
            end
        end

        // Stage 7 (distance = 64)
        for (i = 0; i < 256; i = i + 1) begin : stage_7
            if ((i % 128) >= 64) begin
                assign g_s7[i] = ((word_mode != VecType_h16) & (word_mode != VecType_s32) & (word_mode != VecType_d64)) ? g_s6[i] | (p_s6[i] & g_s6[i - (i%128) + 63]) : g_s6[i] | (p_s6[i] & b_invert);
                assign p_s7[i] = ((word_mode != VecType_h16) & (word_mode != VecType_s32) & (word_mode != VecType_d64)) ? p_s6[i] & p_s6[i - (i%128) + 63]             : 1'b0;
            end else begin
                assign g_s7[i] = g_s6[i];
                assign p_s7[i] = p_s6[i];
            end
        end

        // Stage 8 (distance = 128)
        for (i = 0; i < 256; i = i + 1) begin : stage_8
            if ((i % 256) >= 128) begin
                assign g_s8[i] = (word_mode == VecType_v256) ? g_s7[i] | (p_s7[i] & g_s7[i - (i%256) + 127]) : g_s7[i] | (p_s7[i] & b_invert);
                assign p_s8[i] = (word_mode == VecType_v256) ? p_s7[i] & p_s7[i - (i%256) + 127]             : 1'b0;
            end else begin
                assign g_s8[i] = g_s7[i];
                assign p_s8[i] = p_s7[i];
            end
        end
    endgenerate

    assign carry[0] = cin;
    generate
        for (i = 1; i < 256; i = i + 1) begin : carry_assign
          if ((i % 64) == 0)
            assign carry[i] = (word_mode == VecType_v256) ? g_s8[i - 1] : b_invert;
          else if ((i % 32) == 0)
            assign carry[i] = ((word_mode != VecType_h16) & (word_mode != VecType_s32)) ? g_s8[i - 1] : b_invert;
          else if ((i % 16) == 0)
            assign carry[i] = (word_mode != VecType_h16) ? g_s8[i - 1] : b_invert;
          else
            assign carry[i] = g_s8[i - 1];
        end
    endgenerate

    assign res = p ^ carry;

    generate
      for(i = 0; i < 15; i++) begin
        assign cout[i] = carry[i*16 + 16];
      end
    endgenerate

   assign cout[15] = g_s8[255];

endmodule
