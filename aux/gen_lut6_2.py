#!/usr/bin/env python3
# Copyright Ruben Niederhagen and Hoang Nguyen Hien Pham - authors of
# "Improving ML-KEM & ML-DSA on OpenTitan - Efficient Multiplication Vector Instructions for OTBN"
# (https://eprint.iacr.org/2025/2028)
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import sys

def create_lut_res(verbose=False):
    init_list = []
    i5 = [0] * 32 + [1] * 32
    i4 = ([0] * 16 + [1] * 16) * 2
    i3 = ([0] * 8 + [1] * 8) * 4
    i2 = ([0] * 4 + [1] * 4) * 8
    i1 = ([0] * 2 + [1] * 2) * 16
    i0 = ([0] * 1 + [1] * 1) * 32
    i6 = [0] * 64
    i7 = [0] * 64

    init = ""
    for i in range(64):
        if i < 32:
            if i1[i] == 0:
                i6[i] = i2[i] # if co[31][3] == 0 then res = o_hi0
            else:
                i6[i] = i0[i] # if co[31][3] == 0 then res = o_hi1
            i7[i] = 0
        else:
            if i1[i] == 0:
                i6[i] = i4[i] # if co[31][3] == 0 then res = o_hi0
            else:
                i6[i] = i3[i] # if co[31][3] == 0 then res = o_hi1
            i7[i] = 0

        if verbose:
            row = (
                f"{i0[i]} | {i1[i]} | {i2[i]} | {i3[i]} | {i4[i]} | "
                f"{i5[i]} | {i6[i]} | {i7[i]}\n"
            )
            print(row)

        init += str(i6[i])

    return init[::-1]


def create_lut_sdi(verbose=False, bit=0):
    init_list = []
    i5 = [0] * 32 + [1] * 32
    i4 = ([0] * 16 + [1] * 16) * 2
    i3 = ([0] * 8 + [1] * 8) * 4
    i2 = ([0] * 4 + [1] * 4) * 8
    i1 = ([0] * 2 + [1] * 2) * 16
    i0 = ([0] * 1 + [1]* 1) * 32
    i6 = [0] * 64
    i7 = [0] * 64

    init = ""
    if bit == 0:
        for i in range(64):
            if i >= 32:
                i6[i] = i0[i] ^ i1[i]
            else:
                i6[i] = i0[i] & i1[i]

            if verbose:
                row = (
                    f"{i0[i]} | {i1[i]} | {i2[i]} | {i3[i]} | {i4[i]} | "
                    f"{i5[i]} | {i6[i]} | {i7[i]}\n"
                )
                print(row)

            init += str(i6[i])
    elif bit == 16:
        # I0 = A, I1 = B, I2 = word_mode0, I3 = word_mode1, I4 = cin, I5 = 1, O5 = S, O6 = D
        for i in range(64):
            if i >= 32:
                if i3[i] == 0 and i2[i] == 0: # VecType_h16 == 00
                    i6[i] = 0
                else:
                    i6[i] = i0[i] ^ i1[i]
            else:
                if i3[i] == 0 and i2[i] == 0: # VecType_h16 == 00
                    i6[i] = i4[i]
                else:
                    i6[i] = i0[i] & i1[i]

            init += str(i6[i])
    elif bit == 32:
        # I0 = A, I1 = B, I2 = word_mode1, I3 = cin, O5 = S, O6 = D
        for i in range(64):
            if i >= 32:
                if i2[i] == 1:
                    i6[i] = i0[i] ^ i1[i]
                else:
                    i6[i] = 0
            else:
                if i2[i] == 1:
                    i6[i] = i0[i] & i1[i]
                else:
                    i6[i] = i3[i]

            init += str(i6[i])
    elif bit == 64:
        # I0 = A, I1 = B, I2 = word_mode0, I3 = word_mode1, I4 = cin, O5 = S, O6 = D
        for i in range(64):
            if i >= 32:
                if i3[i] == 1 and i2[i] == 1: # VecType_v256
                    i6[i] = i0[i] ^ i1[i]
                else:
                    i6[i] = 0
            else:
                if i3[i] == 1 and i2[i] == 1:
                    i6[i] = i0[i] & i1[i]
                else:
                    i6[i] = i4[i]

            init += str(i6[i])
    else:
        print("This mode is not supported.")
        return 0

    return init[::-1]


def create_cout(verbose=False):
    init_list = []
    i5 = [0] * 32 + [1] * 32
    i4 = ([0] * 16 + [1] * 16) * 2
    i3 = ([0] * 8 + [1] * 8) * 4
    i2 = ([0] * 4 + [1] * 4) * 8
    i1 = ([0] * 2 + [1] * 2) * 16
    i0 = ([0] * 1 + [1]* 1) * 32
    i6 = [0] * 64
    i7 = [0] * 64

    init = ""
    for i in range(64):
        # I0 = O, I1 = word_mode1, I2 = CO, I3 = B, I4 = A, I5 = 1, O5 = res, O6 = cout
        di = i3[i] & i4[i]
        s = i3[i] ^ i4[i]
        sfix = s ^ i2[i]
        if i >= 32:
            i6[i] = (s & i0[i]) | di
        else:
            i6[i] = i0[i] if i1[i] else sfix

        init += str(i6[i])
    return init[::-1]


def main():
    init = create_lut_res(False)
    print(init)
    init_hex = hex(int(init, 2))
    print(init_hex.upper())

    init = create_lut_sdi(False)
    print(init)
    init_hex = hex(int(init, 2))
    print(init_hex.upper())

    init = create_lut_sdi(False, 16)
    print(init)
    init_hex = hex(int(init, 2))
    print(init_hex.upper())

    init = create_lut_sdi(False, 32)
    print(init)
    init_hex = hex(int(init, 2))
    print(init_hex.upper())

    init = create_lut_sdi(False, 64)
    print(init)
    init_hex = hex(int(init, 2))
    print(init_hex.upper())

    init = create_cout(False)
    print(init)
    init_hex = hex(int(init, 2))
    print(init_hex.upper())


if __name__ == "__main__":
    sys.exit(main())
        