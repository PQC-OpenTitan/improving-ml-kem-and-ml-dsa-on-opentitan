
from dataclasses import dataclass

from enum import IntEnum

@dataclass
class mac_bignum_operation_t:
    operand_a: int
    operand_b: int
    operand_a_qw_sel: int
    operand_b_qw_sel: int
    wr_hw_sel_upper: int
    pre_acc_shift_imm: int
    zero_acc: int
    shift_acc: int
    data_type: int
    sel: int
    lane_mode: int
    lane_index: int
    exec_mode: int

    def to_Logic(self) -> int:
        value = self.operand_a
        value = (value << 256) | self.operand_b
        value = (value << 2)   | self.operand_a_qw_sel
        value = (value << 2)   | self.operand_b_qw_sel
        value = (value << 1)   | self.wr_hw_sel_upper
        value = (value << 2)   | self.pre_acc_shift_imm
        value = (value << 1)   | self.zero_acc
        value = (value << 1)   | self.shift_acc
        value = (value << 2)   | self.data_type
        value = (value << 1)   | self.sel
        value = (value << 1)   | self.lane_mode
        value = (value << 4)   | self.lane_index
        value = (value << 2)   | self.exec_mode
        return value

@dataclass
class mac_predec_bignum_t:
    op_en: int
    acc_rd_en: int

    def to_Logic(self) -> int:
        return (self.op_en << 1) | self.acc_rd_en


def mask(val, bits=256):
    return val & ((1 << bits) - 1)


def select_quarter_word(val: int, sel: int) -> int:
    """Select 64-bit quarter-word from 256-bit operand"""
    shift = sel * 64
    return (val >> shift) & 0xFFFFFFFFFFFFFFFF


# Parameter constants
WLEN = 256
DLEN = 64
SLEN = 32
HLEN = 16

MODE_64 = 0b00
MODE_16 = 0b10
MODE_32 = 0b11

def reference_prod(A, B, data_type, word_sel_A, word_sel_B, half_sel, lane_mode=0, lane_word_32=0, lane_word_16=0):
    if data_type == MODE_64:
        # 64x64 data_type
        a = (A >> (word_sel_A * DLEN)) & ((1 << DLEN) - 1)
        b = (B >> (word_sel_B * DLEN)) & ((1 << DLEN) - 1)
        expected = a * b

        return expected

    elif data_type == MODE_32:
        # 4x 32x32 data_type
        expected = 0

        lane_index = (word_sel_B << 1) | lane_word_32

        for i in range(4):
            idx = 2 * i + int(half_sel)
            a = (A >> (idx * SLEN)) & ((1 << SLEN) - 1)
            b = (B >> (idx * SLEN)) & ((1 << SLEN) - 1) if lane_mode == 0 else (B >> (lane_index * SLEN)) & ((1 << SLEN) - 1)
            expected |= (a * b) << (i*64)

        return expected

    elif data_type == MODE_16:
        # 16x 16x16 data_type
        expected = 0

        lane_index = (word_sel_B << 2) | (lane_word_32 << 1) | lane_word_16

        for i in range(8):
            idx = 2 * i + int(half_sel)
            a = (A >> (idx * HLEN)) & ((1 << HLEN) - 1)
            b = (B >> (idx * HLEN)) & ((1 << HLEN) - 1) if lane_mode == 0 else (B >> (lane_index * HLEN)) & ((1 << HLEN) - 1)
            expected |= (a * b) << (i*32)
            # if half_sel != None:
            #   expected |= (a * b * (1 if i & 1 == half_sel else 0)) << (i*32)
            # else:
            #   expected |= (a * b) << (i*32)

#            print(expected)

        return expected


def reference_sum(A, B, data_type, cin, wsize=[(8, 32), (16, 16)]):
    if data_type == MODE_64:
        full = (A + B + cin) & ((1 << 256) - 1)
        cout = (A + B + cin) >> 256
        return full, cout
    elif data_type == MODE_32:
        result = 0
        for i in range(wsize[0][0]):
            mask = (1 << wsize[0][1]) - 1
            a = (A >> (wsize[0][1] * i)) & mask
            b = (B >> (wsize[0][1] * i)) & mask
            s = (a + b) & mask
            result |= (s << (wsize[0][1] * i))
        return result, 0
    elif data_type == MODE_16:
        result = 0
        for i in range(wsize[1][0]):
            mask = (1 << wsize[1][1]) - 1
            a = (A >> (wsize[1][1] * i)) & mask
            b = (B >> (wsize[1][1] * i)) & mask
            s = (a + b) & mask
            result |= (s << (wsize[1][1] * i))
#            print(hex(A), hex(a), hex(b), hex(s), hex(result))
        return result, 0
    else:
        raise ValueError("Invalid mode")


def reference_cond_sub(A, B, data_type, cin, wsize=[(8, 32), (16, 16)]):
    if data_type == 0:
        result = 0
        for i in range(wsize[1][0]):
            mask = (1 << wsize[1][1]) - 1
            a = (A >> (wsize[1][1] * i)) & mask
            b = (B >> (wsize[1][1] * i)) & mask
            s = (a - b) & mask if (a - b >= 0) else a
            result |= (s << (wsize[1][1] * i))
        return result, 0
    elif data_type == 1:
        result = 0
        for i in range(wsize[0][0]):
            mask = (1 << wsize[0][1]) - 1
            a = (A >> (wsize[0][1] * i)) & mask
            b = (B >> (wsize[0][1] * i)) & mask
            s = (a - b) & mask if (a - b >= 0) else a
            result |= (s << (wsize[0][1] * i))
        return result, 0
    else:
        raise ValueError("Invalid mode")


class VecType(IntEnum):
  h16  = 0b00
  s32  = 0b01
  d64  = 0b10
  v256 = 0b11

def reference_vector_addition(A, B, addition, data_type, wsize=[(16, 16), (8, 32), (4, 64), (1, 256)]):
    """Reference model for vector addition: A + B and subtraction: A + ~in_B + 1 where B = ~in_B"""
    num_words = wsize[data_type][0]
    word_size = wsize[data_type][1]
    res = [0] * num_words
    for i in range(num_words):
        a = mask(A >> (word_size * i), word_size)
        b = mask(B >> (word_size * i), word_size)
        if addition:
            res[i] = a + b
        else:
            res[i] = a + b + 1

    result = sum(mask(res[i], word_size) << (i * word_size) for i in range(num_words))
    result = mask(result)
    return result


acc = 0

def mac_acc():
  return acc

def mac_model(op: mac_bignum_operation_t, predec: mac_predec_bignum_t) -> int:
    """Python model of the MAC bignum hardware"""

    global acc

    mul_res = reference_prod(op.operand_a, op.operand_b, op.data_type, op.operand_a_qw_sel, op.operand_b_qw_sel, op.sel, op.lane_mode, op.lane_index)

    print(f"mul_res: {hex(mul_res)}")

    mul_res = mul_res << (op.pre_acc_shift_imm * 64)

    if op.zero_acc or not predec.acc_rd_en:
      acc = 0

    res, _ = reference_sum(mul_res, acc, op.data_type, 0, [(8, 64), (16, 32)])

    print(f"res: {hex(res)}")

    if op.shift_acc:
      acc = res >> 128
    else:
      acc = res

    if op.exec_mode == 0:
      if op.data_type == MODE_64:
        res = mask(res)
      elif op.data_type == 1:
        res = (((res >> (  0 + 64*op.sel)) & (0xffffffffffffffff)) <<   0) | \
              (((res >> (128 + 64*op.sel)) & (0xffffffffffffffff)) <<  64) | \
              (((res >> (256 + 64*op.sel)) & (0xffffffffffffffff)) << 128) | \
              (((res >> (384 + 64*op.sel)) & (0xffffffffffffffff)) << 192)
      elif op.data_type == MODE_32:
        res = (((res >> (  0 + 32*op.sel)) & (0xffffffff)) <<   0) | \
              (((res >> ( 64 + 32*op.sel)) & (0xffffffff)) <<  32) | \
              (((res >> (128 + 32*op.sel)) & (0xffffffff)) <<  64) | \
              (((res >> (192 + 32*op.sel)) & (0xffffffff)) <<  96) | \
              (((res >> (256 + 32*op.sel)) & (0xffffffff)) << 128) | \
              (((res >> (320 + 32*op.sel)) & (0xffffffff)) << 160) | \
              (((res >> (384 + 32*op.sel)) & (0xffffffff)) << 192) | \
              (((res >> (448 + 32*op.sel)) & (0xffffffff)) << 224)
    if op.exec_mode == 1:
      if op.data_type == MODE_16:
        res = res          & (0xffffffff <<   0) | \
              op.operand_a & (0xffffffff <<  32) | \
              res          & (0xffffffff <<  64) | \
              op.operand_a & (0xffffffff <<  96) | \
              res          & (0xffffffff << 128) | \
              op.operand_a & (0xffffffff << 160) | \
              res          & (0xffffffff << 192) | \
              op.operand_a & (0xffffffff << 224)

      elif op.data_type == MODE_16:
        res = ((res & (0xffff <<   0)) >>   0) | \
              ((res & (0xffff <<  32)) >>  16) | \
              ((res & (0xffff <<  64)) >>  32) | \
              ((res & (0xffff <<  96)) >>  48) | \
              ((res & (0xffff << 128)) >>  64) | \
              ((res & (0xffff << 160)) >>  80) | \
              ((res & (0xffff << 192)) >>  96) | \
              ((res & (0xffff << 224)) >> 112) | \
              ((res & (0xffff << 256)) >> 128) | \
              ((res & (0xffff << 288)) >> 144) | \
              ((res & (0xffff << 320)) >> 160) | \
              ((res & (0xffff << 352)) >> 176) | \
              ((res & (0xffff << 384)) >> 192) | \
              ((res & (0xffff << 416)) >> 208) | \
              ((res & (0xffff << 448)) >> 224) | \
              ((res & (0xffff << 480)) >> 240)

    elif op.exec_mode == 2:
      if op.data_type == MODE_32:
        res = op.operand_a & (0xffffffff <<   0) | \
              res          & (0xffffffff <<  32) | \
              op.operand_a & (0xffffffff <<  64) | \
              res          & (0xffffffff <<  96) | \
              op.operand_a & (0xffffffff << 128) | \
              res          & (0xffffffff << 160) | \
              op.operand_a & (0xffffffff << 192) | \
              res          & (0xffffffff << 224)

      elif op.data_type == MODE_16:
        res = ((res & (0xffff << (16+  0))) >>  16) | \
              ((res & (0xffff << (16+ 32))) >>  32) | \
              ((res & (0xffff << (16+ 64))) >>  48) | \
              ((res & (0xffff << (16+ 96))) >>  64) | \
              ((res & (0xffff << (16+128))) >>  80) | \
              ((res & (0xffff << (16+160))) >>  96) | \
              ((res & (0xffff << (16+192))) >> 112) | \
              ((res & (0xffff << (16+224))) >> 128) | \
              ((res & (0xffff << (16+256))) >> 144) | \
              ((res & (0xffff << (16+288))) >> 160) | \
              ((res & (0xffff << (16+320))) >> 176) | \
              ((res & (0xffff << (16+352))) >> 192) | \
              ((res & (0xffff << (16+384))) >> 208) | \
              ((res & (0xffff << (16+416))) >> 224) | \
              ((res & (0xffff << (16+448))) >> 240) | \
              ((res & (0xffff << (16+480))) >> 256)


    return res

