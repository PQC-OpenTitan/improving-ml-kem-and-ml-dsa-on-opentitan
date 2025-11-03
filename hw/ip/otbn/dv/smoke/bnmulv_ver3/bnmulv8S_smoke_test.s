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
  li      x4, 24
  bn.lid  x4++, 64(x5)
  bn.lid  x4, 96(x5)

  bn.mulv.8S.even          w2, w0, w1
  bn.mulv.8S.odd           w3, w0, w1
  bn.mulv.8S.even.lo       w4, w0, w1
  bn.mulv.8S.odd.lo        w5, w0, w1
  bn.mulv.8S.even.hi       w6, w0, w1
  bn.mulv.8S.odd.hi        w7, w0, w1
  bn.mulv.8S.even.acc      w10, w0, w1
  bn.mulv.8S.odd.acc       w11, w0, w1
  bn.mulv.8S.even.acc.lo   w12, w0, w1
  bn.mulv.8S.odd.acc.lo    w13, w0, w1
  bn.mulv.8S.even.acc.hi   w14, w0, w1
  bn.mulv.8S.odd.acc.hi    w15, w0, w1
  bn.mulv.8S.even.acc.z    w18, w0, w1
  bn.mulv.8S.odd.acc.z     w19, w0, w1
  bn.mulv.8S.even.acc.z.lo w20, w0, w1
  bn.mulv.8S.odd.acc.z.lo  w21, w0, w1
  bn.mulv.8S.even.acc.z.hi w22, w0, w1
  bn.mulv.8S.odd.acc.z.hi  w23, w0, w1
  bn.addvm.8S.cond         w8, w24, w25
  bn.subvm.8S.cond         w9, w24, w25

  /* Zeroize the unused WDRs to test with expected results.
   * Otherwise, they will have random values. */
  bn.xor w16, w16, w16
  bn.xor w17, w17, w17
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
  .dword 0x002cd0060044c77b
  .dword 0x00406fbb00461534
  .dword 0x0002399a0008f282
  .dword 0x0059877b0058649e

.globl operand4
operand4:
  .dword 0x00eccbf500a2b36c
  .dword 0x006f6e97006a1304
  .dword 0x002d9100005d6326
  .dword 0x00f6befb00ac4d5c

.globl modulus
modulus:
  .dword 0x00000000007fe001
  .dword 0x0000000000000000
  .dword 0x0000000000000000
  .dword 0x0000000000000000
