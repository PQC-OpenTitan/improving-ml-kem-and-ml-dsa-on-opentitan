/* Copyright "Towards ML-KEM & ML-DSA on OpenTitan" Authors */
/* Licensed under the Apache License, Version 2.0, see LICENSE for details. */
/* SPDX-License-Identifier: Apache-2.0 */
/* Modified by Ruben Niederhagen and Hoang Nguyen Hien Pham - authors of */
/* "Improving ML-KEM & ML-DSA on OpenTitan - Efficient Multiplication Vector Instructions for OTBN" */
/* (https://eprint.iacr.org/2025/2028) */
/* Copyright Ruben Niederhagen and Hoang Nguyen Hien Pham. */


/*
 * Testwrapper for mlkem_keypair
*/

.section .text.start

#define STACK_SIZE 20000
#define CRYPTO_BYTES 32

#if KYBER_K == 2
  #define CRYPTO_PUBLICKEYBYTES  800
  #define CRYPTO_SECRETKEYBYTES  1632
  #define CRYPTO_CIPHERTEXTBYTES 768
#elif KYBER_K == 3 
  #define CRYPTO_PUBLICKEYBYTES  1184
  #define CRYPTO_SECRETKEYBYTES  2400
  #define CRYPTO_CIPHERTEXTBYTES 1088
#elif KYBER_K == 4
  #define CRYPTO_PUBLICKEYBYTES  1568
  #define CRYPTO_SECRETKEYBYTES  3168
  #define CRYPTO_CIPHERTEXTBYTES 1568
#endif

/* Entry point. */
.globl main
main:
  /* Init all-zero register. */
#ifdef RTL_ISS_TEST
  bn.xor  w0, w0, w0
  bn.xor  w1, w1, w1
  bn.xor  w2, w2, w2
  bn.xor  w3, w3, w3
  bn.xor  w4, w4, w4
  bn.xor  w5, w5, w5
  bn.xor  w6, w6, w6
  bn.xor  w7, w7, w7
  bn.xor  w8, w8, w8
  bn.xor  w9, w9, w9
  bn.xor  w10, w10, w10
  bn.xor  w11, w11, w11
  bn.xor  w12, w12, w12
  bn.xor  w13, w13, w13
  bn.xor  w14, w14, w14
  bn.xor  w15, w15, w15
  bn.xor  w16, w16, w16
  bn.xor  w17, w17, w17
  bn.xor  w18, w18, w18
  bn.xor  w19, w19, w19
  bn.xor  w20, w20, w20
  bn.xor  w21, w21, w21
  bn.xor  w22, w22, w22
  bn.xor  w23, w23, w23
  bn.xor  w24, w24, w24
  bn.xor  w25, w25, w25
  bn.xor  w26, w26, w26
  bn.xor  w27, w27, w27
  bn.xor  w28, w28, w28
  bn.xor  w29, w29, w29
  bn.xor  w30, w30, w30
#endif
  bn.xor  w31, w31, w31

  /* MOD <= dmem[modulus] = KYBER_Q */
  li      x5, 2
  la      x6, modulus
  bn.lid  x5, 0(x6)
  bn.wsrw 0x0, w2

  /* Load stack pointer */
  la   x2, stack_end
  la   x10, coins
  la   x11, ek
  la   x12, dk
  jal  x1, crypto_kem_keypair

  ecall

.data
.balign 32
.global stack
stack:
  .zero STACK_SIZE
stack_end:
.globl dk
dk:
  .zero CRYPTO_SECRETKEYBYTES
.globl ek
ek:
  .zero CRYPTO_PUBLICKEYBYTES

.balign 32
/* First input: coins */
.globl coins
coins:
  .word 0xa42b9c7f
  .word 0x7d828fe8
  .word 0x50456061
  .word 0x3e850576
  .word 0x93803bd7
  .word 0x88bceff6
  .word 0xac6e1aeb
  .word 0x26ef66fa
  .word 0xa9eeb13c
  .word 0x934b0088
  .word 0x0afb3c10
  .word 0x682afdee
  .word 0x4afa016e
  .word 0x63a3e858
  .word 0xe3a1a89c
  .word 0xe257aef9

/* Modulus: KYBER_Q = 3329 */
.globl modulus
modulus:
  .word 0x00000d01
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000

/* 1/Q mod 2^32 */
.globl qinv
qinv:
  .word 0x6ba8f301
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000

.globl modulus_bn
modulus_bn:
  .word 0x0d010d01
  .word 0x0d010d01
  .word 0x0d010d01
  .word 0x0d010d01
  .word 0x0d010d01
  .word 0x0d010d01
  .word 0x0d010d01
  .word 0x0d010d01

.globl modulus_over_2
modulus_over_2:
  .word 0x06810681
  .word 0x06810681
  .word 0x06810681
  .word 0x06810681
  .word 0x06810681
  .word 0x06810681
  .word 0x06810681
  .word 0x06810681

.globl const_0x0fff
const_0x0fff:
  .word 0x0fff0fff
  .word 0x0fff0fff
  .word 0x0fff0fff
  .word 0x0fff0fff
  .word 0x0fff0fff
  .word 0x0fff0fff
  .word 0x0fff0fff
  .word 0x0fff0fff

.globl const_1290167
const_1290167:
  .word 0x0013afb7
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000

.globl const_8
const_8:
  .word 0x00080008
  .word 0x00080008
  .word 0x00080008
  .word 0x00080008
  .word 0x00080008
  .word 0x00080008
  .word 0x00080008
  .word 0x00080008

.globl const_toplant
const_toplant:
  .word 0x97f44fab
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000
  .word 0x00000000

.globl cbd2_const
cbd2_const:
  /* const1 */
  .word 0x55555555
  .word 0x55555555
  .word 0x55555555
  .word 0x55555555
  .word 0x55555555
  .word 0x55555555
  .word 0x55555555
  .word 0x55555555
  /* const2 */ 
  .word 0x33333333
  .word 0x33333333
  .word 0x33333333
  .word 0x33333333
  .word 0x33333333
  .word 0x33333333
  .word 0x33333333
  .word 0x33333333

.globl cbd3_const
cbd3_const:
  /* const1 */
  .word 0x49249249
  .word 0x92492492
  .word 0x24924924
  .word 0x49249249
  .word 0x92492492
  .word 0x24924924
  .word 0x49249249
  .word 0x12492492
  /* const2 */
  .word 0xc71c71c7
  .word 0x71c71c71
  .word 0x1c71c71c
  .word 0xc71c71c7
  .word 0x71c71c71
  .word 0x1c71c71c
  .word 0xc71c71c7
  .word 0x71c71c71

.globl twiddles_ntt
twiddles_ntt:
  /* Layer 1--4 */ 
  .word 0x84f5c5b6, 0x00000000
  .word 0xc666e465, 0x00000000
  .word 0xfcec8b58, 0x00000000
  .word 0xcb2b72d0, 0x00000000
  .word 0x30726d5b, 0x00000000
  .word 0x91e11612, 0x00000000
  .word 0x41360f89, 0x00000000
  .word 0x51aaf2da, 0x00000000
  .word 0x93922fd5, 0x00000000
  .word 0x0ed77946, 0x00000000
  .word 0x3d4a0dff, 0x00000000
  .word 0xd63e49fb, 0x00000000
  .word 0xfab1a391, 0x00000000
  .word 0x2bc18ea7, 0x00000000
  .word 0x864470e4, 0x00000000
  /* Padding */
  .word 0x00000000, 0x00000000
  /* Layer 5 - 1 */
  .word 0x16c32c11, 0x00000000
  /* Layer 6 - 1 */
  .word 0x16395e0d, 0x00000000
  .word 0x19743224, 0x00000000
  .word 0x00000000, 0x00000000
  /* Layer 7 - 1 */
  .word 0x014eab2e, 0x00000000
  .word 0xd4522112, 0x00000000
  .word 0x2cd52aae, 0x00000000
  .word 0xcbb540d4, 0x00000000
  /* Layer 5 - 2 */
  .word 0xbc2c9a1c, 0x00000000
  /* Layer 6 - 2 */
  .word 0xfa27d58e, 0x00000000
  .word 0x87094e0e, 0x00000000
  .word 0x00000000, 0x00000000
  /* Layer 7 - 2 */
  .word 0x7de29fcd, 0x00000000
  .word 0x379942fb, 0x00000000
  .word 0xaff27732, 0x00000000
  .word 0x54970814, 0x00000000
  /* Layer 5 - 3 */
  .word 0x66f8144e, 0x00000000
  /* Layer 6 - 3 */
  .word 0x5c0c9c92, 0x00000000
  .word 0xb12d72a9, 0x00000000
  .word 0x00000000, 0x00000000
  /* Layer 7 - 3 */
  .word 0x6c5a2074, 0x00000000
  .word 0xccb52d24, 0x00000000
  .word 0xfc4f0d9d, 0x00000000
  .word 0x11eaedee, 0x00000000
  /* Layer 5 - 4 */
  .word 0x71811d74, 0x00000000
  /* Layer 6 - 4 */
  .word 0xaf19ea51, 0x00000000
  .word 0x9e078945, 0x00000000
  .word 0x00000000, 0x00000000
  /* Layer 7 - 4 */
  .word 0x3a22e9a0, 0x00000000
  .word 0xa5cbdca1, 0x00000000
  .word 0xe7da790b, 0x00000000
  .word 0xea8b7f1e, 0x00000000
  /* Layer 5 - 5 */
  .word 0xea3cc040, 0x00000000
  /* Layer 6 - 5 */
  .word 0x31fc27af, 0x00000000
  .word 0x9807ff63, 0x00000000
  .word 0x00000000, 0x00000000
  /* Layer 7 - 5 */
  .word 0x82f5ed16, 0x00000000
  .word 0x7ef63bd5, 0x00000000
  .word 0xd6795921, 0x00000000
  .word 0x8992f4b3, 0x00000000
  /* Layer 5 - 6 */
  .word 0x044e701f, 0x00000000
  /* Layer 6 - 6 */
  .word 0xc13fe765, 0x00000000
  .word 0x3099ccc9, 0x00000000
  .word 0x00000000, 0x00000000
  /* Layer 7 - 6 */
  .word 0x8e08c440, 0x00000000
  .word 0x4935720b, 0x00000000
  .word 0x7059d1b5, 0x00000000
  .word 0xcea1560e, 0x00000000
  /* Layer 5 - 7 */
  .word 0xac4184cf, 0x00000000
  /* Layer 6 - 7 */
  .word 0xdc518394, 0x00000000
  .word 0x0289a6a5, 0x00000000
  .word 0x00000000, 0x00000000
  /* Layer 7 - 7 */
  .word 0x483585bb, 0x00000000
  .word 0xb17c3187, 0x00000000
  .word 0xbb67bcf2, 0x00000000
  .word 0xb7a31ad7, 0x00000000
  /* Layer 5 - 8 */
  .word 0x6681f601, 0x00000000
  /* Layer 6 - 8 */
  .word 0x658209b1, 0x00000000
  .word 0x934370f8, 0x00000000
  .word 0x00000000, 0x00000000
  /* Layer 7 - 8 */
  .word 0x385e2025, 0x00000000
  .word 0xb3b7194d, 0x00000000
  .word 0x149bf401, 0x00000000
  .word 0x314afa3c, 0x00000000
  /* Layer 5 - 9 */
  .word 0x6da8cba2, 0x00000000
  /* Layer 6 - 9 */
  .word 0xb254be68, 0x00000000
  .word 0x6e59f915, 0x00000000
  .word 0x00000000, 0x00000000
  /* Layer 7 - 9 */
  .word 0x79cf3ed4, 0x00000000
  .word 0xb0b7545c, 0x00000000
  .word 0x9ca52e5f, 0x00000000
  .word 0xf79e2ee9, 0x00000000
  /* Layer 5 - 10 */
  .word 0xa1074e36, 0x00000000
  /* Layer 6 - 10 */
  .word 0x3e0eeb29, 0x00000000
  .word 0x22c23fd4, 0x00000000
  .word 0x00000000, 0x00000000
  /* Layer 7 - 10 */
  .word 0x1cd665aa, 0x00000000
  .word 0xc4049d2f, 0x00000000
  .word 0xa0b88f58, 0x00000000
  .word 0x7e801d88, 0x00000000
  /* Layer 5 - 11 */
  .word 0x2924384b, 0x00000000
  /* Layer 6 - 11 */
  .word 0x6e95083b, 0x00000000
  .word 0xdc8c92ba, 0x00000000
  .word 0x00000000, 0x00000000
  /* Layer 7 - 11 */
  .word 0x51bea292, 0x00000000
  .word 0x1887f58b, 0x00000000
  .word 0xd53e5dab, 0x00000000
  .word 0x3a369957, 0x00000000
  /* Layer 5 - 12 */
  .word 0xdda02ec2, 0x00000000
  /* Layer 6 - 12 */
  .word 0x75f6ed02, 0x00000000
  .word 0xb8b6b6df, 0x00000000
  .word 0x00000000, 0x00000000
  /* Layer 7 - 12 */
  .word 0xa169bccb, 0x00000000
  .word 0x2b2410ec, 0x00000000
  .word 0xbda2a4b9, 0x00000000
  .word 0xc77a806d, 0x00000000
  /* Layer 5 - 13 */
  .word 0xb805896c, 0x00000000
  /* Layer 6 - 13 */
  .word 0xcb8de165, 0x00000000
  .word 0xc93f49e7, 0x00000000
  .word 0x00000000, 0x00000000
  /* Layer 7 - 13 */
  .word 0xd7a0a4e0, 0x00000000
  .word 0x53f98a58, 0x00000000
  .word 0x1efd9db9, 0x00000000
  .word 0x4ee63d0f, 0x00000000
  /* Layer 5 - 14 */
  .word 0xdd651f9c, 0x00000000
  /* Layer 6 - 14 */
  .word 0x71e38c09, 0x00000000
  .word 0x31d4c840, 0x00000000
  .word 0x00000000, 0x00000000
  /* Layer 7 - 14 */
  .word 0x57e58be2, 0x00000000
  .word 0xa555be54, 0x00000000
  .word 0xd565bd19, 0x00000000
  .word 0x442224c3, 0x00000000
  /* Layer 5 - 15 */
  .word 0x97ccf03d, 0x00000000
  /* Layer 6 - 15 */
  .word 0xbe402274, 0x00000000
  .word 0xef28ae1a, 0x00000000
  .word 0x00000000, 0x00000000
  /* Layer 7 - 15 */
  .word 0x846bf7b2, 0x00000000
  .word 0x5d33e851, 0x00000000
  .word 0x901c4c98, 0x00000000
  .word 0x4f214c36, 0x00000000
  /* Layer 5 - 16 */
  .word 0x3f228731, 0x00000000
  /* Layer 6 - 16 */
  .word 0x5e5b3410, 0x00000000
  .word 0x45fa9df4, 0x00000000
  .word 0x00000000, 0x00000000
  /* Layer 7 - 16 */
  .word 0xa24249ac, 0x00000000
  .word 0xe1b38fba, 0x00000000
  .word 0x440e750b, 0x00000000
  .word 0xa5a47d32, 0x00000000

.globl twiddles_intt
twiddles_intt:
  /* Layer 7 - 1 */
  .word 0x5a5b82cf, 0x00000000
  .word 0xbbf18af6, 0x00000000
  .word 0x1e4c7047, 0x00000000
  .word 0x5dbdb655, 0x00000000
  /* Layer 6 - 1 */
  .word 0xba05620d, 0x00000000
  .word 0xa1a4cbf1, 0x00000000
  /* Layer 5 - 1 */
  .word 0xc0dd78d0, 0x00000000
  .word 0x00000000, 0x00000000
  /* Layer 7 - 2 */
  .word 0xb0deb3cb, 0x00000000
  .word 0x6fe3b369, 0x00000000
  .word 0xa2cc17b0, 0x00000000
  .word 0x7b94084f, 0x00000000
  /* Layer 6 - 2 */
  .word 0x10d751e7, 0x00000000
  .word 0x41bfdd8d, 0x00000000
  /* Layer 5 - 2 */
  .word 0x68330fc4, 0x00000000
  .word 0x00000000, 0x00000000
  /* Layer 7 - 3 */
  .word 0xbbdddb3e, 0x00000000
  .word 0x2a9a42e8, 0x00000000
  .word 0x5aaa41ad, 0x00000000
  .word 0xa81a741f, 0x00000000
  /* Layer 6 - 3 */
  .word 0xce2b37c1, 0x00000000
  .word 0x8e1c73f8, 0x00000000
  /* Layer 5 - 3 */
  .word 0x229ae065, 0x00000000
  .word 0x00000000, 0x00000000
  /* Layer 7 - 4 */
  .word 0xb119c2f2, 0x00000000
  .word 0xe1026248, 0x00000000
  .word 0xac0675a9, 0x00000000
  .word 0x285f5b21, 0x00000000
  /* Layer 6 - 4 */
  .word 0x36c0b61a, 0x00000000
  .word 0x34721e9c, 0x00000000
  /* Layer 5 - 4 */
  .word 0x47fa7695, 0x00000000
  .word 0x00000000, 0x00000000
  /* Layer 7 - 5 */
  .word 0x38857f94, 0x00000000
  .word 0x425d5b48, 0x00000000
  .word 0xd4dbef15, 0x00000000
  .word 0x5e964336, 0x00000000
  /* Layer 6 - 5 */
  .word 0x47494922, 0x00000000
  .word 0x8a0912ff, 0x00000000
  /* Layer 5 - 5 */
  .word 0x225fd13f, 0x00000000
  .word 0x00000000, 0x00000000
  /* Layer 7 - 6 */
  .word 0xc5c966aa, 0x00000000
  .word 0x2ac1a256, 0x00000000
  .word 0xe7780a76, 0x00000000
  .word 0xae415d6f, 0x00000000
  /* Layer 6 - 6 */
  .word 0x23736d47, 0x00000000
  .word 0x916af7c6, 0x00000000
  /* Layer 5 - 6 */
  .word 0xd6dbc7b6, 0x00000000
  .word 0x00000000, 0x00000000
  /* Layer 7 - 7 */
  .word 0x817fe279, 0x00000000
  .word 0x5f4770a9, 0x00000000
  .word 0x3bfb62d2, 0x00000000
  .word 0xe3299a57, 0x00000000
  /* Layer 6 - 7 */
  .word 0xdd3dc02d, 0x00000000
  .word 0xc1f114d8, 0x00000000
  /* Layer 5 - 7 */
  .word 0x5ef8b1cb, 0x00000000
  .word 0x00000000, 0x00000000
  /* Layer 7 - 8 */
  .word 0x0861d118, 0x00000000
  .word 0x635ad1a2, 0x00000000
  .word 0x4f48aba5, 0x00000000
  .word 0x8630c12d, 0x00000000
  /* Layer 6 - 8 */
  .word 0x91a606ec, 0x00000000
  .word 0x4dab4199, 0x00000000
  /* Layer 5 - 8 */
  .word 0x9257345f, 0x00000000
  .word 0x00000000, 0x00000000
  /* Layer 7 - 9 */
  .word 0xceb505c5, 0x00000000
  .word 0xeb640c00, 0x00000000
  .word 0x4c48e6b4, 0x00000000
  .word 0xc7a1dfdc, 0x00000000
  /* Layer 6 - 9 */
  .word 0x6cbc8f09, 0x00000000
  .word 0x9a7df650, 0x00000000
  /* Layer 5 - 9 */
  .word 0x997e0a00, 0x00000000
  .word 0x00000000, 0x00000000
  /* Layer 7 - 10 */
  .word 0x485ce52a, 0x00000000
  .word 0x4498430f, 0x00000000
  .word 0x4e83ce7a, 0x00000000
  .word 0xb7ca7a46, 0x00000000
  /* Layer 6 - 10 */
  .word 0xfd76595c, 0x00000000
  .word 0x23ae7c6d, 0x00000000
  /* Layer 5 - 10 */
  .word 0x53be7b32, 0x00000000
  .word 0x00000000, 0x00000000
  /* Layer 7 - 11 */
  .word 0x315ea9f3, 0x00000000
  .word 0x8fa62e4c, 0x00000000
  .word 0xb6ca8df6, 0x00000000
  .word 0x71f73bc1, 0x00000000
  /* Layer 6 - 11 */
  .word 0xcf663338, 0x00000000
  .word 0x3ec0189c, 0x00000000
  /* Layer 5 - 11 */
  .word 0xfbb18fe2, 0x00000000
  .word 0x00000000, 0x00000000
  /* Layer 7 - 12 */
  .word 0x766d0b4e, 0x00000000
  .word 0x2986a6e0, 0x00000000
  .word 0x8109c42c, 0x00000000
  .word 0x7d0a12eb, 0x00000000
  /* Layer 6 - 12 */
  .word 0x67f8009e, 0x00000000
  .word 0xce03d852, 0x00000000
  /* Layer 5 - 12 */
  .word 0x15c33fc1, 0x00000000
  .word 0x00000000, 0x00000000
  /* Layer 7 - 13 */
  .word 0x157480e3, 0x00000000
  .word 0x182586f6, 0x00000000
  .word 0x5a342360, 0x00000000
  .word 0xc5dd1661, 0x00000000
  /* Layer 6 - 13 */
  .word 0x61f876bc, 0x00000000
  .word 0x50e615b0, 0x00000000
  /* Layer 5 - 13 */
  .word 0x8e7ee28d, 0x00000000
  .word 0x00000000, 0x00000000
  /* Layer 7 - 14 */
  .word 0xee151213, 0x00000000
  .word 0x03b0f264, 0x00000000
  .word 0x334ad2dd, 0x00000000
  .word 0x93a5df8d, 0x00000000
  /* Layer 6 - 14 */
  .word 0x4ed28d58, 0x00000000
  .word 0xa3f3636f, 0x00000000
  /* Layer 5 - 14 */
  .word 0x9907ebb3, 0x00000000
  .word 0x00000000, 0x00000000
  /* Layer 7 - 15 */
  .word 0xab68f7ed, 0x00000000
  .word 0x500d88cf, 0x00000000
  .word 0xc866bd06, 0x00000000
  .word 0x821d6034, 0x00000000
  /* Layer 6 - 15 */
  .word 0x78f6b1f3, 0x00000000
  .word 0x05d82a73, 0x00000000
  /* Layer 5 - 15 */
  .word 0x43d365e5, 0x00000000
  .word 0x00000000, 0x00000000
  /* Layer 7 - 16 */
  .word 0x344abf2d, 0x00000000
  .word 0xd32ad553, 0x00000000
  .word 0x2baddeef, 0x00000000
  .word 0xfeb154d3, 0x00000000
  /* Layer 6 - 16 */
  .word 0xe68bcddd, 0x00000000
  .word 0xe9c6a1f4, 0x00000000
  /* Layer 5 - 16 */
  .word 0xe93cd3f0, 0x00000000
  .word 0x00000000, 0x00000000
  /* Layer 4--1 */ 
  .word 0x79bb8f1d, 0x00000000
  .word 0xd43e715a, 0x00000000
  .word 0x054e5c70, 0x00000000
  .word 0x29c1b606, 0x00000000
  .word 0xc2b5f202, 0x00000000
  .word 0xf12886bb, 0x00000000
  .word 0x6c6dd02c, 0x00000000
  .word 0xae550d27, 0x00000000
  .word 0xbec9f078, 0x00000000
  .word 0x6e1ee9ef, 0x00000000
  .word 0xcf8d92a6, 0x00000000
  .word 0x34d48d31, 0x00000000
  .word 0x031374a9, 0x00000000
  .word 0x39991b9c, 0x00000000
  .word 0x6b6de3db, 0x00000000
  /* n_inv */ 
  .word 0x912fe8a0, 0x00000000
