# Copyright Ruben Niederhagen and Hoang Nguyen Hien Pham - authors of
# "Improving ML-KEM & ML-DSA on OpenTitan - Efficient Multiplication Vector Instructions for OTBN"
# (https://eprint.iacr.org/2025/2028)
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

"""All constants needed for cocotb tests are declared here.
"""

from enum import IntEnum

class VecType(IntEnum):
    """ Vector types:
        - H16  : 256-bit integer is seen as vector of 16 16-bit elements.
        - S32  : 256-bit integer is seen as vector of 8 32-bit elements.
        - D64  : 256-bit integer is seen as vector of 4 64-bit elements.
        - V256 : 256-bit integer is seen as vector of 1 256-bit elements.
    """
    H16  = 0b00
    S32  = 0b01
    D64  = 0b10
    V256 = 0b11

class ModeMul(IntEnum):
    """MODE for vector multiplier unified_mul.sv
    """
    MODE_16 = 0b10
    MODE_32 = 0b11
    MODE_64 = 0b00

# Vector element size
WLEN = 256
DLEN = 64
SLEN = 32
HLEN = 16
