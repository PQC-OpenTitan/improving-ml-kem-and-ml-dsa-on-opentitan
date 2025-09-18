module csa_carry4
	import otbn_pkg::*;
(
	input logic [WLEN-1:0]  A,
	input logic [WLEN-1:0]  B,
	input vec_type_e        word_mode,
	input logic             cin,
	output logic [WLEN-1:0] res,
	output logic [15:0]     cout
);
	localparam QLEN = 128;
	// For bottom 128 bits
	logic [QLEN-1:0] S;
	logic [QLEN-1:0] DI;
	logic [7:0]      O;
	logic [3:0]      CO [0:31];
	// For top 128 bits when carry in = 0
	logic [QLEN-1:0] S0;
	logic [QLEN-1:0] DI0;
	logic [3:0]      O_HI0  [0:31];
	logic [3:0]      CO_HI0 [0:31];
	// For top 128 bits when carry in = 1
	logic [QLEN-1:0] S1;
	logic [QLEN-1:0] DI1;
	logic [3:0]      O_HI1  [0:31];
	logic [3:0]      CO_HI1 [0:31];
	// Temporary logics for res
	logic [7:0] res_tmp;

	// COMPUTE S, DI --> CARRY4 FOR BOTTOM 128 BITS
	// 0..3
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y0", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_0  (.I0(A[0]), .I1(B[0]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[0]), .O6(S[0]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y0", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_1  (.I0(A[1]), .I1(B[1]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[1]), .O6(S[1]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y0", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_2  (.I0(A[2]), .I1(B[2]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[2]), .O6(S[2]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y0", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_3  (.I0(A[3]), .I1(B[3]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[3]), .O6(S[3]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y0", HU_SET = "BOTTOM" *)CARRY4 c_lo_0 (.CI(1'b0), .CYINIT(cin), .DI(DI[3:0]), .S(S[3:0]), .O(res[3:0]), .CO(CO[0]));
	// 4..7
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y1", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_4  (.I0(A[4]), .I1(B[4]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[4]), .O6(S[4]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y1", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_5  (.I0(A[5]), .I1(B[5]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[5]), .O6(S[5]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y1", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_6  (.I0(A[6]), .I1(B[6]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[6]), .O6(S[6]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y1", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_7  (.I0(A[7]), .I1(B[7]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[7]), .O6(S[7]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y1", HU_SET = "BOTTOM" *)CARRY4 c_lo_1 (.CI(CO[0][3]), .CYINIT(1'b0), .DI(DI[7:4]), .S(S[7:4]), .O(res[7:4]), .CO(CO[1]));
	// 8..11
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y2", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_8  (.I0(A[8]), .I1(B[8]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[8]), .O6(S[8]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y2", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_9  (.I0(A[9]), .I1(B[9]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[9]), .O6(S[9]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y2", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_10  (.I0(A[10]), .I1(B[10]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[10]), .O6(S[10]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y2", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_11  (.I0(A[11]), .I1(B[11]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[11]), .O6(S[11]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y2", HU_SET = "BOTTOM" *)CARRY4 c_lo_2 (.CI(CO[1][3]), .CYINIT(1'b0), .DI(DI[11:8]), .S(S[11:8]), .O(res[11:8]), .CO(CO[2]));
	// 12..15
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y3", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_12  (.I0(A[12]), .I1(B[12]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[12]), .O6(S[12]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y3", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_13  (.I0(A[13]), .I1(B[13]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[13]), .O6(S[13]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y3", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_14  (.I0(A[14]), .I1(B[14]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[14]), .O6(S[14]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y3", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h66606660888F8880)) gen_SDI_15  (.I0(A[15]), .I1(B[15]), .I2(word_mode[0]), .I3(word_mode[1]), .I4(cin), .I5(1), .O5(DI[15]), .O6(S[15]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y3", HU_SET = "BOTTOM" *)CARRY4 c_lo_3 (.CI(CO[2][3]), .CYINIT(1'b0), .DI(DI[15:12]), .S(S[15:12]), .O({O[0], res[14:12]}), .CO(CO[3]));
	// 16..19
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y4", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_16  (.I0(A[16]), .I1(B[16]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[16]), .O6(S[16]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y4", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_17  (.I0(A[17]), .I1(B[17]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[17]), .O6(S[17]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y4", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_18  (.I0(A[18]), .I1(B[18]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[18]), .O6(S[18]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y4", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_19  (.I0(A[19]), .I1(B[19]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[19]), .O6(S[19]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y4", HU_SET = "BOTTOM" *)CARRY4 c_lo_4 (.CI(CO[3][3]), .CYINIT(1'b0), .DI(DI[19:16]), .S(S[19:16]), .O(res[19:16]), .CO(CO[4]));
	// 20..23
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y5", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_20  (.I0(A[20]), .I1(B[20]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[20]), .O6(S[20]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y5", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_21  (.I0(A[21]), .I1(B[21]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[21]), .O6(S[21]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y5", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_22  (.I0(A[22]), .I1(B[22]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[22]), .O6(S[22]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y5", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_23  (.I0(A[23]), .I1(B[23]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[23]), .O6(S[23]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y5", HU_SET = "BOTTOM" *)CARRY4 c_lo_5 (.CI(CO[4][3]), .CYINIT(1'b0), .DI(DI[23:20]), .S(S[23:20]), .O(res[23:20]), .CO(CO[5]));
	// 24..27
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y6", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_24  (.I0(A[24]), .I1(B[24]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[24]), .O6(S[24]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y6", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_25  (.I0(A[25]), .I1(B[25]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[25]), .O6(S[25]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y6", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_26  (.I0(A[26]), .I1(B[26]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[26]), .O6(S[26]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y6", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_27  (.I0(A[27]), .I1(B[27]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[27]), .O6(S[27]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y6", HU_SET = "BOTTOM" *)CARRY4 c_lo_6 (.CI(CO[5][3]), .CYINIT(1'b0), .DI(DI[27:24]), .S(S[27:24]), .O(res[27:24]), .CO(CO[6]));
	// 28..31
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y7", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_28  (.I0(A[28]), .I1(B[28]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[28]), .O6(S[28]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y7", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_29  (.I0(A[29]), .I1(B[29]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[29]), .O6(S[29]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y7", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_30  (.I0(A[30]), .I1(B[30]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[30]), .O6(S[30]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y7", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h606060608F808F80)) gen_SDI_31  (.I0(A[31]), .I1(B[31]), .I2(word_mode[1]), .I3(cin), .I4(0), .I5(1), .O5(DI[31]), .O6(S[31]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y7", HU_SET = "BOTTOM" *)CARRY4 c_lo_7 (.CI(CO[6][3]), .CYINIT(1'b0), .DI(DI[31:28]), .S(S[31:28]), .O({O[1], res[30:28]}), .CO(CO[7]));
	// 32..35
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y8", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_32  (.I0(A[32]), .I1(B[32]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[32]), .O6(S[32]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y8", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_33  (.I0(A[33]), .I1(B[33]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[33]), .O6(S[33]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y8", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_34  (.I0(A[34]), .I1(B[34]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[34]), .O6(S[34]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y8", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_35  (.I0(A[35]), .I1(B[35]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[35]), .O6(S[35]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y8", HU_SET = "BOTTOM" *)CARRY4 c_lo_8 (.CI(CO[7][3]), .CYINIT(1'b0), .DI(DI[35:32]), .S(S[35:32]), .O(res[35:32]), .CO(CO[8]));
	// 36..39
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y9", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_36  (.I0(A[36]), .I1(B[36]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[36]), .O6(S[36]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y9", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_37  (.I0(A[37]), .I1(B[37]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[37]), .O6(S[37]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y9", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_38  (.I0(A[38]), .I1(B[38]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[38]), .O6(S[38]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y9", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_39  (.I0(A[39]), .I1(B[39]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[39]), .O6(S[39]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y9", HU_SET = "BOTTOM" *)CARRY4 c_lo_9 (.CI(CO[8][3]), .CYINIT(1'b0), .DI(DI[39:36]), .S(S[39:36]), .O(res[39:36]), .CO(CO[9]));
	// 40..43
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y10", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_40  (.I0(A[40]), .I1(B[40]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[40]), .O6(S[40]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y10", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_41  (.I0(A[41]), .I1(B[41]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[41]), .O6(S[41]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y10", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_42  (.I0(A[42]), .I1(B[42]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[42]), .O6(S[42]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y10", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_43  (.I0(A[43]), .I1(B[43]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[43]), .O6(S[43]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y10", HU_SET = "BOTTOM" *)CARRY4 c_lo_10 (.CI(CO[9][3]), .CYINIT(1'b0), .DI(DI[43:40]), .S(S[43:40]), .O(res[43:40]), .CO(CO[10]));
	// 44..47
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y11", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_44  (.I0(A[44]), .I1(B[44]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[44]), .O6(S[44]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y11", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_45  (.I0(A[45]), .I1(B[45]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[45]), .O6(S[45]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y11", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_46  (.I0(A[46]), .I1(B[46]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[46]), .O6(S[46]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y11", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h66606660888F8880)) gen_SDI_47  (.I0(A[47]), .I1(B[47]), .I2(word_mode[0]), .I3(word_mode[1]), .I4(cin), .I5(1), .O5(DI[47]), .O6(S[47]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y11", HU_SET = "BOTTOM" *)CARRY4 c_lo_11 (.CI(CO[10][3]), .CYINIT(1'b0), .DI(DI[47:44]), .S(S[47:44]), .O({O[2], res[46:44]}), .CO(CO[11]));
	// 48..51
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y12", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_48  (.I0(A[48]), .I1(B[48]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[48]), .O6(S[48]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y12", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_49  (.I0(A[49]), .I1(B[49]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[49]), .O6(S[49]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y12", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_50  (.I0(A[50]), .I1(B[50]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[50]), .O6(S[50]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y12", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_51  (.I0(A[51]), .I1(B[51]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[51]), .O6(S[51]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y12", HU_SET = "BOTTOM" *)CARRY4 c_lo_12 (.CI(CO[11][3]), .CYINIT(1'b0), .DI(DI[51:48]), .S(S[51:48]), .O(res[51:48]), .CO(CO[12]));
	// 52..55
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y13", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_52  (.I0(A[52]), .I1(B[52]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[52]), .O6(S[52]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y13", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_53  (.I0(A[53]), .I1(B[53]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[53]), .O6(S[53]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y13", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_54  (.I0(A[54]), .I1(B[54]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[54]), .O6(S[54]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y13", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_55  (.I0(A[55]), .I1(B[55]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[55]), .O6(S[55]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y13", HU_SET = "BOTTOM" *)CARRY4 c_lo_13 (.CI(CO[12][3]), .CYINIT(1'b0), .DI(DI[55:52]), .S(S[55:52]), .O(res[55:52]), .CO(CO[13]));
	// 56..59
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y14", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_56  (.I0(A[56]), .I1(B[56]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[56]), .O6(S[56]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y14", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_57  (.I0(A[57]), .I1(B[57]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[57]), .O6(S[57]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y14", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_58  (.I0(A[58]), .I1(B[58]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[58]), .O6(S[58]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y14", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_59  (.I0(A[59]), .I1(B[59]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[59]), .O6(S[59]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y14", HU_SET = "BOTTOM" *)CARRY4 c_lo_14 (.CI(CO[13][3]), .CYINIT(1'b0), .DI(DI[59:56]), .S(S[59:56]), .O(res[59:56]), .CO(CO[14]));
	// 60..63
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y15", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_60  (.I0(A[60]), .I1(B[60]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[60]), .O6(S[60]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y15", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_61  (.I0(A[61]), .I1(B[61]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[61]), .O6(S[61]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y15", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_62  (.I0(A[62]), .I1(B[62]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[62]), .O6(S[62]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y15", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h600060008FFF8000)) gen_SDI_63  (.I0(A[63]), .I1(B[63]), .I2(word_mode[0]), .I3(word_mode[1]), .I4(cin), .I5(1), .O5(DI[63]), .O6(S[63]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y15", HU_SET = "BOTTOM" *)CARRY4 c_lo_15 (.CI(CO[14][3]), .CYINIT(1'b0), .DI(DI[63:60]), .S(S[63:60]), .O({O[3], res[62:60]}), .CO(CO[15]));
	// 64..67
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y16", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_64  (.I0(A[64]), .I1(B[64]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[64]), .O6(S[64]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y16", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_65  (.I0(A[65]), .I1(B[65]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[65]), .O6(S[65]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y16", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_66  (.I0(A[66]), .I1(B[66]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[66]), .O6(S[66]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y16", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_67  (.I0(A[67]), .I1(B[67]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[67]), .O6(S[67]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y16", HU_SET = "BOTTOM" *)CARRY4 c_lo_16 (.CI(CO[15][3]), .CYINIT(1'b0), .DI(DI[67:64]), .S(S[67:64]), .O(res[67:64]), .CO(CO[16]));
	// 68..71
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y17", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_68  (.I0(A[68]), .I1(B[68]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[68]), .O6(S[68]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y17", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_69  (.I0(A[69]), .I1(B[69]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[69]), .O6(S[69]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y17", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_70  (.I0(A[70]), .I1(B[70]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[70]), .O6(S[70]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y17", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_71  (.I0(A[71]), .I1(B[71]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[71]), .O6(S[71]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y17", HU_SET = "BOTTOM" *)CARRY4 c_lo_17 (.CI(CO[16][3]), .CYINIT(1'b0), .DI(DI[71:68]), .S(S[71:68]), .O(res[71:68]), .CO(CO[17]));
	// 72..75
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y18", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_72  (.I0(A[72]), .I1(B[72]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[72]), .O6(S[72]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y18", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_73  (.I0(A[73]), .I1(B[73]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[73]), .O6(S[73]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y18", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_74  (.I0(A[74]), .I1(B[74]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[74]), .O6(S[74]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y18", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_75  (.I0(A[75]), .I1(B[75]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[75]), .O6(S[75]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y18", HU_SET = "BOTTOM" *)CARRY4 c_lo_18 (.CI(CO[17][3]), .CYINIT(1'b0), .DI(DI[75:72]), .S(S[75:72]), .O(res[75:72]), .CO(CO[18]));
	// 76..79
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y19", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_76  (.I0(A[76]), .I1(B[76]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[76]), .O6(S[76]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y19", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_77  (.I0(A[77]), .I1(B[77]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[77]), .O6(S[77]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y19", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_78  (.I0(A[78]), .I1(B[78]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[78]), .O6(S[78]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y19", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h66606660888F8880)) gen_SDI_79  (.I0(A[79]), .I1(B[79]), .I2(word_mode[0]), .I3(word_mode[1]), .I4(cin), .I5(1), .O5(DI[79]), .O6(S[79]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y19", HU_SET = "BOTTOM" *)CARRY4 c_lo_19 (.CI(CO[18][3]), .CYINIT(1'b0), .DI(DI[79:76]), .S(S[79:76]), .O({O[4], res[78:76]}), .CO(CO[19]));
	// 80..83
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y20", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_80  (.I0(A[80]), .I1(B[80]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[80]), .O6(S[80]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y20", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_81  (.I0(A[81]), .I1(B[81]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[81]), .O6(S[81]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y20", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_82  (.I0(A[82]), .I1(B[82]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[82]), .O6(S[82]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y20", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_83  (.I0(A[83]), .I1(B[83]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[83]), .O6(S[83]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y20", HU_SET = "BOTTOM" *)CARRY4 c_lo_20 (.CI(CO[19][3]), .CYINIT(1'b0), .DI(DI[83:80]), .S(S[83:80]), .O(res[83:80]), .CO(CO[20]));
	// 84..87
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y21", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_84  (.I0(A[84]), .I1(B[84]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[84]), .O6(S[84]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y21", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_85  (.I0(A[85]), .I1(B[85]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[85]), .O6(S[85]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y21", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_86  (.I0(A[86]), .I1(B[86]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[86]), .O6(S[86]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y21", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_87  (.I0(A[87]), .I1(B[87]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[87]), .O6(S[87]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y21", HU_SET = "BOTTOM" *)CARRY4 c_lo_21 (.CI(CO[20][3]), .CYINIT(1'b0), .DI(DI[87:84]), .S(S[87:84]), .O(res[87:84]), .CO(CO[21]));
	// 88..91
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y22", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_88  (.I0(A[88]), .I1(B[88]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[88]), .O6(S[88]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y22", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_89  (.I0(A[89]), .I1(B[89]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[89]), .O6(S[89]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y22", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_90  (.I0(A[90]), .I1(B[90]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[90]), .O6(S[90]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y22", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_91  (.I0(A[91]), .I1(B[91]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[91]), .O6(S[91]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y22", HU_SET = "BOTTOM" *)CARRY4 c_lo_22 (.CI(CO[21][3]), .CYINIT(1'b0), .DI(DI[91:88]), .S(S[91:88]), .O(res[91:88]), .CO(CO[22]));
	// 92..95
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y23", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_92  (.I0(A[92]), .I1(B[92]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[92]), .O6(S[92]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y23", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_93  (.I0(A[93]), .I1(B[93]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[93]), .O6(S[93]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y23", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_94  (.I0(A[94]), .I1(B[94]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[94]), .O6(S[94]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y23", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h606060608F808F80)) gen_SDI_95  (.I0(A[95]), .I1(B[95]), .I2(word_mode[1]), .I3(cin), .I4(0), .I5(1), .O5(DI[95]), .O6(S[95]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y23", HU_SET = "BOTTOM" *)CARRY4 c_lo_23 (.CI(CO[22][3]), .CYINIT(1'b0), .DI(DI[95:92]), .S(S[95:92]), .O({O[5], res[94:92]}), .CO(CO[23]));
	// 96..99
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y24", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_96  (.I0(A[96]), .I1(B[96]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[96]), .O6(S[96]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y24", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_97  (.I0(A[97]), .I1(B[97]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[97]), .O6(S[97]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y24", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_98  (.I0(A[98]), .I1(B[98]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[98]), .O6(S[98]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y24", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_99  (.I0(A[99]), .I1(B[99]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[99]), .O6(S[99]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y24", HU_SET = "BOTTOM" *)CARRY4 c_lo_24 (.CI(CO[23][3]), .CYINIT(1'b0), .DI(DI[99:96]), .S(S[99:96]), .O(res[99:96]), .CO(CO[24]));
	// 100..103
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y25", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_100  (.I0(A[100]), .I1(B[100]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[100]), .O6(S[100]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y25", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_101  (.I0(A[101]), .I1(B[101]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[101]), .O6(S[101]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y25", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_102  (.I0(A[102]), .I1(B[102]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[102]), .O6(S[102]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y25", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_103  (.I0(A[103]), .I1(B[103]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[103]), .O6(S[103]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y25", HU_SET = "BOTTOM" *)CARRY4 c_lo_25 (.CI(CO[24][3]), .CYINIT(1'b0), .DI(DI[103:100]), .S(S[103:100]), .O(res[103:100]), .CO(CO[25]));
	// 104..107
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y26", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_104  (.I0(A[104]), .I1(B[104]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[104]), .O6(S[104]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y26", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_105  (.I0(A[105]), .I1(B[105]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[105]), .O6(S[105]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y26", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_106  (.I0(A[106]), .I1(B[106]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[106]), .O6(S[106]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y26", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_107  (.I0(A[107]), .I1(B[107]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[107]), .O6(S[107]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y26", HU_SET = "BOTTOM" *)CARRY4 c_lo_26 (.CI(CO[25][3]), .CYINIT(1'b0), .DI(DI[107:104]), .S(S[107:104]), .O(res[107:104]), .CO(CO[26]));
	// 108..111
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y27", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_108  (.I0(A[108]), .I1(B[108]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[108]), .O6(S[108]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y27", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_109  (.I0(A[109]), .I1(B[109]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[109]), .O6(S[109]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y27", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_110  (.I0(A[110]), .I1(B[110]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[110]), .O6(S[110]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y27", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h66606660888F8880)) gen_SDI_111  (.I0(A[111]), .I1(B[111]), .I2(word_mode[0]), .I3(word_mode[1]), .I4(cin), .I5(1), .O5(DI[111]), .O6(S[111]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y27", HU_SET = "BOTTOM" *)CARRY4 c_lo_27 (.CI(CO[26][3]), .CYINIT(1'b0), .DI(DI[111:108]), .S(S[111:108]), .O({O[6], res[110:108]}), .CO(CO[27]));
	// 112..115
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y28", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_112  (.I0(A[112]), .I1(B[112]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[112]), .O6(S[112]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y28", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_113  (.I0(A[113]), .I1(B[113]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[113]), .O6(S[113]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y28", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_114  (.I0(A[114]), .I1(B[114]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[114]), .O6(S[114]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y28", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_115  (.I0(A[115]), .I1(B[115]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[115]), .O6(S[115]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y28", HU_SET = "BOTTOM" *)CARRY4 c_lo_28 (.CI(CO[27][3]), .CYINIT(1'b0), .DI(DI[115:112]), .S(S[115:112]), .O(res[115:112]), .CO(CO[28]));
	// 116..119
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y29", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_116  (.I0(A[116]), .I1(B[116]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[116]), .O6(S[116]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y29", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_117  (.I0(A[117]), .I1(B[117]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[117]), .O6(S[117]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y29", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_118  (.I0(A[118]), .I1(B[118]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[118]), .O6(S[118]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y29", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_119  (.I0(A[119]), .I1(B[119]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[119]), .O6(S[119]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y29", HU_SET = "BOTTOM" *)CARRY4 c_lo_29 (.CI(CO[28][3]), .CYINIT(1'b0), .DI(DI[119:116]), .S(S[119:116]), .O(res[119:116]), .CO(CO[29]));
	// 120..123
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y30", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_120  (.I0(A[120]), .I1(B[120]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[120]), .O6(S[120]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y30", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_121  (.I0(A[121]), .I1(B[121]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[121]), .O6(S[121]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y30", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_122  (.I0(A[122]), .I1(B[122]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[122]), .O6(S[122]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y30", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_123  (.I0(A[123]), .I1(B[123]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[123]), .O6(S[123]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y30", HU_SET = "BOTTOM" *)CARRY4 c_lo_30 (.CI(CO[29][3]), .CYINIT(1'b0), .DI(DI[123:120]), .S(S[123:120]), .O(res[123:120]), .CO(CO[30]));
	// 124..127
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y31", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_124  (.I0(A[124]), .I1(B[124]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[124]), .O6(S[124]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y31", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_125  (.I0(A[125]), .I1(B[125]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[125]), .O6(S[125]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y31", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI_126  (.I0(A[126]), .I1(B[126]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[126]), .O6(S[126]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y31", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64'h600060008FFF8000)) gen_SDI_127  (.I0(A[127]), .I1(B[127]), .I2(word_mode[0]), .I3(word_mode[1]), .I4(cin), .I5(1), .O5(DI[127]), .O6(S[127]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y31", HU_SET = "BOTTOM" *)CARRY4 c_lo_31 (.CI(CO[30][3]), .CYINIT(1'b0), .DI(DI[127:124]), .S(S[127:124]), .O({O[7], res[126:124]}), .CO(CO[31]));
	// COMPUTE S0, DI0 FOR TOP 128 BITS WHEN CARRY IN = 0
	// 128..131
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y0", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_0  (.I0(A[128]), .I1(B[128]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[0]), .O6(S0[0]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y0", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_1  (.I0(A[129]), .I1(B[129]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[1]), .O6(S0[1]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y0", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_2  (.I0(A[130]), .I1(B[130]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[2]), .O6(S0[2]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y0", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_3  (.I0(A[131]), .I1(B[131]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[3]), .O6(S0[3]));
	// 132..135
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y1", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_4  (.I0(A[132]), .I1(B[132]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[4]), .O6(S0[4]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y1", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_5  (.I0(A[133]), .I1(B[133]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[5]), .O6(S0[5]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y1", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_6  (.I0(A[134]), .I1(B[134]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[6]), .O6(S0[6]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y1", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_7  (.I0(A[135]), .I1(B[135]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[7]), .O6(S0[7]));
	// 136..139
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y2", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_8  (.I0(A[136]), .I1(B[136]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[8]), .O6(S0[8]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y2", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_9  (.I0(A[137]), .I1(B[137]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[9]), .O6(S0[9]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y2", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_10  (.I0(A[138]), .I1(B[138]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[10]), .O6(S0[10]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y2", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_11  (.I0(A[139]), .I1(B[139]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[11]), .O6(S0[11]));
	// 140..143
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y3", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_12  (.I0(A[140]), .I1(B[140]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[12]), .O6(S0[12]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y3", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_13  (.I0(A[141]), .I1(B[141]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[13]), .O6(S0[13]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y3", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_14  (.I0(A[142]), .I1(B[142]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[14]), .O6(S0[14]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y3", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h66606660888F8880)) gen_SDI0_15  (.I0(A[143]), .I1(B[143]), .I2(word_mode[0]), .I3(word_mode[1]), .I4(cin), .I5(1), .O5(DI0[15]), .O6(S0[15]));
	// 144..147
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y4", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_16  (.I0(A[144]), .I1(B[144]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[16]), .O6(S0[16]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y4", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_17  (.I0(A[145]), .I1(B[145]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[17]), .O6(S0[17]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y4", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_18  (.I0(A[146]), .I1(B[146]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[18]), .O6(S0[18]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y4", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_19  (.I0(A[147]), .I1(B[147]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[19]), .O6(S0[19]));
	// 148..151
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y5", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_20  (.I0(A[148]), .I1(B[148]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[20]), .O6(S0[20]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y5", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_21  (.I0(A[149]), .I1(B[149]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[21]), .O6(S0[21]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y5", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_22  (.I0(A[150]), .I1(B[150]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[22]), .O6(S0[22]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y5", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_23  (.I0(A[151]), .I1(B[151]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[23]), .O6(S0[23]));
	// 152..155
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y6", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_24  (.I0(A[152]), .I1(B[152]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[24]), .O6(S0[24]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y6", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_25  (.I0(A[153]), .I1(B[153]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[25]), .O6(S0[25]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y6", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_26  (.I0(A[154]), .I1(B[154]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[26]), .O6(S0[26]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y6", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_27  (.I0(A[155]), .I1(B[155]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[27]), .O6(S0[27]));
	// 156..159
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y7", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_28  (.I0(A[156]), .I1(B[156]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[28]), .O6(S0[28]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y7", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_29  (.I0(A[157]), .I1(B[157]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[29]), .O6(S0[29]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y7", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_30  (.I0(A[158]), .I1(B[158]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[30]), .O6(S0[30]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y7", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h606060608F808F80)) gen_SDI0_31  (.I0(A[159]), .I1(B[159]), .I2(word_mode[1]), .I3(cin), .I4(0), .I5(1), .O5(DI0[31]), .O6(S0[31]));
	// 160..163
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y8", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_32  (.I0(A[160]), .I1(B[160]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[32]), .O6(S0[32]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y8", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_33  (.I0(A[161]), .I1(B[161]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[33]), .O6(S0[33]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y8", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_34  (.I0(A[162]), .I1(B[162]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[34]), .O6(S0[34]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y8", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_35  (.I0(A[163]), .I1(B[163]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[35]), .O6(S0[35]));
	// 164..167
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y9", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_36  (.I0(A[164]), .I1(B[164]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[36]), .O6(S0[36]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y9", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_37  (.I0(A[165]), .I1(B[165]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[37]), .O6(S0[37]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y9", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_38  (.I0(A[166]), .I1(B[166]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[38]), .O6(S0[38]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y9", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_39  (.I0(A[167]), .I1(B[167]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[39]), .O6(S0[39]));
	// 168..171
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y10", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_40  (.I0(A[168]), .I1(B[168]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[40]), .O6(S0[40]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y10", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_41  (.I0(A[169]), .I1(B[169]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[41]), .O6(S0[41]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y10", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_42  (.I0(A[170]), .I1(B[170]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[42]), .O6(S0[42]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y10", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_43  (.I0(A[171]), .I1(B[171]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[43]), .O6(S0[43]));
	// 172..175
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y11", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_44  (.I0(A[172]), .I1(B[172]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[44]), .O6(S0[44]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y11", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_45  (.I0(A[173]), .I1(B[173]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[45]), .O6(S0[45]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y11", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_46  (.I0(A[174]), .I1(B[174]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[46]), .O6(S0[46]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y11", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h66606660888F8880)) gen_SDI0_47  (.I0(A[175]), .I1(B[175]), .I2(word_mode[0]), .I3(word_mode[1]), .I4(cin), .I5(1), .O5(DI0[47]), .O6(S0[47]));
	// 176..179
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y12", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_48  (.I0(A[176]), .I1(B[176]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[48]), .O6(S0[48]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y12", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_49  (.I0(A[177]), .I1(B[177]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[49]), .O6(S0[49]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y12", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_50  (.I0(A[178]), .I1(B[178]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[50]), .O6(S0[50]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y12", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_51  (.I0(A[179]), .I1(B[179]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[51]), .O6(S0[51]));
	// 180..183
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y13", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_52  (.I0(A[180]), .I1(B[180]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[52]), .O6(S0[52]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y13", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_53  (.I0(A[181]), .I1(B[181]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[53]), .O6(S0[53]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y13", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_54  (.I0(A[182]), .I1(B[182]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[54]), .O6(S0[54]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y13", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_55  (.I0(A[183]), .I1(B[183]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[55]), .O6(S0[55]));
	// 184..187
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y14", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_56  (.I0(A[184]), .I1(B[184]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[56]), .O6(S0[56]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y14", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_57  (.I0(A[185]), .I1(B[185]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[57]), .O6(S0[57]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y14", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_58  (.I0(A[186]), .I1(B[186]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[58]), .O6(S0[58]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y14", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_59  (.I0(A[187]), .I1(B[187]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[59]), .O6(S0[59]));
	// 188..191
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y15", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_60  (.I0(A[188]), .I1(B[188]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[60]), .O6(S0[60]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y15", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_61  (.I0(A[189]), .I1(B[189]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[61]), .O6(S0[61]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y15", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_62  (.I0(A[190]), .I1(B[190]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[62]), .O6(S0[62]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y15", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h600060008FFF8000)) gen_SDI0_63  (.I0(A[191]), .I1(B[191]), .I2(word_mode[0]), .I3(word_mode[1]), .I4(cin), .I5(1), .O5(DI0[63]), .O6(S0[63]));
	// 192..195
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y16", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_64  (.I0(A[192]), .I1(B[192]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[64]), .O6(S0[64]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y16", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_65  (.I0(A[193]), .I1(B[193]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[65]), .O6(S0[65]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y16", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_66  (.I0(A[194]), .I1(B[194]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[66]), .O6(S0[66]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y16", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_67  (.I0(A[195]), .I1(B[195]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[67]), .O6(S0[67]));
	// 196..199
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y17", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_68  (.I0(A[196]), .I1(B[196]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[68]), .O6(S0[68]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y17", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_69  (.I0(A[197]), .I1(B[197]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[69]), .O6(S0[69]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y17", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_70  (.I0(A[198]), .I1(B[198]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[70]), .O6(S0[70]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y17", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_71  (.I0(A[199]), .I1(B[199]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[71]), .O6(S0[71]));
	// 200..203
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y18", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_72  (.I0(A[200]), .I1(B[200]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[72]), .O6(S0[72]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y18", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_73  (.I0(A[201]), .I1(B[201]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[73]), .O6(S0[73]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y18", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_74  (.I0(A[202]), .I1(B[202]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[74]), .O6(S0[74]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y18", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_75  (.I0(A[203]), .I1(B[203]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[75]), .O6(S0[75]));
	// 204..207
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y19", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_76  (.I0(A[204]), .I1(B[204]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[76]), .O6(S0[76]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y19", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_77  (.I0(A[205]), .I1(B[205]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[77]), .O6(S0[77]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y19", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_78  (.I0(A[206]), .I1(B[206]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[78]), .O6(S0[78]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y19", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h66606660888F8880)) gen_SDI0_79  (.I0(A[207]), .I1(B[207]), .I2(word_mode[0]), .I3(word_mode[1]), .I4(cin), .I5(1), .O5(DI0[79]), .O6(S0[79]));
	// 208..211
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y20", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_80  (.I0(A[208]), .I1(B[208]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[80]), .O6(S0[80]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y20", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_81  (.I0(A[209]), .I1(B[209]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[81]), .O6(S0[81]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y20", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_82  (.I0(A[210]), .I1(B[210]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[82]), .O6(S0[82]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y20", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_83  (.I0(A[211]), .I1(B[211]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[83]), .O6(S0[83]));
	// 212..215
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y21", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_84  (.I0(A[212]), .I1(B[212]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[84]), .O6(S0[84]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y21", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_85  (.I0(A[213]), .I1(B[213]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[85]), .O6(S0[85]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y21", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_86  (.I0(A[214]), .I1(B[214]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[86]), .O6(S0[86]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y21", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_87  (.I0(A[215]), .I1(B[215]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[87]), .O6(S0[87]));
	// 216..219
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y22", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_88  (.I0(A[216]), .I1(B[216]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[88]), .O6(S0[88]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y22", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_89  (.I0(A[217]), .I1(B[217]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[89]), .O6(S0[89]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y22", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_90  (.I0(A[218]), .I1(B[218]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[90]), .O6(S0[90]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y22", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_91  (.I0(A[219]), .I1(B[219]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[91]), .O6(S0[91]));
	// 220..223
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y23", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_92  (.I0(A[220]), .I1(B[220]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[92]), .O6(S0[92]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y23", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_93  (.I0(A[221]), .I1(B[221]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[93]), .O6(S0[93]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y23", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_94  (.I0(A[222]), .I1(B[222]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[94]), .O6(S0[94]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y23", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h606060608F808F80)) gen_SDI0_95  (.I0(A[223]), .I1(B[223]), .I2(word_mode[1]), .I3(cin), .I4(0), .I5(1), .O5(DI0[95]), .O6(S0[95]));
	// 224..227
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y24", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_96  (.I0(A[224]), .I1(B[224]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[96]), .O6(S0[96]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y24", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_97  (.I0(A[225]), .I1(B[225]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[97]), .O6(S0[97]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y24", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_98  (.I0(A[226]), .I1(B[226]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[98]), .O6(S0[98]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y24", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_99  (.I0(A[227]), .I1(B[227]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[99]), .O6(S0[99]));
	// 228..231
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y25", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_100  (.I0(A[228]), .I1(B[228]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[100]), .O6(S0[100]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y25", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_101  (.I0(A[229]), .I1(B[229]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[101]), .O6(S0[101]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y25", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_102  (.I0(A[230]), .I1(B[230]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[102]), .O6(S0[102]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y25", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_103  (.I0(A[231]), .I1(B[231]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[103]), .O6(S0[103]));
	// 232..235
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y26", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_104  (.I0(A[232]), .I1(B[232]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[104]), .O6(S0[104]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y26", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_105  (.I0(A[233]), .I1(B[233]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[105]), .O6(S0[105]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y26", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_106  (.I0(A[234]), .I1(B[234]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[106]), .O6(S0[106]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y26", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_107  (.I0(A[235]), .I1(B[235]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[107]), .O6(S0[107]));
	// 236..239
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y27", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_108  (.I0(A[236]), .I1(B[236]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[108]), .O6(S0[108]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y27", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_109  (.I0(A[237]), .I1(B[237]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[109]), .O6(S0[109]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y27", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_110  (.I0(A[238]), .I1(B[238]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[110]), .O6(S0[110]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y27", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h66606660888F8880)) gen_SDI0_111  (.I0(A[239]), .I1(B[239]), .I2(word_mode[0]), .I3(word_mode[1]), .I4(cin), .I5(1), .O5(DI0[111]), .O6(S0[111]));
	// 240..243
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y28", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_112  (.I0(A[240]), .I1(B[240]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[112]), .O6(S0[112]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y28", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_113  (.I0(A[241]), .I1(B[241]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[113]), .O6(S0[113]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y28", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_114  (.I0(A[242]), .I1(B[242]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[114]), .O6(S0[114]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y28", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_115  (.I0(A[243]), .I1(B[243]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[115]), .O6(S0[115]));
	// 244..247
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y29", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_116  (.I0(A[244]), .I1(B[244]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[116]), .O6(S0[116]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y29", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_117  (.I0(A[245]), .I1(B[245]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[117]), .O6(S0[117]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y29", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_118  (.I0(A[246]), .I1(B[246]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[118]), .O6(S0[118]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y29", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_119  (.I0(A[247]), .I1(B[247]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[119]), .O6(S0[119]));
	// 248..251
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y30", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_120  (.I0(A[248]), .I1(B[248]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[120]), .O6(S0[120]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y30", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_121  (.I0(A[249]), .I1(B[249]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[121]), .O6(S0[121]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y30", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_122  (.I0(A[250]), .I1(B[250]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[122]), .O6(S0[122]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y30", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_123  (.I0(A[251]), .I1(B[251]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[123]), .O6(S0[123]));
	// 252..255
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y31", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_124  (.I0(A[252]), .I1(B[252]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[124]), .O6(S0[124]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y31", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_125  (.I0(A[253]), .I1(B[253]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[125]), .O6(S0[125]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y31", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI0_126  (.I0(A[254]), .I1(B[254]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI0[126]), .O6(S0[126]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y31", HU_SET = "TOPC0" *)LUT6_2 #(.INIT(64'h600060008FFF8000)) gen_SDI0_127  (.I0(A[255]), .I1(B[255]), .I2(word_mode[0]), .I3(word_mode[1]), .I4(cin), .I5(1), .O5(DI0[127]), .O6(S0[127]));

	// COMPUTE CARRY4 CHAIN FOR TOP 128 BITS WHEN CARRY IN = 0
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y0", HU_SET = "TOPC0" *)CARRY4 c_hi0_0 (.CI(1'b0), .CYINIT(1'b0), .DI(DI0[3:0]), .S(S0[3:0]), .O(O_HI0[0]), .CO(CO_HI0[0]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y1", HU_SET = "TOPC0" *)CARRY4 c_hi0_1 (.CI(CO_HI0[0][3]), .CYINIT(1'b0), .DI(DI0[7:4]), .S(S0[7:4]), .O(O_HI0[1]), .CO(CO_HI0[1]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y2", HU_SET = "TOPC0" *)CARRY4 c_hi0_2 (.CI(CO_HI0[1][3]), .CYINIT(1'b0), .DI(DI0[11:8]), .S(S0[11:8]), .O(O_HI0[2]), .CO(CO_HI0[2]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y3", HU_SET = "TOPC0" *)CARRY4 c_hi0_3 (.CI(CO_HI0[2][3]), .CYINIT(1'b0), .DI(DI0[15:12]), .S(S0[15:12]), .O(O_HI0[3]), .CO(CO_HI0[3]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y4", HU_SET = "TOPC0" *)CARRY4 c_hi0_4 (.CI(CO_HI0[3][3]), .CYINIT(1'b0), .DI(DI0[19:16]), .S(S0[19:16]), .O(O_HI0[4]), .CO(CO_HI0[4]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y5", HU_SET = "TOPC0" *)CARRY4 c_hi0_5 (.CI(CO_HI0[4][3]), .CYINIT(1'b0), .DI(DI0[23:20]), .S(S0[23:20]), .O(O_HI0[5]), .CO(CO_HI0[5]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y6", HU_SET = "TOPC0" *)CARRY4 c_hi0_6 (.CI(CO_HI0[5][3]), .CYINIT(1'b0), .DI(DI0[27:24]), .S(S0[27:24]), .O(O_HI0[6]), .CO(CO_HI0[6]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y7", HU_SET = "TOPC0" *)CARRY4 c_hi0_7 (.CI(CO_HI0[6][3]), .CYINIT(1'b0), .DI(DI0[31:28]), .S(S0[31:28]), .O(O_HI0[7]), .CO(CO_HI0[7]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y8", HU_SET = "TOPC0" *)CARRY4 c_hi0_8 (.CI(CO_HI0[7][3]), .CYINIT(1'b0), .DI(DI0[35:32]), .S(S0[35:32]), .O(O_HI0[8]), .CO(CO_HI0[8]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y9", HU_SET = "TOPC0" *)CARRY4 c_hi0_9 (.CI(CO_HI0[8][3]), .CYINIT(1'b0), .DI(DI0[39:36]), .S(S0[39:36]), .O(O_HI0[9]), .CO(CO_HI0[9]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y10", HU_SET = "TOPC0" *)CARRY4 c_hi0_10 (.CI(CO_HI0[9][3]), .CYINIT(1'b0), .DI(DI0[43:40]), .S(S0[43:40]), .O(O_HI0[10]), .CO(CO_HI0[10]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y11", HU_SET = "TOPC0" *)CARRY4 c_hi0_11 (.CI(CO_HI0[10][3]), .CYINIT(1'b0), .DI(DI0[47:44]), .S(S0[47:44]), .O(O_HI0[11]), .CO(CO_HI0[11]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y12", HU_SET = "TOPC0" *)CARRY4 c_hi0_12 (.CI(CO_HI0[11][3]), .CYINIT(1'b0), .DI(DI0[51:48]), .S(S0[51:48]), .O(O_HI0[12]), .CO(CO_HI0[12]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y13", HU_SET = "TOPC0" *)CARRY4 c_hi0_13 (.CI(CO_HI0[12][3]), .CYINIT(1'b0), .DI(DI0[55:52]), .S(S0[55:52]), .O(O_HI0[13]), .CO(CO_HI0[13]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y14", HU_SET = "TOPC0" *)CARRY4 c_hi0_14 (.CI(CO_HI0[13][3]), .CYINIT(1'b0), .DI(DI0[59:56]), .S(S0[59:56]), .O(O_HI0[14]), .CO(CO_HI0[14]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y15", HU_SET = "TOPC0" *)CARRY4 c_hi0_15 (.CI(CO_HI0[14][3]), .CYINIT(1'b0), .DI(DI0[63:60]), .S(S0[63:60]), .O(O_HI0[15]), .CO(CO_HI0[15]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y16", HU_SET = "TOPC0" *)CARRY4 c_hi0_16 (.CI(CO_HI0[15][3]), .CYINIT(1'b0), .DI(DI0[67:64]), .S(S0[67:64]), .O(O_HI0[16]), .CO(CO_HI0[16]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y17", HU_SET = "TOPC0" *)CARRY4 c_hi0_17 (.CI(CO_HI0[16][3]), .CYINIT(1'b0), .DI(DI0[71:68]), .S(S0[71:68]), .O(O_HI0[17]), .CO(CO_HI0[17]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y18", HU_SET = "TOPC0" *)CARRY4 c_hi0_18 (.CI(CO_HI0[17][3]), .CYINIT(1'b0), .DI(DI0[75:72]), .S(S0[75:72]), .O(O_HI0[18]), .CO(CO_HI0[18]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y19", HU_SET = "TOPC0" *)CARRY4 c_hi0_19 (.CI(CO_HI0[18][3]), .CYINIT(1'b0), .DI(DI0[79:76]), .S(S0[79:76]), .O(O_HI0[19]), .CO(CO_HI0[19]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y20", HU_SET = "TOPC0" *)CARRY4 c_hi0_20 (.CI(CO_HI0[19][3]), .CYINIT(1'b0), .DI(DI0[83:80]), .S(S0[83:80]), .O(O_HI0[20]), .CO(CO_HI0[20]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y21", HU_SET = "TOPC0" *)CARRY4 c_hi0_21 (.CI(CO_HI0[20][3]), .CYINIT(1'b0), .DI(DI0[87:84]), .S(S0[87:84]), .O(O_HI0[21]), .CO(CO_HI0[21]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y22", HU_SET = "TOPC0" *)CARRY4 c_hi0_22 (.CI(CO_HI0[21][3]), .CYINIT(1'b0), .DI(DI0[91:88]), .S(S0[91:88]), .O(O_HI0[22]), .CO(CO_HI0[22]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y23", HU_SET = "TOPC0" *)CARRY4 c_hi0_23 (.CI(CO_HI0[22][3]), .CYINIT(1'b0), .DI(DI0[95:92]), .S(S0[95:92]), .O(O_HI0[23]), .CO(CO_HI0[23]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y24", HU_SET = "TOPC0" *)CARRY4 c_hi0_24 (.CI(CO_HI0[23][3]), .CYINIT(1'b0), .DI(DI0[99:96]), .S(S0[99:96]), .O(O_HI0[24]), .CO(CO_HI0[24]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y25", HU_SET = "TOPC0" *)CARRY4 c_hi0_25 (.CI(CO_HI0[24][3]), .CYINIT(1'b0), .DI(DI0[103:100]), .S(S0[103:100]), .O(O_HI0[25]), .CO(CO_HI0[25]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y26", HU_SET = "TOPC0" *)CARRY4 c_hi0_26 (.CI(CO_HI0[25][3]), .CYINIT(1'b0), .DI(DI0[107:104]), .S(S0[107:104]), .O(O_HI0[26]), .CO(CO_HI0[26]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y27", HU_SET = "TOPC0" *)CARRY4 c_hi0_27 (.CI(CO_HI0[26][3]), .CYINIT(1'b0), .DI(DI0[111:108]), .S(S0[111:108]), .O(O_HI0[27]), .CO(CO_HI0[27]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y28", HU_SET = "TOPC0" *)CARRY4 c_hi0_28 (.CI(CO_HI0[27][3]), .CYINIT(1'b0), .DI(DI0[115:112]), .S(S0[115:112]), .O(O_HI0[28]), .CO(CO_HI0[28]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y29", HU_SET = "TOPC0" *)CARRY4 c_hi0_29 (.CI(CO_HI0[28][3]), .CYINIT(1'b0), .DI(DI0[119:116]), .S(S0[119:116]), .O(O_HI0[29]), .CO(CO_HI0[29]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y30", HU_SET = "TOPC0" *)CARRY4 c_hi0_30 (.CI(CO_HI0[29][3]), .CYINIT(1'b0), .DI(DI0[123:120]), .S(S0[123:120]), .O(O_HI0[30]), .CO(CO_HI0[30]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y31", HU_SET = "TOPC0" *)CARRY4 c_hi0_31 (.CI(CO_HI0[30][3]), .CYINIT(1'b0), .DI(DI0[127:124]), .S(S0[127:124]), .O(O_HI0[31]), .CO(CO_HI0[31]));

	// COMPUTE S1, DI1 FOR TOP 128 BITS WHEN CARRY IN = 1
	// 128..131
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y0", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_0  (.I0(A[128]), .I1(B[128]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[0]), .O6(S1[0]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y0", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_1  (.I0(A[129]), .I1(B[129]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[1]), .O6(S1[1]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y0", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_2  (.I0(A[130]), .I1(B[130]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[2]), .O6(S1[2]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y0", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_3  (.I0(A[131]), .I1(B[131]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[3]), .O6(S1[3]));
	// 132..135
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y1", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_4  (.I0(A[132]), .I1(B[132]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[4]), .O6(S1[4]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y1", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_5  (.I0(A[133]), .I1(B[133]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[5]), .O6(S1[5]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y1", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_6  (.I0(A[134]), .I1(B[134]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[6]), .O6(S1[6]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y1", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_7  (.I0(A[135]), .I1(B[135]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[7]), .O6(S1[7]));
	// 136..139
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y2", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_8  (.I0(A[136]), .I1(B[136]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[8]), .O6(S1[8]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y2", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_9  (.I0(A[137]), .I1(B[137]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[9]), .O6(S1[9]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y2", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_10  (.I0(A[138]), .I1(B[138]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[10]), .O6(S1[10]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y2", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_11  (.I0(A[139]), .I1(B[139]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[11]), .O6(S1[11]));
	// 140..143
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y3", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_12  (.I0(A[140]), .I1(B[140]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[12]), .O6(S1[12]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y3", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_13  (.I0(A[141]), .I1(B[141]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[13]), .O6(S1[13]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y3", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_14  (.I0(A[142]), .I1(B[142]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[14]), .O6(S1[14]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y3", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h66606660888F8880)) gen_SDI1_15  (.I0(A[143]), .I1(B[143]), .I2(word_mode[0]), .I3(word_mode[1]), .I4(cin), .I5(1), .O5(DI1[15]), .O6(S1[15]));
	// 144..147
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y4", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_16  (.I0(A[144]), .I1(B[144]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[16]), .O6(S1[16]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y4", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_17  (.I0(A[145]), .I1(B[145]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[17]), .O6(S1[17]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y4", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_18  (.I0(A[146]), .I1(B[146]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[18]), .O6(S1[18]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y4", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_19  (.I0(A[147]), .I1(B[147]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[19]), .O6(S1[19]));
	// 148..151
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y5", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_20  (.I0(A[148]), .I1(B[148]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[20]), .O6(S1[20]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y5", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_21  (.I0(A[149]), .I1(B[149]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[21]), .O6(S1[21]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y5", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_22  (.I0(A[150]), .I1(B[150]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[22]), .O6(S1[22]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y5", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_23  (.I0(A[151]), .I1(B[151]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[23]), .O6(S1[23]));
	// 152..155
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y6", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_24  (.I0(A[152]), .I1(B[152]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[24]), .O6(S1[24]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y6", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_25  (.I0(A[153]), .I1(B[153]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[25]), .O6(S1[25]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y6", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_26  (.I0(A[154]), .I1(B[154]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[26]), .O6(S1[26]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y6", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_27  (.I0(A[155]), .I1(B[155]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[27]), .O6(S1[27]));
	// 156..159
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y7", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_28  (.I0(A[156]), .I1(B[156]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[28]), .O6(S1[28]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y7", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_29  (.I0(A[157]), .I1(B[157]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[29]), .O6(S1[29]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y7", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_30  (.I0(A[158]), .I1(B[158]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[30]), .O6(S1[30]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y7", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h606060608F808F80)) gen_SDI1_31  (.I0(A[159]), .I1(B[159]), .I2(word_mode[1]), .I3(cin), .I4(0), .I5(1), .O5(DI1[31]), .O6(S1[31]));
	// 160..163
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y8", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_32  (.I0(A[160]), .I1(B[160]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[32]), .O6(S1[32]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y8", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_33  (.I0(A[161]), .I1(B[161]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[33]), .O6(S1[33]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y8", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_34  (.I0(A[162]), .I1(B[162]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[34]), .O6(S1[34]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y8", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_35  (.I0(A[163]), .I1(B[163]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[35]), .O6(S1[35]));
	// 164..167
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y9", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_36  (.I0(A[164]), .I1(B[164]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[36]), .O6(S1[36]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y9", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_37  (.I0(A[165]), .I1(B[165]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[37]), .O6(S1[37]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y9", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_38  (.I0(A[166]), .I1(B[166]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[38]), .O6(S1[38]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y9", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_39  (.I0(A[167]), .I1(B[167]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[39]), .O6(S1[39]));
	// 168..171
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y10", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_40  (.I0(A[168]), .I1(B[168]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[40]), .O6(S1[40]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y10", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_41  (.I0(A[169]), .I1(B[169]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[41]), .O6(S1[41]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y10", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_42  (.I0(A[170]), .I1(B[170]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[42]), .O6(S1[42]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y10", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_43  (.I0(A[171]), .I1(B[171]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[43]), .O6(S1[43]));
	// 172..175
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y11", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_44  (.I0(A[172]), .I1(B[172]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[44]), .O6(S1[44]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y11", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_45  (.I0(A[173]), .I1(B[173]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[45]), .O6(S1[45]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y11", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_46  (.I0(A[174]), .I1(B[174]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[46]), .O6(S1[46]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y11", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h66606660888F8880)) gen_SDI1_47  (.I0(A[175]), .I1(B[175]), .I2(word_mode[0]), .I3(word_mode[1]), .I4(cin), .I5(1), .O5(DI1[47]), .O6(S1[47]));
	// 176..179
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y12", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_48  (.I0(A[176]), .I1(B[176]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[48]), .O6(S1[48]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y12", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_49  (.I0(A[177]), .I1(B[177]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[49]), .O6(S1[49]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y12", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_50  (.I0(A[178]), .I1(B[178]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[50]), .O6(S1[50]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y12", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_51  (.I0(A[179]), .I1(B[179]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[51]), .O6(S1[51]));
	// 180..183
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y13", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_52  (.I0(A[180]), .I1(B[180]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[52]), .O6(S1[52]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y13", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_53  (.I0(A[181]), .I1(B[181]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[53]), .O6(S1[53]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y13", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_54  (.I0(A[182]), .I1(B[182]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[54]), .O6(S1[54]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y13", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_55  (.I0(A[183]), .I1(B[183]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[55]), .O6(S1[55]));
	// 184..187
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y14", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_56  (.I0(A[184]), .I1(B[184]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[56]), .O6(S1[56]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y14", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_57  (.I0(A[185]), .I1(B[185]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[57]), .O6(S1[57]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y14", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_58  (.I0(A[186]), .I1(B[186]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[58]), .O6(S1[58]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y14", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_59  (.I0(A[187]), .I1(B[187]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[59]), .O6(S1[59]));
	// 188..191
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y15", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_60  (.I0(A[188]), .I1(B[188]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[60]), .O6(S1[60]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y15", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_61  (.I0(A[189]), .I1(B[189]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[61]), .O6(S1[61]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y15", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_62  (.I0(A[190]), .I1(B[190]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[62]), .O6(S1[62]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y15", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h600060008FFF8000)) gen_SDI1_63  (.I0(A[191]), .I1(B[191]), .I2(word_mode[0]), .I3(word_mode[1]), .I4(cin), .I5(1), .O5(DI1[63]), .O6(S1[63]));
	// 192..195
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y16", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_64  (.I0(A[192]), .I1(B[192]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[64]), .O6(S1[64]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y16", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_65  (.I0(A[193]), .I1(B[193]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[65]), .O6(S1[65]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y16", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_66  (.I0(A[194]), .I1(B[194]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[66]), .O6(S1[66]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y16", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_67  (.I0(A[195]), .I1(B[195]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[67]), .O6(S1[67]));
	// 196..199
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y17", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_68  (.I0(A[196]), .I1(B[196]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[68]), .O6(S1[68]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y17", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_69  (.I0(A[197]), .I1(B[197]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[69]), .O6(S1[69]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y17", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_70  (.I0(A[198]), .I1(B[198]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[70]), .O6(S1[70]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y17", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_71  (.I0(A[199]), .I1(B[199]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[71]), .O6(S1[71]));
	// 200..203
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y18", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_72  (.I0(A[200]), .I1(B[200]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[72]), .O6(S1[72]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y18", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_73  (.I0(A[201]), .I1(B[201]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[73]), .O6(S1[73]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y18", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_74  (.I0(A[202]), .I1(B[202]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[74]), .O6(S1[74]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y18", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_75  (.I0(A[203]), .I1(B[203]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[75]), .O6(S1[75]));
	// 204..207
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y19", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_76  (.I0(A[204]), .I1(B[204]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[76]), .O6(S1[76]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y19", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_77  (.I0(A[205]), .I1(B[205]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[77]), .O6(S1[77]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y19", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_78  (.I0(A[206]), .I1(B[206]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[78]), .O6(S1[78]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y19", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h66606660888F8880)) gen_SDI1_79  (.I0(A[207]), .I1(B[207]), .I2(word_mode[0]), .I3(word_mode[1]), .I4(cin), .I5(1), .O5(DI1[79]), .O6(S1[79]));
	// 208..211
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y20", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_80  (.I0(A[208]), .I1(B[208]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[80]), .O6(S1[80]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y20", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_81  (.I0(A[209]), .I1(B[209]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[81]), .O6(S1[81]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y20", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_82  (.I0(A[210]), .I1(B[210]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[82]), .O6(S1[82]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y20", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_83  (.I0(A[211]), .I1(B[211]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[83]), .O6(S1[83]));
	// 212..215
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y21", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_84  (.I0(A[212]), .I1(B[212]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[84]), .O6(S1[84]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y21", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_85  (.I0(A[213]), .I1(B[213]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[85]), .O6(S1[85]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y21", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_86  (.I0(A[214]), .I1(B[214]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[86]), .O6(S1[86]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y21", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_87  (.I0(A[215]), .I1(B[215]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[87]), .O6(S1[87]));
	// 216..219
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y22", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_88  (.I0(A[216]), .I1(B[216]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[88]), .O6(S1[88]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y22", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_89  (.I0(A[217]), .I1(B[217]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[89]), .O6(S1[89]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y22", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_90  (.I0(A[218]), .I1(B[218]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[90]), .O6(S1[90]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y22", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_91  (.I0(A[219]), .I1(B[219]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[91]), .O6(S1[91]));
	// 220..223
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y23", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_92  (.I0(A[220]), .I1(B[220]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[92]), .O6(S1[92]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y23", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_93  (.I0(A[221]), .I1(B[221]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[93]), .O6(S1[93]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y23", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_94  (.I0(A[222]), .I1(B[222]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[94]), .O6(S1[94]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y23", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h606060608F808F80)) gen_SDI1_95  (.I0(A[223]), .I1(B[223]), .I2(word_mode[1]), .I3(cin), .I4(0), .I5(1), .O5(DI1[95]), .O6(S1[95]));
	// 224..227
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y24", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_96  (.I0(A[224]), .I1(B[224]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[96]), .O6(S1[96]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y24", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_97  (.I0(A[225]), .I1(B[225]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[97]), .O6(S1[97]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y24", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_98  (.I0(A[226]), .I1(B[226]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[98]), .O6(S1[98]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y24", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_99  (.I0(A[227]), .I1(B[227]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[99]), .O6(S1[99]));
	// 228..231
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y25", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_100  (.I0(A[228]), .I1(B[228]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[100]), .O6(S1[100]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y25", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_101  (.I0(A[229]), .I1(B[229]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[101]), .O6(S1[101]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y25", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_102  (.I0(A[230]), .I1(B[230]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[102]), .O6(S1[102]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y25", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_103  (.I0(A[231]), .I1(B[231]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[103]), .O6(S1[103]));
	// 232..235
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y26", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_104  (.I0(A[232]), .I1(B[232]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[104]), .O6(S1[104]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y26", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_105  (.I0(A[233]), .I1(B[233]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[105]), .O6(S1[105]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y26", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_106  (.I0(A[234]), .I1(B[234]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[106]), .O6(S1[106]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y26", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_107  (.I0(A[235]), .I1(B[235]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[107]), .O6(S1[107]));
	// 236..239
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y27", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_108  (.I0(A[236]), .I1(B[236]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[108]), .O6(S1[108]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y27", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_109  (.I0(A[237]), .I1(B[237]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[109]), .O6(S1[109]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y27", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_110  (.I0(A[238]), .I1(B[238]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[110]), .O6(S1[110]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y27", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h66606660888F8880)) gen_SDI1_111  (.I0(A[239]), .I1(B[239]), .I2(word_mode[0]), .I3(word_mode[1]), .I4(cin), .I5(1), .O5(DI1[111]), .O6(S1[111]));
	// 240..243
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y28", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_112  (.I0(A[240]), .I1(B[240]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[112]), .O6(S1[112]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y28", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_113  (.I0(A[241]), .I1(B[241]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[113]), .O6(S1[113]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y28", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_114  (.I0(A[242]), .I1(B[242]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[114]), .O6(S1[114]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y28", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_115  (.I0(A[243]), .I1(B[243]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[115]), .O6(S1[115]));
	// 244..247
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y29", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_116  (.I0(A[244]), .I1(B[244]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[116]), .O6(S1[116]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y29", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_117  (.I0(A[245]), .I1(B[245]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[117]), .O6(S1[117]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y29", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_118  (.I0(A[246]), .I1(B[246]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[118]), .O6(S1[118]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y29", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_119  (.I0(A[247]), .I1(B[247]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[119]), .O6(S1[119]));
	// 248..251
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y30", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_120  (.I0(A[248]), .I1(B[248]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[120]), .O6(S1[120]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y30", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_121  (.I0(A[249]), .I1(B[249]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[121]), .O6(S1[121]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y30", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_122  (.I0(A[250]), .I1(B[250]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[122]), .O6(S1[122]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y30", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_123  (.I0(A[251]), .I1(B[251]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[123]), .O6(S1[123]));
	// 252..255
	(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X0Y31", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_124  (.I0(A[252]), .I1(B[252]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[124]), .O6(S1[124]));
	(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X0Y31", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_125  (.I0(A[253]), .I1(B[253]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[125]), .O6(S1[125]));
	(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X0Y31", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h6666666688888888)) gen_SDI1_126  (.I0(A[254]), .I1(B[254]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI1[126]), .O6(S1[126]));
	(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X0Y31", HU_SET = "TOPC1" *)LUT6_2 #(.INIT(64'h600060008FFF8000)) gen_SDI1_127  (.I0(A[255]), .I1(B[255]), .I2(word_mode[0]), .I3(word_mode[1]), .I4(cin), .I5(1), .O5(DI1[127]), .O6(S1[127]));

	// COMPUTE CARRY4 CHAIN FOR TOP 128 BITS WHEN CARRY IN = 1
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y0", HU_SET = "TOPC1" *)CARRY4 c_hi1_0 (.CI(1'b1), .CYINIT(1'b0), .DI(DI1[3:0]), .S(S1[3:0]), .O(O_HI1[0]), .CO(CO_HI1[0]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y1", HU_SET = "TOPC1" *)CARRY4 c_hi1_1 (.CI(CO_HI1[0][3]), .CYINIT(1'b0), .DI(DI1[7:4]), .S(S1[7:4]), .O(O_HI1[1]), .CO(CO_HI1[1]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y2", HU_SET = "TOPC1" *)CARRY4 c_hi1_2 (.CI(CO_HI1[1][3]), .CYINIT(1'b0), .DI(DI1[11:8]), .S(S1[11:8]), .O(O_HI1[2]), .CO(CO_HI1[2]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y3", HU_SET = "TOPC1" *)CARRY4 c_hi1_3 (.CI(CO_HI1[2][3]), .CYINIT(1'b0), .DI(DI1[15:12]), .S(S1[15:12]), .O(O_HI1[3]), .CO(CO_HI1[3]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y4", HU_SET = "TOPC1" *)CARRY4 c_hi1_4 (.CI(CO_HI1[3][3]), .CYINIT(1'b0), .DI(DI1[19:16]), .S(S1[19:16]), .O(O_HI1[4]), .CO(CO_HI1[4]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y5", HU_SET = "TOPC1" *)CARRY4 c_hi1_5 (.CI(CO_HI1[4][3]), .CYINIT(1'b0), .DI(DI1[23:20]), .S(S1[23:20]), .O(O_HI1[5]), .CO(CO_HI1[5]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y6", HU_SET = "TOPC1" *)CARRY4 c_hi1_6 (.CI(CO_HI1[5][3]), .CYINIT(1'b0), .DI(DI1[27:24]), .S(S1[27:24]), .O(O_HI1[6]), .CO(CO_HI1[6]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y7", HU_SET = "TOPC1" *)CARRY4 c_hi1_7 (.CI(CO_HI1[6][3]), .CYINIT(1'b0), .DI(DI1[31:28]), .S(S1[31:28]), .O(O_HI1[7]), .CO(CO_HI1[7]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y8", HU_SET = "TOPC1" *)CARRY4 c_hi1_8 (.CI(CO_HI1[7][3]), .CYINIT(1'b0), .DI(DI1[35:32]), .S(S1[35:32]), .O(O_HI1[8]), .CO(CO_HI1[8]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y9", HU_SET = "TOPC1" *)CARRY4 c_hi1_9 (.CI(CO_HI1[8][3]), .CYINIT(1'b0), .DI(DI1[39:36]), .S(S1[39:36]), .O(O_HI1[9]), .CO(CO_HI1[9]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y10", HU_SET = "TOPC1" *)CARRY4 c_hi1_10 (.CI(CO_HI1[9][3]), .CYINIT(1'b0), .DI(DI1[43:40]), .S(S1[43:40]), .O(O_HI1[10]), .CO(CO_HI1[10]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y11", HU_SET = "TOPC1" *)CARRY4 c_hi1_11 (.CI(CO_HI1[10][3]), .CYINIT(1'b0), .DI(DI1[47:44]), .S(S1[47:44]), .O(O_HI1[11]), .CO(CO_HI1[11]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y12", HU_SET = "TOPC1" *)CARRY4 c_hi1_12 (.CI(CO_HI1[11][3]), .CYINIT(1'b0), .DI(DI1[51:48]), .S(S1[51:48]), .O(O_HI1[12]), .CO(CO_HI1[12]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y13", HU_SET = "TOPC1" *)CARRY4 c_hi1_13 (.CI(CO_HI1[12][3]), .CYINIT(1'b0), .DI(DI1[55:52]), .S(S1[55:52]), .O(O_HI1[13]), .CO(CO_HI1[13]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y14", HU_SET = "TOPC1" *)CARRY4 c_hi1_14 (.CI(CO_HI1[13][3]), .CYINIT(1'b0), .DI(DI1[59:56]), .S(S1[59:56]), .O(O_HI1[14]), .CO(CO_HI1[14]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y15", HU_SET = "TOPC1" *)CARRY4 c_hi1_15 (.CI(CO_HI1[14][3]), .CYINIT(1'b0), .DI(DI1[63:60]), .S(S1[63:60]), .O(O_HI1[15]), .CO(CO_HI1[15]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y16", HU_SET = "TOPC1" *)CARRY4 c_hi1_16 (.CI(CO_HI1[15][3]), .CYINIT(1'b0), .DI(DI1[67:64]), .S(S1[67:64]), .O(O_HI1[16]), .CO(CO_HI1[16]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y17", HU_SET = "TOPC1" *)CARRY4 c_hi1_17 (.CI(CO_HI1[16][3]), .CYINIT(1'b0), .DI(DI1[71:68]), .S(S1[71:68]), .O(O_HI1[17]), .CO(CO_HI1[17]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y18", HU_SET = "TOPC1" *)CARRY4 c_hi1_18 (.CI(CO_HI1[17][3]), .CYINIT(1'b0), .DI(DI1[75:72]), .S(S1[75:72]), .O(O_HI1[18]), .CO(CO_HI1[18]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y19", HU_SET = "TOPC1" *)CARRY4 c_hi1_19 (.CI(CO_HI1[18][3]), .CYINIT(1'b0), .DI(DI1[79:76]), .S(S1[79:76]), .O(O_HI1[19]), .CO(CO_HI1[19]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y20", HU_SET = "TOPC1" *)CARRY4 c_hi1_20 (.CI(CO_HI1[19][3]), .CYINIT(1'b0), .DI(DI1[83:80]), .S(S1[83:80]), .O(O_HI1[20]), .CO(CO_HI1[20]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y21", HU_SET = "TOPC1" *)CARRY4 c_hi1_21 (.CI(CO_HI1[20][3]), .CYINIT(1'b0), .DI(DI1[87:84]), .S(S1[87:84]), .O(O_HI1[21]), .CO(CO_HI1[21]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y22", HU_SET = "TOPC1" *)CARRY4 c_hi1_22 (.CI(CO_HI1[21][3]), .CYINIT(1'b0), .DI(DI1[91:88]), .S(S1[91:88]), .O(O_HI1[22]), .CO(CO_HI1[22]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y23", HU_SET = "TOPC1" *)CARRY4 c_hi1_23 (.CI(CO_HI1[22][3]), .CYINIT(1'b0), .DI(DI1[95:92]), .S(S1[95:92]), .O(O_HI1[23]), .CO(CO_HI1[23]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y24", HU_SET = "TOPC1" *)CARRY4 c_hi1_24 (.CI(CO_HI1[23][3]), .CYINIT(1'b0), .DI(DI1[99:96]), .S(S1[99:96]), .O(O_HI1[24]), .CO(CO_HI1[24]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y25", HU_SET = "TOPC1" *)CARRY4 c_hi1_25 (.CI(CO_HI1[24][3]), .CYINIT(1'b0), .DI(DI1[103:100]), .S(S1[103:100]), .O(O_HI1[25]), .CO(CO_HI1[25]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y26", HU_SET = "TOPC1" *)CARRY4 c_hi1_26 (.CI(CO_HI1[25][3]), .CYINIT(1'b0), .DI(DI1[107:104]), .S(S1[107:104]), .O(O_HI1[26]), .CO(CO_HI1[26]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y27", HU_SET = "TOPC1" *)CARRY4 c_hi1_27 (.CI(CO_HI1[26][3]), .CYINIT(1'b0), .DI(DI1[111:108]), .S(S1[111:108]), .O(O_HI1[27]), .CO(CO_HI1[27]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y28", HU_SET = "TOPC1" *)CARRY4 c_hi1_28 (.CI(CO_HI1[27][3]), .CYINIT(1'b0), .DI(DI1[115:112]), .S(S1[115:112]), .O(O_HI1[28]), .CO(CO_HI1[28]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y29", HU_SET = "TOPC1" *)CARRY4 c_hi1_29 (.CI(CO_HI1[28][3]), .CYINIT(1'b0), .DI(DI1[119:116]), .S(S1[119:116]), .O(O_HI1[29]), .CO(CO_HI1[29]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y30", HU_SET = "TOPC1" *)CARRY4 c_hi1_30 (.CI(CO_HI1[29][3]), .CYINIT(1'b0), .DI(DI1[123:120]), .S(S1[123:120]), .O(O_HI1[30]), .CO(CO_HI1[30]));
	(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X0Y31", HU_SET = "TOPC1" *)CARRY4 c_hi1_31 (.CI(CO_HI1[30][3]), .CYINIT(1'b0), .DI(DI1[127:124]), .S(S1[127:124]), .O(O_HI1[31]), .CO(CO_HI1[31]));

	// COMPUTE res FOR TOP 128 bits
	(* BEL = "A6LUT", RLOC = "X0Y0", HU_SET = "R0" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_128_129 (.I0(O_HI1[0][0]), .I1(CO[31][3]), .I2(O_HI0[0][0]), .I3(O_HI1[0][1]), .I4(O_HI0[0][1]), .I5(1), .O5(res[128]), .O6(res[129]));
	(* BEL = "B6LUT", RLOC = "X0Y0", HU_SET = "R0" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_130_131 (.I0(O_HI1[0][2]), .I1(CO[31][3]), .I2(O_HI0[0][2]), .I3(O_HI1[0][3]), .I4(O_HI0[0][3]), .I5(1), .O5(res[130]), .O6(res[131]));
	(* BEL = "A6LUT", RLOC = "X0Y0", HU_SET = "R1" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_132_133 (.I0(O_HI1[1][0]), .I1(CO[31][3]), .I2(O_HI0[1][0]), .I3(O_HI1[1][1]), .I4(O_HI0[1][1]), .I5(1), .O5(res[132]), .O6(res[133]));
	(* BEL = "B6LUT", RLOC = "X0Y0", HU_SET = "R1" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_134_135 (.I0(O_HI1[1][2]), .I1(CO[31][3]), .I2(O_HI0[1][2]), .I3(O_HI1[1][3]), .I4(O_HI0[1][3]), .I5(1), .O5(res[134]), .O6(res[135]));
	(* BEL = "A6LUT", RLOC = "X0Y0", HU_SET = "R2" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_136_137 (.I0(O_HI1[2][0]), .I1(CO[31][3]), .I2(O_HI0[2][0]), .I3(O_HI1[2][1]), .I4(O_HI0[2][1]), .I5(1), .O5(res[136]), .O6(res[137]));
	(* BEL = "B6LUT", RLOC = "X0Y0", HU_SET = "R2" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_138_139 (.I0(O_HI1[2][2]), .I1(CO[31][3]), .I2(O_HI0[2][2]), .I3(O_HI1[2][3]), .I4(O_HI0[2][3]), .I5(1), .O5(res[138]), .O6(res[139]));
	(* BEL = "A6LUT", RLOC = "X0Y0", HU_SET = "R3" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_140_141 (.I0(O_HI1[3][0]), .I1(CO[31][3]), .I2(O_HI0[3][0]), .I3(O_HI1[3][1]), .I4(O_HI0[3][1]), .I5(1), .O5(res[140]), .O6(res[141]));
	(* BEL = "D6LUT", RLOC = "X0Y0", HU_SET = "R3" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_142_144 (.I0(O_HI1[3][2]), .I1(CO[31][3]), .I2(O_HI0[3][2]), .I3(O_HI1[4][0]), .I4(O_HI0[4][0]), .I5(1), .O5(res[142]), .O6(res[144]));
	(* BEL = "B6LUT", RLOC = "X0Y0", HU_SET = "R3" *)LUT6_2 #(.INIT(64'hB84747B8FFB8B800)) gen_res_143_tmp (.I0(CO_HI1[3][2]), .I1(CO[31][3]), .I2(CO_HI0[3][2]), .I3(A[143]), .I4(B[143]), .I5(1), .O5(cout[8]), .O6(res_tmp[0]));

	(* BEL = "A6LUT", RLOC = "X0Y0", HU_SET = "R4" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_145_146 (.I0(O_HI1[4][1]), .I1(CO[31][3]), .I2(O_HI0[4][1]), .I3(O_HI1[4][2]), .I4(O_HI0[4][2]), .I5(1), .O5(res[145]), .O6(res[146]));
	(* BEL = "B6LUT", RLOC = "X0Y0", HU_SET = "R4" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_147_148 (.I0(O_HI1[4][3]), .I1(CO[31][3]), .I2(O_HI0[4][3]), .I3(O_HI1[5][0]), .I4(O_HI0[5][0]), .I5(1), .O5(res[147]), .O6(res[148]));
	(* BEL = "A6LUT", RLOC = "X0Y0", HU_SET = "R5" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_149_150 (.I0(O_HI1[5][1]), .I1(CO[31][3]), .I2(O_HI0[5][1]), .I3(O_HI1[5][2]), .I4(O_HI0[5][2]), .I5(1), .O5(res[149]), .O6(res[150]));
	(* BEL = "B6LUT", RLOC = "X0Y0", HU_SET = "R5" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_151_152 (.I0(O_HI1[5][3]), .I1(CO[31][3]), .I2(O_HI0[5][3]), .I3(O_HI1[6][0]), .I4(O_HI0[6][0]), .I5(1), .O5(res[151]), .O6(res[152]));
	(* BEL = "A6LUT", RLOC = "X0Y0", HU_SET = "R6" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_153_154 (.I0(O_HI1[6][1]), .I1(CO[31][3]), .I2(O_HI0[6][1]), .I3(O_HI1[6][2]), .I4(O_HI0[6][2]), .I5(1), .O5(res[153]), .O6(res[154]));
	(* BEL = "B6LUT", RLOC = "X0Y0", HU_SET = "R6" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_155_156 (.I0(O_HI1[6][3]), .I1(CO[31][3]), .I2(O_HI0[6][3]), .I3(O_HI1[7][0]), .I4(O_HI0[7][0]), .I5(1), .O5(res[155]), .O6(res[156]));
	(* BEL = "A6LUT", RLOC = "X0Y0", HU_SET = "R7" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_157_158 (.I0(O_HI1[7][1]), .I1(CO[31][3]), .I2(O_HI0[7][1]), .I3(O_HI1[7][2]), .I4(O_HI0[7][2]), .I5(1), .O5(res[157]), .O6(res[158]));
	(* BEL = "B6LUT", RLOC = "X0Y0", HU_SET = "R7" *)LUT6_2 #(.INIT(64'hB84747B8FFB8B800)) gen_res_159_tmp (.I0(CO_HI1[7][2]), .I1(CO[31][3]), .I2(CO_HI0[7][2]), .I3(A[159]), .I4(B[159]), .I5(1), .O5(cout[9]), .O6(res_tmp[1]));

	(* BEL = "A6LUT", RLOC = "X0Y0", HU_SET = "R8" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_160_161 (.I0(O_HI1[8][0]), .I1(CO[31][3]), .I2(O_HI0[8][0]), .I3(O_HI1[8][1]), .I4(O_HI0[8][1]), .I5(1), .O5(res[160]), .O6(res[161]));
	(* BEL = "B6LUT", RLOC = "X0Y0", HU_SET = "R8" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_162_163 (.I0(O_HI1[8][2]), .I1(CO[31][3]), .I2(O_HI0[8][2]), .I3(O_HI1[8][3]), .I4(O_HI0[8][3]), .I5(1), .O5(res[162]), .O6(res[163]));
	(* BEL = "A6LUT", RLOC = "X0Y0", HU_SET = "R9" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_164_165 (.I0(O_HI1[9][0]), .I1(CO[31][3]), .I2(O_HI0[9][0]), .I3(O_HI1[9][1]), .I4(O_HI0[9][1]), .I5(1), .O5(res[164]), .O6(res[165]));
	(* BEL = "B6LUT", RLOC = "X0Y0", HU_SET = "R9" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_166_167 (.I0(O_HI1[9][2]), .I1(CO[31][3]), .I2(O_HI0[9][2]), .I3(O_HI1[9][3]), .I4(O_HI0[9][3]), .I5(1), .O5(res[166]), .O6(res[167]));
	(* BEL = "A6LUT", RLOC = "X0Y0", HU_SET = "R10" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_168_169 (.I0(O_HI1[10][0]), .I1(CO[31][3]), .I2(O_HI0[10][0]), .I3(O_HI1[10][1]), .I4(O_HI0[10][1]), .I5(1), .O5(res[168]), .O6(res[169]));
	(* BEL = "B6LUT", RLOC = "X0Y0", HU_SET = "R10" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_170_171 (.I0(O_HI1[10][2]), .I1(CO[31][3]), .I2(O_HI0[10][2]), .I3(O_HI1[10][3]), .I4(O_HI0[10][3]), .I5(1), .O5(res[170]), .O6(res[171]));
	(* BEL = "A6LUT", RLOC = "X0Y0", HU_SET = "R11" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_172_173 (.I0(O_HI1[11][0]), .I1(CO[31][3]), .I2(O_HI0[11][0]), .I3(O_HI1[11][1]), .I4(O_HI0[11][1]), .I5(1), .O5(res[172]), .O6(res[173]));
	(* BEL = "D6LUT", RLOC = "X0Y0", HU_SET = "R11" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_174_176 (.I0(O_HI1[11][2]), .I1(CO[31][3]), .I2(O_HI0[11][2]), .I3(O_HI1[12][0]), .I4(O_HI0[12][0]), .I5(1), .O5(res[174]), .O6(res[176]));
	(* BEL = "B6LUT", RLOC = "X0Y0", HU_SET = "R11" *)LUT6_2 #(.INIT(64'hB84747B8FFB8B800)) gen_res_175_tmp (.I0(CO_HI1[11][2]), .I1(CO[31][3]), .I2(CO_HI0[11][2]), .I3(A[175]), .I4(B[175]), .I5(1), .O5(cout[10]), .O6(res_tmp[2]));

	(* BEL = "A6LUT", RLOC = "X0Y0", HU_SET = "R12" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_177_178 (.I0(O_HI1[12][1]), .I1(CO[31][3]), .I2(O_HI0[12][1]), .I3(O_HI1[12][2]), .I4(O_HI0[12][2]), .I5(1), .O5(res[177]), .O6(res[178]));
	(* BEL = "B6LUT", RLOC = "X0Y0", HU_SET = "R12" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_179_180 (.I0(O_HI1[12][3]), .I1(CO[31][3]), .I2(O_HI0[12][3]), .I3(O_HI1[13][0]), .I4(O_HI0[13][0]), .I5(1), .O5(res[179]), .O6(res[180]));
	(* BEL = "A6LUT", RLOC = "X0Y0", HU_SET = "R13" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_181_182 (.I0(O_HI1[13][1]), .I1(CO[31][3]), .I2(O_HI0[13][1]), .I3(O_HI1[13][2]), .I4(O_HI0[13][2]), .I5(1), .O5(res[181]), .O6(res[182]));
	(* BEL = "B6LUT", RLOC = "X0Y0", HU_SET = "R13" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_183_184 (.I0(O_HI1[13][3]), .I1(CO[31][3]), .I2(O_HI0[13][3]), .I3(O_HI1[14][0]), .I4(O_HI0[14][0]), .I5(1), .O5(res[183]), .O6(res[184]));
	(* BEL = "A6LUT", RLOC = "X0Y0", HU_SET = "R14" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_185_186 (.I0(O_HI1[14][1]), .I1(CO[31][3]), .I2(O_HI0[14][1]), .I3(O_HI1[14][2]), .I4(O_HI0[14][2]), .I5(1), .O5(res[185]), .O6(res[186]));
	(* BEL = "B6LUT", RLOC = "X0Y0", HU_SET = "R14" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_187_188 (.I0(O_HI1[14][3]), .I1(CO[31][3]), .I2(O_HI0[14][3]), .I3(O_HI1[15][0]), .I4(O_HI0[15][0]), .I5(1), .O5(res[187]), .O6(res[188]));
	(* BEL = "A6LUT", RLOC = "X0Y0", HU_SET = "R15" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_189_190 (.I0(O_HI1[15][1]), .I1(CO[31][3]), .I2(O_HI0[15][1]), .I3(O_HI1[15][2]), .I4(O_HI0[15][2]), .I5(1), .O5(res[189]), .O6(res[190]));
	(* BEL = "B6LUT", RLOC = "X0Y0", HU_SET = "R15" *)LUT6_2 #(.INIT(64'hB84747B8FFB8B800)) gen_res_191_tmp (.I0(CO_HI1[15][2]), .I1(CO[31][3]), .I2(CO_HI0[15][2]), .I3(A[191]), .I4(B[191]), .I5(1), .O5(cout[11]), .O6(res_tmp[3]));

	(* BEL = "A6LUT", RLOC = "X0Y0", HU_SET = "R16" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_192_193 (.I0(O_HI1[16][0]), .I1(CO[31][3]), .I2(O_HI0[16][0]), .I3(O_HI1[16][1]), .I4(O_HI0[16][1]), .I5(1), .O5(res[192]), .O6(res[193]));
	(* BEL = "B6LUT", RLOC = "X0Y0", HU_SET = "R16" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_194_195 (.I0(O_HI1[16][2]), .I1(CO[31][3]), .I2(O_HI0[16][2]), .I3(O_HI1[16][3]), .I4(O_HI0[16][3]), .I5(1), .O5(res[194]), .O6(res[195]));
	(* BEL = "A6LUT", RLOC = "X0Y0", HU_SET = "R17" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_196_197 (.I0(O_HI1[17][0]), .I1(CO[31][3]), .I2(O_HI0[17][0]), .I3(O_HI1[17][1]), .I4(O_HI0[17][1]), .I5(1), .O5(res[196]), .O6(res[197]));
	(* BEL = "B6LUT", RLOC = "X0Y0", HU_SET = "R17" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_198_199 (.I0(O_HI1[17][2]), .I1(CO[31][3]), .I2(O_HI0[17][2]), .I3(O_HI1[17][3]), .I4(O_HI0[17][3]), .I5(1), .O5(res[198]), .O6(res[199]));
	(* BEL = "A6LUT", RLOC = "X0Y0", HU_SET = "R18" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_200_201 (.I0(O_HI1[18][0]), .I1(CO[31][3]), .I2(O_HI0[18][0]), .I3(O_HI1[18][1]), .I4(O_HI0[18][1]), .I5(1), .O5(res[200]), .O6(res[201]));
	(* BEL = "B6LUT", RLOC = "X0Y0", HU_SET = "R18" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_202_203 (.I0(O_HI1[18][2]), .I1(CO[31][3]), .I2(O_HI0[18][2]), .I3(O_HI1[18][3]), .I4(O_HI0[18][3]), .I5(1), .O5(res[202]), .O6(res[203]));
	(* BEL = "A6LUT", RLOC = "X0Y0", HU_SET = "R19" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_204_205 (.I0(O_HI1[19][0]), .I1(CO[31][3]), .I2(O_HI0[19][0]), .I3(O_HI1[19][1]), .I4(O_HI0[19][1]), .I5(1), .O5(res[204]), .O6(res[205]));
	(* BEL = "D6LUT", RLOC = "X0Y0", HU_SET = "R19" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_206_208 (.I0(O_HI1[19][2]), .I1(CO[31][3]), .I2(O_HI0[19][2]), .I3(O_HI1[20][0]), .I4(O_HI0[20][0]), .I5(1), .O5(res[206]), .O6(res[208]));
	(* BEL = "B6LUT", RLOC = "X0Y0", HU_SET = "R19" *)LUT6_2 #(.INIT(64'hB84747B8FFB8B800)) gen_res_207_tmp (.I0(CO_HI1[19][2]), .I1(CO[31][3]), .I2(CO_HI0[19][2]), .I3(A[207]), .I4(B[207]), .I5(1), .O5(cout[12]), .O6(res_tmp[4]));

	(* BEL = "A6LUT", RLOC = "X0Y0", HU_SET = "R20" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_209_210 (.I0(O_HI1[20][1]), .I1(CO[31][3]), .I2(O_HI0[20][1]), .I3(O_HI1[20][2]), .I4(O_HI0[20][2]), .I5(1), .O5(res[209]), .O6(res[210]));
	(* BEL = "B6LUT", RLOC = "X0Y0", HU_SET = "R20" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_211_212 (.I0(O_HI1[20][3]), .I1(CO[31][3]), .I2(O_HI0[20][3]), .I3(O_HI1[21][0]), .I4(O_HI0[21][0]), .I5(1), .O5(res[211]), .O6(res[212]));
	(* BEL = "A6LUT", RLOC = "X0Y0", HU_SET = "R21" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_213_214 (.I0(O_HI1[21][1]), .I1(CO[31][3]), .I2(O_HI0[21][1]), .I3(O_HI1[21][2]), .I4(O_HI0[21][2]), .I5(1), .O5(res[213]), .O6(res[214]));
	(* BEL = "B6LUT", RLOC = "X0Y0", HU_SET = "R21" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_215_216 (.I0(O_HI1[21][3]), .I1(CO[31][3]), .I2(O_HI0[21][3]), .I3(O_HI1[22][0]), .I4(O_HI0[22][0]), .I5(1), .O5(res[215]), .O6(res[216]));
	(* BEL = "A6LUT", RLOC = "X0Y0", HU_SET = "R22" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_217_218 (.I0(O_HI1[22][1]), .I1(CO[31][3]), .I2(O_HI0[22][1]), .I3(O_HI1[22][2]), .I4(O_HI0[22][2]), .I5(1), .O5(res[217]), .O6(res[218]));
	(* BEL = "B6LUT", RLOC = "X0Y0", HU_SET = "R22" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_219_220 (.I0(O_HI1[22][3]), .I1(CO[31][3]), .I2(O_HI0[22][3]), .I3(O_HI1[23][0]), .I4(O_HI0[23][0]), .I5(1), .O5(res[219]), .O6(res[220]));
	(* BEL = "A6LUT", RLOC = "X0Y0", HU_SET = "R23" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_221_222 (.I0(O_HI1[23][1]), .I1(CO[31][3]), .I2(O_HI0[23][1]), .I3(O_HI1[23][2]), .I4(O_HI0[23][2]), .I5(1), .O5(res[221]), .O6(res[222]));
	(* BEL = "B6LUT", RLOC = "X0Y0", HU_SET = "R23" *)LUT6_2 #(.INIT(64'hB84747B8FFB8B800)) gen_res_223_tmp (.I0(CO_HI1[23][2]), .I1(CO[31][3]), .I2(CO_HI0[23][2]), .I3(A[223]), .I4(B[223]), .I5(1), .O5(cout[13]), .O6(res_tmp[5]));

	(* BEL = "A6LUT", RLOC = "X0Y0", HU_SET = "R24" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_224_225 (.I0(O_HI1[24][0]), .I1(CO[31][3]), .I2(O_HI0[24][0]), .I3(O_HI1[24][1]), .I4(O_HI0[24][1]), .I5(1), .O5(res[224]), .O6(res[225]));
	(* BEL = "B6LUT", RLOC = "X0Y0", HU_SET = "R24" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_226_227 (.I0(O_HI1[24][2]), .I1(CO[31][3]), .I2(O_HI0[24][2]), .I3(O_HI1[24][3]), .I4(O_HI0[24][3]), .I5(1), .O5(res[226]), .O6(res[227]));
	(* BEL = "A6LUT", RLOC = "X0Y0", HU_SET = "R25" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_228_229 (.I0(O_HI1[25][0]), .I1(CO[31][3]), .I2(O_HI0[25][0]), .I3(O_HI1[25][1]), .I4(O_HI0[25][1]), .I5(1), .O5(res[228]), .O6(res[229]));
	(* BEL = "B6LUT", RLOC = "X0Y0", HU_SET = "R25" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_230_231 (.I0(O_HI1[25][2]), .I1(CO[31][3]), .I2(O_HI0[25][2]), .I3(O_HI1[25][3]), .I4(O_HI0[25][3]), .I5(1), .O5(res[230]), .O6(res[231]));
	(* BEL = "A6LUT", RLOC = "X0Y0", HU_SET = "R26" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_232_233 (.I0(O_HI1[26][0]), .I1(CO[31][3]), .I2(O_HI0[26][0]), .I3(O_HI1[26][1]), .I4(O_HI0[26][1]), .I5(1), .O5(res[232]), .O6(res[233]));
	(* BEL = "B6LUT", RLOC = "X0Y0", HU_SET = "R26" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_234_235 (.I0(O_HI1[26][2]), .I1(CO[31][3]), .I2(O_HI0[26][2]), .I3(O_HI1[26][3]), .I4(O_HI0[26][3]), .I5(1), .O5(res[234]), .O6(res[235]));
	(* BEL = "A6LUT", RLOC = "X0Y0", HU_SET = "R27" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_236_237 (.I0(O_HI1[27][0]), .I1(CO[31][3]), .I2(O_HI0[27][0]), .I3(O_HI1[27][1]), .I4(O_HI0[27][1]), .I5(1), .O5(res[236]), .O6(res[237]));
	(* BEL = "D6LUT", RLOC = "X0Y0", HU_SET = "R27" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_238_240 (.I0(O_HI1[27][2]), .I1(CO[31][3]), .I2(O_HI0[27][2]), .I3(O_HI1[28][0]), .I4(O_HI0[28][0]), .I5(1), .O5(res[238]), .O6(res[240]));
	(* BEL = "B6LUT", RLOC = "X0Y0", HU_SET = "R27" *)LUT6_2 #(.INIT(64'hB84747B8FFB8B800)) gen_res_239_tmp (.I0(CO_HI1[27][2]), .I1(CO[31][3]), .I2(CO_HI0[27][2]), .I3(A[239]), .I4(B[239]), .I5(1), .O5(cout[14]), .O6(res_tmp[6]));

	(* BEL = "A6LUT", RLOC = "X0Y0", HU_SET = "R28" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_241_242 (.I0(O_HI1[28][1]), .I1(CO[31][3]), .I2(O_HI0[28][1]), .I3(O_HI1[28][2]), .I4(O_HI0[28][2]), .I5(1), .O5(res[241]), .O6(res[242]));
	(* BEL = "B6LUT", RLOC = "X0Y0", HU_SET = "R28" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_243_244 (.I0(O_HI1[28][3]), .I1(CO[31][3]), .I2(O_HI0[28][3]), .I3(O_HI1[29][0]), .I4(O_HI0[29][0]), .I5(1), .O5(res[243]), .O6(res[244]));
	(* BEL = "A6LUT", RLOC = "X0Y0", HU_SET = "R29" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_245_246 (.I0(O_HI1[29][1]), .I1(CO[31][3]), .I2(O_HI0[29][1]), .I3(O_HI1[29][2]), .I4(O_HI0[29][2]), .I5(1), .O5(res[245]), .O6(res[246]));
	(* BEL = "B6LUT", RLOC = "X0Y0", HU_SET = "R29" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_247_248 (.I0(O_HI1[29][3]), .I1(CO[31][3]), .I2(O_HI0[29][3]), .I3(O_HI1[30][0]), .I4(O_HI0[30][0]), .I5(1), .O5(res[247]), .O6(res[248]));
	(* BEL = "A6LUT", RLOC = "X0Y0", HU_SET = "R30" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_249_250 (.I0(O_HI1[30][1]), .I1(CO[31][3]), .I2(O_HI0[30][1]), .I3(O_HI1[30][2]), .I4(O_HI0[30][2]), .I5(1), .O5(res[249]), .O6(res[250]));
	(* BEL = "B6LUT", RLOC = "X0Y0", HU_SET = "R30" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_251_252 (.I0(O_HI1[30][3]), .I1(CO[31][3]), .I2(O_HI0[30][3]), .I3(O_HI1[31][0]), .I4(O_HI0[31][0]), .I5(1), .O5(res[251]), .O6(res[252]));
	(* BEL = "A6LUT", RLOC = "X0Y0", HU_SET = "R31" *)LUT6_2 #(.INIT(64'hFF33CC00B8B8B8B8)) gen_res_253_254 (.I0(O_HI1[31][1]), .I1(CO[31][3]), .I2(O_HI0[31][1]), .I3(O_HI1[31][2]), .I4(O_HI0[31][2]), .I5(1), .O5(res[253]), .O6(res[254]));
	(* BEL = "B6LUT", RLOC = "X0Y0", HU_SET = "R31" *)LUT6_2 #(.INIT(64'hB84747B8FFB8B800)) gen_res_255_tmp (.I0(CO_HI1[31][2]), .I1(CO[31][3]), .I2(CO_HI0[31][2]), .I3(A[255]), .I4(B[255]), .I5(1), .O5(cout[15]), .O6(res_tmp[7]));

	// COMPUTE cout[i - 1] AND res[i*16 - 1] FOR i = 1..8
	(* DONT_TOUCH = "yes" *)LUT6_2 #(.INIT(64'h00000000E8E8E8E8)) gen_cout_0 (.I0(CO[3][2]), .I1(A[15]), .I2(B[15]), .I3(0), .I4(0), .I5(1), .O5(cout[0]), .O6());
	(* DONT_TOUCH = "yes" *)LUT6_2 #(.INIT(64'h00000000E8E8E8E8)) gen_cout_2 (.I0(CO[11][2]), .I1(A[47]), .I2(B[47]), .I3(0), .I4(0), .I5(1), .O5(cout[2]), .O6());
	(* DONT_TOUCH = "yes" *)LUT6_2 #(.INIT(64'h00000000E8E8E8E8)) gen_cout_3 (.I0(CO[15][2]), .I1(A[63]), .I2(B[63]), .I3(0), .I4(0), .I5(1), .O5(cout[3]), .O6());
	(* DONT_TOUCH = "yes" *)LUT6_2 #(.INIT(64'h00000000E8E8E8E8)) gen_cout_4 (.I0(CO[19][2]), .I1(A[79]), .I2(B[79]), .I3(0), .I4(0), .I5(1), .O5(cout[4]), .O6());
	(* DONT_TOUCH = "yes" *)LUT6_2 #(.INIT(64'h00000000E8E8E8E8)) gen_cout_6 (.I0(CO[27][2]), .I1(A[111]), .I2(B[111]), .I3(0), .I4(0), .I5(1), .O5(cout[6]), .O6());
	(* DONT_TOUCH = "yes" *)LUT6_2 #(.INIT(64'h00000000E8E8E8E8)) gen_cout_7 (.I0(CO[31][2]), .I1(A[127]), .I2(B[127]), .I3(0), .I4(0), .I5(1), .O5(cout[7]), .O6());

	(* DONT_TOUCH = "yes" *)LUT6_2 #(.INIT(64'hAAAAAAAAB88B8BB8)) gen_res_15 (.I0(O[0]), .I1(word_mode[1]), .I2(CO[3][2]), .I3(A[15]), .I4(B[15]), .I5(word_mode[0]), .O5(), .O6(res[15]));
	(* DONT_TOUCH = "yes" *)LUT6_2 #(.INIT(64'hAAAAAAAAB88B8BB8)) gen_res_47 (.I0(O[2]), .I1(word_mode[1]), .I2(CO[11][2]), .I3(A[47]), .I4(B[47]), .I5(word_mode[0]), .O5(), .O6(res[47]));
	(* DONT_TOUCH = "yes" *)LUT6_2 #(.INIT(64'hBF8080BF80BFBF80)) gen_res_63 (.I0(O[3]), .I1(word_mode[1]), .I2(word_mode[0]), .I3(CO[15][2]), .I4(A[63]), .I5(B[63]), .O5(), .O6(res[63]));
	(* DONT_TOUCH = "yes" *)LUT6_2 #(.INIT(64'hAAAAAAAAB88B8BB8)) gen_res_79 (.I0(O[4]), .I1(word_mode[1]), .I2(CO[19][2]), .I3(A[79]), .I4(B[79]), .I5(word_mode[0]), .O5(), .O6(res[79]));
	(* DONT_TOUCH = "yes" *)LUT6_2 #(.INIT(64'hAAAAAAAAB88B8BB8)) gen_res_111 (.I0(O[6]), .I1(word_mode[1]), .I2(CO[27][2]), .I3(A[111]), .I4(B[111]), .I5(word_mode[0]), .O5(), .O6(res[111]));
	(* DONT_TOUCH = "yes" *)LUT6_2 #(.INIT(64'hBF8080BF80BFBF80)) gen_res_127 (.I0(O[7]), .I1(word_mode[1]), .I2(word_mode[0]), .I3(CO[31][2]), .I4(A[127]), .I5(B[127]), .O5(), .O6(res[127]));

	(* DONT_TOUCH = "yes" *)LUT6_2 #(.INIT(64'hFFAAAA00B88B8BB8)) gen_c_1_r_31 (.I0(O[1]), .I1(word_mode[1]), .I2(CO[7][2]), .I3(B[31]), .I4(A[31]), .I5(1), .O5(res[31]), .O6(cout[1]));
	(* DONT_TOUCH = "yes" *)LUT6_2 #(.INIT(64'hFFAAAA00B88B8BB8)) gen_c_5_r_95 (.I0(O[5]), .I1(word_mode[1]), .I2(CO[23][2]), .I3(B[95]), .I4(A[95]), .I5(1), .O5(res[95]), .O6(cout[5]));

	// COMPUTE cout[i - 1] AND res[i*16 - 1] FOR i = 9..16
	(* BEL = "C6LUT", RLOC = "X0Y0", HU_SET = "R2" *)LUT6_2 #(.INIT(64'hCFC0DFD5CFC08A80)) gen_res_143 (.I0(word_mode[0]), .I1(O_HI1[3][3]), .I2(CO[31][3]), .I3(O_HI0[3][3]),  .I4(word_mode[1]), .I5(res_tmp[0]), .O5(), .O6(res[143]));
	(* BEL = "C6LUT", RLOC = "X0Y0", HU_SET = "R6" *)LUT6_2 #(.INIT(64'h00000000B8FFB800)) gen_res_159 (.I0(O_HI1[7][3]), .I1(CO[31][3]), .I2(O_HI0[7][3]),  .I3(word_mode[1]), .I4(res_tmp[1]), .I5(1), .O5(res[159]), .O6());
	(* BEL = "C6LUT", RLOC = "X0Y0", HU_SET = "R10" *)LUT6_2 #(.INIT(64'hCFC0DFD5CFC08A80)) gen_res_175 (.I0(word_mode[0]), .I1(O_HI1[11][3]), .I2(CO[31][3]), .I3(O_HI0[11][3]),  .I4(word_mode[1]), .I5(res_tmp[2]), .O5(), .O6(res[175]));
	(* BEL = "C6LUT", RLOC = "X0Y0", HU_SET = "R14" *)LUT6_2 #(.INIT(64'hB8FFFFFFB8000000)) gen_res_191 (.I0(O_HI1[15][3]), .I1(CO[31][3]), .I2(O_HI0[15][3]), .I3(word_mode[1]),  .I4(word_mode[0]), .I5(res_tmp[3]), .O5(), .O6(res[191]));
	(* BEL = "C6LUT", RLOC = "X0Y0", HU_SET = "R18" *)LUT6_2 #(.INIT(64'hCFC0DFD5CFC08A80)) gen_res_207 (.I0(word_mode[0]), .I1(O_HI1[19][3]), .I2(CO[31][3]), .I3(O_HI0[19][3]),  .I4(word_mode[1]), .I5(res_tmp[4]), .O5(), .O6(res[207]));
	(* BEL = "C6LUT", RLOC = "X0Y0", HU_SET = "R22" *)LUT6_2 #(.INIT(64'h00000000B8FFB800)) gen_res_223 (.I0(O_HI1[23][3]), .I1(CO[31][3]), .I2(O_HI0[23][3]),  .I3(word_mode[1]), .I4(res_tmp[5]), .I5(1), .O5(res[223]), .O6());
	(* BEL = "C6LUT", RLOC = "X0Y0", HU_SET = "R26" *)LUT6_2 #(.INIT(64'hCFC0DFD5CFC08A80)) gen_res_239 (.I0(word_mode[0]), .I1(O_HI1[27][3]), .I2(CO[31][3]), .I3(O_HI0[27][3]),  .I4(word_mode[1]), .I5(res_tmp[6]), .O5(), .O6(res[239]));
	(* BEL = "C6LUT", RLOC = "X0Y0", HU_SET = "R30" *)LUT6_2 #(.INIT(64'hB8FFFFFFB8000000)) gen_res_255 (.I0(O_HI1[31][3]), .I1(CO[31][3]), .I2(O_HI0[31][3]), .I3(word_mode[1]),  .I4(word_mode[0]), .I5(res_tmp[7]), .O5(), .O6(res[255]));
endmodule
