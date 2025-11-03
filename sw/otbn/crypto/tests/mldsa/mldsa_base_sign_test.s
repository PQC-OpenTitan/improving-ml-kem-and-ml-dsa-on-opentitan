/* Copyright "Towards ML-KEM & ML-DSA on OpenTitan" Authors */
/* Licensed under the Apache License, Version 2.0, see LICENSE for details. */
/* SPDX-License-Identifier: Apache-2.0 */
/* Modified by Ruben Niederhagen and Hoang Nguyen Hien Pham - authors of */
/* "Improving ML-KEM & ML-DSA on OpenTitan - Efficient Multiplication Vector Instructions for OTBN" */
/* (https://eprint.iacr.org/2025/2028) */
/* Copyright Ruben Niederhagen and Hoang Nguyen Hien Pham. */


/**
 * Test for crypto_sign_signature_internal
*/

.section .text.start

#define CTXLEN 32

#define SEEDBYTES 32
#define CRHBYTES 64
#define TRBYTES 64
#define RNDBYTES 32
#define N 256
#define Q 8380417
#define D 13
#define ROOT_OF_UNITY 1753

#if DILITHIUM_MODE == 2
#define K 4
#define L 4
#define ETA 2
#define TAU 39
#define BETA 78
#define GAMMA1 131072
#define GAMMA2 95232
#define GAMMA2x2 190464
#define OMEGA 80
#define CTILDEBYTES 32

#define CRYPTO_PUBLICKEYBYTES 1312
#define CRYPTO_SECRETKEYBYTES 2560
#define CRYPTO_BYTES 2420
#define STACK_SIZE 51200 /* minimum 50KB */

#elif DILITHIUM_MODE == 3
#define K 6
#define L 5
#define ETA 4
#define TAU 49
#define BETA 196
#define GAMMA1 524288
#define GAMMA2 261888
#define GAMMA2x2 523776
#define OMEGA 55
#define CTILDEBYTES 48

#define CRYPTO_PUBLICKEYBYTES 1952
#define CRYPTO_SECRETKEYBYTES 4032
#define CRYPTO_BYTES 3309
#define STACK_SIZE 78848 /* minimum 77KB */

#elif DILITHIUM_MODE == 5
#define K 8
#define L 7
#define ETA 2
#define TAU 60
#define BETA 120
#define GAMMA1 524288
#define GAMMA2 261888
#define GAMMA2x2 523776
#define OMEGA 75
#define CTILDEBYTES 64

#define CRYPTO_PUBLICKEYBYTES 2592
#define CRYPTO_SECRETKEYBYTES 4896
#define CRYPTO_BYTES 4627
#define STACK_SIZE 120832 /* minimum 118KB */

#endif

#define POLYT1_PACKEDBYTES  320
#define POLYT0_PACKEDBYTES  416
#define POLYVECH_PACKEDBYTES (OMEGA + K)

#if GAMMA1 == (1 << 17)
#define POLYZ_PACKEDBYTES   576
#elif GAMMA1 == (1 << 19)
#define POLYZ_PACKEDBYTES   640
#endif

#if GAMMA2 == (Q-1)/88
#define POLYW1_PACKEDBYTES  192
#elif GAMMA2 == (Q-1)/32
#define POLYW1_PACKEDBYTES  128
#endif

#if ETA == 2
#define POLYETA_PACKEDBYTES  96
#elif ETA == 4
#define POLYETA_PACKEDBYTES 128
#endif

/* Entry point. */
.globl main
main:
  /* Init all-zero register. */
#ifdef RTL_ISS_TEST
  xor  x2, x2, x2
  xor  x3, x3, x3
  xor  x4, x4, x4
  xor  x5, x5, x5
  xor  x6, x6, x6
  xor  x7, x7, x7
  xor  x8, x8, x8
  xor  x9, x9, x9
  xor  x10, x10, x10
  xor  x11, x11, x11
  xor  x12, x12, x12
  xor  x13, x13, x13
  xor  x14, x14, x14
  xor  x15, x15, x15
  xor  x16, x16, x16
  xor  x17, x17, x17
  xor  x18, x18, x18
  xor  x19, x19, x19
  xor  x20, x20, x20
  xor  x21, x21, x21
  xor  x22, x22, x22
  xor  x23, x23, x23
  xor  x24, x24, x24
  xor  x25, x25, x25
  xor  x26, x26, x26
  xor  x27, x27, x27
  xor  x28, x28, x28
  xor  x29, x29, x29
  xor  x30, x30, x30
  xor  x31, x31, x31

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
  
  /* MOD <= dmem[modulus] = DILITHIUM_Q */
  li      x5, 2
  la      x6, modulus
  bn.lid  x5, 0(x6)
  bn.rshi w2, w31, w2 >> 224
  bn.wsrw 0x0, w2

  /* Load stack address */
  la x2, stack_end
  /* Load parameters */
  la x10, signature
  la x11, message
  la x12, messagelen
  lw x12, 0(x12) /* msglen */
  la x13, sk
  /* Prepare context */
  la x14, ctx
  li x15, CTXLEN

  jal x1, crypto_sign_signature_internal

#if DILITHIUM_MODE == 3
  li   x10, CRYPTO_BYTES
  addi x10, x10, -1
  la   x11, signature
  add  x11, x11, x10
  lw   x10, 0(x11)
  slli x10, x10, 24
  srli x10, x10, 24
  sw   x10, 0(x11)
#endif

  ecall

.data
.balign 32
#if DILITHIUM_MODE == 2
.global stack
stack:
    .zero 2528 /* STACK_SIZE + STACK_SIGNATURE */

.globl signature
signature:
  .zero CRYPTO_BYTES
  .zero 12

.zero 17408 /* STACK_SIZE + STACK_MAT - (CRYPTO_BYTES + 12) - 1504 */

.globl sk
sk:
  .word 0xb07ee122
  .word 0x1af5a5de
  .word 0xb00f45d2
  .word 0xb879ab3b
  .word 0x3cc7f80a
  .word 0x38de7c83
  .word 0x0f976a74
  .word 0x0623ab82
  .word 0x25a622d0
  .word 0x0ea44c1e
  .word 0xa44531b3
  .word 0xea59a239
  .word 0xb08b7e3a
  .word 0xfaefa4aa
  .word 0xa67735d8
  .word 0x7a425f51
  .word 0xef7d29f8
  .word 0x51ae1bf1
  .word 0x2b33b634
  .word 0x1e1f2e5e
  .word 0x2661e395
  .word 0x2c171325
  .word 0xce29be76
  .word 0x563d40db
  .word 0x02e6845d
  .word 0xb1144a61
  .word 0x52e2b56c
  .word 0x38bce07e
  .word 0x51275c7f
  .word 0xc6052064
  .word 0x8c66b2f5
  .word 0x096c8e2e
  .word 0xe228450b
  .word 0x105b2030
  .word 0x00386326
  .word 0xd9223304
  .word 0x470c7126
  .word 0x8cb60270
  .word 0x510e24c4
  .word 0x18c84c44
  .word 0x6d261425
  .word 0x01653052
  .word 0x451a8180
  .word 0x6c362351
  .word 0x490010c2
  .word 0xc8e211b4
  .word 0x8d011069
  .word 0x99424292
  .word 0x24e13208
  .word 0x00410366
  .word 0x612d3109
  .word 0xb20c01c2
  .word 0x0a032269
  .word 0x01264490
  .word 0xc24c7220
  .word 0x6e44c14c
  .word 0x53918300
  .word 0x44508880
  .word 0x05a72430
  .word 0x59061300
  .word 0x269a81c2
  .word 0x61a00b24
  .word 0xdb691521
  .word 0xb20b2dc4
  .word 0x69c32104
  .word 0x090a3613
  .word 0xc44201c9
  .word 0x88350a01
  .word 0x993146d8
  .word 0x070969a4
  .word 0x64165b20
  .word 0x0384b4c9
  .word 0x18990240
  .word 0x6602a424
  .word 0x992cc603
  .word 0x13019226
  .word 0x66049a60
  .word 0x1a4d0212
  .word 0xa6e39100
  .word 0x45c81244
  .word 0x242a46c8
  .word 0x94dc6cb7
  .word 0x4ca28c88
  .word 0xa02c230b
  .word 0x90498138
  .word 0x7082d040
  .word 0xc8803682
  .word 0x34c80d00
  .word 0x41c2406e
  .word 0x02810459
  .word 0x04e37244
  .word 0x82400261
  .word 0xc32ca6c3
  .word 0x24994c88
  .word 0x92111040
  .word 0x13252613
  .word 0x19134532
  .word 0x6a070961
  .word 0x542132db
  .word 0x00505218
  .word 0x50b65925
  .word 0x0331968a
  .word 0xa2618c39
  .word 0x84104408
  .word 0x13651492
  .word 0xa8537248
  .word 0x20172065
  .word 0x0a022523
  .word 0x045c0c40
  .word 0x4e051181
  .word 0x536da0dc
  .word 0x08628544
  .word 0x0928a128
  .word 0x0150930b
  .word 0x442490b9
  .word 0x28c2d142
  .word 0x4c0540e2
  .word 0x90a08834
  .word 0x51171404
  .word 0xcc80965c
  .word 0x20e35194
  .word 0x2c10e328
  .word 0x91854321
  .word 0xa8db71c4
  .word 0x85851325
  .word 0x1a60a6c3
  .word 0x265b8c87
  .word 0x51150844
  .word 0x112926d4
  .word 0x95243226
  .word 0x65486171
  .word 0xa20e080a
  .word 0x22224518
  .word 0x0540d240
  .word 0x606e0004
  .word 0x120c0826
  .word 0x4a22d340
  .word 0xca010264
  .word 0x912470c2
  .word 0x1032c32c
  .word 0x228a125b
  .word 0xa4c12442
  .word 0x02184a04
  .word 0xd4243690
  .word 0x92524044
  .word 0x00826249
  .word 0x9b8d4249
  .word 0xb8136504
  .word 0x48085c71
  .word 0x00659891
  .word 0xb6817016
  .word 0x31b0a14d
  .word 0xc16d2513
  .word 0x82d93002
  .word 0x9080c12c
  .word 0x11208290
  .word 0x20a28e08
  .word 0x08c6e400
  .word 0x1309b6da
  .word 0xc4587206
  .word 0x8924d049
  .word 0x6490b4e1
  .word 0xa4c31240
  .word 0x6d148220
  .word 0x9030345a
  .word 0xb4a44090
  .word 0x05924b90
  .word 0x5a05111a
  .word 0x33217130
  .word 0x4894e449
  .word 0x99804822
  .word 0x225c2592
  .word 0x89c4a392
  .word 0x5c0c2824
  .word 0x390a4c28
  .word 0x4194a122
  .word 0x146918e0
  .word 0x08d32206
  .word 0x25081891
  .word 0x0b4008e4
  .word 0xb68c64b8
  .word 0x6cc8520c
  .word 0x41492603
  .word 0x950b25a4
  .word 0x60000364
  .word 0x9c488452
  .word 0xc2538c26
  .word 0x4d206061
  .word 0x12021722
  .word 0x468324a5
  .word 0x64080b92
  .word 0x5049940a
  .word 0x281900a0
  .word 0x80804012
  .word 0x51721102
  .word 0x86112500
  .word 0x21a80a6d
  .word 0xa189b688
  .word 0xa8cc6522
  .word 0x89481b31
  .word 0xd18884d9
  .word 0x94246618
  .word 0x60061a91
  .word 0x4985a4da
  .word 0xc8948c44
  .word 0x0e32d86c
  .word 0x1b6228c8
  .word 0x04996d06
  .word 0x82192349
  .word 0x53014611
  .word 0x971a4582
  .word 0x22171924
  .word 0x62290889
  .word 0x36e10042
  .word 0x6d281b81
  .word 0x9868c624
  .word 0x131c2516
  .word 0x25208830
  .word 0x8a8d030c
  .word 0x14d22cb8
  .word 0x49924320
  .word 0x24902061
  .word 0x34922833
  .word 0x69208c8e
  .word 0x338125e9
  .word 0xeab263ed
  .word 0xe056da01
  .word 0xbbaacff7
  .word 0x85a014a6
  .word 0xc2610b50
  .word 0x8ec884ea
  .word 0xfd347a7e
  .word 0x4122eecc
  .word 0xf23bc9b8
  .word 0x6f27ab76
  .word 0xf9c3fa9b
  .word 0x3a2582bd
  .word 0xf6faf3e2
  .word 0x4a9c7317
  .word 0xf16f3c0f
  .word 0x7467fdf7
  .word 0xca162bed
  .word 0x1c72cc71
  .word 0x0305851b
  .word 0xd2798b7b
  .word 0x9c9555b4
  .word 0x83a369d4
  .word 0xc19306df
  .word 0xe75130bf
  .word 0xebddc2d1
  .word 0xf41ad4ea
  .word 0xf97af713
  .word 0x8483ad7c
  .word 0x94e3fdb9
  .word 0xb11ebb60
  .word 0x5adfbeea
  .word 0x78003589
  .word 0xef5ecbcd
  .word 0xbe62d0c8
  .word 0x61fb474d
  .word 0x2ba41880
  .word 0x2daf7f19
  .word 0x0e883572
  .word 0x5ad49ccb
  .word 0xd454f10c
  .word 0xcc84c21d
  .word 0xbae8befe
  .word 0x81497ac2
  .word 0xb6129ea6
  .word 0x538cd29c
  .word 0x8f0ceb1e
  .word 0xcfec4be4
  .word 0x3928d0cf
  .word 0x5d44bd14
  .word 0x13e296fb
  .word 0x6e03562e
  .word 0xbfc374f3
  .word 0xaa855b76
  .word 0x5bbd31f3
  .word 0xa3a17092
  .word 0x7cc2a97f
  .word 0x95b2c78d
  .word 0xd3825489
  .word 0x62f174b7
  .word 0x242c61ef
  .word 0xc774893f
  .word 0x6290b520
  .word 0xfa59a51a
  .word 0xec750068
  .word 0xfc3db1da
  .word 0x633eccd3
  .word 0x8d595775
  .word 0x4754b9b4
  .word 0xc9efd126
  .word 0x61496ecd
  .word 0x11b6898d
  .word 0xc86b3084
  .word 0x0bc27f21
  .word 0xcb0e52ea
  .word 0x9c67a068
  .word 0xdb283dca
  .word 0x13a556d8
  .word 0x7d94c236
  .word 0x7a953862
  .word 0x6fbcf5d0
  .word 0xced81cbc
  .word 0xce78ab33
  .word 0x75ec7fcb
  .word 0xf8f92ebd
  .word 0xdb5e6da9
  .word 0x7612a852
  .word 0xa068ae09
  .word 0x136ea5fc
  .word 0x0298a37b
  .word 0x8fdfe88c
  .word 0xdc0d8cb2
  .word 0x5555bb7e
  .word 0xd18be4b4
  .word 0xc34a4c94
  .word 0x2685f1ca
  .word 0x43dcedab
  .word 0xd55f6035
  .word 0x6bb39179
  .word 0xb2ac60a7
  .word 0x8c923a29
  .word 0xac9ac30e
  .word 0x00d0c57d
  .word 0x81e49eaa
  .word 0x6531386b
  .word 0xb72ff706
  .word 0xe2e152fa
  .word 0x9ffa6ac0
  .word 0x613f4209
  .word 0x0b1f61dd
  .word 0x8a6e43d3
  .word 0x712c5873
  .word 0xbcf8a246
  .word 0xb8ae5c3d
  .word 0xe23730cc
  .word 0x019356f4
  .word 0xf88f521d
  .word 0xbbc74eb1
  .word 0x563cea33
  .word 0xde6cd063
  .word 0x1dd5f006
  .word 0xffc1cddc
  .word 0x5f8ebdd4
  .word 0x4534c8f7
  .word 0x246d20ef
  .word 0xb4f03962
  .word 0xbe72577e
  .word 0x16abb6d4
  .word 0x454debc5
  .word 0xdbedb690
  .word 0x07edd30b
  .word 0xd6b6c421
  .word 0x89811e15
  .word 0x2cbf7a91
  .word 0xe0a15f7d
  .word 0x8c4cf8ec
  .word 0x0cc52e0f
  .word 0x68f8f962
  .word 0x4126d745
  .word 0xe2f52b6d
  .word 0xc80a6683
  .word 0x09f60510
  .word 0x7b55bef7
  .word 0x16264592
  .word 0x8163e3cf
  .word 0x3af40c69
  .word 0xc2e35b4c
  .word 0x6adeef72
  .word 0x1f813f02
  .word 0xd512bb3f
  .word 0xc9837bac
  .word 0x1c85506a
  .word 0x60cbf392
  .word 0x5a1f222a
  .word 0x777dd2b5
  .word 0x05c4032d
  .word 0x54f2caea
  .word 0xcc016c7b
  .word 0x46d4ee0d
  .word 0x787e0cb6
  .word 0xac294466
  .word 0xc73054d8
  .word 0xbdd0a6cd
  .word 0x40982163
  .word 0x28acf836
  .word 0xf63a04e8
  .word 0x76a8dc6b
  .word 0xc91a76e7
  .word 0x2f14c84f
  .word 0x771dba82
  .word 0x76de1933
  .word 0x3e172cbf
  .word 0xe672b709
  .word 0x68e47228
  .word 0xc45e31b6
  .word 0x6ef84e47
  .word 0x39c8444b
  .word 0x539ffe7c
  .word 0x50021b88
  .word 0x3d494694
  .word 0x4b8f5cb6
  .word 0x46d995ef
  .word 0x76c7f8b9
  .word 0x2585520d
  .word 0x5e490189
  .word 0x7bbe8ced
  .word 0xe52eef36
  .word 0xb5f01d0b
  .word 0x310b9b3a
  .word 0x578f82ea
  .word 0x5c8ac8f9
  .word 0x32ebd12e
  .word 0xa965cadf
  .word 0x5ade9901
  .word 0xb1b52604
  .word 0xdd5aad1f
  .word 0x22eb7a8f
  .word 0x3c4caaa8
  .word 0x8aa17daf
  .word 0xa6854d72
  .word 0x510872d9
  .word 0x39c245d8
  .word 0xb8b08e14
  .word 0xdce8e709
  .word 0xc02bbfa4
  .word 0x5d793b9a
  .word 0xaf31dc3d
  .word 0xff24f468
  .word 0x13634d6b
  .word 0xf302dbb4
  .word 0x57ee460c
  .word 0xc1a8000b
  .word 0x30d24551
  .word 0x77d8f276
  .word 0xfa3ba610
  .word 0x32728f91
  .word 0xa0bedcc5
  .word 0xf8459be0
  .word 0xd5818a84
  .word 0xac62ee2e
  .word 0x7171273e
  .word 0x6edc9d9a
  .word 0x7cbfdcb9
  .word 0x97bb82cd
  .word 0x5f6482a3
  .word 0xab8ec253
  .word 0x3cb1f170
  .word 0x098db4dd
  .word 0xdfc0855e
  .word 0xe184fd56
  .word 0xdfdaaf6b
  .word 0xf7fcc1b4
  .word 0x7dfc9c51
  .word 0x7fff76f7
  .word 0x0892eccd
  .word 0x4a350c3b
  .word 0x0612ccbb
  .word 0x7ba0aee8
  .word 0x52038bd5
  .word 0xb656c16e
  .word 0x7e2852c0
  .word 0x27300f16
  .word 0x5c308e1e
  .word 0x0a11ea2a
  .word 0x6b9a4b8f
  .word 0xbf8eadc8
  .word 0xf3dfb4b3
  .word 0xb9ff7c64
  .word 0x34bb4882
  .word 0x12487051
  .word 0x317a8a81
  .word 0x417c88dd
  .word 0x4a7bb3f8
  .word 0x02ea9583
  .word 0x4e78a3fb
  .word 0x51d95c74
  .word 0x49863bfb
  .word 0x5937ce93
  .word 0xdf2597dd
  .word 0x2113106b
  .word 0x9182dd86
  .word 0xc823431f
  .word 0xf6564d3b
  .word 0xcd661421
  .word 0x61a235a4
  .word 0xc7612eb5
  .word 0x07a09e85
  .word 0xbf3851bd
  .word 0x54f40490
  .word 0x13c0cb66
  .word 0xde780a52
  .word 0xaaa604f4
  .word 0x9dc00bdd
  .word 0x5e648857
  .word 0xee9830a4
  .word 0x84f45cfb
  .word 0x5a45aa96
  .word 0xc7540dd1
  .word 0xac04619f
  .word 0xff9728e4
  .word 0x99d87ef6
  .word 0x1441adcc
  .word 0x5a02c794
  .word 0x554497db
  .word 0x0aace207
  .word 0x1ee7d488
  .word 0xbe289bf3
  .word 0xc0839959
  .word 0x16441bdc
  .word 0x03cbc4b1
  .word 0x9b52d9ed
  .word 0x71e7135f
  .word 0x6b4ad80f
  .word 0xae0b4d90
  .word 0xfdc80acf
  .word 0xd17a9d25
  .word 0x7ff9390b
  .word 0x420f52d7
  .word 0x0412d7a6
  .word 0x1226b31c
  .word 0xebc81ed4
  .word 0x45292ce7
  .word 0xe3de73de
  .word 0xb693aaae
  .word 0x35c9fa8a
  .word 0xd3722624
  .word 0xea4917a2
  .word 0x75799a32
  .word 0x26c12442
  .word 0x091db609
  .word 0x43c4aa0e
  .word 0xad00cb21
  .word 0xc207e83c
  .word 0xb5ec6106
  .word 0x42ea2e8a
  .word 0x350afbf6
  .word 0xfe9b1359
  .word 0xea72d50f
  .word 0x935c5116
  .word 0x0a11ba1c
  .word 0x8e1945a8
  .word 0x689eff55
  .word 0x290bf624
  .word 0x04147b6a
  .word 0x81287e5b
  .word 0x93dd5ee8
  .word 0x0a060c68
  .word 0x9785d497
  .word 0xdf476756
  .word 0xb97aaf31
  .word 0x415a86c5
  .word 0xb75083fd
  .word 0xfc34f9a9
  .word 0xa920399a
  .word 0x72d463a8
  .word 0x1fd75e3d
  .word 0x5d85ced7
  .word 0x7e333aca
  .word 0x576c466e
  .word 0x2efb9ebb
  .word 0x1b5c3a84
  .word 0x1872cbae
  .word 0xfce6d184
  .word 0x0772bad0
  .word 0x0e067608
  .word 0xf8e7fd8c
  .word 0x9424bf1e
  .word 0x90144d9b
  .word 0x9aee69e4
  .word 0x632a5fc4
  .word 0xd79a29f2
  .word 0xb4c863a8
  .word 0x62ca685c
  .word 0xa619d1fd
  .word 0xa9157e25
  .word 0x1bf6cc31
  .word 0xf8e75b00
  .word 0xa3ec60a6
  .word 0xf6a26ca3
  .word 0x83a491e2
  .word 0x693c17c3
  .word 0x60a44835
  .word 0xbcceab36
  .word 0x9402e700
  .word 0xa7ee9c71
  .word 0x445ffcce
  .word 0xdb418034
  .word 0x439834a2
  .word 0x246634ff
  .word 0x7c8e2d66
  .word 0x89dacabc
  .word 0x01ff9c0e
  .word 0xf3a8b066
  .word 0xe0b862b3
  .word 0xa8f27d56
  .word 0x0a98784d
  .word 0x9e1a6d5b
  .word 0x94f337a2
  .word 0x25207824
  .word 0x18d2579d
  .word 0xe2712cf8
  .word 0xec282ce7
  .word 0x8c358c32
  .word 0xd5b7f0b5
  .word 0xa7887bf7
  .word 0x6e27432a
  .word 0x7b01c4b0
  .word 0xc75da8f6
  .word 0x6926ff65
  .word 0x857ea93e
  .word 0xc5b6d8d7
  .word 0x971f98af
  .word 0x3f03a75d
  .word 0x37ea7a01
  .word 0x56306326
  .word 0xc27696e3
  .word 0xd8668ac3
  .word 0xfc698d7b
  .word 0x057445cb
  .word 0xc502adc2
  .word 0x52334e93
  .word 0x9133603d
  .word 0xedb4a202
  .word 0x6781aa88
  .word 0xe9989b59
  .word 0x58ffc5f5
  .word 0x441f1ee9
  .word 0xced501b8
  .word 0xdf486fe6
  .word 0x82bfe970
  .word 0x3d7863e0
  .word 0xc0ee6bc7
  .word 0x06f07e00
  .word 0xe717e2c1
  .word 0x9591bcea
  .word 0x1de1af12

.globl message
message:
  .word 0xa9eeb13c
  .word 0x934b0088
  .word 0x0afb3c10
  .word 0x682afdee
  .word 0x4afa016e
  .word 0x63a3e858
  .word 0xe3a1a89c
  .word 0xe257aef9
  .word 0x87ccb835
  .word 0x62dc233c
  .word 0x1660d2b8
  .word 0x752ffa9a
  .word 0x586a91ab
  .word 0x889174d9
  .word 0x6a5ed235
  .word 0xb2855043
  .zero 3132
/* account for longer messages in the tests */

.globl messagelen
messagelen:
  .word 0x00000040

  .zero 23072
stack_end:

#elif DILITHIUM_MODE == 3
.global stack
stack:
    .zero 2656 /* STACK_SIZE + STACK_SIGNATURE */

/* In case of Dilithium3, CTILDEBYTES is 48, not divisible by 32.
   To make the packing easier, we dis-align the start of the signature buffer
   because we will simply need to write C to the beginning, which is much easier
   than dealing with the disalignment later on in the signature. */
  .zero 16
.globl signature
signature:
  .zero CRYPTO_BYTES
  .zero 3

.zero 24576 /* STACK_SIZE + STACK_MAT - (CRYPTO_BYTES + 12) - 79328 */

.globl sk
sk:
  .word 0x8ca9a4c8
  .word 0xbc446839
  .word 0xae9bcd7a
  .word 0x8d02709b
  .word 0x12133086
  .word 0x82523c65
  .word 0x7fad9e53
  .word 0x28499345
  .word 0xc8e11e65
  .word 0xa743c18a
  .word 0x8e5eba68
  .word 0x072cfde1
  .word 0xd539ef7c
  .word 0x63825d29
  .word 0xef093e92
  .word 0xa7ba4ea7
  .word 0x85b90970
  .word 0xd948be84
  .word 0xad90eaa1
  .word 0x6d768ead
  .word 0x1aaf86f0
  .word 0x87502b52
  .word 0x51f370fd
  .word 0x0d0723e5
  .word 0xd9746cb6
  .word 0x274f4969
  .word 0xa239015f
  .word 0xb9048418
  .word 0xa0b9b0f9
  .word 0x9d52f077
  .word 0x7412c21d
  .word 0xd47555fe
  .word 0x30750236
  .word 0x20077412
  .word 0x74077756
  .word 0x11476138
  .word 0x03580568
  .word 0x80545851
  .word 0x84882425
  .word 0x40480387
  .word 0x11553700
  .word 0x52310708
  .word 0x78288076
  .word 0x28614476
  .word 0x16040271
  .word 0x64637877
  .word 0x06817548
  .word 0x61433658
  .word 0x22048063
  .word 0x37615148
  .word 0x07286036
  .word 0x64424257
  .word 0x26531848
  .word 0x25246838
  .word 0x06828220
  .word 0x08046374
  .word 0x35008213
  .word 0x81217276
  .word 0x48342623
  .word 0x57512116
  .word 0x37525458
  .word 0x43275024
  .word 0x35482286
  .word 0x72168241
  .word 0x88612086
  .word 0x80077157
  .word 0x86214652
  .word 0x04716405
  .word 0x11071853
  .word 0x87834414
  .word 0x23272500
  .word 0x24452442
  .word 0x38233260
  .word 0x83868332
  .word 0x86811417
  .word 0x05765476
  .word 0x54720473
  .word 0x70510300
  .word 0x50741444
  .word 0x70404076
  .word 0x35864724
  .word 0x06811163
  .word 0x11001330
  .word 0x23317604
  .word 0x43233674
  .word 0x27105642
  .word 0x57843560
  .word 0x04253643
  .word 0x70202372
  .word 0x36308812
  .word 0x72640664
  .word 0x81312007
  .word 0x25032717
  .word 0x30313287
  .word 0x20168767
  .word 0x43834066
  .word 0x88266050
  .word 0x30331723
  .word 0x44384534
  .word 0x60667221
  .word 0x73470742
  .word 0x75317566
  .word 0x44512522
  .word 0x06581180
  .word 0x34353580
  .word 0x15062531
  .word 0x33082282
  .word 0x88113860
  .word 0x74408512
  .word 0x40653320
  .word 0x83378502
  .word 0x23731582
  .word 0x32810080
  .word 0x40126172
  .word 0x36147177
  .word 0x42086161
  .word 0x01883325
  .word 0x50434676
  .word 0x04446546
  .word 0x70680446
  .word 0x85344853
  .word 0x24476826
  .word 0x01103075
  .word 0x03533418
  .word 0x47424633
  .word 0x44334341
  .word 0x76287081
  .word 0x23136535
  .word 0x30873675
  .word 0x70036362
  .word 0x41020587
  .word 0x23280430
  .word 0x02683547
  .word 0x13027610
  .word 0x67177047
  .word 0x54525644
  .word 0x23102558
  .word 0x18327738
  .word 0x73000713
  .word 0x21446105
  .word 0x55766847
  .word 0x63273717
  .word 0x70580871
  .word 0x46840172
  .word 0x72376238
  .word 0x02763443
  .word 0x33840328
  .word 0x27853754
  .word 0x26622620
  .word 0x04684312
  .word 0x20206570
  .word 0x64381466
  .word 0x10506267
  .word 0x50077081
  .word 0x48517267
  .word 0x64756333
  .word 0x68145587
  .word 0x38027748
  .word 0x61634574
  .word 0x43600615
  .word 0x22753143
  .word 0x27281078
  .word 0x34300040
  .word 0x38863217
  .word 0x06667606
  .word 0x61068013
  .word 0x33368271
  .word 0x22078783
  .word 0x08736202
  .word 0x03634828
  .word 0x35550172
  .word 0x72457652
  .word 0x16285707
  .word 0x38728570
  .word 0x46661131
  .word 0x22818588
  .word 0x56380341
  .word 0x57203730
  .word 0x62807522
  .word 0x84121133
  .word 0x86726164
  .word 0x58112330
  .word 0x20303580
  .word 0x80288472
  .word 0x81842131
  .word 0x72585283
  .word 0x06104664
  .word 0x18062482
  .word 0x23328338
  .word 0x01880161
  .word 0x50113361
  .word 0x18424206
  .word 0x86720686
  .word 0x17247734
  .word 0x38213574
  .word 0x41330046
  .word 0x83174003
  .word 0x73228411
  .word 0x12335552
  .word 0x42425331
  .word 0x48817775
  .word 0x13607118
  .word 0x37370838
  .word 0x15382085
  .word 0x54567678
  .word 0x36366770
  .word 0x63816760
  .word 0x11855456
  .word 0x64018867
  .word 0x51634317
  .word 0x35552710
  .word 0x06242144
  .word 0x61170854
  .word 0x83606446
  .word 0x84301242
  .word 0x74761170
  .word 0x37703258
  .word 0x70337272
  .word 0x88113644
  .word 0x77827200
  .word 0x48850248
  .word 0x31430112
  .word 0x24566771
  .word 0x01884505
  .word 0x18708668
  .word 0x62645283
  .word 0x42686406
  .word 0x77068431
  .word 0x54365850
  .word 0x26702682
  .word 0x42550438
  .word 0x36044238
  .word 0x86800477
  .word 0x44456373
  .word 0x77341251
  .word 0x76150033
  .word 0x14548661
  .word 0x83661352
  .word 0x14058765
  .word 0x15281214
  .word 0x34880177
  .word 0x78274064
  .word 0x71825017
  .word 0x41202742
  .word 0x32201088
  .word 0x18281082
  .word 0x26675612
  .word 0x41178535
  .word 0x46651163
  .word 0x87304006
  .word 0x04653400
  .word 0x04556121
  .word 0x00442405
  .word 0x87427834
  .word 0x28624722
  .word 0x86062054
  .word 0x18678624
  .word 0x64308276
  .word 0x38562164
  .word 0x34761700
  .word 0x76766802
  .word 0x10006054
  .word 0x64124657
  .word 0x24223585
  .word 0x21586462
  .word 0x56320182
  .word 0x50731388
  .word 0x71243411
  .word 0x66271635
  .word 0x64608330
  .word 0x05711272
  .word 0x85870521
  .word 0x20371676
  .word 0x61702161
  .word 0x83127754
  .word 0x47570611
  .word 0x23434612
  .word 0x83264878
  .word 0x18686477
  .word 0x53835471
  .word 0x07222633
  .word 0x80612032
  .word 0x45546263
  .word 0x42157305
  .word 0x45776050
  .word 0x02832410
  .word 0x30380353
  .word 0x41427241
  .word 0x82536147
  .word 0x78105250
  .word 0x66732061
  .word 0x28648227
  .word 0x16074212
  .word 0x62252284
  .word 0x23750022
  .word 0x80453732
  .word 0x74367865
  .word 0x72775203
  .word 0x05822037
  .word 0x21475142
  .word 0x64533068
  .word 0x24016532
  .word 0x51542030
  .word 0x10767146
  .word 0x46064081
  .word 0x42725577
  .word 0x62415322
  .word 0x52758377
  .word 0x08851805
  .word 0x21835107
  .word 0x38570875
  .word 0x64311273
  .word 0x56280525
  .word 0x43241111
  .word 0x48454727
  .word 0x63355165
  .word 0x41414787
  .word 0x64463162
  .word 0x37016871
  .word 0x25563567
  .word 0x04687445
  .word 0x47008024
  .word 0x11432633
  .word 0x14343208
  .word 0x06076158
  .word 0x68205483
  .word 0x52761776
  .word 0x13132344
  .word 0x80173162
  .word 0x51862521
  .word 0x70178458
  .word 0x10505284
  .word 0x86760381
  .word 0x62688655
  .word 0x04233655
  .word 0x66773568
  .word 0x40413160
  .word 0x08808660
  .word 0x73886037
  .word 0x47525678
  .word 0x38505014
  .word 0x78227858
  .word 0x55307075
  .word 0x41650171
  .word 0x38152824
  .word 0x72005646
  .word 0x08333421
  .word 0x16344376
  .word 0x84087116
  .word 0x21775608
  .word 0x40256818
  .word 0x36152320
  .word 0x86277425
  .word 0x50168707
  .word 0x76658018
  .word 0x52754878
  .word 0x51882058
  .word 0x12301262
  .word 0x40602437
  .word 0x63184522
  .word 0x51863243
  .word 0x36373525
  .word 0x38634416
  .word 0x56216444
  .word 0x57701712
  .word 0x38765471
  .word 0x71762886
  .word 0x56104743
  .word 0x34470746
  .word 0x34700726
  .word 0x21230862
  .word 0x03257055
  .word 0x82300771
  .word 0x41218247
  .word 0x74186482
  .word 0x42744656
  .word 0x81627773
  .word 0x74473440
  .word 0x80000405
  .word 0x58363160
  .word 0x10086637
  .word 0x65523187
  .word 0x05668431
  .word 0x57677127
  .word 0x072caa7d
  .word 0xeca6aee7
  .word 0xcdc9d2dd
  .word 0x6902eb8c
  .word 0xdb6189c6
  .word 0xa8ba1c45
  .word 0xe635ee2a
  .word 0x620b561e
  .word 0x10be0809
  .word 0xa618fb75
  .word 0xb5066f71
  .word 0x3b09718c
  .word 0xbdc37039
  .word 0x12267fda
  .word 0x8f9a859d
  .word 0x662fae36
  .word 0x2701ecf5
  .word 0x6072a812
  .word 0x05fcfb2e
  .word 0x8237cedb
  .word 0xf1faa93e
  .word 0x668b80b4
  .word 0x1fe3cf69
  .word 0xf2c3b2b0
  .word 0x1723c95b
  .word 0x9c4dcfe8
  .word 0x75e022b6
  .word 0x4d2ee459
  .word 0x6d53e913
  .word 0xcdf3b3b3
  .word 0x8a34f673
  .word 0x5556b6fd
  .word 0x9f9edc7a
  .word 0xb6444192
  .word 0x26dc4292
  .word 0x8108005b
  .word 0x60acdbe1
  .word 0x4a2b3980
  .word 0x4b616f35
  .word 0xcbf257c4
  .word 0xea1b4c7b
  .word 0xdd9dab81
  .word 0xf30dd51a
  .word 0x80224ce3
  .word 0xff86ca1e
  .word 0xc4520285
  .word 0xf0783398
  .word 0x827255b5
  .word 0x133f411f
  .word 0x0a6b2843
  .word 0x1d87229b
  .word 0x098f7d3e
  .word 0xb4996e9d
  .word 0x81e67a52
  .word 0x5c329969
  .word 0xb8ee1c5b
  .word 0xa48ee194
  .word 0x303e52d4
  .word 0xe498d7a4
  .word 0x2e25e9f3
  .word 0xf318e5c7
  .word 0xaa0a4faf
  .word 0x213b3086
  .word 0xf09dea49
  .word 0x90c9126f
  .word 0x15df918f
  .word 0x2869c938
  .word 0xb3a3c8d5
  .word 0x67dded9b
  .word 0x463a3d2a
  .word 0x539298a9
  .word 0x6f0890d6
  .word 0xc7f63fc4
  .word 0x605fcbc6
  .word 0x58da436f
  .word 0xc6146adb
  .word 0x1d9f2171
  .word 0x7a4b1b3c
  .word 0xefba1c30
  .word 0x26982121
  .word 0x23a42429
  .word 0x364efda2
  .word 0xc6bb1459
  .word 0x8fcec564
  .word 0xad6c7ca5
  .word 0x4b84d25f
  .word 0xe37b5699
  .word 0xa36c008c
  .word 0xbf84893f
  .word 0x7abb8e06
  .word 0xcbdf6e34
  .word 0x041276d4
  .word 0x29f619dd
  .word 0xbf19b8b4
  .word 0x41481312
  .word 0xf7d945f3
  .word 0xf6e94eb4
  .word 0x56eda817
  .word 0xb8975a3f
  .word 0x1837f723
  .word 0x297355b0
  .word 0x05609a68
  .word 0x830b3124
  .word 0x4b5bce72
  .word 0x1a0f3730
  .word 0x7d9acf2c
  .word 0xb88a4479
  .word 0x598e2c1c
  .word 0x0ed2657f
  .word 0xf75933a3
  .word 0xc5aa06f8
  .word 0x153ae850
  .word 0x3fa4e4bc
  .word 0xa71e0fac
  .word 0x2e7a4433
  .word 0xe9bc37ae
  .word 0x2fe848aa
  .word 0x422dd9d3
  .word 0x265e3d50
  .word 0xb4f886c3
  .word 0x0df2d59d
  .word 0x63ef2d92
  .word 0x56309693
  .word 0x7271585b
  .word 0xc03471bd
  .word 0x0749c592
  .word 0x337190ab
  .word 0x6934edbd
  .word 0xd9823546
  .word 0x41ba70e5
  .word 0xab7dc270
  .word 0xa5f84bc2
  .word 0xc79d10be
  .word 0x465975f3
  .word 0xd1dfeee0
  .word 0x38958b95
  .word 0xf60f5361
  .word 0xc6e71579
  .word 0x4f8e20c8
  .word 0x9f1cf943
  .word 0x7689af36
  .word 0x5f739b10
  .word 0xecbe943d
  .word 0x797a454a
  .word 0x2eaa7dbe
  .word 0xdff17dfa
  .word 0xe1b61450
  .word 0xd1a3b8e1
  .word 0x1fe9d6f2
  .word 0xb668f373
  .word 0x7007d7b2
  .word 0x692f99c7
  .word 0xc593fcf7
  .word 0x30cd68d4
  .word 0xeb1363b7
  .word 0x30478475
  .word 0xb7b485f7
  .word 0xf250e43a
  .word 0xedf15275
  .word 0x0383fcb1
  .word 0xf0da1eac
  .word 0xe09b0888
  .word 0x8a479d74
  .word 0x2937d602
  .word 0x146d5966
  .word 0xb0063405
  .word 0x2d35aa90
  .word 0x7aba23c2
  .word 0x56b86e7d
  .word 0x23ae2031
  .word 0x8ab7b522
  .word 0xbb197525
  .word 0x8b31cf8d
  .word 0x6d60601f
  .word 0xa7a531c1
  .word 0x21acdb9f
  .word 0x05f57017
  .word 0x20d77c19
  .word 0xea26bb96
  .word 0xdf102dd7
  .word 0x8d84446b
  .word 0xc7ffc456
  .word 0xc368981a
  .word 0xe323b650
  .word 0x7a1cb8ca
  .word 0x8b476b4c
  .word 0xb1cdcdb8
  .word 0x4d6fb8f4
  .word 0x9f8c3d48
  .word 0x5e98e961
  .word 0xf052f9a5
  .word 0x641e9c50
  .word 0xd68b1ce8
  .word 0x253a4a4b
  .word 0xde595162
  .word 0x53b68cea
  .word 0x81b1dd87
  .word 0x331a327f
  .word 0x060eb2f2
  .word 0x2bc24d20
  .word 0x89d4ae4a
  .word 0x08086308
  .word 0x21b9b67c
  .word 0x27f07b57
  .word 0x547deccd
  .word 0xb59f9a56
  .word 0xd097f89c
  .word 0x2d91f45f
  .word 0x8e3b1eb6
  .word 0x6f54ca8d
  .word 0x95ca8b89
  .word 0x96fd0ac8
  .word 0x150e6126
  .word 0x4dabfa22
  .word 0x5bb243cb
  .word 0x1cfc20dd
  .word 0x36f014f1
  .word 0xa1342d10
  .word 0x29c0e886
  .word 0x6e6b14e5
  .word 0x58b24897
  .word 0x89914df6
  .word 0xbe058ced
  .word 0x2f8cb4af
  .word 0xf7a2c3c5
  .word 0x87f2adbb
  .word 0xd78698cb
  .word 0x15aa9338
  .word 0x1b141210
  .word 0x9a5190c1
  .word 0x01d6393d
  .word 0x5db46471
  .word 0xc74c0bca
  .word 0xc705f4eb
  .word 0x50c5a8aa
  .word 0x7aae68c3
  .word 0x58124ad9
  .word 0xabc3de80
  .word 0xf5004388
  .word 0x5583cc15
  .word 0xfb975d08
  .word 0x08371dda
  .word 0xc5d8f0a1
  .word 0xf9f00597
  .word 0x4c6aafa2
  .word 0xef2fa80c
  .word 0xe27ce3b2
  .word 0x2c8b8c4b
  .word 0x002caff7
  .word 0xbc1e7c4d
  .word 0x54c6ebe5
  .word 0x13538b40
  .word 0xa8ace4ca
  .word 0x9f9ab2e8
  .word 0xf3261e19
  .word 0x516e77c4
  .word 0xc8d4b8b8
  .word 0xadd1eb5e
  .word 0x4cf5e378
  .word 0xa323e73c
  .word 0x761698e4
  .word 0x3dd72c8f
  .word 0x4ac92158
  .word 0x793aa581
  .word 0xf5c55d45
  .word 0x3a0740da
  .word 0xca79a4f0
  .word 0x5699b210
  .word 0x9b560887
  .word 0xcc3b1524
  .word 0x6f3b9c80
  .word 0xb1c2823d
  .word 0x62909023
  .word 0x2768fab5
  .word 0x271901fd
  .word 0x3d1189f4
  .word 0x9d97d22b
  .word 0xcb190235
  .word 0x16a72ed6
  .word 0x02da7b32
  .word 0x598a4b00
  .word 0x5f3f2da2
  .word 0xea44f8ea
  .word 0x8e02c5c5
  .word 0x445ff4bd
  .word 0x5d277dda
  .word 0xded627a4
  .word 0x757c1608
  .word 0x89d4efba
  .word 0x7a1c92f5
  .word 0x8c9ad4bb
  .word 0x9039758c
  .word 0xe0e9b3ef
  .word 0xf1f86197
  .word 0xafab5678
  .word 0x0c102a90
  .word 0xad9d68d6
  .word 0xfd3a5a6d
  .word 0xed804e76
  .word 0xe014a08b
  .word 0xe0b8f7f3
  .word 0x8baac7d4
  .word 0x0def09b1
  .word 0x11359333
  .word 0x171f123a
  .word 0x92fe973e
  .word 0x252197fa
  .word 0x2e320b70
  .word 0x78898b12
  .word 0x6edf6f3b
  .word 0xa04051ef
  .word 0xf76e0a66
  .word 0x32a783d2
  .word 0x6c68854d
  .word 0x7acbd078
  .word 0x8ab279cf
  .word 0xf5fbd543
  .word 0x0df001aa
  .word 0xe8e059d0
  .word 0x0c41e78d
  .word 0x1ff3968e
  .word 0xf2fb6f60
  .word 0x6c5964d0
  .word 0xcb068a3b
  .word 0x392971d2
  .word 0x590c5339
  .word 0xe7983c2c
  .word 0xcb9b8506
  .word 0xe1cdcb33
  .word 0x868eaba0
  .word 0x0e0e21c5
  .word 0xc54442b7
  .word 0x3e89dc27
  .word 0x1de723f1
  .word 0x1efa7d90
  .word 0x520d866f
  .word 0x0ed86c14
  .word 0x4d205c57
  .word 0xa757fb74
  .word 0x47c49753
  .word 0xf407980a
  .word 0x284e4cf2
  .word 0x4104552e
  .word 0x5b2530bb
  .word 0x292404a4
  .word 0x18702be2
  .word 0x88ce8f04
  .word 0x04f91a42
  .word 0x5c718243
  .word 0x418dc739
  .word 0x13b143a5
  .word 0x3e04d9ca
  .word 0xc762a8a1
  .word 0x26e203a3
  .word 0xa598e2ed
  .word 0x797cf499
  .word 0xdf286694
  .word 0x39e19c0c
  .word 0x3ac22c2a
  .word 0xb3f3206a
  .word 0x96b7a104
  .word 0xb783a69b
  .word 0x5b645ca5
  .word 0xfb96f423
  .word 0x6b363fb2
  .word 0x99d9b5a3
  .word 0x118a9900
  .word 0xf8fcb0b9
  .word 0x88af6a64
  .word 0xe2b84436
  .word 0x47601f44
  .word 0xc558acda
  .word 0x44ad97c4
  .word 0x25f04790
  .word 0xa9c38a47
  .word 0x46e52e49
  .word 0xcf27e386
  .word 0x7611b95b
  .word 0x8fbe79ad
  .word 0x9afd1617
  .word 0x1dfe589d
  .word 0x48615058
  .word 0x7d577839
  .word 0x2d6712a4
  .word 0xe9600068
  .word 0x6d270449
  .word 0x7e0cbc3f
  .word 0xde770d3e
  .word 0x3eb089c6
  .word 0x0d43501e
  .word 0x67623ceb
  .word 0x06151481
  .word 0x08d63fdc
  .word 0x7f813978
  .word 0x28ba4840
  .word 0x2d13a34c
  .word 0x496a7ba7
  .word 0xaab836e5
  .word 0x96e94fbc
  .word 0xd5d3d831
  .word 0x897b61a7
  .word 0xba612094
  .word 0x30ff963e
  .word 0x95d8b599
  .word 0xce6118f3
  .word 0xd2d54bba
  .word 0xd3f57037
  .word 0xce949f7b
  .word 0x75494140
  .word 0x557a46a5
  .word 0xa0a0b1b0
  .word 0xbd5f8d13
  .word 0x26e8c48b
  .word 0xf3e352f9
  .word 0xc74d1ccb
  .word 0x4b44b3a7
  .word 0xabb33efe
  .word 0x4e21192b
  .word 0x16bda9db
  .word 0xf4469adc
  .word 0x5a9e7a2d
  .word 0x6d8551d4
  .word 0x41f4d286
  .word 0xe70adea5
  .word 0xb8027c97
  .word 0x439ed830
  .word 0x1493b057
  .word 0x19a4872f
  .word 0x8c4ba712
  .word 0x60139c58
  .word 0x55ac60b2
  .word 0x0c51916f
  .word 0x2426c6c4
  .word 0x11071db9
  .word 0x3e4cd8ff
  .word 0x029ef078
  .word 0xeee91c9e
  .word 0x37f91ade
  .word 0xf6ae9966
  .word 0xb2a1583f
  .word 0x73af75c3
  .word 0x6bac7795
  .word 0xde051840
  .word 0x4a6c121f
  .word 0x8d25fb7f
  .word 0x9e6e6146
  .word 0x96de7a96
  .word 0xb7bb81c5
  .word 0xa16d8a54
  .word 0x7553e245
  .word 0x77e2988a
  .word 0xd6947099
  .word 0x33e60a66
  .word 0x42a667c0
  .word 0x04399d89
  .word 0xfeeeeff9
  .word 0xf0f85f04
  .word 0x774f7b12
  .word 0xf93c57d7
  .word 0xa46a1dc6
  .word 0x3965d13e
  .word 0x67931540
  .word 0x567a6aa1
  .word 0x635108d9
  .word 0x710d1b41
  .word 0xd93a604b
  .word 0xe71eadff
  .word 0x03d6687b
  .word 0x1fcc63a6
  .word 0x6e6c0a3f
  .word 0xe4d8ea0a
  .word 0x025b62bd
  .word 0x0854dd24
  .word 0xdc6a0b4e
  .word 0x4aea4723
  .word 0x777d4fb3
  .word 0xbc146b28
  .word 0xf9715352
  .word 0xb6c8a542
  .word 0x768aa5d9
  .word 0x412dd208
  .word 0x76593e7d
  .word 0x6f4f9f5f
  .word 0xc2784133
  .word 0xda943d8a
  .word 0x8726f1fa
  .word 0xbda30ccc
  .word 0xadbebafa
  .word 0x202274e2
  .word 0x61f6b30b
  .word 0x8d8f6dd0
  .word 0x468b06a0
  .word 0x14382fc7
  .word 0x1c8ddb57
  .word 0xe5f6c11f
  .word 0xd635f60b
  .word 0xeabfa92a
  .word 0xe1b15e76
  .word 0xe4278152
  .word 0xf944fa48
  .word 0x7872c9e7
  .word 0xbe27658e
  .word 0xe6ccc702
  .word 0x8b01c679
  .word 0xb7fc0e5d
  .word 0x3d936ab8
  .word 0x9f3ed7d0
  .word 0xfa4f5dc4
  .word 0x59d8d16a
  .word 0xd089e6c4
  .word 0xb9fe82c0
  .word 0x42e5321e
  .word 0x67f89b77
  .word 0x841ce319
  .word 0x0dc4868e
  .word 0xe2c73b18
  .word 0xeba54ca3
  .word 0xfb5a2fea
  .word 0x094e5f48
  .word 0x30ce43ac
  .word 0x294c1acb
  .word 0x478876a9
  .word 0xc3d72c5b
  .word 0xf04aaf56
  .word 0x990a068c
  .word 0x1e9e8cff
  .word 0x569465af
  .word 0x0119b6cc
  .word 0x8997ebb2
  .word 0x55d35665
  .word 0x12e8bfb9
  .word 0xe126752d
  .word 0xb9c78294
  .word 0x0040dae7
  .word 0xf3f81023
  .word 0xc19d2345
  .word 0xb992f211
  .word 0x99586071
  .word 0x32d6a6f0
  .word 0x76649ec1
  .word 0x457a4a1c
  .word 0xcb36fcb5
  .word 0x478b1ca5
  .word 0xdffe4fde
  .word 0x9338e6d6
  .word 0xd9ee5183
  .word 0x477c47f0
  .word 0x5d06e7e4
  .word 0x8ba2315e
  .word 0xe1edc908
  .word 0xb2ff61d7
  .word 0xebbf341c
  .word 0x6015c6cc
  .word 0x05a71edb
  .word 0x21f6ed76
  .word 0x4930276f
  .word 0x769503e3
  .word 0xbbafd998
  .word 0x8f984e48
  .word 0x4c9e7386
  .word 0x11cfa8c7
  .word 0x0a5def4b
  .word 0xa62f769c
  .word 0x176e49e1
  .word 0x4e0b6d2e
  .word 0x216e5e18
  .word 0xa8f9dd81
  .word 0x4b65502b
  .word 0xf0ee8c2b
  .word 0x693125c5
  .word 0x73fb50d3
  .word 0xe99b9458
  .word 0x4b7d77e3
  .word 0xbd1b5b87
  .word 0x448fadb6
  .word 0x32b2f932
  .word 0xa3e40054
  .word 0x63a32815
  .word 0x17c76280
  .word 0x616455e0
  .word 0xa75bf3b1
  .word 0x3ae92e6b
  .word 0xb5db381a
  .word 0x697bb107
  .word 0xf16b5a68
  .word 0x13289490
  .word 0x12dfa032
  .word 0x3659cf93
  .word 0x46fe6d7c
  .word 0x32552011
  .word 0x77b6ea83
  .word 0xda05f07b
  .word 0x7bb88f29
  .word 0x924e5fc5
  .word 0xc333f4bf
  .word 0xe0e5a00c
  .word 0xafd18d33
  .word 0x5780a75d
  .word 0xef5619a7
  .word 0x18decdc8
  .word 0x9a57d5c0
  .word 0x84fa652b
  .word 0x22924e42
  .word 0x8c436e6c
  .word 0x1d21c44d
  .word 0x940a9127
  .word 0x80cfbb2d
  .word 0x54dea2ab
  .word 0xbf52280c
  .word 0x7fcf163d
  .word 0xf35377c6
  .word 0x2219fc51
  .word 0x2bc3748a
  .word 0xb659fadb
  .word 0x6871a81f
  .word 0xb70c490d
  .word 0x052cac73
  .word 0x5b605b62
  .word 0x2c7046cb
  .word 0xf39e75d1
  .word 0x6aafacb0
  .word 0x568521a6
  .word 0xc32986ff
  .word 0xbc1218f0

.globl message
message:
  .word 0xa9eeb13c
  .word 0x934b0088
  .word 0x0afb3c10
  .word 0x682afdee
  .word 0x4afa016e
  .word 0x63a3e858
  .word 0xe3a1a89c
  .word 0xe257aef9
  .word 0x87ccb835
  .word 0x62dc233c
  .word 0x1660d2b8
  .word 0x752ffa9a
  .word 0x586a91ab
  .word 0x889174d9
  .word 0x6a5ed235
  .word 0xb2855043
  .zero 3132
/* account for longer messages in the tests */

.globl messagelen
messagelen:
  .word 0x00000040

  .zero 41056
stack_end:

#elif DILITHIUM_MODE == 5
.global stack
stack:
    .zero 2368 /* STACK_SIZE + STACK_SIGNATURE */

.globl signature
signature:
  .zero CRYPTO_BYTES
  .zero 13

.zero 32768 /* STACK_SIZE + STACK_MAT - (CRYPTO_BYTES + 13) - 9536 */

.globl sk
sk:
  .word 0x3afd5356
  .word 0x4bce1420
  .word 0x7ffebe0a
  .word 0x2c86f84a
  .word 0x72ec511b
  .word 0x456b98f7
  .word 0xf6f867e9
  .word 0x1af94cd5
  .word 0x2a4ceb8e
  .word 0x3352ec62
  .word 0xe5ae73f9
  .word 0x6dfe1d10
  .word 0x62a937e3
  .word 0x9e51bf69
  .word 0x9948a641
  .word 0x59f8dca4
  .word 0x0db0ae47
  .word 0xffcd2bdb
  .word 0xeb0ee4e1
  .word 0x100c40af
  .word 0x810840f6
  .word 0x567e9804
  .word 0x8e865c7d
  .word 0x6e3673cb
  .word 0x0f4a753f
  .word 0xb8f01958
  .word 0x54cb1db5
  .word 0xa4baef2a
  .word 0xd20f41aa
  .word 0xf2995201
  .word 0xce847dd9
  .word 0x25abcc61
  .word 0xcc220241
  .word 0x26039244
  .word 0x4a221991
  .word 0x9a4d364a
  .word 0x32881140
  .word 0x8900d331
  .word 0x436a3644
  .word 0x93148a12
  .word 0x71164a80
  .word 0x1b654858
  .word 0xa4632c44
  .word 0x20104361
  .word 0xcc619619
  .word 0x37096c44
  .word 0x70809132
  .word 0xa3492222
  .word 0x885b0e46
  .word 0x84169248
  .word 0x224d028b
  .word 0x966060c8
  .word 0x89828b51
  .word 0x4b32131a
  .word 0xb3092808
  .word 0x66389029
  .word 0xd484390a
  .word 0x44c07186
  .word 0x86364b04
  .word 0x0c0d26c0
  .word 0x06188484
  .word 0x5217090e
  .word 0xe02c021b
  .word 0xb6c34212
  .word 0x09a41245
  .word 0x1c699862
  .word 0x240300c0
  .word 0x1106c262
  .word 0x5140c222
  .word 0x16c80992
  .word 0x24b24844
  .word 0x180c0123
  .word 0x008c4d10
  .word 0x44460849
  .word 0x54608902
  .word 0x30930508
  .word 0x20864930
  .word 0x0a048103
  .word 0xc89b2e27
  .word 0x42490228
  .word 0xd1204243
  .word 0x16e48036
  .word 0x4a34d92e
  .word 0x21290263
  .word 0x80236887
  .word 0x4a005b4c
  .word 0x1c2c1304
  .word 0x169c8da5
  .word 0x25c0d432
  .word 0xdb8a0651
  .word 0x06604428
  .word 0x69169140
  .word 0xd98ca2c4
  .word 0x301b6880
  .word 0x2d425c92
  .word 0xcb6c92d4
  .word 0x12830a00
  .word 0x10b08906
  .word 0x1321b04b
  .word 0x48142dc0
  .word 0x05425170
  .word 0x1a04985b
  .word 0x82820534
  .word 0x60208b89
  .word 0x0410a812
  .word 0x032485a1
  .word 0x3048c08c
  .word 0xd9884010
  .word 0x41242c84
  .word 0x8d46db05
  .word 0x4b48a65c
  .word 0x16006ca8
  .word 0x01891828
  .word 0x5148004b
  .word 0x44180e42
  .word 0x6c912100
  .word 0x216d181c
  .word 0x304b0142
  .word 0x69932100
  .word 0x982048da
  .word 0x34196642
  .word 0x2448844a
  .word 0x4424c2d9
  .word 0x34804a40
  .word 0x4a00e269
  .word 0x22462280
  .word 0x31098a01
  .word 0x30169a42
  .word 0x9b224052
  .word 0xc44c8c80
  .word 0x0cb90c84
  .word 0x0040b0d0
  .word 0x268128c2
  .word 0x42171281
  .word 0x406a125a
  .word 0x90621046
  .word 0x06131945
  .word 0x1028a023
  .word 0xc25390c9
  .word 0x61191c90
  .word 0xc36004a3
  .word 0x20e444c2
  .word 0x68c31942
  .word 0x236a2692
  .word 0xb7144a40
  .word 0x81a4da29
  .word 0x1842350c
  .word 0x48d36898
  .word 0x89a6888a
  .word 0x9c681043
  .word 0x401b2636
  .word 0x49b48181
  .word 0x8172421c
  .word 0x86003104
  .word 0x8580c32c
  .word 0x00809060
  .word 0x06cc6c93
  .word 0x44b1040a
  .word 0x4b308649
  .word 0x82191186
  .word 0x8190d82d
  .word 0xd80da203
  .word 0x84415238
  .word 0x71a90465
  .word 0xdc8dc50a
  .word 0x48982da0
  .word 0x44466009
  .word 0x492a1091
  .word 0xc0a18638
  .word 0x2a072270
  .word 0x91518891
  .word 0x84522db8
  .word 0x0c485928
  .word 0x1490b708
  .word 0xa2a169b2
  .word 0x48a4d988
  .word 0x1c0d9804
  .word 0x230a6087
  .word 0x44a2e221
  .word 0xe36e4311
  .word 0xa21a8494
  .word 0x65c86269
  .word 0xc0313608
  .word 0x440c2088
  .word 0x24949c08
  .word 0xc14e280c
  .word 0xb6046086
  .word 0x84052090
  .word 0x59442519
  .word 0x430960c4
  .word 0x6ca02052
  .word 0x20308661
  .word 0x985b6189
  .word 0x2d48584d
  .word 0x6430b681
  .word 0x36c48198
  .word 0x8c18a291
  .word 0x01423061
  .word 0xa4db61c8
  .word 0x00830080
  .word 0x816c08c2
  .word 0x870061c6
  .word 0x0db04401
  .word 0x404a1260
  .word 0x471b4824
  .word 0x20b85906
  .word 0xd12e30a0
  .word 0x460c84b2
  .word 0x9226500a
  .word 0x816ca699
  .word 0x03014cc6
  .word 0x31a29160
  .word 0x2401b85c
  .word 0x32980641
  .word 0x6132db20
  .word 0x9149c211
  .word 0x91144492
  .word 0x3192904c
  .word 0x510092c4
  .word 0xa6540ca0
  .word 0x21a71888
  .word 0xd1821491
  .word 0x03024d90
  .word 0x6c90cb86
  .word 0x082a1853
  .word 0x80197145
  .word 0x60221b0c
  .word 0x10008850
  .word 0x968a6e14
  .word 0x66322068
  .word 0x20862101
  .word 0x16e469c4
  .word 0x0db8e268
  .word 0x0c61c490
  .word 0x388a30b7
  .word 0x66302160
  .word 0xe2509652
  .word 0x46116a26
  .word 0x81b20450
  .word 0x008c3018
  .word 0x10628a28
  .word 0x32484a10
  .word 0x5b02211b
  .word 0xc8e26c34
  .word 0x29b20089
  .word 0x4a0a3883
  .word 0x06504888
  .word 0x6426e272
  .word 0x24720024
  .word 0x985b4991
  .word 0x04025991
  .word 0x1c62008c
  .word 0xb31a8448
  .word 0x45141811
  .word 0x2404c100
  .word 0x08624085
  .word 0x0ca21401
  .word 0xd8054522
  .word 0xc4e00ca4
  .word 0x3236a411
  .word 0x8a48a600
  .word 0xc08b0440
  .word 0x61b6244d
  .word 0x22091291
  .word 0x39094623
  .word 0x28a90184
  .word 0x5c854813
  .word 0xa8d46512
  .word 0x09905b80
  .word 0x0950c2a3
  .word 0x88014081
  .word 0x84464888
  .word 0x1190c4cc
  .word 0x820188b5
  .word 0x2a20408d
  .word 0x0a10a808
  .word 0x10c42e45
  .word 0x4db6e146
  .word 0x9188320c
  .word 0x210b4996
  .word 0x01c68072
  .word 0x5b0496d0
  .word 0x32417088
  .word 0x01180810
  .word 0x810186c9
  .word 0xa4cb7026
  .word 0x28249828
  .word 0x1371c899
  .word 0x21218d48
  .word 0x09341912
  .word 0x1a844320
  .word 0x94a27193
  .word 0x6a169188
  .word 0x4a208714
  .word 0x90ca0ca8
  .word 0x4da69311
  .word 0xd888129b
  .word 0x17122a36
  .word 0x9000e446
  .word 0x008d1049
  .word 0x44e40c80
  .word 0x1010a368
  .word 0x2490a2a2
  .word 0x262270b7
  .word 0x04125245
  .word 0x9c6116da
  .word 0x148c4026
  .word 0x85820891
  .word 0xc844c089
  .word 0x28428a44
  .word 0x88292240
  .word 0x1c842498
  .word 0x06115041
  .word 0x41361b10
  .word 0x8971309b
  .word 0x90dc6020
  .word 0x00921250
  .word 0x8964190c
  .word 0x126264a0
  .word 0x4da72226
  .word 0x9871484a
  .word 0x42045102
  .word 0x6530a128
  .word 0x4880a8e2
  .word 0x28e38432
  .word 0x0ca6d440
  .word 0x5b24a2c0
  .word 0x48203234
  .word 0x4da25b2d
  .word 0x24264652
  .word 0x28d98237
  .word 0x85268908
  .word 0x014c3919
  .word 0x01101246
  .word 0x5040cb52
  .word 0x511212c8
  .word 0xb51b2990
  .word 0x4a480a8d
  .word 0xe40984c1
  .word 0xb85a6cc8
  .word 0x30c29369
  .word 0xd3010521
  .word 0x46908db0
  .word 0x25032126
  .word 0xd00d101c
  .word 0x39088848
  .word 0x2902cb01
  .word 0x91044092
  .word 0x031a0486
  .word 0x84a51288
  .word 0x21094290
  .word 0xa4546189
  .word 0x70032448
  .word 0x98101691
  .word 0x80948520
  .word 0x28948329
  .word 0x1b8e2454
  .word 0x22099045
  .word 0x10c0424a
  .word 0x63911844
  .word 0x18940e32
  .word 0x4e305489
  .word 0x83302880
  .word 0x429a30c2
  .word 0x9086c321
  .word 0x5b2a2612
  .word 0xb04b28a4
  .word 0x8504a205
  .word 0xdc4ca499
  .word 0x48900e20
  .word 0x60b88426
  .word 0x092e38d3
  .word 0x48849015
  .word 0x84b41a28
  .word 0x588e484b
  .word 0x22647046
  .word 0x01c02346
  .word 0x0c09c302
  .word 0x16128c44
  .word 0x11c31870
  .word 0x10649658
  .word 0x385a2593
  .word 0x4e470952
  .word 0x1b289300
  .word 0x40da60b1
  .word 0x05c24362
  .word 0x40004104
  .word 0x80884834
  .word 0x00a6c16d
  .word 0x0170a913
  .word 0x84190dc1
  .word 0x0e020029
  .word 0x14d1e314
  .word 0xde48e729
  .word 0x403cf727
  .word 0xb5711081
  .word 0xb9c33109
  .word 0x39a31a87
  .word 0xa9ebb7b2
  .word 0x1971a8cb
  .word 0x4f9ec0bf
  .word 0x4f8b8a5d
  .word 0xb6543e58
  .word 0xa02eba8f
  .word 0x984ba798
  .word 0xddd491a4
  .word 0x7cb3c182
  .word 0x1994db68
  .word 0x3fe0cfe3
  .word 0xa5de76f9
  .word 0x3c6ea659
  .word 0xa306d2c8
  .word 0x5f3ab488
  .word 0x3ce1f53f
  .word 0x1078811b
  .word 0x6afb35f1
  .word 0x231f7b50
  .word 0x8a674508
  .word 0xfb2357fe
  .word 0x71324023
  .word 0xf24753b9
  .word 0xc0b2db65
  .word 0x6f767e23
  .word 0x4c444911
  .word 0xa8104330
  .word 0xc4b4e0b1
  .word 0x610a09a4
  .word 0x81cdc97f
  .word 0xe8ae2540
  .word 0x2d9c9c5c
  .word 0xeb7f51ed
  .word 0x33a89a7f
  .word 0x785375d5
  .word 0xbb96e85f
  .word 0xe6d394af
  .word 0x67ff49df
  .word 0x7135d8c6
  .word 0xe4f72788
  .word 0x7f8ca81c
  .word 0xa2fc88a4
  .word 0xe32a70f8
  .word 0xb1319d67
  .word 0xfd4e6402
  .word 0x9d735992
  .word 0xb06d9808
  .word 0x5f2226ac
  .word 0x16402b73
  .word 0x8f679c50
  .word 0x7ecb0290
  .word 0xd633f9a5
  .word 0xfe802c67
  .word 0xfb3e125a
  .word 0xb56fac18
  .word 0xaf462778
  .word 0x78cb969c
  .word 0x0e99bfec
  .word 0x85b81b3e
  .word 0x4504d8f4
  .word 0xc1a989e0
  .word 0x3f0b83c6
  .word 0xe52133be
  .word 0xbc57c99b
  .word 0x6b7107f0
  .word 0x88fead47
  .word 0xfaf17692
  .word 0x32e6b83d
  .word 0xf61c363a
  .word 0x9775b4c8
  .word 0x2380c57e
  .word 0x550d1704
  .word 0x50bfe379
  .word 0x68ad4d45
  .word 0xace8ad06
  .word 0xd72d0ab8
  .word 0xc882b54e
  .word 0x9c143fc2
  .word 0x7bab8a81
  .word 0x06d0b73b
  .word 0x11771483
  .word 0x9c78c177
  .word 0x827768a4
  .word 0x64ca247e
  .word 0x54949149
  .word 0x927e7ea2
  .word 0xc64221f2
  .word 0x23ace760
  .word 0xa1099240
  .word 0xc39614a4
  .word 0x3d9c6a14
  .word 0x14e607bd
  .word 0x15754550
  .word 0xa70f5285
  .word 0xf75cb5fc
  .word 0xb0ba1d2e
  .word 0xccf56f23
  .word 0x02497405
  .word 0xee1339a7
  .word 0xd2d31101
  .word 0x9c2b6eae
  .word 0x80f535c9
  .word 0xa3188e52
  .word 0xfd3632a5
  .word 0x8cec1b4f
  .word 0xa1abf728
  .word 0x720e1b78
  .word 0xa9a80476
  .word 0xc5d30934
  .word 0x7373c06b
  .word 0xfa6cb850
  .word 0xc38c6b1a
  .word 0x3490997a
  .word 0x663f2bff
  .word 0xaffe53e7
  .word 0xcd954168
  .word 0x8e6e6b95
  .word 0xf1637522
  .word 0x86d16248
  .word 0xa9bf71d5
  .word 0xde38b77b
  .word 0xc94dd2a8
  .word 0x4cb4f707
  .word 0x8a235262
  .word 0xa17d055c
  .word 0xebffbf09
  .word 0xa2e9e1e4
  .word 0x54cea797
  .word 0x685be744
  .word 0x2626582b
  .word 0x1299f0b3
  .word 0x27af293b
  .word 0x20878e06
  .word 0x2406cd6e
  .word 0x383b714e
  .word 0x81739e3e
  .word 0x7fee8069
  .word 0x8747f9c6
  .word 0x06134866
  .word 0x3e53465f
  .word 0xcb64c2ed
  .word 0x25e15d28
  .word 0xf491b141
  .word 0x3210367f
  .word 0x84458f1d
  .word 0x3ae9e5da
  .word 0xa1c77526
  .word 0xdb0f8c5a
  .word 0x1ceee573
  .word 0x00df6d3d
  .word 0x48386a67
  .word 0x24de829c
  .word 0x86cc2e72
  .word 0xb0caef29
  .word 0x1ea499a1
  .word 0x8ada99dc
  .word 0x75b83362
  .word 0xc15f8b6c
  .word 0x3fe987d8
  .word 0xacb26c98
  .word 0xc9a7cf4f
  .word 0x532df9f4
  .word 0x31aa797e
  .word 0x4c7c1155
  .word 0x3c2bb871
  .word 0x473b0ecd
  .word 0x04bd92d3
  .word 0x49d83308
  .word 0x556ce09c
  .word 0x8ff55393
  .word 0xf58f0820
  .word 0x8789ea95
  .word 0x0495910f
  .word 0xd4b1d455
  .word 0x2a8cf6af
  .word 0x78e7346b
  .word 0xed650702
  .word 0xe29046ac
  .word 0x79b095e8
  .word 0x51291011
  .word 0x598735d2
  .word 0x81088256
  .word 0xf572557b
  .word 0x091069cf
  .word 0x3b9a6a28
  .word 0x47043312
  .word 0xae693d6b
  .word 0x82e73263
  .word 0x551b65a8
  .word 0x0c801603
  .word 0xd4950acb
  .word 0x2590f734
  .word 0x4aff9e79
  .word 0x6b0a2948
  .word 0x079f588b
  .word 0xaca519d0
  .word 0x8f6dcaac
  .word 0x8a37769f
  .word 0x94e4bc50
  .word 0x961da445
  .word 0x9d900999
  .word 0xc975cd95
  .word 0x91f090bf
  .word 0xf1ceae5c
  .word 0xd57dede8
  .word 0xfe74c641
  .word 0xf192e5a9
  .word 0xdd7dfb12
  .word 0xe8dd0783
  .word 0x6f52807f
  .word 0x9d1dbe43
  .word 0x35c0e4e8
  .word 0x7507ff35
  .word 0xf8d3c770
  .word 0x29f7b48b
  .word 0xcd397c09
  .word 0x9dbeb1d8
  .word 0xc30c3568
  .word 0x0ea830d3
  .word 0x04777e2a
  .word 0x06a2355f
  .word 0xff2321d7
  .word 0x63b668a2
  .word 0xd920e17b
  .word 0xc6dfa6e8
  .word 0x4bbf1a03
  .word 0xc6596934
  .word 0xe2b60078
  .word 0x11c81eb3
  .word 0x20ccd2a9
  .word 0x7cffbf8c
  .word 0x030991cb
  .word 0xff405e52
  .word 0x7639d7f8
  .word 0xace20986
  .word 0x54800122
  .word 0xab895b02
  .word 0xde7ecc09
  .word 0x7edf9361
  .word 0xfb000322
  .word 0x493f5b64
  .word 0x8c88c118
  .word 0x88264cda
  .word 0x4cad5ecf
  .word 0x7dcfa4da
  .word 0xea06c995
  .word 0x58cfc1bb
  .word 0x770994e4
  .word 0xdc684416
  .word 0x85d988d4
  .word 0xda069de0
  .word 0xe5fdc0eb
  .word 0xff6bb9e2
  .word 0xcd9f92f0
  .word 0x56eb6434
  .word 0x90646f00
  .word 0x6f9de04e
  .word 0x528d7335
  .word 0xb7b2b03b
  .word 0x224b57c1
  .word 0x02365e10
  .word 0x1aab9d98
  .word 0xd0d559da
  .word 0x9d2200b5
  .word 0xf22239cb
  .word 0xaee13722
  .word 0x7c8caae5
  .word 0x8841d554
  .word 0x1b33604b
  .word 0x77870819
  .word 0x97071c94
  .word 0x6d13e4d2
  .word 0x7367133a
  .word 0x19ac5ecb
  .word 0x06ee87fd
  .word 0x34ac38a9
  .word 0xb5d8f11a
  .word 0x23bf7698
  .word 0x85a8cbb8
  .word 0x4bcd7160
  .word 0x1b74514c
  .word 0x61a2fae8
  .word 0xf8914a4c
  .word 0x0112db64
  .word 0x5ea924b1
  .word 0x27ca6c08
  .word 0x261bda5e
  .word 0x1c3f18f5
  .word 0x68a602f2
  .word 0x8eeadd96
  .word 0x8cb3f9ff
  .word 0xba01926a
  .word 0xda679ec8
  .word 0xc62e148a
  .word 0x5e892eb9
  .word 0x0637f959
  .word 0x7e65caf9
  .word 0xc941ea40
  .word 0x22eff936
  .word 0xea89707c
  .word 0x1de4147b
  .word 0xde9b86ea
  .word 0xdea3a36b
  .word 0x7b42ca54
  .word 0x8f78ce8b
  .word 0xc6699011
  .word 0x376297a7
  .word 0xe0200bf3
  .word 0xcd825f95
  .word 0x7e1d352f
  .word 0xfbc228bc
  .word 0x9ce6bb90
  .word 0x2669622d
  .word 0x627175f4
  .word 0x6a528de1
  .word 0x62d6f725
  .word 0xb1b40672
  .word 0x863ccb54
  .word 0x4bba1204
  .word 0xdadf02b1
  .word 0xd65cdb51
  .word 0xb8c832de
  .word 0xba1ccb0c
  .word 0x6f45ae23
  .word 0x8ab3ef31
  .word 0xcdecc35a
  .word 0x15aca429
  .word 0xd7b7cc15
  .word 0xf291ba0b
  .word 0x817cc446
  .word 0x6590ae2b
  .word 0xfcb36307
  .word 0x9444b3ad
  .word 0x11bc7bd9
  .word 0xd05ff784
  .word 0x1b82de17
  .word 0xd0230141
  .word 0x8a15c5f8
  .word 0xb5230c22
  .word 0xdfdea4dd
  .word 0xee7d34e4
  .word 0xbb017ca8
  .word 0x03422cb8
  .word 0x58a63b3d
  .word 0x841b430e
  .word 0xc50ff395
  .word 0x8c559bdd
  .word 0x296b1419
  .word 0x36ece238
  .word 0x2bd55c03
  .word 0x0c2b2f6c
  .word 0x10aee2a5
  .word 0xa7edef37
  .word 0xaa57ef74
  .word 0x67a16f1c
  .word 0xcfec579d
  .word 0x045aa9d8
  .word 0xacba0904
  .word 0x6928243f
  .word 0x78d13969
  .word 0x9b801584
  .word 0x91e26540
  .word 0x5ce3b6a8
  .word 0x1f20d921
  .word 0xfe11c0b4
  .word 0x6fa32e9a
  .word 0x76a588fa
  .word 0x6d9c6d9f
  .word 0x173c15e0
  .word 0xe456439b
  .word 0x388b05b1
  .word 0x2025d071
  .word 0x8b47531d
  .word 0xb965133d
  .word 0x43015359
  .word 0xb63dd16c
  .word 0x85c065c8
  .word 0xbb9cf714
  .word 0x49c61d6a
  .word 0xab7b59b4
  .word 0xa11372e1
  .word 0xced785ef
  .word 0xf466cfd6
  .word 0x41e40433
  .word 0xdbcc698c
  .word 0xc3533962
  .word 0xb2a8f03d
  .word 0xf04b1dca
  .word 0x2fd17ae9
  .word 0x623a69a9
  .word 0x00f186a1
  .word 0xd0a343d2
  .word 0x522ef652
  .word 0x63107c84
  .word 0x5e3df3fb
  .word 0x7ad7fbf8
  .word 0x2947e86c
  .word 0x5f273f5c
  .word 0x67c56ef5
  .word 0xb0466d3d
  .word 0x6bd7453c
  .word 0x6cd059a5
  .word 0x7ca7e29a
  .word 0x11994466
  .word 0x27007ea3
  .word 0xafe6b415
  .word 0x0a75e7d0
  .word 0x1348f4e6
  .word 0x3d71e7c4
  .word 0x6f9f8366
  .word 0xfe42fbcb
  .word 0xb4d78471
  .word 0x40d71a5d
  .word 0x877fc8e5
  .word 0x742dc51d
  .word 0x4abcbd8b
  .word 0x4849ce16
  .word 0x6e9da645
  .word 0x817384f8
  .word 0x40d5ee6e
  .word 0x999b678e
  .word 0x28aa9e5a
  .word 0xdd00ec2e
  .word 0x68002d02
  .word 0x38688beb
  .word 0x1506bd14
  .word 0xbde9b56e
  .word 0x0cefde8a
  .word 0xf1bd2940
  .word 0x3eaa0c1e
  .word 0x82475bfa
  .word 0x94524cbf
  .word 0x8a9c76f7
  .word 0x31d4679d
  .word 0xe220ee32
  .word 0x1fc7c15b
  .word 0x0530fa97
  .word 0x2064e3ed
  .word 0x95dbe6d5
  .word 0x3b5b1426
  .word 0xa6cc1e14
  .word 0xbca2e2d2
  .word 0x4e32c2a1
  .word 0x9b47f912
  .word 0x024fbd0b
  .word 0x6d61cf41
  .word 0x88d5cb28
  .word 0xc48e38b3
  .word 0x4ba48e37
  .word 0xb2986d34
  .word 0xc1dea2d4
  .word 0xb60223c7
  .word 0xd17664d0
  .word 0x675497df
  .word 0x46af9795
  .word 0x7c0a2583
  .word 0x254e5d67
  .word 0x9dae532f
  .word 0xfabdfc72
  .word 0x3a53a7fd
  .word 0x9e832834
  .word 0x8fec2b3c
  .word 0x2b6293fe
  .word 0xc2c9de2f
  .word 0x7bae9eaf
  .word 0x0a59aeae
  .word 0xaee7fddf
  .word 0xd6e6a68e
  .word 0x8aab70e7
  .word 0xda110f43
  .word 0x65e7da43
  .word 0xf2fc7654
  .word 0x59fe5635
  .word 0x9239ccb8
  .word 0x028e410e
  .word 0x8effd8f0
  .word 0x731a1bc4
  .word 0x98ce221e
  .word 0x628fc5c4
  .word 0x53de981a
  .word 0xe324dfeb
  .word 0xe07a1d99
  .word 0x1875463b
  .word 0xe6ec2fa4
  .word 0xc9665fbf
  .word 0x256a5283
  .word 0x00b8ae2a
  .word 0x8c3cdbef
  .word 0x4634e687
  .word 0x39272410
  .word 0xa84e40db
  .word 0xa26820d1
  .word 0x60c77f12
  .word 0x2cd4aaf0
  .word 0x08c85465
  .word 0x85ef63bb
  .word 0xb267d547
  .word 0x8d16c867
  .word 0xf831995a
  .word 0x3c3c73c8
  .word 0x5fea6b23
  .word 0x1b06ff18
  .word 0x56455369
  .word 0x12686fa4
  .word 0x07ee154d
  .word 0x3e9b5491
  .word 0xef41889e
  .word 0x40f862ab
  .word 0xbd1b85aa
  .word 0x3151f1d8
  .word 0x224cec5c
  .word 0x1a4d10a8
  .word 0x38e62e1c
  .word 0x93d90d3b
  .word 0x9cb9b64a
  .word 0x3431a51c
  .word 0x90adedd3
  .word 0x159788df
  .word 0xfdba4d1b
  .word 0xe38660cb
  .word 0x5944c8f3
  .word 0xbc979b0a
  .word 0x376968dc
  .word 0x3999e048
  .word 0xd1a1a917
  .word 0x57705290
  .word 0x9c550156
  .word 0x2f10b7f6
  .word 0xbddeee74
  .word 0x22cc8172
  .word 0x10e1c41f
  .word 0x76a4b5ec
  .word 0x14cc0253
  .word 0xb82f3b53
  .word 0x34b3c2f9
  .word 0x27e8eb02
  .word 0xa40d5554
  .word 0x7661e0e3
  .word 0xee60bee1
  .word 0xf01102c2
  .word 0x6d4dcc7e
  .word 0x0cc56001
  .word 0xc5d6701b
  .word 0x53781afc
  .word 0xd5821360
  .word 0xf2227269
  .word 0x4f08bf55
  .word 0xc9275781
  .word 0x5fe5ba7c
  .word 0x5b5608fd
  .word 0x396dcc0c
  .word 0x5e44d8a1
  .word 0x808917f7
  .word 0x24414b56
  .word 0x795c28e3
  .word 0x5699c61f
  .word 0xb8d2ba30
  .word 0x942fe2d6
  .word 0x8b433dd5
  .word 0xe2c66d6f
  .word 0xb625d694
  .word 0xbb04825c
  .word 0xb9f44bb1
  .word 0xa6081e93
  .word 0x6cdb7774
  .word 0x2efbec9d
  .word 0xac40595c
  .word 0x2af765fb
  .word 0x86d25ced
  .word 0x4a8b509e
  .word 0x74cded64
  .word 0x42aeb6fd
  .word 0xa1113ee5
  .word 0xdb9ab41f
  .word 0x564d8dd9
  .word 0xa35cf265
  .word 0x59f92b4f
  .word 0x4d466589
  .word 0x0e8fb765
  .word 0xbc726ca9
  .word 0xdf6b9b84
  .word 0xc917719e
  .word 0x9129c1f7
  .word 0xfcc896af
  .word 0x60f6aa97
  .word 0xee2de955
  .word 0xd21e5a32
  .word 0xc27be6b2
  .word 0x90984556
  .word 0x74e10a9b
  .word 0xe162f954
  .word 0x78a19cbb
  .word 0xa4a08edc
  .word 0x58f802a4
  .word 0x3d1ab07f
  .word 0x75271783
  .word 0x615f739b
  .word 0xca8cedf8
  .word 0x907d8a07
  .word 0x70772971
  .word 0xcb56db16
  .word 0xfd1ca181
  .word 0xfdf82bfc
  .word 0x5dd67629
  .word 0x659ca0b6
  .word 0x64717f06
  .word 0x05e77e4c
  .word 0xa6d528d5
  .word 0xa1c27808
  .word 0x9af64b7c
  .word 0x928fdafc
  .word 0x1b2413c3
  .word 0x40fbcf7e
  .word 0xc4ea54b2
  .word 0x948f11cf
  .word 0x50147cb9
  .word 0x9b8988ac
  .word 0x022e3fd7
  .word 0x716c8309
  .word 0x1e906a68
  .word 0x880264b7
  .word 0xfe6d57f8
  .word 0xc51d0b6d
  .word 0x594c408f
  .word 0xce380c88
  .word 0xd582fa50
  .word 0xb97a247c
  .word 0x66cdf481
  .word 0x864aed55
  .word 0x0b11dd2e
  .word 0x17260b4b
  .word 0xa3db9a62
  .word 0x2cfbcd99
  .word 0x605c60ce
  .word 0xcf85d5f4
  .word 0x5282c254
  .word 0x70b0fd66
  .word 0xf099f99b
  .word 0xc7758da6
  .word 0x9ac11cda
  .word 0x3a2e4890
  .word 0xdc7b1c82
  .word 0x234f30fd
  .word 0x54bbb2e6
  .word 0x90913c80
  .word 0xdf8ee003
  .word 0x10248746
  .word 0x8134a5db
  .word 0x249691cf
  .word 0x4f5900cc
  .word 0x325182e9
  .word 0x3469d0fa
  .word 0xd0481ea8
  .word 0xec9de5fe
  .word 0x3a5e37b2
  .word 0xbf554df5
  .word 0x971a091f
  .word 0x872b0aec
  .word 0x9bcd1e5d
  .word 0x93bc4782
  .word 0x917b284d
  .word 0x18a0eb59
  .word 0xc60a3b1b
  .word 0x6e50806f
  .word 0x8d761b2e
  .word 0xc244bb12
  .word 0x1d60a893
  .word 0x6bfa7444
  .word 0x0fda68b6
  .word 0x1b02701f
  .word 0x4864b7b3
  .word 0x6b1d59fb
  .word 0x61ba1f4a
  .word 0xd0d2f4ae
  .word 0x8b22c6bd
  .word 0x0a6b5925
  .word 0xcc439bb7
  .word 0x95e9de90
  .word 0x0664229f
  .word 0x4fc6fab1
  .word 0xd7519fea
  .word 0xdbe83c3c
  .word 0x534d205f
  .word 0x49920b9f
  .word 0x6055a8c2
  .word 0xdd9245ce
  .word 0x2c2e55b1
  .word 0x03553c41
  .word 0x93ea6d60
  .word 0x8c08ccd0
  .word 0x69b4b42f
  .word 0xe5f5c4b0
  .word 0xd8aee990
  .word 0x72398d78
  .word 0x641d410a
  .word 0x6207aafc
  .word 0xaf25549c
  .word 0x5ee9c56e
  .word 0x201b7775
  .word 0xde7f1640
  .word 0xa3e0b268
  .word 0xba368bc1
  .word 0x815875a2
  .word 0x90dfffca
  .word 0x529dd9a9
  .word 0xd80fd273
  .word 0xd38f0fcf
  .word 0xc91b4c32
  .word 0xaeb5e6ad
  .word 0xe949b662
  .word 0x171a8932
  .word 0x74da9922
  .word 0x8fa6a2c1
  .word 0x0ded49ad
  .word 0x0a2c824a
  .word 0x30315572
  .word 0x19a75dd4
  .word 0x4051f635
  .word 0x819b0cc0
  .word 0x1e94cca8
  .word 0xcc0bc1f6
  .word 0x6df4a3aa
  .word 0x550504e3
  .word 0xcc8ad431
  .word 0xfc9d9d97
  .word 0x366b4acd
  .word 0xefc576ef
  .word 0x7e757eda
  .word 0xb6896288
  .word 0x27a627b9
  .word 0x2abab298
  .word 0x69df939c
  .word 0x18197ef0
  .word 0xcb1ae5a2
  .word 0xade2abb6
  .word 0x2d8ee545
  .word 0x08abb974
  .word 0x46fd55f9
  .word 0xbfb6c59a
  .word 0xf13ccdf0
  .word 0x05559cb4
  .word 0xf4b50de7
  .word 0xe241e474
  .word 0x0db2416f
  .word 0x57dd58ef
  .word 0x5785453c
  .word 0x8d6c71cb
  .word 0x3a715ef1
  .word 0xc661bd51
  .word 0xd57a2197
  .word 0xcfa8e467
  .word 0xda1d1096
  .word 0x30edc693
  .word 0xc10dd15b
  .word 0x631f2e6b
  .word 0x773761d8
  .word 0xda5e8dd9
  .word 0xecde0959
  .word 0x60d56ed6
  .word 0x0d8788fe
  .word 0x441e889d
  .word 0x0355f9af
  .word 0xda1f4b83
  .word 0x995f6b78
  .word 0x0c4c2f7c
  .word 0x4dad7ac4
  .word 0xbdda78ba
  .word 0x57beb4a1
  .word 0xd50f489c
  .word 0xafc6fdb3
  .word 0x8dd997cc
  .word 0xd40e7d10
  .word 0xc013077e
  .word 0x49bf7267
  .word 0x256eeae6
  .word 0xd2c2a9fe
  .word 0xecef66f1
  .word 0xfb2a7726
  .word 0x654de293
  .word 0x56259251
  .word 0xfccdc438
  .word 0x1574f226
  .word 0x990a94ed
  .word 0xf12ade3a
  .word 0x006fe789
  .word 0xf8b896ea
  .word 0xcdbfee5e
  .word 0xb8973e3c
  .word 0x944cbdad
  .word 0xf8acdb43
  .word 0x7a24a049
  .word 0x0a9e2a0b
  .word 0x1872dc9b
  .word 0x456c2781
  .word 0xa3a1941f
  .word 0x2134bf4e
  .word 0xc94db144
  .word 0x90159bbc
  .word 0x3f01c0b5
  .word 0x4203b84d
  .word 0x959bb61b
  .word 0x5721f6c7
  .word 0x396fefaa
  .word 0xc33585c3
  .word 0xeb86f002
  .word 0x59ef21b3
  .word 0xd83b1799
  .word 0xe0c7b5ed
  .word 0xe90f2cd3
  .word 0x2ce8beb8
  .word 0x84481531
  .word 0xea0598ad
  .word 0xbcad7b6b
  .word 0x642901e0
  .word 0x23fd4201
  .word 0x27d55570
  .word 0x7fa96b3b
  .word 0x13cbdba6
  .word 0x8c743e67
  .word 0xb771a77a
  .word 0xed96b00d
  .word 0x58e97fb3
  .word 0x3dd3eac4
  .word 0x245cd39c
  .word 0xd1188683
  .word 0x554d19e3

.globl message
message:
  .word 0xa9eeb13c
  .word 0x934b0088
  .word 0x0afb3c10
  .word 0x682afdee
  .word 0x4afa016e
  .word 0x63a3e858
  .word 0xe3a1a89c
  .word 0xe257aef9
  .word 0x87ccb835
  .word 0x62dc233c
  .word 0x1660d2b8
  .word 0x752ffa9a
  .word 0x586a91ab
  .word 0x889174d9
  .word 0x6a5ed235
  .word 0xb2855043
  .zero 3132
/* account for longer messages in the tests */

.globl messagelen
messagelen:
  .word 0x00000040

  .zero 72960
stack_end:
#endif

.balign 32
.globl ctx
ctx:
    .word 0x00000000
    .word 0x11111111
    .word 0x22222222
    .word 0x33333333
    .word 0x44444444
    .word 0x55555555
    .word 0x66666666
    .word 0x77777777

/* Modulus for reduction */
.global modulus
modulus:
  .word 0x007fe001
  .word 0x007fe001
  .word 0x007fe001
  .word 0x007fe001
  .word 0x007fe001
  .word 0x007fe001
  .word 0x007fe001
  .word 0x007fe001

.global modulus_base
modulus_base:
  .word 0x007fe001
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0

.global twiddles_fwd
twiddles_fwd:
  /* Layers 1-4 */
  .word 0x00ca2087, 0x92e0bb09
  .word 0xb04e1826, 0x73078efd
  .word 0xf0260fa4, 0x72e78afc
  .word 0x073e5788, 0x9e33e1bc
  .word 0xe83c3f40, 0xa7e8dee7
  .word 0xe53b9f1e, 0x9fe85ed7
  .word 0x0e3fd7da, 0x9e3461dc
  .word 0x37ca4823, 0xed9ec1d5
  .word 0x47e44e84, 0x6c36b6d5
  .word 0xf5069bbd, 0x51efdb52
  .word 0xc01904c1, 0x41100b80
  .word 0x5f4cbc71, 0x7301c58b
  .word 0xa7e00ab3, 0xe14ae4f6
  .word 0x5f0c5457, 0x110765b7
  .word 0x51dec50e, 0xdab23ad9
  /* Padding */
  .word 0x00000000
  .word 0 /* Padding */
  /* Layer 5 - 1 */
  .word 0x53417fba, 0x990b69a8
  /* Layer 6 - 1 */
  .word 0x52a977b9, 0x6e09d599
  .word 0x02ecfb39, 0x613a89e0
  /* Layer 7 - 1 */
  .word 0x87efc6e2, 0x5ddf591a
  .word 0xd14d55b3, 0x2707337e
  .word 0x8fa788c3, 0xaf7e3e30
  .word 0xa318f8f9, 0x75ab47e6
  /* Layer 8 - 1 */
  .word 0x3fe51ec8, 0x000db56d
  .word 0x6818b95f, 0xc4e0c0a6
  .word 0x46c35849, 0xaec2272c
  .word 0x74a1175d, 0xd386be08
  .word 0x99e55e24, 0x5144c08d
  .word 0x448d18be, 0xc99e6205
  .word 0xb5448fba, 0xfe317460
  .word 0x932d101e, 0x54b21bdd
  /* Padding */
  .word 0x00000000, 0x00000000
  /* Layer 5 - 2 */
  .word 0x1f48b1ee, 0x83e25f90
  /* Layer 6 - 2 */
  .word 0x5e01198b, 0x53b76b33
  .word 0x6bd87f49, 0x9271813b
  /* Layer 7 - 2 */
  .word 0xd3a1a2c2, 0x7fca89a2
  .word 0x6a2e66c6, 0x9d8d3612
  .word 0x427c2c87, 0xa0a5ea39
  .word 0xcf935b38, 0xf7a0d044
  /* Layer 8 - 2 */
  .word 0x0827f3ed, 0x241d4d0b
  .word 0x4a5da4d5, 0x02a9fa79
  .word 0xda407068, 0x1374db0f
  .word 0x6b518d8d, 0x86dec4a3
  .word 0x94765e6f, 0x8721b75f
  .word 0x8d294337, 0xb9d9dd03
  .word 0xdb6d87ac, 0x9ba784a9
  .word 0x9e73599a, 0x8e74fa21
  /* Padding */
  .word 0x00000000, 0x00000000
  /* Layer 5 - 3 */
  .word 0xdf030905, 0x515bfa5b
  /* Layer 6 - 3 */
  .word 0xcd3d55bb, 0xa0f8fafc
  .word 0x9244ea16, 0x40314fd3
  /* Layer 7 - 3 */
  .word 0xd9954fa1, 0x4ca4908a
  .word 0x3b3db2f7, 0x3df4288e
  .word 0x8341b567, 0x3b300f8d
  .word 0xe17248d0, 0x8b708309
  /* Layer 8 - 3 */
  .word 0x1b839cb1, 0xff2681a2
  .word 0x38ca6628, 0x192061e6
  .word 0x1bc8bdf8, 0x1ed55f1a
  .word 0x1904f50c, 0xb50840a6
  .word 0x0f22ce96, 0xc388107d
  .word 0xceb8c294, 0x30c75d75
  .word 0xfeadb370, 0x872028fb
  .word 0xf009fa9f, 0x8d287903
  /* Padding */
  .word 0x00000000, 0x00000000
  /* Layer 5 - 4 */
  .word 0x6d8a71c2, 0xccd84878
  /* Layer 6 - 4 */
  .word 0xb27c47ad, 0x712c382b
  .word 0x779b43e2, 0x236e6151
  /* Layer 7 - 4 */
  .word 0x9e8ca3ec, 0x55e0ad7f
  .word 0x9f8d4011, 0xa4da6d51
  .word 0x9106025f, 0xde1b6f1f
  .word 0x03e08c1c, 0x7f04d036
  /* Layer 8 - 4 */
  .word 0xebfb40f9, 0xcc85dfde
  .word 0xa09e1444, 0x97d0e509
  .word 0x3e108ba7, 0x51d07f7c
  .word 0x61f7891f, 0x8cde507a
  .word 0x9357d0ce, 0x9386a682
  .word 0xeff5a98b, 0x136d4329
  .word 0xe8854581, 0xf8597a6d
  .word 0x92280ee0, 0xb4fe9e3d
  /* Padding */
  .word 0x00000000, 0x00000000
  /* Layer 5 - 5 */
  .word 0xef36edde, 0x9456626f
  /* Layer 6 - 5 */
  .word 0x8a0d8e50, 0x0c0a4a7a
  .word 0xa305ba29, 0x1c5ef183
  /* Layer 7 - 5 */
  .word 0x683bf22d, 0x2eadaf0e
  .word 0xe1f5879e, 0x0ebe617a
  .word 0x419cd6b3, 0x231839c8
  .word 0x52f1f9d9, 0xa582b161
  /* Layer 8 - 5 */
  .word 0x0a74cf1f, 0x8157a6e7
  .word 0x08c44901, 0xc9da1ef4
  .word 0xb587e48f, 0x42fd12be
  .word 0x7d7f94eb, 0xcb3defe5
  .word 0x69000d32, 0x48eead19
  .word 0x99e6f089, 0x91ab9fc4
  .word 0x3506cf4a, 0xf7cca339
  .word 0x0633d4e9, 0x9ed866dc
  /* Padding */
  .word 0x00000000, 0x00000000
  /* Layer 5 - 6 */
  .word 0xddccb372, 0xf2bd155f
  /* Layer 6 - 6 */
  .word 0x6d307744, 0x2176b56a
  .word 0xa8669c57, 0x94e3a1be
  /* Layer 7 - 6 */
  .word 0xa5589cdd, 0xeeb8e85c
  .word 0x8f2c61fb, 0x052efbb4
  .word 0xf371b687, 0x4b38a592
  .word 0xb45527e2, 0x9a24abf6
  /* Layer 8 - 6 */
  .word 0x56d37e32, 0x7278011b
  .word 0x5237bf4c, 0x4623ce67
  .word 0xb0e0acca, 0x25e045c5
  .word 0x26a48ad6, 0x8abe928f
  .word 0x7be12f55, 0x619e9ee4
  .word 0x261c8ed8, 0x50bc767c
  .word 0x4bf39e50, 0x264fefaf
  .word 0x30c0bbce, 0xff9ee5ba
  /* Padding */
  .word 0x00000000, 0x00000000
  /* Layer 5 - 7 */
  .word 0x5006d115, 0x14ab0698
  /* Layer 6 - 7 */
  .word 0x6c2307ea, 0x3f49fc00
  .word 0xf6d24ea7, 0x853af5b2
  /* Layer 7 - 7 */
  .word 0xeb7fe423, 0x80b9fd7d
  .word 0xda78c47d, 0x95705eec
  .word 0xff4c4914, 0x3cb8f9c4
  .word 0xd809f0cd, 0x9e551608
  /* Layer 8 - 7 */
  .word 0x8ced6c42, 0x5b967ae7
  .word 0x26330876, 0x04552b42
  .word 0x508542b0, 0xfd45a76f
  .word 0x939c07db, 0x4cc4246f
  .word 0xa48a3545, 0xd69c8f76
  .word 0x3918c3bf, 0x12bb9ac1
  .word 0x3a251ed4, 0xd7f994b5
  .word 0xdfe54592, 0xbc3b4959
  /* Padding */
  .word 0x00000000, 0x00000000
  /* Layer 5 - 8 */
  .word 0xbf96dc38, 0xd730cc84
  /* Layer 6 - 8 */
  .word 0x47bf273b, 0x6308a964
  .word 0xef869bc8, 0x41dc9aa2
  /* Layer 7 - 8 */
  .word 0xf454cf4c, 0x350a3422
  .word 0x2935f52b, 0x0730ea2c
  .word 0x3898ebca, 0x9cb75a9d
  .word 0xd44dd7ce, 0x6389939d
  /* Layer 8 - 8 */
  .word 0xd7474e25, 0xf1fc9741
  .word 0x25cba89f, 0xc549bee5
  .word 0x9aa32595, 0x7b6ae1c1
  .word 0xd44f7234, 0x95eff2d0
  .word 0xf2385632, 0x3e4a621b
  .word 0x28179395, 0xc6931939
  .word 0x64fe44c8, 0xe6fd2d7d
  .word 0xc40bdf70, 0xbd703291
  /* Padding */
  .word 0x00000000, 0x00000000
  /* Layer 5 - 9 */
  .word 0xbf4b7f62, 0x9d659229
  /* Layer 6 - 9 */
  .word 0xcc178048, 0x68524dc2
  .word 0xcdc91ead, 0x35be5529
  /* Layer 7 - 9 */
  .word 0x99de4a5f, 0xb135e416
  .word 0x0817e5ea, 0x369df510
  .word 0x0f8c10e6, 0xb6f55be9
  .word 0x5ea2b7f1, 0xbb1fba78
  /* Layer 8 - 9 */
  .word 0xd8e8e087, 0xce6926ac
  .word 0x3a8fd581, 0x404f9f67
  .word 0xb2377e7c, 0xb777da87
  .word 0xd600da8b, 0xc1df5a52
  .word 0x2dd37e84, 0x11e87bfb
  .word 0x17bdbd40, 0xdbf74419
  .word 0x444ce2b1, 0x1020e218
  .word 0x680ba018, 0xac322731
  /* Padding */
  .word 0x00000000, 0x00000000
  /* Layer 5 - 10 */
  .word 0x8a185502, 0x345e0518
  /* Layer 6 - 10 */
  .word 0x6b1700eb, 0xe706c1e2
  .word 0x8b41834b, 0x92cf30a6
  /* Layer 7 - 10 */
  .word 0x015a5693, 0x6a5f5300
  .word 0xde651589, 0x80390941
  .word 0x1ba17025, 0xd849b2bc
  .word 0x78ecee4a, 0xb7d858a6
  /* Layer 8 - 10 */
  .word 0xef6e43b3, 0xd2e1c6cb
  .word 0xa97e784c, 0x3ce9b5f3
  .word 0xccf32d32, 0x4c1a8007
  .word 0xc7949396, 0xd5714ea8
  .word 0xb10e7a3d, 0x0f840ee4
  .word 0x8e3bb3d1, 0xdbb693ed
  .word 0x1226396b, 0xe9dbef28
  .word 0x8c9f66c1, 0xc7f5c1e0
  /* Padding */
  .word 0x00000000, 0x00000000
  /* Layer 5 - 11 */
  .word 0xd53f3e26, 0x4af67b08
  /* Layer 6 - 11 */
  .word 0x6b2345fc, 0x72c29bc1
  .word 0xbe9bd579, 0xc4ddc9e8
  /* Layer 7 - 11 */
  .word 0x8e3b23ad, 0xd7bf9435
  .word 0xffbceb3c, 0x4b306181
  .word 0x327f2f67, 0x5cbdc6b8
  .word 0x9cbaaf73, 0x12f9963f
  /* Layer 8 - 11 */
  .word 0xc27d4fcf, 0xa353b9a7
  .word 0x4a4da8d6, 0xf5a98275
  .word 0x4afa2bf6, 0x50e3ac49
  .word 0xfaf7dc02, 0x5bf0a370
  .word 0x3bca2211, 0xb02f2268
  .word 0x66eae9ed, 0x7eb99768
  .word 0x05aae0ad, 0x16e5cb45
  .word 0xdb1e15d0, 0x851d8c58
  /* Padding */
  .word 0x00000000, 0x00000000
  /* Layer 5 - 12 */
  .word 0x9be028d3, 0x2c9f0367
  /* Layer 6 - 12 */
  .word 0xcf1c7f82, 0xcb8ceba3
  .word 0x710357f4, 0x87560c74
  /* Layer 7 - 12 */
  .word 0x48fd16b4, 0x772e0a94
  .word 0xf98e2196, 0xda875820
  .word 0x17370f96, 0x5960475f
  .word 0xd7c601d1, 0x671317f7
  /* Layer 8 - 12 */
  .word 0x9ec12d0e, 0x7998d341
  .word 0x04f97654, 0x4e7a03e4
  .word 0x316067b8, 0xcea655f8
  .word 0x5c11e5c2, 0x34a3e28f
  .word 0x18bf79ad, 0x32df035b
  .word 0x327bd290, 0x3df38866
  .word 0x8f269888, 0x238b7e98
  .word 0xc90abd1e, 0x9913d3c2
  /* Padding */
  .word 0x00000000, 0x00000000
  /* Layer 5 - 13 */
  .word 0x35add50a, 0xec5e8fcb
  /* Layer 6 - 13 */
  .word 0x18cd8330, 0xa77e9c58
  .word 0x103b42b1, 0x6184a466
  /* Layer 7 - 13 */
  .word 0x05ca4a88, 0x296f9b94
  .word 0x9374ee15, 0xab3537f7
  .word 0x6085a4a9, 0x51f7893e
  .word 0xc771c8e4, 0xab1d8009
  /* Layer 8 - 13 */
  .word 0xa32b438b, 0x7a06dec3
  .word 0x6ba55a80, 0xffa31ac7
  .word 0x761fb101, 0xd6225eeb
  .word 0x083d8f54, 0x5c43e240
  .word 0x439ad42e, 0x66bf5b09
  .word 0xe2307459, 0x0690640b
  .word 0x3478ebd3, 0x10a8ea19
  .word 0x0e6bb6d1, 0xe8770bf2
  /* Padding */
  .word 0x00000000, 0x00000000
  /* Layer 5 - 14 */
  .word 0xff681e09, 0x927c0bdd
  /* Layer 6 - 14 */
  .word 0x1d263554, 0x1102b08a
  .word 0x768e48a6, 0x763a67ad
  /* Layer 7 - 14 */
  .word 0xb666c044, 0x9612636c
  .word 0xfa946525, 0x46a6b51f
  .word 0x283015b6, 0xec0b4cfb
  .word 0x28f96207, 0xf1f9486e
  /* Layer 8 - 14 */
  .word 0xf2f747ed, 0x5edde2ba
  .word 0x34a6c94a, 0xde4bb330
  .word 0xc8eb9754, 0x0f85c351
  .word 0x3a5b6665, 0xef15d998
  .word 0xcd107483, 0x1a467167
  .word 0xde43f742, 0x68ca79cc
  .word 0xf809b67e, 0x0448ba25
  .word 0x8ae26f87, 0xd1bf2024
  /* Padding */
  .word 0x00000000, 0x00000000
  /* Layer 5 - 15 */
  .word 0x7a82a1b4, 0x5602adff
  /* Layer 6 - 15 */
  .word 0x7728311e, 0x591dfacc
  .word 0xb1e4d9d3, 0x38a103cf
  /* Layer 7 - 15 */
  .word 0x27461b39, 0x0aa7c1db
  .word 0xcf95a5cb, 0xf5fc2f1f
  .word 0xe72c5347, 0x1ee3e6bb
  .word 0xd405059a, 0xb815b7fd
  /* Layer 8 - 15 */
  .word 0xa63856ca, 0xbd40589b
  .word 0xbbb24b1c, 0x5f6c3e50
  .word 0xf324833b, 0x480acc22
  .word 0xba289cb3, 0xbd01c2f6
  .word 0x059a8c98, 0xa3ead36d
  .word 0xe2289461, 0xcb8e47fa
  .word 0x3144a4c7, 0x596223d6
  .word 0x93b03ee9, 0xf400fa56
  /* Padding */
  .word 0x00000000, 0x00000000
  /* Layer 5 - 16 */
  .word 0x088dad5b, 0x45c31a3b
  /* Layer 6 - 16 */
  .word 0x3f4a7a20, 0x6635e2ac
  .word 0xaa88fceb, 0x38c510d2
  /* Layer 7 - 16 */
  .word 0xa3c63647, 0x8b59d15d
  .word 0x89719553, 0xc547b863
  .word 0x9124f81c, 0xbbac7fa8
  .word 0x754d0457, 0x354a4827
  /* Layer 8 - 16 */
  .word 0xef10643b, 0xf6be75af
  .word 0x77bc4623, 0x6bdeb0d4
  .word 0xfe863d93, 0x8696fcb1
  .word 0xd663572a, 0x8cb8e920
  .word 0x7849a579, 0x3a0aaa36
  .word 0x2ac7818b, 0xe81da198
  .word 0xe626f5f2, 0x20362949
  .word 0x3c62b435, 0xe9a81632
  /* Padding */
  .word 0x00000000, 0x00000000

.global twiddles_inv
twiddles_inv:
  /* Inv Layer 8 - 1 */
  .word 0xc39d4bcc, 0x1657e9cd
  .word 0x19d90a0f, 0xdfc9d6b6
  .word 0xd5387e76, 0x17e25e67
  .word 0x87b65a88, 0xc5f555c9
  .word 0x299ca8d7, 0x734716df
  .word 0x0179c26e, 0x7969034e
  .word 0x8843b9de, 0x94214f2b
  .word 0x10ef9bc6, 0x09418a50
  /* Inv Layer 7 - 1 */
  .word 0x8ab2fbaa, 0xcab5b7d8
  .word 0x6edb07e5, 0x44538057
  .word 0x768e6aae, 0x3ab8479c
  .word 0x5c39c9ba, 0x74a62ea2
  /* Inv Layer 6 - 1 */
  .word 0x55770316, 0xc73aef2d
  .word 0xc0b585e1, 0x99ca1d53
  /* Inv Layer 5 - 1 */
  .word 0xf77252a6, 0xba3ce5c4
  /* Padding */
  .word 0x00000000, 0x00000000
  /* Inv Layer 8 - 2 */
  .word 0x6c4fc118, 0x0bff05a9
  .word 0xcebb5b3a, 0xa69ddc29
  .word 0x1dd76ba0, 0x3471b805
  .word 0xfa657369, 0x5c152c92
  .word 0x45d7634e, 0x42fe3d09
  .word 0x0cdb7cc6, 0xb7f533dd
  .word 0x444db4e5, 0xa093c1af
  .word 0x59c7a937, 0x42bfa764
  /* Inv Layer 7 - 2 */
  .word 0x2bfafa67, 0x47ea4802
  .word 0x18d3acba, 0xe11c1944
  .word 0x306a5a36, 0x0a03d0e0
  .word 0xd8b9e4c8, 0xf5583e24
  /* Inv Layer 6 - 2 */
  .word 0x4e1b262e, 0xc75efc30
  .word 0x88d7cee3, 0xa6e20533
  /* Inv Layer 5 - 2 */
  .word 0x857d5e4d, 0xa9fd5200
  /* Padding */
  .word 0x00000000, 0x00000000
  /* Inv Layer 8 - 3 */
  .word 0x751d907a, 0x2e40dfdb
  .word 0x07f64983, 0xfbb745da
  .word 0x21bc08bf, 0x97358633
  .word 0x32ef8b7e, 0xe5b98e98
  .word 0xc5a4999c, 0x10ea2667
  .word 0x371468ad, 0xf07a3cae
  .word 0xcb5936b7, 0x21b44ccf
  .word 0x0d08b814, 0xa1221d45
  /* Inv Layer 7 - 3 */
  .word 0xd7069dfa, 0x0e06b791
  .word 0xd7cfea4b, 0x13f4b304
  .word 0x056b9adc, 0xb9594ae0
  .word 0x49993fbd, 0x69ed9c93
  /* Inv Layer 6 - 3 */
  .word 0x8971b75b, 0x89c59852
  .word 0xe2d9caad, 0xeefd4f75
  /* Inv Layer 5 - 3 */
  .word 0x0097e1f8, 0x6d83f422
  /* Padding */
  .word 0x00000000, 0x00000000
  /* Inv Layer 8 - 4 */
  .word 0xf1944930, 0x1788f40d
  .word 0xcb87142e, 0xef5715e6
  .word 0x1dcf8ba8, 0xf96f9bf4
  .word 0xbc652bd3, 0x9940a4f6
  .word 0xf7c270ad, 0xa3bc1dbf
  .word 0x89e04f00, 0x29dda114
  .word 0x945aa581, 0x005ce538
  .word 0x5cd4bc76, 0x85f9213c
  /* Inv Layer 7 - 4 */
  .word 0x388e371d, 0x54e27ff6
  .word 0x9f7a5b58, 0xae0876c1
  .word 0x6c8b11ec, 0x54cac808
  .word 0xfa35b579, 0xd690646b
  /* Inv Layer 6 - 4 */
  .word 0xefc4bd50, 0x9e7b5b99
  .word 0xe7327cd1, 0x588163a7
  /* Inv Layer 5 - 4 */
  .word 0xca522af7, 0x13a17034
  /* Padding */
  .word 0x00000000, 0x00000000
  /* Inv Layer 8 - 5 */
  .word 0x36f542e3, 0x66ec2c3d
  .word 0x70d96779, 0xdc748167
  .word 0xcd842d71, 0xc20c7799
  .word 0xe7408654, 0xcd20fca4
  .word 0xa3ee1a3f, 0xcb5c1d70
  .word 0xce9f9849, 0x3159aa07
  .word 0xfb0689ad, 0xb185fc1b
  .word 0x613ed2f3, 0x86672cbe
  /* Inv Layer 7 - 5 */
  .word 0x2839fe30, 0x98ece808
  .word 0xe8c8f06b, 0xa69fb8a0
  .word 0x0671de6b, 0x2578a7df
  .word 0xb702e94d, 0x88d1f56b
  /* Inv Layer 6 - 5 */
  .word 0x8efca80d, 0x78a9f38b
  .word 0x30e3807f, 0x3473145c
  /* Inv Layer 5 - 5 */
  .word 0x641fd72e, 0xd360fc98
  /* Padding */
  .word 0x00000000, 0x00000000
  /* Inv Layer 8 - 6 */
  .word 0x24e1ea31, 0x7ae273a7
  .word 0xfa551f54, 0xe91a34ba
  .word 0x99151614, 0x81466897
  .word 0xc435ddf0, 0x4fd0dd97
  .word 0x050823ff, 0xa40f5c8f
  .word 0xb505d40b, 0xaf1c53b6
  .word 0xb5b2572b, 0x0a567d8a
  .word 0x3d82b032, 0x5cac4658
  /* Inv Layer 7 - 6 */
  .word 0x6345508e, 0xed0669c0
  .word 0xcd80d09a, 0xa3423947
  .word 0x004314c5, 0xb4cf9e7e
  .word 0x71c4dc54, 0x28406bca
  /* Inv Layer 6 - 6 */
  .word 0x41642a88, 0x3b223617
  .word 0x94dcba05, 0x8d3d643e
  /* Inv Layer 5 - 6 */
  .word 0x2ac0c1db, 0xb50984f7
  /* Padding */
  .word 0x00000000, 0x00000000
  /* Inv Layer 8 - 7 */
  .word 0x73609940, 0x380a3e1f
  .word 0xedd9c696, 0x162410d7
  .word 0x71c44c30, 0x24496c12
  .word 0x4ef185c4, 0xf07bf11b
  .word 0x386b6c6b, 0x2a8eb157
  .word 0x330cd2cf, 0xb3e57ff8
  .word 0x568187b5, 0xc3164a0c
  .word 0x1091bc4e, 0x2d1e3934
  /* Inv Layer 7 - 7 */
  .word 0x871311b7, 0x4827a759
  .word 0xe45e8fdc, 0x27b64d43
  .word 0x219aea78, 0x7fc6f6be
  .word 0xfea5a96e, 0x95a0acff
  /* Inv Layer 6 - 7 */
  .word 0x74be7cb6, 0x6d30cf59
  .word 0x94e8ff16, 0x18f93e1d
  /* Inv Layer 5 - 7 */
  .word 0x75e7aaff, 0xcba1fae7
  /* Padding */
  .word 0x00000000, 0x00000000
  /* Inv Layer 8 - 8 */
  .word 0x97f45fe9, 0x53cdd8ce
  .word 0xbbb31d50, 0xefdf1de7
  .word 0xe84242c1, 0x2408bbe6
  .word 0xd22c817d, 0xee178404
  .word 0x29ff2576, 0x3e20a5ad
  .word 0x4dc88185, 0x48882578
  .word 0xc5702a80, 0xbfb06098
  .word 0x27171f7a, 0x3196d953
  /* Inv Layer 7 - 8 */
  .word 0xa15d4810, 0x44e04587
  .word 0xf073ef1b, 0x490aa416
  .word 0xf7e81a17, 0xc9620aef
  .word 0x6621b5a2, 0x4eca1be9
  /* Inv Layer 6 - 8 */
  .word 0x3236e154, 0xca41aad6
  .word 0x33e87fb9, 0x97adb23d
  /* Inv Layer 5 - 8 */
  .word 0x40b4809f, 0x629a6dd6
  /* Padding */
  .word 0x00000000, 0x00000000
  /* Inv Layer 8 - 9 */
  .word 0x3bf42091, 0x428fcd6e
  .word 0x9b01bb39, 0x1902d282
  .word 0xd7e86c6c, 0x396ce6c6
  .word 0x0dc7a9cf, 0xc1b59de4
  .word 0x2bb08dcd, 0x6a100d2f
  .word 0x655cda6c, 0x84951e3e
  .word 0xda345762, 0x3ab6411a
  .word 0x28b8b1dc, 0x0e0368be
  /* Inv Layer 7 - 9 */
  .word 0x2bb22833, 0x9c766c62
  .word 0xc7671437, 0x6348a562
  .word 0xd6ca0ad6, 0xf8cf15d3
  .word 0x0bab30b5, 0xcaf5cbdd
  /* Inv Layer 6 - 9 */
  .word 0x10796439, 0xbe23655d
  .word 0xb840d8c6, 0x9cf7569b
  /* Inv Layer 5 - 9 */
  .word 0x406923c9, 0x28cf337b
  /* Padding */
  .word 0x00000000, 0x00000000
  /* Inv Layer 8 - 10 */
  .word 0x201aba6f, 0x43c4b6a6
  .word 0xc5dae12d, 0x28066b4a
  .word 0xc6e73c42, 0xed44653e
  .word 0x5b75cabc, 0x29637089
  .word 0x6c63f826, 0xb33bdb90
  .word 0xaf7abd51, 0x02ba5890
  .word 0xd9ccf78b, 0xfbaad4bd
  .word 0x731293bf, 0xa4698518
  /* Inv Layer 7 - 10 */
  .word 0x27f60f34, 0x61aae9f7
  .word 0x00b3b6ed, 0xc347063b
  .word 0x25873b84, 0x6a8fa113
  .word 0x14801bde, 0x7f460282
  /* Inv Layer 6 - 10 */
  .word 0x092db15a, 0x7ac50a4d
  .word 0x93dcf817, 0xc0b603ff
  /* Inv Layer 5 - 10 */
  .word 0xaff92eec, 0xeb54f967
  /* Padding */
  .word 0x00000000, 0x00000000
  /* Inv Layer 8 - 11 */
  .word 0xcf3f4433, 0x00611a45
  .word 0xb40c61b1, 0xd9b01050
  .word 0xd9e37129, 0xaf438983
  .word 0x841ed0ac, 0x9e61611b
  .word 0xd95b752b, 0x75416d70
  .word 0x4f1f5337, 0xda1fba3a
  .word 0xadc840b5, 0xb9dc3198
  .word 0xa92c81cf, 0x8d87fee4
  /* Inv Layer 7 - 11 */
  .word 0x4baad81f, 0x65db5409
  .word 0x0c8e497a, 0xb4c75a6d
  .word 0x70d39e06, 0xfad1044b
  .word 0x5aa76324, 0x114717a3
  /* Inv Layer 6 - 11 */
  .word 0x579963aa, 0x6b1c5e41
  .word 0x92cf88bd, 0xde894a95
  /* Inv Layer 5 - 11 */
  .word 0x22334c8f, 0x0d42eaa0
  /* Padding */
  .word 0x00000000, 0x00000000
  /* Inv Layer 8 - 12 */
  .word 0xf9cc2b18, 0x61279923
  .word 0xcaf930b7, 0x08335cc6
  .word 0x66190f78, 0x6e54603b
  .word 0x96fff2cf, 0xb71152e6
  .word 0x82806b16, 0x34c2101a
  .word 0x4a781b72, 0xbd02ed41
  .word 0xf73bb700, 0x3625e10b
  .word 0xf58b30e2, 0x7ea85918
  /* Inv Layer 7 - 12 */
  .word 0xad0e0628, 0x5a7d4e9e
  .word 0xbe63294e, 0xdce7c637
  .word 0x1e0a7863, 0xf1419e85
  .word 0x97c40dd4, 0xd15250f1
  /* Inv Layer 6 - 12 */
  .word 0x5cfa45d8, 0xe3a10e7c
  .word 0x75f271b1, 0xf3f5b585
  /* Inv Layer 5 - 12 */
  .word 0x10c91223, 0x6ba99d90
  /* Padding */
  .word 0x00000000, 0x00000000
  /* Inv Layer 8 - 13 */
  .word 0x6dd7f121, 0x4b0161c2
  .word 0x177aba80, 0x07a68592
  .word 0x100a5676, 0xec92bcd6
  .word 0x6ca82f33, 0x6c79597d
  .word 0x9e0876e2, 0x7321af85
  .word 0xc1ef745a, 0xae2f8083
  .word 0x5f61ebbd, 0x682f1af6
  .word 0x1404bf08, 0x337a2021
  /* Inv Layer 7 - 13 */
  .word 0xfc1f73e5, 0x80fb2fc9
  .word 0x6ef9fda2, 0x21e490e0
  .word 0x6072bff0, 0x5b2592ae
  .word 0x61735c15, 0xaa1f5280
  /* Inv Layer 6 - 13 */
  .word 0x8864bc1f, 0xdc919eae
  .word 0x4d83b854, 0x8ed3c7d4
  /* Inv Layer 5 - 13 */
  .word 0x92758e3f, 0x3327b787
  /* Padding */
  .word 0x00000000, 0x00000000
  /* Inv Layer 8 - 14 */
  .word 0x0ff60562, 0x72d786fc
  .word 0x01524c91, 0x78dfd704
  .word 0x31473d6d, 0xcf38a28a
  .word 0xf0dd316b, 0x3c77ef82
  .word 0xe6fb0af5, 0x4af7bf59
  .word 0xe4374209, 0xe12aa0e5
  .word 0xc73599d9, 0xe6df9e19
  .word 0xe47c6350, 0x00d97e5d
  /* Inv Layer 7 - 14 */
  .word 0x1e8db731, 0x748f7cf6
  .word 0x7cbe4a9a, 0xc4cff072
  .word 0xc4c24d0a, 0xc20bd771
  .word 0x266ab060, 0xb35b6f75
  /* Inv Layer 6 - 14 */
  .word 0x6dbb15eb, 0xbfceb02c
  .word 0x32c2aa46, 0x5f070503
  /* Inv Layer 5 - 14 */
  .word 0x20fcf6fc, 0xaea405a4
  /* Padding */
  .word 0x00000000, 0x00000000
  /* Inv Layer 8 - 15 */
  .word 0x618ca667, 0x718b05de
  .word 0x24927855, 0x64587b56
  .word 0x72d6bcca, 0x462622fc
  .word 0x6b89a192, 0x78de48a0
  .word 0x94ae7274, 0x79213b5c
  .word 0x25bf8f99, 0xec8b24f0
  .word 0xb5a25b2c, 0xfd560586
  .word 0xf7d80c14, 0xdbe2b2f4
  /* Inv Layer 7 - 15 */
  .word 0x306ca4c9, 0x085f2fbb
  .word 0xbd83d37a, 0x5f5a15c6
  .word 0x95d1993b, 0x6272c9ed
  .word 0x2c5e5d3f, 0x8035765d
  /* Inv Layer 6 - 15 */
  .word 0x942780b8, 0x6d8e7ec4
  .word 0xa1fee676, 0xac4894cc
  /* Inv Layer 5 - 15 */
  .word 0xe0b74e13, 0x7c1da06f
  /* Padding */
  .word 0x00000000, 0x00000000
  /* Inv Layer 8 - 16 */
  .word 0x6cd2efe3, 0xab4de422
  .word 0x4abb7047, 0x01ce8b9f
  .word 0xbb72e743, 0x36619dfa
  .word 0x661aa1dd, 0xaebb3f72
  .word 0x8b5ee8a4, 0x2c7941f7
  .word 0xb93ca7b8, 0x513dd8d3
  .word 0x97e746a2, 0x3b1f3f59
  .word 0xc01ae139, 0xfff24a92
  /* Inv Layer 7 - 16 */
  .word 0x5ce70708, 0x8a54b819
  .word 0x7058773e, 0x5081c1cf
  .word 0x2eb2aa4e, 0xd8f8cc81
  .word 0x7810391f, 0xa220a6e5
  /* Inv Layer 6 - 16 */
  .word 0xfd1304c8, 0x9ec5761f
  .word 0xad568848, 0x91f62a66
  /* Inv Layer 5 - 16 */
  .word 0xacbe8047, 0x66f49657
  /* Padding */
  .word 0x00000000, 0x00000000
  /* ---------------- */
  /* Inv Layer 4 */
  .word 0xae213af3, 0x254dc526
  .word 0xa0f3abaa, 0xeef89a48
  .word 0x581ff54e, 0x1eb51b09
  .word 0xa0b34390, 0x8cfe3a74
  .word 0x3fe6fb40, 0xbeeff47f
  .word 0x0af96444, 0xae1024ad
  .word 0xb81bb17d, 0x93c9492a
  .word 0xc835b7de, 0x12613e2a
  /* Inv Layer 3 */
  .word 0xf1c02827, 0x61cb9e23
  .word 0x1ac460e3, 0x6017a128
  .word 0x17c3c0c1, 0x58172118
  .word 0xf8c1a879, 0x61cc1e43
  /* Inv Layer 2 */
  .word 0x0fd9f05d, 0x8d187503
  .word 0x4fb1e7db, 0x8cf87102
  /* Inv Layer 1 (Including ninv and plant for conversion to normal domain) */
  .word 0x78196f6c, 0x868d624b
  /* ninv * plant**2 * qprime */
  .word 0x0ccf51bb, 0xfeb7b9f1

.global power2round_D_preprocessed
power2round_D_preprocessed:
  .word 0xfff
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0

.global eta_vec_const
eta_vec_const:
  .word ETA
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0

.global polyt0_pack_const
polyt0_pack_const:
  .word 0x1000
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0

.global decompose_const
decompose_const:
#if GAMMA2 == (Q-1)/88
  .word 0x00002c0b
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
#elif GAMMA2 == (Q-1)/32
  .word 1025
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
#endif

.global gamma1_vec_const
gamma1_vec_const:
  .word GAMMA1
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0

.global gamma2x2_vec_const
gamma2x2_vec_const:
  .word GAMMA2x2
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0

.global qm1half_const
qm1half_const:
  .word 0x003ff000
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0

.global polyt1_unpack_mask
polyt1_unpack_mask:
  .word 0x3ff
  .word 0x3ff
  .word 0x3ff
  .word 0x3ff
  .word 0x3ff
  .word 0x3ff
  .word 0x3ff
  .word 0x3ff

.global polyz_unpack_mask
polyz_unpack_mask:
#if GAMMA1 == (1 << 17)
  .word 0x3ffff
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
#elif GAMMA1 == (1 << 19)
  .word 0xfffff
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
#endif

.global qprime_single
qprime_single:
  /* qprime */
  .word 0x03802001, 0x180a4060
  .word 0x0, 0x0
  .word 0x0, 0x0
  .word 0x0, 0x0

.global reduce32_cmp_const
reduce32_cmp_const:
  .word 4194304
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
  .word 0x0
