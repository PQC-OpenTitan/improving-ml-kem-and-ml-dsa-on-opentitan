module unified_mul #(
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
`ifdef BNMULV_COND_SUB
  output logic [31:0]                  scalar32,
  output logic [15:0]                  scalar16,
`endif
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

  // -------------------------------------------------------------------
  // Input and intermediate arrays
  // -------------------------------------------------------------------
  logic [HLEN-1:0] A16 [0:NHALF-1];
  logic [HLEN-1:0] B16 [0:NHALF-1];

  logic [WLEN-1:0] A_composed;
  logic [WLEN-1:0] B_composed;

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

`ifndef BNMULV_COND_SUB
  logic [31:0] scalar32;
  logic [15:0] scalar16;
`endif

  assign scalar32 = scalar64_B[SLEN*lane_word_32 +: SLEN];
  assign scalar16 = scalar32[HLEN*lane_word_16 +: HLEN];

  // -------------------------------------------------------------------
  // Input Decomposition
  // -------------------------------------------------------------------
  always_comb begin
    A_composed = 256'b0;
    B_composed = 256'b0;

    unique case (word_mode)
      MODE_16: begin
        `ifdef BNMULV_ACCH
        if (exec_mode == 2'b00) begin
          for (int i = 0; i < NHALF; i+=2) begin
            if (half_sel == 1'b0) begin
              A_composed[i*HLEN +: HLEN] = A[HLEN*i +: HLEN];
              B_composed[i*HLEN +: HLEN] = (lane_mode == 1'b0) ? B[HLEN*i +: HLEN] : scalar16;
            end else begin
              A_composed[(i+1)*HLEN +: HLEN] = A[(i+1)*HLEN +: HLEN];
              B_composed[(i+1)*HLEN +: HLEN] = (lane_mode == 1'b0) ? B[(i+1)*HLEN +: HLEN] : scalar16;
            end
          end
        end else begin
          for (int i = 0; i < NHALF; i++) begin
            A_composed[i*HLEN +: HLEN] = A[HLEN*i +: HLEN];
            B_composed[i*HLEN +: HLEN] = (lane_mode == 1'b0) ? B[HLEN*i +: HLEN] : scalar16;
          end
        end
        `else
        for (int i = 0; i < NSING; i++) begin
          if (half_sel == 1'b0) begin
            A_composed[i*HLEN +: HLEN] = A[HLEN*(2*i + 0) +: HLEN];
            B_composed[i*HLEN +: HLEN] = (lane_mode == 1'b0) ? B[HLEN*(2*i + 0) +: HLEN] : scalar16;
          end else begin
            A_composed[i*HLEN +: HLEN] = A[HLEN*(2*i + 1) +: HLEN];
            B_composed[i*HLEN +: HLEN] = (lane_mode == 1'b0) ? B[HLEN*(2*i + 1) +: HLEN] : scalar16;
          end
        end
        `endif
      end

      MODE_32: begin
        for (int i = 0; i < NDOUB; i++) begin
          if (half_sel == 1'b0) begin
            A_composed[i*32 +: 32] = A[SLEN*(2*i + 0) +: SLEN];
            B_composed[i*32 +: 32] = (lane_mode == 1'b0) ? B[SLEN*(2*i + 0) +: SLEN] : scalar32;
          end
          else begin
            A_composed[i*32 +: 32] = A[SLEN*(2*i + 1) +: SLEN];
            B_composed[i*32 +: 32] = (lane_mode == 1'b0) ? B[SLEN*(2*i + 1) +: SLEN] : scalar32;
          end
        end
      end

      MODE_64: begin
        A_composed[DLEN-1:0] = scalar64_A;
        B_composed[DLEN-1:0] = scalar64_B;
      end

      default: begin
        A_composed = 256'b0;
        B_composed = 256'b0;
      end
    endcase
  end

  always_comb begin
    unique case (word_mode)
      MODE_16: begin
        for (int i = 0; i < NHALF; i++) begin
          A16[i] = A_composed[HLEN*i +: HLEN];
          B16[i] = B_composed[HLEN*i +: HLEN];
        end
      end

      MODE_32: begin
        for (int i = 0; i < NDOUB; i++) begin
          A16[4*i + 0] = A_composed[i*32 + 0    +: HLEN];
          A16[4*i + 1] = A_composed[i*32 + 0    +: HLEN];
          A16[4*i + 2] = A_composed[i*32 + HLEN +: HLEN];
          A16[4*i + 3] = A_composed[i*32 + HLEN +: HLEN];

          B16[4*i + 0] = B_composed[i*32 + 0    +: HLEN];
          B16[4*i + 1] = B_composed[i*32 + HLEN +: HLEN];
          B16[4*i + 2] = B_composed[i*32 + 0    +: HLEN];
          B16[4*i + 3] = B_composed[i*32 + HLEN +: HLEN];
        end
      end

      MODE_64: begin
        logic [4*SLEN-1:0] A32 = {A_composed[SLEN +: SLEN],
                                  A_composed[SLEN +: SLEN],
                                  A_composed[0    +: SLEN],
                                  A_composed[0    +: SLEN]};
        logic [4*SLEN-1:0] B32 = {B_composed[SLEN +: SLEN],
                                  B_composed[0    +: SLEN],
                                  B_composed[SLEN +: SLEN],
                                  B_composed[0    +: SLEN]};
  
        for (int i = 0; i < NDOUB; i++) begin
          A16[4*i + 0] = A32[i*32 + 0    +: HLEN];
          A16[4*i + 1] = A32[i*32 + 0    +: HLEN];
          A16[4*i + 2] = A32[i*32 + HLEN +: HLEN];
          A16[4*i + 3] = A32[i*32 + HLEN +: HLEN];

          B16[4*i + 0] = B32[i*32 + 0    +: HLEN];
          B16[4*i + 1] = B32[i*32 + HLEN +: HLEN];
          B16[4*i + 2] = B32[i*32 + 0    +: HLEN];
          B16[4*i + 3] = B32[i*32 + HLEN +: HLEN];
        end
      end

      default: begin
        for (int i = 0; i < NHALF; i++) begin
          A16[i] = '0;
          B16[i] = '0;
        end
      end
    endcase
  end


  // -------------------------------------------------------------------
  // Shared 16x16 Multipliers
  // -------------------------------------------------------------------
  generate
    for (genvar i = 0; i < NHALF; i++) begin : gen_mults
      /* verilator lint_off UNUSED */
      logic [2*HLEN:0] product_full;  // "2*HLEN:0" to circumvent Verilator bug
      /* verilator lint_on UNUSED */
      assign product_full = A16[i] * B16[i];
      assign products[i] = product_full[2*HLEN-1:0];
    end
  endgenerate

  // -------------------------------------------------------------------
  // Output Reconstruction
  // -------------------------------------------------------------------
`ifdef BNMULV_ACCH
  logic [2*HLEN*NHALF-1:0] result_16;
  logic [2*SLEN*NDOUB-1:0] result_32;
  logic [2*DLEN-1:0]       result_64;
`else
  logic [255:0] result_16;
  logic [255:0] result_32;
  logic [127:0] result_64;
`endif

  // -- 16x16 results --
  always_comb begin
    result_16 = '0;
    `ifdef BNMULV_ACCH
    for (int i = 0; i < NHALF; i++) begin : gen_output_16
      if (word_mode == MODE_16)
        result_16[2*HLEN*i +: 2*HLEN] = products[i];
    end
    `else
    for (int i = 0; i < NSING; i++) begin : gen_output_16
      if (word_mode == MODE_16)
        result_16[2*HLEN*i +: 2*HLEN] = products[i];
    end
    `endif
  end

  // -- 32x32 grouped reconstruction --
  always_comb begin
    result_32 = '0;
    for (int i = 0; i < NDOUB; i++) begin
      logic [2*HLEN-1:0] p0 = products[4*i + 0];
      logic [2*HLEN-1:0] p1 = products[4*i + 1];
      logic [2*HLEN-1:0] p2 = products[4*i + 2];
      logic [2*HLEN-1:0] p3 = products[4*i + 3];


      partial32[i] = {{(SLEN){1'b0}}, p0} +
                      {{(HLEN){1'd0}}, p1, {(HLEN){1'd0}}} + 
                      {{(HLEN){1'd0}}, p2, {(HLEN){1'd0}}} +
                      {p3, {(SLEN){1'd0}}};

      if (word_mode == MODE_32)
        result_32[2*SLEN*i +: 2*SLEN] = partial32[i];
    end
  end

  // -- 64x64 reconstruction using the 32x32 results --
  always_comb begin
    result_64 = '0;
    if (word_mode == MODE_64) begin
      result_64 = {{DLEN{1'b0}}, partial32[0]} +
                  {{SLEN{1'b0}}, partial32[1], {SLEN{1'b0}}} +
                  {{SLEN{1'b0}}, partial32[2], {SLEN{1'b0}}} +
                  {partial32[3], {DLEN{1'b0}}};
    end
  end

  // -------------------------------------------------------------------
  // Unified Output Selection
  // -------------------------------------------------------------------
  always_comb begin
    result = '0;

    unique case (word_mode)
      MODE_64: begin
        unique case (data_type_64_shift)
          2'd0: result[  0 +: 128] = result_64;
          2'd1: result[ 64 +: 128] = result_64;
          2'd2: result[128 +: 128] = result_64;
          `ifdef BNMULV_ACCH
          2'd3: result[192 +: 128] = result_64;
          `else
          2'd3: result[192 +:  64] = result_64[63:0];
          `endif
        endcase
      end
      MODE_32: begin
        `ifdef BNMULV_ACCH
        if (half_sel == 1'b0) begin
          for (int i = 0; i < NDOUB; i++) begin
            result[(128*i) +  0 +: 64] = result_32[64*i +: 64];
          end
        end else begin
          for (int i = 0; i < NDOUB; i++) begin
            result[(128*i) + 64 +: 64] = result_32[64*i +: 64];
          end
        end
        `else
        result = result_32;
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
