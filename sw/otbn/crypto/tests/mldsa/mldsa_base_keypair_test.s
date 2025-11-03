/* Copyright "Towards ML-KEM & ML-DSA on OpenTitan" Authors */
/* Licensed under the Apache License, Version 2.0, see LICENSE for details. */
/* SPDX-License-Identifier: Apache-2.0 */
/* Modified by Ruben Niederhagen and Hoang Nguyen Hien Pham - authors of */
/* "Improving ML-KEM & ML-DSA on OpenTitan - Efficient Multiplication Vector Instructions for OTBN" */
/* (https://eprint.iacr.org/2025/2028) */
/* Copyright Ruben Niederhagen and Hoang Nguyen Hien Pham. */


/**
 * Test for crypto_sign_keypair
*/

.section .text.start
#define STACK_SIZE 112000

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

#define POLYVECK_BYTES 4096
#define POLYVECL_BYTES 4096

#define CRYPTO_PUBLICKEYBYTES 1312
#define CRYPTO_SECRETKEYBYTES 2560
#define CRYPTO_BYTES 2420

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

#define POLYVECK_BYTES 6144
#define POLYVECL_BYTES 5120

#define CRYPTO_PUBLICKEYBYTES 1952
#define CRYPTO_SECRETKEYBYTES 4032
#define CRYPTO_BYTES 3309

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

#define POLYVECK_BYTES 8192
#define POLYVECL_BYTES 7168

#define CRYPTO_PUBLICKEYBYTES 2592
#define CRYPTO_SECRETKEYBYTES 4896
#define CRYPTO_BYTES 4627

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

  /* Loadf stack address */
  la  x2, stack_end
  la  x10, zeta
  la  x11, pk
  la  x12, sk
  jal x1, crypto_sign_keypair

  ecall

.data
.balign 32
.global stack
stack:
    .zero STACK_SIZE
stack_end:
.globl pk
pk:
  .zero CRYPTO_PUBLICKEYBYTES
.globl sk
sk:
  .zero CRYPTO_SECRETKEYBYTES

.balign 32
.globl zeta
zeta:
  .word 0xa42b9c7f
  .word 0x7d828fe8
  .word 0x50456061
  .word 0x3e850576
  .word 0x93803bd7
  .word 0x88bceff6
  .word 0xac6e1aeb
  .word 0x26ef66fa

.balign 32
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
