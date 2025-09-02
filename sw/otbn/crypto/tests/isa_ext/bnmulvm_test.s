/* Copyright "Towards ML-KEM & ML-DSA on OpenTitan" Authors */
/* Licensed under the Apache License, Version 2.0, see LICENSE for details. */
/* SPDX-License-Identifier: Apache-2.0 */


/* 256-bit vector multiplication with reduction example. */

.section .text.start

li x2, 0
li x3, 1
li x4, 2
la x5, operand1
la x6, result

/******************************/
/*   Tests for bn.mulvm.8S    */
/******************************/

/* Load mod WSR with base li pseudo-instruction*/
li    x23, 0x7fe001
csrrw x0, 0x7d0, x23
li    x23, 0xFC7FDFFF
csrrw x0, 0x7d1, x23

bn.lid x2, 0(x5++)
bn.lid x3, 0(x5++)

/* Perform vectorized modular multiplication, limbs are 32-bit. */
bn.mulvm.8S w2, w0, w1

/* store result from [w2] to dmem */
bn.sid x4, 0(x6++)

/******************************/
/*   Tests for bn.mulvm.16H   */
/******************************/

/* Load mod WSR with base li pseudo-instruction*/
li    x23, 0x00000D01
csrrw x0, 0x7d0, x23
li    x23, 0xCFF
csrrw x0, 0x7d1, x23

bn.lid x2, 0(x5++)
bn.lid x3, 0(x5++)

/* Performvectorized modular multiplication, limbs are 16-bit. */
bn.mulvm.16H w2, w0, w1

/* store result from [w2, w3] to dmem */
bn.sid x4, 0(x6++)

ecall

.data
.globl operand1
operand1:
  .quad 0x0000000200000121
  .quad 0x0000000400023453
  .quad 0x0000000600002305
  .quad 0x007fa23400020007

.globl operand2
operand2:
  .quad 0x00000002007fa234
  .quad 0x0000000400000003
  .quad 0x0000000600000005
  .quad 0x0030a23400000007

.globl operand3
operand3:
  .quad 0x0004000300020001
  .quad 0x0008000700060005
  .quad 0x000c000b000a0009
  .quad 0x0010000f000e000d

.globl operand4
operand4:
  .quad 0x0004000300020001
  .quad 0x0008000700060005
  .quad 0x000c000b000a0009
  .quad 0x0010000f000e000d

.globl result
result:
  .zero 32*2
