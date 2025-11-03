/*  Copyright Ruben Niederhagen and Hoang Nguyen Hien Pham - authors of */
/* "Improving ML-KEM & ML-DSA on OpenTitan - Efficient Multiplication Vector Instructions for OTBN" */
/* (https://eprint.iacr.org/2025/2028) */
/* Licensed under the Apache License, Version 2.0, see LICENSE for details. */
/* SPDX-License-Identifier: Apache-2.0 */

.section .text.start

.globl main
main:
  li      x4, 0
  la      x5, operand1
  bn.lid  x4++, 0(x5)
  bn.lid  x4++, 32(x5)
  bn.lid  x4, 128(x5)
  bn.wsrw 0x0, w2
  li      x4, 16
  bn.lid  x4++, 64(x5)
  bn.lid  x4, 96(x5)

  bn.mulv.16H.even          w2, w0, w1
  bn.mulv.16H.odd           w3, w0, w1
  bn.mulv.16H.lo            w4, w0, w1
  bn.mulv.16H.hi            w5, w0, w1
  bn.mulv.16H.even.acc      w7, w0, w1
  bn.mulv.16H.odd.acc       w8, w0, w1
  bn.mulv.16H.acc.lo        w9, w0, w1
  bn.mulv.16H.acc.hi        w10, w0, w1
  bn.mulv.16H.even.acc.z    w12, w0, w1
  bn.mulv.16H.odd.acc.z     w13, w0, w1
  bn.mulv.16H.acc.z.lo      w14, w0, w1
  bn.mulv.16H.acc.z.hi      w15, w0, w1
  bn.addvm.16H.cond         w6, w16, w17
  bn.subvm.16H.cond         w11, w16, w17

  /* Zeroize the unused WDRs to test with expected results.
   * Otherwise, they will have random values. */
  bn.xor w18, w18, w18
  bn.xor w19, w19, w19
  bn.xor w20, w20, w20
  bn.xor w21, w21, w21
  bn.xor w22, w22, w22
  bn.xor w23, w23, w23
  bn.xor w24, w24, w24
  bn.xor w25, w25, w25
  bn.xor w26, w26, w26
  bn.xor w27, w27, w27
  bn.xor w28, w28, w28
  bn.xor w29, w29, w29
  bn.xor w30, w30, w30
  bn.xor w31, w31, w31

  /* Zeroize the unused GPRs to test with expected results.
   * Otherwise, they will have random values. */
  xor x2, x2, x2
  xor x3, x3, x3
  xor x6, x6, x6
  xor x7, x7, x7
  xor x8, x8, x8
  xor x9, x9, x9
  xor x10, x10, x10
  xor x11, x11, x11
  xor x12, x12, x12
  xor x13, x13, x13
  xor x14, x14, x14
  xor x15, x15, x15
  xor x16, x16, x16
  xor x17, x17, x17
  xor x18, x18, x18
  xor x19, x19, x19
  xor x20, x20, x20
  xor x21, x21, x21
  xor x22, x22, x22
  xor x23, x23, x23
  xor x24, x24, x24
  xor x25, x25, x25
  xor x26, x26, x26
  xor x27, x27, x27
  xor x28, x28, x28
  xor x29, x29, x29
  xor x30, x30, x30
  xor x31, x31, x31

  ecall

.data
.balign 32
.globl operand1
operand1:
  .dword 0x6baa9455d82c07cd
  .dword 0x7a02420482e2e662
  .dword 0x81332876e87a1613
  .dword 0xc17c627948268673

.globl operand2
operand2:
  .dword 0x4f65d4d9e6f4590b
  .dword 0xaf19922abad640fb
  .dword 0x6f25e2a219c78df4
  .dword 0x7a1d5006e9bb17bc

.globl operand3
operand3:
  .dword 0x004a0aba0cdd065a
  .dword 0x005604370c2003b6
  .dword 0x0767055a0ae002e7
  .dword 0x0bfa04810c490398

.globl operand4
operand4:
  .dword 0x108518d109fc0034
  .dword 0x0219156e0ec90812
  .dword 0x1919177615670470
  .dword 0x09e20b95032a13b0

.globl modulus
modulus:
  .dword 0x0000000000000d01
  .dword 0x0000000000000000
  .dword 0x0000000000000000
  .dword 0x0000000000000000
