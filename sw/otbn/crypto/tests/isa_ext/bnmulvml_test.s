/* Copyright "Towards ML-KEM & ML-DSA on OpenTitan" Authors */
/* Licensed under the Apache License, Version 2.0, see LICENSE for details. */
/* SPDX-License-Identifier: Apache-2.0 */


/* 256-bit lane-wise vector multiplication with reduction example. */

.section .text.start

li x2, 0
li x3, 1
li x4, 2
la x5, operand1
la x6, result

/******************************/
/*   Tests for bn.mulvm.l.8S    */
/******************************/

/* Load mod WSR with base li pseudo-instruction*/
li    x23, 0x7fe001
csrrw x0, 0x7d0, x23
li    x23, 0xFC7FDFFF
csrrw x0, 0x7d1, x23

bn.lid x2, 0(x5++)
bn.lid x3, 0(x5++)

/* Perform vector addition and subtraction, limbs are 32-bit. */
bn.mulvm.l.8S w2, w0, w1, 0
bn.mulvm.l.8S w3, w0, w1, 1
bn.mulvm.l.8S w4, w0, w1, 2
bn.mulvm.l.8S w5, w0, w1, 3
bn.mulvm.l.8S w6, w0, w1, 4
bn.mulvm.l.8S w7, w0, w1, 5
bn.mulvm.l.8S w8, w0, w1, 6
bn.mulvm.l.8S w9, w0, w1, 7

/* store result from [w2, w3] to dmem */
bn.sid x4++,   0(x6)
bn.sid x4++,  32(x6)
bn.sid x4++,  64(x6)
bn.sid x4++,  96(x6)
bn.sid x4++, 128(x6)
bn.sid x4++, 160(x6)
bn.sid x4++, 192(x6)
bn.sid x4++, 224(x6)

/******************************/
/*   Tests for bn.mulvm.l.16H   */
/******************************/

/* Load mod WSR with base li pseudo-instruction*/
li    x23, 0x00000D01
csrrw x0, 0x7d0, x23
li    x23, 0xCFF
csrrw x0, 0x7d1, x23

bn.lid x2, 0(x5++)
bn.lid x3, 0(x5++)

/* Perform vector addition and subtraction, limbs are 32-bit. */
bn.mulvm.l.16H w2, w0, w1, 0
bn.mulvm.l.16H w3, w0, w1, 1
bn.mulvm.l.16H w4, w0, w1, 2
bn.mulvm.l.16H w5, w0, w1, 3
bn.mulvm.l.16H w6, w0, w1, 4
bn.mulvm.l.16H w7, w0, w1, 5
bn.mulvm.l.16H w8, w0, w1, 6
bn.mulvm.l.16H w9, w0, w1, 7
bn.mulvm.l.16H w10, w0, w1, 8
bn.mulvm.l.16H w11, w0, w1, 9
bn.mulvm.l.16H w12, w0, w1, 10
bn.mulvm.l.16H w13, w0, w1, 11
bn.mulvm.l.16H w14, w0, w1, 12
bn.mulvm.l.16H w15, w0, w1, 13
bn.mulvm.l.16H w16, w0, w1, 14
bn.mulvm.l.16H w17, w0, w1, 15

/* store result from [w2, w3] to dmem */
li x4, 2
bn.sid x4++, 256(x6)
bn.sid x4++, 288(x6)
bn.sid x4++, 320(x6)
bn.sid x4++, 352(x6)
bn.sid x4++, 384(x6)
bn.sid x4++, 416(x6)
bn.sid x4++, 448(x6)
bn.sid x4++, 480(x6)
bn.sid x4++, 512(x6)
bn.sid x4++, 544(x6)
bn.sid x4++, 576(x6)
bn.sid x4++, 608(x6)
bn.sid x4++, 640(x6)
bn.sid x4++, 672(x6)
bn.sid x4++, 704(x6)
bn.sid x4++, 736(x6)

ecall

.data
.globl operand1
operand1:
  .quad 0x00023412006d0400
  .quad 0x0000021400368200
  .quad 0x0004321600523125
  .quad 0x0000000800003417

.globl operand2
operand2:
  .quad 0x006fe22100581103
  .quad 0x005aaaaa00591103
  .quad 0x000feabc00801143
  .quad 0x00203a08007fe000

.globl operand3
operand3:
  .quad 0x0004000300020d00
  .quad 0x0008000700060005
  .quad 0x00cc000b000a0009
  .quad 0x0b60000f005e0023

.globl operand4
operand4:
  .quad 0x0D000D000D000b00
  .quad 0x0D000D000D000023
  .quad 0x0D000D000D0000ff
  .quad 0x0D000D000BA00D00

.globl result
result:
  .zero 32*24
