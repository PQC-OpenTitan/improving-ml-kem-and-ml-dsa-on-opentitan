# Copyright Ruben Niederhagen and Hoang Nguyen Hien Pham - authors of
# "Improving ML-KEM & ML-DSA on OpenTitan - Efficient Multiplication Vector Instructions for OTBN"
# (https://eprint.iacr.org/2025/2028)
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

from constants import VecType, ModeMul
from constants import WLEN, DLEN, SLEN, HLEN


def mask(a, size=WLEN):
    return a & ((1 << size) - 1)


def reference_prod(a, b, word_mode, word_sel_a, word_sel_b, half_sel,
                   lane_mode=0, lane_word_32=0, lane_word_16=0, data_type_64_shift=0,
                   acch_en=0, exec_mode=0):
    """Reference model for vector multiplier that can support either"
        - 1 64x64-bit multiplication
        - 4 32x32-bit multiplications
        - 8 16x16-bit multiplications if not acch_en
        - 16 16x16-bit multiplications if acch_en
    """
    mode_64 = word_mode == ModeMul.MODE_64
    data_type = word_mode & 1

    if mode_64:
        a_masked = mask(a >> (word_sel_a * DLEN), DLEN)
        b_masked = mask(b >> (word_sel_b * DLEN), DLEN)

        result = a_masked * b_masked
        result <<= (data_type_64_shift * DLEN)
    else:
        size = SLEN if data_type else HLEN
        num_lanes = WLEN // size
        lane_index = (word_sel_b << 1) | lane_word_32
        if data_type == 0:
            lane_index = (lane_index << 1) | lane_word_16

        vec_a = [mask(a >> (i * size), size) for i in range(num_lanes)]
        if lane_mode:
            vec_b = [mask(b >> (lane_index * size), size) for i in range(num_lanes)]
        else:
            vec_b = [mask(b >> (i * size), size) for i in range(num_lanes)]
        vec_res = [0] * num_lanes

        lane_indices = range(half_sel, num_lanes, 2)
        if acch_en:
            if (data_type == 0) and (exec_mode != 0):
                lane_indices = range(num_lanes)

        for i in lane_indices:
            prodi = vec_a[i] * vec_b[i]
            if acch_en:
                vec_res[i] = prodi
            else:
                lo = mask(prodi, size)
                hi = mask((prodi >> size), size)
                vec_res[i - 1 if half_sel else i    ] = lo
                vec_res[i     if half_sel else i + 1] = hi
        if acch_en:
            size *= 2
        result = sum(mask(vec_res[i], size) << (i * size) for i in range(num_lanes))

    return result


def reference_non_vector_adder(a, b, cin):
    """Reference model for 256-bit non-vector adder:
        - Addition: a + b
        - Subtraction: a + b + 1 where b is already negated before entering this function.
    """
    full_result = a + b + cin
    result = mask(full_result, WLEN)
    cout = full_result >> WLEN
    return result, cout


def reference_vector_adder(a, b, addition, word_mode):
    """Reference model for vector adder:
        - Addition: a + b
        - Subtraction: a + b + 1 where b is already negated before entering this function.
    """
    if word_mode == VecType.H16:
        size = HLEN
    elif word_mode == VecType.S32:
        size = SLEN
    elif word_mode == VecType.D64:
        size = DLEN
    else: # word_mode == VecType.V256
        size = WLEN
    num_words = WLEN // size

    res = [0] * num_words
    for i in range(num_words):
        a_masked = mask(a >> (size * i), size)
        b_masked = mask(b >> (size * i), size)
        if addition:
            res[i] = a_masked + b_masked
        else:
            res[i] = a_masked + b_masked + 1

    result = sum(mask(res[i], size) << (i * size) for i in range(num_words))
    result = mask(result)

    cout = sum((res[i] >> size) << i for i in range(num_words))

    return cout, result
