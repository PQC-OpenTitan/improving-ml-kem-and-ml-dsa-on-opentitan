.section .text.start

.globl main
main:
  li     x4, 0
  li     x5, 16
  la     x6, operand1
  bn.lid x4, 0(x6)
  bn.lid x5, 32(x6)

  bn.mulv.l.8S.even          w2, w0, sw0.5
  bn.mulv.l.8S.odd           w3, w0, sw0.5
  bn.mulv.l.8S.even.lo       w4, w0, sw0.5
  bn.mulv.l.8S.odd.lo        w5, w0, sw0.5
  bn.mulv.l.8S.even.hi       w6, w0, sw0.5
  bn.mulv.l.8S.odd.hi        w7, w0, sw0.5
  bn.mulv.l.8S.even.acc      w10, w0, sw0.5
  bn.mulv.l.8S.odd.acc       w11, w0, sw0.5
  bn.mulv.l.8S.even.acc.lo   w12, w0, sw0.5
  bn.mulv.l.8S.odd.acc.lo    w13, w0, sw0.5
  bn.mulv.l.8S.even.acc.hi   w14, w0, sw0.5
  bn.mulv.l.8S.odd.acc.hi    w15, w0, sw0.5
  bn.mulv.l.8S.even.acc.z    w18, w0, sw0.5
  bn.mulv.l.8S.odd.acc.z     w19, w0, sw0.5
  bn.mulv.l.8S.even.acc.z.lo w20, w0, sw0.5
  bn.mulv.l.8S.odd.acc.z.lo  w21, w0, sw0.5
  bn.mulv.l.8S.even.acc.z.hi w22, w0, sw0.5
  bn.mulv.l.8S.odd.acc.z.hi  w23, w0, sw0.5

  /* Zeroize the unused WDRs to test with expected results.
   * Otherwise, they will have random values. */
  bn.xor w8, w8, w8
  bn.xor w9, w9, w9
  bn.xor w1, w1, w1
  bn.xor w17, w17, w17
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
