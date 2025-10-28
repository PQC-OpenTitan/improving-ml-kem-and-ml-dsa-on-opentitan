// 7-Series (DSP48E1) multimode multiplier with full column cascades.
// Modes:
//   mode=2'b00 : 1 × (64x64  -> 128b)
//   mode=2'b01 : 4 × (32x32  ->  64b)
//   mode=2'b10 : 16× (16x16  ->  32b)
//
// Single-cycle: all DSP regs disabled. Unsigned arithmetic.

module mul_dsp #(
  parameter int WLEN = 256,
  parameter int DLEN = 64,
  parameter int SLEN = 32,
  parameter int HLEN = 16
) (
  input  logic [1:0]                   word_mode, // 00 = 64x64, 11 = 4x32x32, 10 = 16x16x16
  input  logic [$clog2(WLEN/DLEN)-1:0] word_sel_A,
  input  logic [$clog2(WLEN/DLEN)-1:0] word_sel_B,
`ifdef BNMULV_ACCH
  input  logic [1:0]                   exec_mode,
`endif
  input  logic                         half_sel,
  input  logic                         lane_mode,
  input  logic                         lane_word_32,
  input  logic                         lane_word_16,
  input  logic [WLEN-1:0]              A,
  input  logic [WLEN-1:0]              B,
  input  logic [1:0]                   data_type_64_shift,
`ifdef BNMULV_ACCH
  output logic [2*WLEN-1:0]            result
`else
  output logic [WLEN-1:0]              result
`endif
);

  localparam int NHALF = WLEN / HLEN;  // 16
`ifndef BNMULV_ACCH
  localparam int NSING = WLEN / SLEN;  // 8
`endif
  localparam int NDOUB = WLEN / DLEN;  // 4

  logic [63:0] a64;
  logic [63:0] b64;

  logic [3:0][31:0] a32;
  logic [3:0][31:0] b32;

  logic [15:0][15:0] a16;
  logic [15:0][15:0] b16;

  logic [127:0]       p64;
  logic [3:0][63:0]   p32;
  logic [15:0][31:0]  p16;


  // -------------------------------------------------------------------
  // Input and intermediate arrays
  // -------------------------------------------------------------------
  logic [2*HLEN-1:0] products [0:NHALF-1];
  logic [2*SLEN-1:0] partial32 [0:NDOUB-1];

  localparam MODE_64 = 2'b00;
  localparam MODE_32 = 2'b11;
  localparam MODE_16 = 2'b10;

  logic [63:0] scalar64_A;
  logic [63:0] scalar64_B;

  // -------------------------------------------------------------------
  // Index Scalar Operands
  // -------------------------------------------------------------------

  assign scalar64_A = A[DLEN*word_sel_A +: DLEN];
  assign scalar64_B = B[DLEN*word_sel_B +: DLEN];

  logic [31:0] scalar32;
  logic [15:0] scalar16;

  assign scalar32 = scalar64_B[SLEN*lane_word_32 +: SLEN];
  assign scalar16 = scalar32[HLEN*lane_word_16 +: HLEN];

  // -------------------------------------------------------------------
  // Input Decomposition
  // -------------------------------------------------------------------
  always_comb begin
    // 16 x 16
    `ifdef BNMULV_ACCH
    if (exec_mode == 2'b00) begin
      for (int i = 0; i < NHALF; i+=2) begin
        if (half_sel == 1'b0) begin
          a16[i] = A[HLEN*i +: HLEN];
          b16[i] = (lane_mode == 1'b0) ? B[HLEN*i +: HLEN] : scalar16;
          a16[i+1] = 16'b0;
          b16[i+1] = 16'b0;
        end else begin
          a16[i] = 16'b0;
          b16[i] = 16'b0;
          a16[i+1] = A[(i+1)*HLEN +: HLEN];
          b16[i+1] = (lane_mode == 1'b0) ? B[(i+1)*HLEN +: HLEN] : scalar16;
        end
      end
    end else begin
      for (int i = 0; i < NHALF; i++) begin
        a16[i] = A[HLEN*i +: HLEN];
        b16[i] = (lane_mode == 1'b0) ? B[HLEN*i +: HLEN] : scalar16;
      end
    end
    `else
    for (int i = 0; i < NSING; i++) begin
      if (half_sel == 1'b0) begin
        a16[i] = A[HLEN*(2*i + 0) +: HLEN];
        b16[i] = (lane_mode == 1'b0) ? B[HLEN*(2*i + 0) +: HLEN] : scalar16;
      end else begin
        a16[i] = A[HLEN*(2*i + 1) +: HLEN];
        b16[i] = (lane_mode == 1'b0) ? B[HLEN*(2*i + 1) +: HLEN] : scalar16;
      end
    end
    `endif

    // 32 x 32
    for (int i = 0; i < NDOUB; i++) begin
      if (half_sel == 1'b0) begin
        a32[i] = A[SLEN*(2*i + 0) +: SLEN];
        b32[i] = (lane_mode == 1'b0) ? B[SLEN*(2*i + 0) +: SLEN] : scalar32;
      end
      else begin
        a32[i] = A[SLEN*(2*i + 1) +: SLEN];
        b32[i] = (lane_mode == 1'b0) ? B[SLEN*(2*i + 1) +: SLEN] : scalar32;
      end
    end

    // 64 x 64
    a64 = scalar64_A;
    b64 = scalar64_B;
  end


  localparam logic [6:0] OPMODE_M_ONLY       = 7'b0000001; // P = M
  localparam logic [6:0] OPMODE_M_PLUS_PCIN  = 7'b0010001; // P = M + PCIN
  localparam logic [3:0] ALU_ADD             = 4'b0000;

  // -------- split inputs --------
  // 64×64 into 16-bit tiles A64[i], B64[j], i,j in 0..3
  logic [15:0] A64 [0:3], B64 [0:3];
  assign {A64[3],A64[2],A64[1],A64[0]} = a64;
  assign {B64[3],B64[2],B64[1],B64[0]} = b64;

  // 4×32×32 halves (per tile g = {0:TL,1:TR,2:BL,3:BR})
  logic [15:0] A32h [0:3][0:1];
  logic [15:0] B32h [0:3][0:1];
  for (genvar g=0; g<4; g++) begin : SPLIT32
    assign A32h[g][0] = a32[g][15:0];
    assign A32h[g][1] = a32[g][31:16];
    assign B32h[g][0] = b32[g][15:0];
    assign B32h[g][1] = b32[g][31:16];
  end

  // -------- per-DSP selected 16×16 inputs (runtime) --------
  // DSP indices k = 0..15 laid out as 4×4 grid: k = 4*i + j (i=row, j=col).
  logic [15:0] dspA16 [0:15];
  logic [15:0] dspB16 [0:15];

  always_comb begin
    for (int k=0; k<16; k++) begin
      int i = k/4; int j = k%4;          // grid indices
      int gg = (i/2)*2 + (j/2);          // tile index 0..3 (TL,TR,BL,BR)
      int ii = i%2; int jj = j%2;        // 2×2 local row/col inside tile

      unique case (word_mode)
      2'b00: begin // 64×64
        dspA16[k] = A64[i];
        dspB16[k] = B64[j];
      end
      2'b11: begin // 4×32×32 mapped by tiles
        dspA16[k] = A32h[gg][ii];      // A0/A1
        dspB16[k] = B32h[gg][jj];      // B0/B1
      end
      default: begin // 2'b10: 16×16 independent
        dspA16[k] = a16[k];
        dspB16[k] = b16[k];
      end
      endcase
    end
  end

  logic [47:0] P     [0:15];
  logic [47:0] PCOUT [0:15];

  function automatic logic [6:0] op_for(input logic [1:0] m, input int idx);
    unique case (m)
      2'b10: op_for = OPMODE_M_ONLY;                                     // 16×16
      2'b11: op_for = (idx==4 || idx==6 || idx==12 || idx==14) ? OPMODE_M_PLUS_PCIN
                                          : OPMODE_M_ONLY;                // 32×32
      default: op_for = (idx==4 || idx==6 || idx==12 || idx==14 || idx==2 || idx==5  || idx==9  || idx==13  || idx== 10) 
                        ? OPMODE_M_PLUS_PCIN : OPMODE_M_ONLY;   // 64×64
    endcase
  endfunction

  `define DSP_CELL(idx, pcin_wire) \
    DSP48E1 #(.USE_MULT("MULTIPLY"), .USE_SIMD("ONE48"), \
              .AREG(0), .BREG(0), .MREG(0), .PREG(0), \
              .ACASCREG(0), .BCASCREG(0), .CREG(0), .DREG(0), .ADREG(0), \
              .INMODEREG(0), .ALUMODEREG(0), .OPMODEREG(0), \
              .CARRYINREG(0), .CARRYINSELREG(0)) \
    u_dsp``idx ( \
        .CLK(1'b0), \
        .A({14'b0, dspA16[idx]}), \
        .B({2'b0, dspB16[idx]}), \
        .C(48'd0), \
        .P(P[idx]), \
        .PCIN(pcin_wire), \
        .PCOUT(PCOUT[idx]), \
        .OPMODE(op_for(word_mode, idx)), \
        .ALUMODE(4'b0000), \
        .INMODE(5'b00000), \
        .ACIN(30'd0), .BCIN(18'd0), \
        .CARRYIN(1'b0), .CARRYINSEL(3'b000), \
        .CEA1(1'b0), .CEA2(1'b0), .CEB1(1'b0), .CEB2(1'b0), \
        .CEC(1'b0), .CEM(1'b0), .CEP(1'b0), \
        .RSTA(1'b0), .RSTB(1'b0), .RSTC(1'b0), .RSTM(1'b0), .RSTP(1'b0), \
        .RSTINMODE(1'b0), .RSTALLCARRYIN(1'b0), .RSTALUMODE(1'b0), .RSTCTRL(1'b0) );

  /* verilator lint_off PINMISSING */
  `DSP_CELL(0,  48'd0)
  `DSP_CELL(1,  48'd0)
  `DSP_CELL(4,  PCOUT[1])
  `DSP_CELL(5,  PCOUT[2])

  `DSP_CELL(2,  PCOUT[8])
  `DSP_CELL(3,  48'd0)
  `DSP_CELL(6,  PCOUT[3])
  `DSP_CELL(7,  48'd0)

  `DSP_CELL(8,  48'd0)
  `DSP_CELL(9,  PCOUT[6])
  `DSP_CELL(12, PCOUT[9])
  `DSP_CELL(13, PCOUT[7])

  `DSP_CELL(10, PCOUT[13])
  `DSP_CELL(11, 48'd0)
  `DSP_CELL(14, PCOUT[11])
  `DSP_CELL(15, 48'd0)
  /* verilator lint_on PINMISSING */

  // Final 64×64 sum across diagonals
  logic [127:0] sum64;

  logic [111:0] x;
  logic [111:0] y;
  logic [111:0] z;
  logic [111:0] sum;
  logic [111:0] carry;

  // 3:2 compressor input
  assign x = {{15'b0}, P[14][32:0], {14'd0}, P[ 5][33:0], P[0][31:16]};
  assign y = {P[15][31:0], P[10][31:0], {15'd0}, P[ 4][32:0]};
  assign z = (word_mode == 2'b00) ? {{30'b0}, P[10][33:32],{14'd0}, P[12][33:0], {32'b0}} : {112'b0};

  // 3:2 compressor
  always_comb begin
    for (int i = 0; i < 112; i++) begin
      sum[i]   = x[i] ^ y[i] ^ z[i];
      carry[i] = (x[i] & y[i]) | (y[i] & z[i]) | (z[i] & x[i]);
    end
  end

  assign sum64[15:0] = P[0][15:0];
  assign sum64[127:16] = sum + {carry[110:0], 1'b0};

  assign p64 = sum64;

  always_comb begin
    p32[1][15:0] = P[2][15:0];
    p32[1][63:16]  = {P[7][31:0], P[2][31:16]};
    p32[1][63:16] += {15'd0, P[6][32:0]};

    p32[2][15:0] = P[8][15:0];
    p32[2][63:16]  = {P[13][31:0], P[8][31:16]};
    p32[2][63:16] += {15'd0, P[12][32:0]};
  end

  assign p32[0] = sum64[0+:64];
  assign p32[3] = sum64[64+:64];

  for (genvar t=0; t<16; t++) begin : P16_OUT
    always_comb p16[t] = P[t][31:0];
  end

`ifdef BNMULV_ACCH
  logic [2*HLEN*NHALF-1:0] result_16;
`else
  logic [255:0] result_16;
`endif

  // -- 16x16 results --
  always_comb begin
    result_16 = '0;
    `ifdef BNMULV_ACCH
    for (int i = 0; i < NHALF; i++) begin : gen_output_16
      result_16[2*HLEN*i +: 2*HLEN] = p16[i];
    end
    `else
    for (int i = 0; i < NSING; i++) begin : gen_output_16
      result_16[2*HLEN*i +: 2*HLEN] = p16[i];
    end
    `endif
  end


  // -------------------------------------------------------------------
  // Unified Output Selection
  // -------------------------------------------------------------------
  always_comb begin
    result = '0;

    unique case (word_mode)
      MODE_64: begin
        unique case (data_type_64_shift)
          2'd0: result[  0 +: 128] = p64;
          2'd1: result[ 64 +: 128] = p64;
          2'd2: result[128 +: 128] = p64;
          `ifdef BNMULV_ACCH
          2'd3: result[192 +: 128] = p64;
          `else
          2'd3: result[192 +:  64] = p64[63:0];
          `endif
        endcase
      end
      MODE_32: begin
        `ifdef BNMULV_ACCH
        if (half_sel == 1'b0) begin
          for (int i = 0; i < NDOUB; i++) begin
            result[(128*i) +  0 +: 64] = p32[i];
          end
        end else begin
          for (int i = 0; i < NDOUB; i++) begin
            result[(128*i) + 64 +: 64] = p32[i];
          end
        end
        `else
        result = p32;
        `endif
      end
      MODE_16: begin
        result = result_16;
      end
      default: begin
        result = '0;
      end
    endcase
  end


endmodule

