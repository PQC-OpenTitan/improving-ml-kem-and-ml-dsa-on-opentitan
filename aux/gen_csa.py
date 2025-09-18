#!/usr/bin/env python3

import sys
import argparse
from pathlib import Path

WLEN = 256

def print_info(s):
    """Print info or error message
    """
    s_split = s.split(':', 1)
    if s_split[0] == 'ERROR':
        s_split[0] = f'\033[1;31m{s_split[0]}\033[0m'
    if s_split[0] == 'INFO':
        s_split[0] = f'\033[1;32m{s_split[0]}\033[0m'
    s_split[1] = f'\033[1m{s_split[1]}\033[0m'

    info = ': '.join(s_split)
    print(info)


def gen_code():
    count = 0
    tmp = 0
    # Bottom 128 bits
    block = "\t// COMPUTE S, DI --> CARRY4 FOR BOTTOM 128 BITS\n"
    x = 0
    y =0
    for i in range(0, WLEN//2, 4):
        block += (
            f'\t// {i}..{i + 3}\n'
            f'\t(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X{x}Y{y}", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64\'h6666666688888888)) '
            f'gen_SDI_{i}  (.I0(A[{i}]), .I1(B[{i}]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[{i}]), .O6(S[{i}]));\n'
            f'\t(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X{x}Y{y}", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64\'h6666666688888888)) '
            f'gen_SDI_{i + 1}  (.I0(A[{i + 1}]), .I1(B[{i + 1}]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[{i + 1}]), .O6(S[{i + 1}]));\n'
            f'\t(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X{x}Y{y}", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64\'h6666666688888888)) '
            f'gen_SDI_{i + 2}  (.I0(A[{i + 2}]), .I1(B[{i + 2}]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[{i + 2}]), .O6(S[{i + 2}]));\n'
        )
        if i in {12, 44, 76, 108}:
            block += (
                f'\t(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X{x}Y{y}", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64\'h66606660888F8880)) '
                f'gen_SDI_{i+3}  (.I0(A[{i + 3}]), .I1(B[{i + 3}]), .I2(word_mode[0]), '
                f'.I3(word_mode[1]), .I4(cin), .I5(1), .O5(DI[{i + 3}]), .O6(S[{i + 3}]));\n'
            )
        elif i in {28, 92}:
            block += (
                f'\t(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X{x}Y{y}", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64\'h606060608F808F80)) '
                f'gen_SDI_{i+3}  (.I0(A[{i + 3}]), .I1(B[{i + 3}]), .I2(word_mode[1]), .I3(cin), .I4(0), .I5(1), .O5(DI[{i + 3}]), .O6(S[{i + 3}]));\n'
            )
        elif i in {60, 124}:
            block += (
                f'\t(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X{x}Y{y}", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64\'h600060008FFF8000)) '
                f'gen_SDI_{i+3}  (.I0(A[{i + 3}]), .I1(B[{i + 3}]), .I2(word_mode[0]), '
                f'.I3(word_mode[1]), .I4(cin), .I5(1), .O5(DI[{i + 3}]), .O6(S[{i + 3}]));\n'
            )
        else:
            block += (
                f'\t(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X{x}Y{y}", HU_SET = "BOTTOM" *)LUT6_2 #(.INIT(64\'h6666666688888888)) '
                f'gen_SDI_{i + 3}  (.I0(A[{i + 3}]), .I1(B[{i + 3}]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI[{i + 3}]), .O6(S[{i + 3}]));\n'
            )
        # CARRY4
        if i == 0:
            block += (
                # f'  (* BOX_TYPE = "PRIMITIVE", DONT_TOUCH = "yes", BEL = "CARRY4", LOC = "SLICE_X{x}Y{y}" *)\n'
                f'\t(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X{x}Y{y}", HU_SET = "BOTTOM" *)CARRY4 c_lo_{count} (.CI(1\'b0), .CYINIT(cin), .DI(DI[{i + 3}:{i}]), '
                f'.S(S[{i + 3}:{i}]), .O(res[{i + 3}:{i}]), .CO(CO[{count}]));\n'
            )
        else:
            if (i + 4) % 16 == 0:
                block += (
                    # f'  (* BOX_TYPE = "PRIMITIVE", DONT_TOUCH = "yes", BEL = "CARRY4", LOC = "SLICE_X{x}Y{y}" *)\n'
                    f'\t(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X{x}Y{y}", HU_SET = "BOTTOM" *)CARRY4 c_lo_{count} (.CI(CO[{count - 1}][3]), .CYINIT(1\'b0), .DI(DI[{i + 3}:{i}]), '
                    f'.S(S[{i + 3}:{i}]), .O({{O[{tmp}], res[{i + 2}:{i}]}}), .CO(CO[{count}]));\n'
                )
                tmp += 1
            else:
                block += (
                    # f'  (* BOX_TYPE = "PRIMITIVE", DONT_TOUCH = "yes", BEL = "CARRY4", LOC = "SLICE_X{x}Y{y}" *)\n'
                    f'\t(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X{x}Y{y}", HU_SET = "BOTTOM" *)CARRY4 c_lo_{count} (.CI(CO[{count - 1}][3]), .CYINIT(1\'b0), .DI(DI[{i + 3}:{i}]), '
                    f'.S(S[{i + 3}:{i}]), .O(res[{i + 3}:{i}]), .CO(CO[{count}]));\n'
                )
        count += 1
        y += 1
    # block += (
    #     "\t/* verilator lint_off WIDTHEXPAND */\n"
    #     f'\tCARRY4 c_lo_{count} (.CI(CO[{count - 1}][3]), .CYINIT(1\'b0), .DI(4\'b0000), .S(4\'b0001), .O(), .CO(CO[31][3]));\n'
    #     "\t/* verilator lint_on WIDTHEXPAND */\n\n"
    # )

    cin = [0, 1]
    for c in cin:
        x = 0
        y = 0
        count = 0
        block += f"\t// COMPUTE S{c}, DI{c} FOR TOP 128 BITS WHEN CARRY IN = {c}\n"
        for i in range(WLEN//2, WLEN, 4):
            block += (
                f'\t// {i}..{i + 3}\n'
                f'\t(* DONT_TOUCH = "yes", BEL = "A6LUT", RLOC = "X{x}Y{y}", HU_SET = "TOPC{c}" *)LUT6_2 #(.INIT(64\'h6666666688888888)) '
                f'gen_SDI{c}_{i- 128}  (.I0(A[{i}]), .I1(B[{i}]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI{c}[{i - 128}]), .O6(S{c}[{i - 128}]));\n'
                f'\t(* DONT_TOUCH = "yes", BEL = "B6LUT", RLOC = "X{x}Y{y}", HU_SET = "TOPC{c}" *)LUT6_2 #(.INIT(64\'h6666666688888888)) '
                f'gen_SDI{c}_{i + 1 - 128}  (.I0(A[{i + 1}]), .I1(B[{i + 1}]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI{c}[{i + 1 - 128}]), .O6(S{c}[{i + 1 - 128}]));\n'
                f'\t(* DONT_TOUCH = "yes", BEL = "C6LUT", RLOC = "X{x}Y{y}", HU_SET = "TOPC{c}" *)LUT6_2 #(.INIT(64\'h6666666688888888)) '
                f'gen_SDI{c}_{i + 2 - 128}  (.I0(A[{i + 2}]), .I1(B[{i + 2}]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI{c}[{i + 2 - 128}]), .O6(S{c}[{i + 2 - 128}]));\n'
            )
            if i in {140, 172, 204, 236}:
                block += (
                    # Compute S0
                    f'\t(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X{x}Y{y}", HU_SET = "TOPC{c}" *)LUT6_2 #(.INIT(64\'h66606660888F8880)) '
                    f'gen_SDI{c}_{i + 3 - 128}  (.I0(A[{i + 3}]), .I1(B[{i + 3}]), .I2(word_mode[0]), '
                    f'.I3(word_mode[1]), .I4(cin), .I5(1), .O5(DI{c}[{i + 3 - 128}]), .O6(S{c}[{i + 3 - 128}]));\n'
                )
            elif i in {156, 220}:
                block += (
                    # Compute S0
                    f'\t(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X{x}Y{y}", HU_SET = "TOPC{c}" *)LUT6_2 #(.INIT(64\'h606060608F808F80)) '
                    f'gen_SDI{c}_{i + 3 - 128}  (.I0(A[{i + 3}]), .I1(B[{i + 3}]), .I2(word_mode[1]), .I3(cin), .I4(0), .I5(1), .O5(DI{c}[{i + 3 - 128}]), .O6(S{c}[{i + 3 - 128}]));\n'
                )
            elif i in {188, 252}:
                block += (
                    f'\t(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X{x}Y{y}", HU_SET = "TOPC{c}" *)LUT6_2 #(.INIT(64\'h600060008FFF8000)) '
                    f'gen_SDI{c}_{i + 3 - 128}  (.I0(A[{i + 3}]), .I1(B[{i + 3}]), .I2(word_mode[0]), '
                    f'.I3(word_mode[1]), .I4(cin), .I5(1), .O5(DI{c}[{i + 3 - 128}]), .O6(S{c}[{i + 3 - 128}]));\n'
                )
            else:
                block += (
                    f'\t(* DONT_TOUCH = "yes", BEL = "D6LUT", RLOC = "X{x}Y{y}", HU_SET = "TOPC{c}" *)LUT6_2 #(.INIT(64\'h6666666688888888)) '
                    f'gen_SDI{c}_{i + 3 - 128}  (.I0(A[{i + 3}]), .I1(B[{i + 3}]), .I2(0), .I3(0), .I4(0), .I5(1), .O5(DI{c}[{i + 3 - 128}]), .O6(S{c}[{i + 3 - 128}]));\n'
                )
            count += 1
            y += 1
        block += "\n"
        count = 0
        x = 0
        y = 0
        block += f"\t// COMPUTE CARRY4 CHAIN FOR TOP 128 BITS WHEN CARRY IN = {c}\n"
        for i in range(0, WLEN//2, 4):
            if i == 0:
                block += (
                    f'\t(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X{x}Y{y}", HU_SET = "TOPC{c}" *)CARRY4 c_hi{c}_{count} (.CI(1\'b{c}), .CYINIT(1\'b0), .DI(DI{c}[{i + 3}:{i}]), '
                    f'.S(S{c}[{i + 3}:{i}]), .O(O_HI{c}[{count}]), .CO(CO_HI{c}[{count}]));\n'
                )
            else:
                block += (
                    f'\t(* DONT_TOUCH = "yes", BEL = "CARRY4", RLOC = "X{x}Y{y}", HU_SET = "TOPC{c}" *)CARRY4 c_hi{c}_{count} (.CI(CO_HI{c}[{count - 1}][3]), .CYINIT(1\'b0), .DI(DI{c}[{i + 3}:{i}]), '
                    f'.S(S{c}[{i + 3}:{i}]), .O(O_HI{c}[{count}]), .CO(CO_HI{c}[{count}]));\n'
                )
            count += 1
            y += 1
        block += "\n"
    return block


def gen_carry4(c):
    block = (
        f"module csa_carry4_top_cin{c}\n"
        "(\n"
        f"  input logic [127:0] S{c},\n"
        f"  input logic [127:0] DI{c},\n"
        f"  output logic [3:0]  O_HI{c} [0:31],\n"
        f"  output logic [3:0]  CO_HI{c} [0:31]\n"
        ");\n"
    )
    count = 0
    block += f"\t// COMPUTE CARRY4 CHAIN FOR TOP 128 BITS WHEN CARRY IN = {c}\n"
    for i in range(0, WLEN//2, 4):
        if i == 0:
            block += (
                f'\tCARRY4 c_hi{c}_{count} (.CI(1\'b{c}), .CYINIT(1\'b0), .DI(DI{c}[{i + 3}:{i}]), '
                f'.S(S{c}[{i + 3}:{i}]), .O(O_HI{c}[{count}]), .CO(CO_HI{c}[{count}]));\n'
            )
        else:
            block += (
                f'\tCARRY4 c_hi{c}_{count} (.CI(CO_HI{c}[{count - 1}][3]), .CYINIT(1\'b0), .DI(DI{c}[{i + 3}:{i}]), '
                f'.S(S{c}[{i + 3}:{i}]), .O(O_HI{c}[{count}]), .CO(CO_HI{c}[{count}]));\n'
            )
        count += 1
    block += "endmodule\n"
    return block

def gen_res(x, y):
    block = "\t// COMPUTE res FOR TOP 128 bits\n"
    count = 0
    b_count = 0
    tmp = 0
    x = 0
    y = 0
    for i in range(WLEN//2, WLEN, 32):
        block += (
            f'\t(* BEL = "A6LUT", RLOC = "X{x}Y{y}", HU_SET = "R{count}" *)LUT6_2 #(.INIT(64\'hFF33CC00B8B8B8B8)) '
            f'gen_res_{i}_{i+1} (.I0(O_HI1[{count}][{b_count}]), .I1(CO[31][3]), '
            f'.I2(O_HI0[{count}][{b_count}]), .I3(O_HI1[{count}][{b_count + 1}]), '
            f'.I4(O_HI0[{count}][{b_count + 1}]), .I5(1), .O5(res[{i}]), .O6(res[{i + 1}]));\n'
            f'\t(* BEL = "B6LUT", RLOC = "X{x}Y{y}", HU_SET = "R{count}" *)LUT6_2 #(.INIT(64\'hFF33CC00B8B8B8B8)) '
            f'gen_res_{i + 2}_{i + 3} (.I0(O_HI1[{count}][{b_count + 2}]), .I1(CO[31][3]), '
            f'.I2(O_HI0[{count}][{b_count + 2}]), .I3(O_HI1[{count}][{b_count + 3}]), '
            f'.I4(O_HI0[{count}][{b_count + 3}]), .I5(1), .O5(res[{i + 2}]), .O6(res[{i + 3}]));\n'
        )
        count += 1
        block += (
            f'\t(* BEL = "A6LUT", RLOC = "X{x}Y{y}", HU_SET = "R{count}" *)LUT6_2 #(.INIT(64\'hFF33CC00B8B8B8B8)) '
            f'gen_res_{i+4}_{i+5} (.I0(O_HI1[{count}][{b_count}]), .I1(CO[31][3]), '
            f'.I2(O_HI0[{count}][{b_count}]), .I3(O_HI1[{count}][{b_count + 1}]), '
            f'.I4(O_HI0[{count}][{b_count + 1}]), .I5(1), .O5(res[{i+4}]), .O6(res[{i + 5}]));\n'
            f'\t(* BEL = "B6LUT", RLOC = "X{x}Y{y}", HU_SET = "R{count}" *)LUT6_2 #(.INIT(64\'hFF33CC00B8B8B8B8)) '
            f'gen_res_{i + 6}_{i + 7} (.I0(O_HI1[{count}][{b_count + 2}]), .I1(CO[31][3]), '
            f'.I2(O_HI0[{count}][{b_count + 2}]), .I3(O_HI1[{count}][{b_count + 3}]), '
            f'.I4(O_HI0[{count}][{b_count + 3}]), .I5(1), .O5(res[{i + 6}]), .O6(res[{i + 7}]));\n'
        )
        count += 1
        block += (
            f'\t(* BEL = "A6LUT", RLOC = "X{x}Y{y}", HU_SET = "R{count}" *)LUT6_2 #(.INIT(64\'hFF33CC00B8B8B8B8)) '
            f'gen_res_{i+8}_{i+9} (.I0(O_HI1[{count}][{b_count}]), .I1(CO[31][3]), '
            f'.I2(O_HI0[{count}][{b_count}]), .I3(O_HI1[{count}][{b_count + 1}]), '
            f'.I4(O_HI0[{count}][{b_count + 1}]), .I5(1), .O5(res[{i+8}]), .O6(res[{i + 9}]));\n'
            f'\t(* BEL = "B6LUT", RLOC = "X{x}Y{y}", HU_SET = "R{count}" *)LUT6_2 #(.INIT(64\'hFF33CC00B8B8B8B8)) '
            f'gen_res_{i + 10}_{i + 11} (.I0(O_HI1[{count}][{b_count + 2}]), .I1(CO[31][3]), '
            f'.I2(O_HI0[{count}][{b_count + 2}]), .I3(O_HI1[{count}][{b_count + 3}]), '
            f'.I4(O_HI0[{count}][{b_count + 3}]), .I5(1), .O5(res[{i + 10}]), .O6(res[{i + 11}]));\n'
        )
        count += 1
        block += (
            f'\t(* BEL = "A6LUT", RLOC = "X{x}Y{y}", HU_SET = "R{count}" *)LUT6_2 #(.INIT(64\'hFF33CC00B8B8B8B8)) '
            f'gen_res_{i+12}_{i+13} (.I0(O_HI1[{count}][{b_count}]), .I1(CO[31][3]), '
            f'.I2(O_HI0[{count}][{b_count}]), .I3(O_HI1[{count}][{b_count + 1}]), '
            f'.I4(O_HI0[{count}][{b_count + 1}]), .I5(1), .O5(res[{i+12}]), .O6(res[{i + 13}]));\n'
            f'\t(* BEL = "D6LUT", RLOC = "X{x}Y{y}", HU_SET = "R{count}" *)LUT6_2 #(.INIT(64\'hFF33CC00B8B8B8B8)) '
            f'gen_res_{i + 14}_{i + 16} (.I0(O_HI1[{count}][{b_count + 2}]), .I1(CO[31][3]), '
            f'.I2(O_HI0[{count}][{b_count + 2}]), .I3(O_HI1[{count+1}][{b_count}]), '
            f'.I4(O_HI0[{count+1}][{b_count}]), .I5(1), .O5(res[{i + 14}]), .O6(res[{i + 16}]));\n'
        )
        block += (
            f'\t(* BEL = "B6LUT", RLOC = "X{x}Y{y}", HU_SET = "R{count}" *)LUT6_2 #(.INIT(64\'hB84747B8FFB8B800)) '
            f'gen_res_{i+15}_tmp (.I0(CO_HI1[{count}][2]), .I1(CO[31][3]), .I2(CO_HI0[{count}][2]), '
            f'.I3(A[{i + 15}]), .I4(B[{i + 15}]), .I5(1), .O5(cout[{tmp + 8}]), .O6(res_tmp[{tmp}]));\n\n'
        )
        tmp += 1
        count += 1
        block += (
            f'\t(* BEL = "A6LUT", RLOC = "X{x}Y{y}", HU_SET = "R{count}" *)LUT6_2 #(.INIT(64\'hFF33CC00B8B8B8B8)) '
            f'gen_res_{i+17}_{i+18} (.I0(O_HI1[{count}][{b_count + 1}]), .I1(CO[31][3]), '
            f'.I2(O_HI0[{count}][{b_count + 1}]), .I3(O_HI1[{count}][{b_count + 2}]), '
            f'.I4(O_HI0[{count}][{b_count + 2}]), .I5(1), .O5(res[{i + 17}]), .O6(res[{i + 18}]));\n'
            f'\t(* BEL = "B6LUT", RLOC = "X{x}Y{y}", HU_SET = "R{count}" *)LUT6_2 #(.INIT(64\'hFF33CC00B8B8B8B8)) '
            f'gen_res_{i + 19}_{i + 20} (.I0(O_HI1[{count}][{b_count + 3}]), .I1(CO[31][3]), '
            f'.I2(O_HI0[{count}][{b_count + 3}]), .I3(O_HI1[{count + 1}][{b_count}]), '
            f'.I4(O_HI0[{count + 1}][{b_count}]), .I5(1), .O5(res[{i + 19}]), .O6(res[{i + 20}]));\n'
        )
        count += 1
        block += (
            f'\t(* BEL = "A6LUT", RLOC = "X{x}Y{y}", HU_SET = "R{count}" *)LUT6_2 #(.INIT(64\'hFF33CC00B8B8B8B8)) '
            f'gen_res_{i+21}_{i+22} (.I0(O_HI1[{count}][{b_count + 1}]), .I1(CO[31][3]), '
            f'.I2(O_HI0[{count}][{b_count + 1}]), .I3(O_HI1[{count}][{b_count + 2}]), '
            f'.I4(O_HI0[{count}][{b_count + 2}]), .I5(1), .O5(res[{i + 21}]), .O6(res[{i + 22}]));\n'
            f'\t(* BEL = "B6LUT", RLOC = "X{x}Y{y}", HU_SET = "R{count}" *)LUT6_2 #(.INIT(64\'hFF33CC00B8B8B8B8)) '
            f'gen_res_{i + 23}_{i + 24} (.I0(O_HI1[{count}][{b_count + 3}]), .I1(CO[31][3]), '
            f'.I2(O_HI0[{count}][{b_count + 3}]), .I3(O_HI1[{count + 1}][{b_count}]), '
            f'.I4(O_HI0[{count + 1}][{b_count}]), .I5(1), .O5(res[{i + 23}]), .O6(res[{i + 24}]));\n'
        )
        count += 1
        block += (
            f'\t(* BEL = "A6LUT", RLOC = "X{x}Y{y}", HU_SET = "R{count}" *)LUT6_2 #(.INIT(64\'hFF33CC00B8B8B8B8)) '
            f'gen_res_{i+25}_{i+26} (.I0(O_HI1[{count}][{b_count + 1}]), .I1(CO[31][3]), '
            f'.I2(O_HI0[{count}][{b_count + 1}]), .I3(O_HI1[{count}][{b_count + 2}]), '
            f'.I4(O_HI0[{count}][{b_count + 2}]), .I5(1), .O5(res[{i + 25}]), .O6(res[{i + 26}]));\n'
            f'\t(* BEL = "B6LUT", RLOC = "X{x}Y{y}", HU_SET = "R{count}" *)LUT6_2 #(.INIT(64\'hFF33CC00B8B8B8B8)) '
            f'gen_res_{i + 27}_{i + 28} (.I0(O_HI1[{count}][{b_count + 3}]), .I1(CO[31][3]), '
            f'.I2(O_HI0[{count}][{b_count + 3}]), .I3(O_HI1[{count + 1}][{b_count}]), '
            f'.I4(O_HI0[{count + 1}][{b_count}]), .I5(1), .O5(res[{i + 27}]), .O6(res[{i + 28}]));\n'
        )
        count += 1
        block += (
            f'\t(* BEL = "A6LUT", RLOC = "X{x}Y{y}", HU_SET = "R{count}" *)LUT6_2 #(.INIT(64\'hFF33CC00B8B8B8B8)) '
            f'gen_res_{i+29}_{i+30} (.I0(O_HI1[{count}][{b_count + 1}]), .I1(CO[31][3]), '
            f'.I2(O_HI0[{count}][{b_count + 1}]), .I3(O_HI1[{count}][{b_count + 2}]), '
            f'.I4(O_HI0[{count}][{b_count + 2}]), .I5(1), .O5(res[{i + 29}]), .O6(res[{i + 30}]));\n'
        )
        block += (
            f'\t(* BEL = "B6LUT", RLOC = "X{x}Y{y}", HU_SET = "R{count}" *)LUT6_2 #(.INIT(64\'hB84747B8FFB8B800)) '
            f'gen_res_{i+31}_tmp (.I0(CO_HI1[{count}][2]), .I1(CO[31][3]), .I2(CO_HI0[{count}][2]), '
            f'.I3(A[{i + 31}]), .I4(B[{i + 31}]), .I5(1), .O5(cout[{tmp + 8}]), .O6(res_tmp[{tmp}]));\n\n'
        )
        tmp += 1
        count += 1


    return block


def gen_co_res(X, Y):
    x = X
    y = Y
    block = "\t// COMPUTE cout[i - 1] AND res[i*16 - 1] FOR i = 1..8\n"
    start = 15
    for i in range(8):
        if i == 1 or i == 5:
            start += 16
            continue
        block += (
            # f'  // cout[{i}]\n'
            f'\t(* DONT_TOUCH = "yes" *)LUT6_2 #(.INIT(64\'h00000000E8E8E8E8)) ' 
            f'gen_cout_{i} (.I0(CO[{i*4 + 3}][2]), .I1(A[{start}]), .I2(B[{start}]), .I3(0), .I4(0), .I5(1), .O5(cout[{i}]), .O6());\n'
        )
        start += 16
        y += 1
    block += "\n"

    y = Y
    start = 15
    for i in range(8):
        if i == 1 or i == 5:
            start += 16
            continue
        if i % 2 == 0:
            block += (
                # f'  // res[{start}]\n'
                f'\t(* DONT_TOUCH = "yes" *)LUT6_2 #(.INIT(64\'hAAAAAAAAB88B8BB8)) '
                f'gen_res_{start} (.I0(O[{i}]), .I1(word_mode[1]), .I2(CO[{i*4 + 3}][2]), .I3(A[{start}]), .I4(B[{start}]), '
                f'.I5(word_mode[0]), .O5(), .O6(res[{start}]));\n'
            )
        else:
            if i % 4 == 1:
                block += (
                    # f'  // res[{start}]\n'
                    f'\t(* DONT_TOUCH = "yes" *)LUT6_2 #(.INIT(64\'h00000000B88B8BB8)) '
                    f'gen_res_{start} (.I0(O[{i}]), .I1(word_mode[1]), .I2(CO[{i*4 + 3}][2]), .I3(B[{start}]), .I4(A[{start}]), '
                    f'.I5(1), .O5(res[{start}]), .O6());\n'
                )
            else:
                block += (
                    # f'  // res[{start}]\n'
                    f'\t(* DONT_TOUCH = "yes" *)LUT6_2 #(.INIT(64\'hBF8080BF80BFBF80)) '
                    f'gen_res_{start} (.I0(O[{i}]), .I1(word_mode[1]), .I2(word_mode[0]), .I3(CO[{i*4 + 3}][2]), '
                    f'.I4(A[{start}]), .I5(B[{start}]), .O5(), .O6(res[{start}]));\n'
                )
        start += 16
        y += 1
    block += "\n"

    block += (
        '\t(* DONT_TOUCH = "yes" *)LUT6_2 #(.INIT(64\'hFFAAAA00B88B8BB8)) gen_c_1_r_31 (.I0(O[1]), .I1(word_mode[1]), .I2(CO[7][2]), .I3(B[31]), .I4(A[31]), .I5(1), .O5(res[31]), .O6(cout[1]));\n'
	    '\t(* DONT_TOUCH = "yes" *)LUT6_2 #(.INIT(64\'hFFAAAA00B88B8BB8)) gen_c_5_r_95 (.I0(O[5]), .I1(word_mode[1]), .I2(CO[23][2]), .I3(B[95]), .I4(A[95]), .I5(1), .O5(res[95]), .O6(cout[5]));\n\n'
    )

    y = 2
    x = 0
    start = 143
    block += "\t// COMPUTE cout[i - 1] AND res[i*16 - 1] FOR i = 9..16\n"
    # for i in range(8):
    #     block += (
    #         # f'  // cout[{i + 8}]\n'
    #         f'\t(* BEL = "C6LUT", RLOC = "X{x}Y{x}", HU_SET = "R{y}" *)LUT6_2 #(.INIT(64\'h00000000FFB8B800)) ' 
    #         f'gen_cout_{i + 8} (.I0(CO_HI1[{i*4 + 3}][2]), .I1(CO[31][3]), .I2(CO_HI0[{i*4 + 3}][2]), '
    #         f'.I3(B[{start}]), .I4(A[{start}]), .I5(1), .O5(cout[{i + 8}]), .O6());\n'
    #     )
    #     start += 16
    #     y += 4
    # block += "\n"

    y = 2
    start = 143
    for i in range(8):
        if i % 2 == 0:
            block += (
                # f'  // res[{start}]\n'
                f'\t(* BEL = "C6LUT", RLOC = "X{x}Y{x}", HU_SET = "R{y}" *)LUT6_2 #(.INIT(64\'hCFC0DFD5CFC08A80)) '
                f'gen_res_{start} (.I0(word_mode[0]), .I1(O_HI1[{i*4 + 3}][3]), .I2(CO[31][3]), .I3(O_HI0[{i*4 + 3}][3]), '
                f' .I4(word_mode[1]), .I5(res_tmp[{i}]), .O5(), .O6(res[{start}]));\n'
            )
        else:
            if i % 4 == 1:
                block += (
                    # f'  // res[{start}]\n'
                    f'\t(* BEL = "C6LUT", RLOC = "X{x}Y{x}", HU_SET = "R{y}" *)LUT6_2 #(.INIT(64\'h00000000B8FFB800)) '
                    f'gen_res_{start} (.I0(O_HI1[{i*4 + 3}][3]), .I1(CO[31][3]), .I2(O_HI0[{i*4 + 3}][3]), '
                    f' .I3(word_mode[1]), .I4(res_tmp[{i}]), .I5(1), .O5(res[{start}]), .O6());\n'
                )
            else:
                block += (
                    # f'  // res[{start}]\n'
                    f'\t(* BEL = "C6LUT", RLOC = "X{x}Y{x}", HU_SET = "R{y}" *)LUT6_2 #(.INIT(64\'hB8FFFFFFB8000000)) '
                    f'gen_res_{start} (.I0(O_HI1[{i*4 + 3}][3]), .I1(CO[31][3]), .I2(O_HI0[{i*4 + 3}][3]), .I3(word_mode[1]), '
                    f' .I4(word_mode[0]), .I5(res_tmp[{i}]), .O5(), .O6(res[{start}]));\n'
                )
        start += 16
        y += 4
    return block


def main() -> int:
    filename = "hw/ip/otbn/rtl/bn_vec_core/csa_carry4.sv"
    filepath = Path(filename)
    if filepath.exists():
        print_info('INFO: Output file exists. It will be overwritten')
        filepath.unlink()
    else:
        print_info('INFO: Output file doesn\'t exist. It will be created')

    header = (
        # '(* RLOC_ORIGIN = "X0Y0" *)\n'
        "module csa_carry4\n"
        "\timport otbn_pkg::*;\n"
        "(\n"
        "\tinput logic [WLEN-1:0]  A,\n"
        "\tinput logic [WLEN-1:0]  B,\n"
        "\tinput vec_type_e        word_mode,\n"
        "\tinput logic             cin,\n"
        "\toutput logic [WLEN-1:0] res,\n"
        "\toutput logic [15:0]     cout\n"
        ");\n"
    )
    regs = (
        "\tlocalparam QLEN = 128;\n"
        "\t// For bottom 128 bits\n"
        "\tlogic [QLEN-1:0] S;\n"
        "\tlogic [QLEN-1:0] DI;\n"
        "\tlogic [7:0]      O;\n"
        "\tlogic [3:0]      CO [0:31];\n"
        "\t// For top 128 bits when carry in = 0\n"
        "\tlogic [QLEN-1:0] S0;\n"
        "\tlogic [QLEN-1:0] DI0;\n"
        "\tlogic [3:0]      O_HI0  [0:31];\n"
        "\tlogic [3:0]      CO_HI0 [0:31];\n"
        "\t// For top 128 bits when carry in = 1\n"
        "\tlogic [QLEN-1:0] S1;\n"
        "\tlogic [QLEN-1:0] DI1;\n"
        "\tlogic [3:0]      O_HI1  [0:31];\n"
        "\tlogic [3:0]      CO_HI1 [0:31];\n"
        "\t// Temporary logics for res\n"
        "\tlogic [7:0] res_tmp;\n"
        # "  logic       CO[31][3];\n"
        "\n"
    )
    block = header + regs
    block += gen_code()
    block += gen_res(2, 0)
    block += gen_co_res(2, 32)
    block += "endmodule\n"
    with filepath.open("a") as f:
        f.write(block)

    return 0


if __name__ == "__main__":
    sys.exit(main())
