// Copyright Ruben Niederhagen and Hoang Nguyen Hien Pham - authors of
// "Improving ML-KEM & ML-DSA on OpenTitan - Efficient Multiplication Vector Instructions for OTBN"
// (https://eprint.iacr.org/2025/2028)
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include <stdlib.h>
#include "sw/device/lib/dif/dif_otbn.h"
#include "sw/device/lib/runtime/ibex.h"
#include "sw/device/lib/runtime/log.h"
#include "sw/device/lib/testing/entropy_testutils.h"
#include "sw/device/lib/testing/otbn_testutils.h"
#include "sw/device/lib/testing/test_framework/check.h"
#include "sw/device/lib/testing/test_framework/ottf_main.h"

#include "hw/top_earlgrey/sw/autogen/top_earlgrey.h"

#include "sw/device/tests/pq-crystals/dilithium_opentitan/lowram/params.h"
#include "sw/device/tests/pq-crystals/dilithium_opentitan/lowram/sign.h"
#include "sw/device/tests/pq-crystals/dilithium_opentitan/lowram/fips202.h"

#ifndef NTESTS 
  #define NTESTS 1
#endif

#ifndef BNMULV_VER
  #define BNMULV_VER 1
#endif

#define MLEN 64
#define CTXLEN 32

#if DILITHIUM_MODE == 2
  #define CRYPTO_BYTES_ALIGNED CRYPTO_BYTES
#elif DILITHIUM_MODE == 3
  #define CRYPTO_BYTES_ALIGNED (CRYPTO_BYTES+3)
#elif DILITHIUM_MODE == 5
  #define CRYPTO_BYTES_ALIGNED (CRYPTO_BYTES+13)
#endif

const uint8_t context[CTXLEN] = {
  0x00, 0x00, 0x00, 0x00, 0x11, 0x11, 0x11, 0x11, 0x22, 0x22, 0x22, 0x22, 0x33,
  0x33, 0x33, 0x33, 0x44, 0x44, 0x44, 0x44, 0x55, 0x55, 0x55, 0x55, 0x66, 0x66,
  0x66, 0x66, 0x77, 0x77, 0x77, 0x77
};

#if BNMULV_VER == 1
  #if DILITHIUM_MODE == 2
    OTBN_DECLARE_APP_SYMBOLS(otbn_mldsa44_keypair_test_ver1);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_keypair_test_ver1, zeta);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_keypair_test_ver1, pk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_keypair_test_ver1, sk);

    static const otbn_app_t kAppMLDSAVer1Keypair = OTBN_APP_T_INIT(otbn_mldsa44_keypair_test_ver1);
    static const otbn_addr_t kZetaVer1 = OTBN_ADDR_T_INIT(otbn_mldsa44_keypair_test_ver1, zeta);
    static const otbn_addr_t kPkVer1 = OTBN_ADDR_T_INIT(otbn_mldsa44_keypair_test_ver1, pk);
    static const otbn_addr_t kSkVer1 = OTBN_ADDR_T_INIT(otbn_mldsa44_keypair_test_ver1, sk);

    OTBN_DECLARE_APP_SYMBOLS(otbn_mldsa44_sign_test_ver1);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_sign_test_ver1, signature);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_sign_test_ver1, message);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_sign_test_ver1, messagelen);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_sign_test_ver1, sk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_sign_test_ver1, ctx);

    static const otbn_app_t kAppMLDSAVer1Sign = OTBN_APP_T_INIT(otbn_mldsa44_sign_test_ver1);
    static const otbn_addr_t kSigSVer1 = OTBN_ADDR_T_INIT(otbn_mldsa44_sign_test_ver1, signature);
    static const otbn_addr_t kMsgSVer1 = OTBN_ADDR_T_INIT(otbn_mldsa44_sign_test_ver1, message);
    static const otbn_addr_t kMlenSVer1 = OTBN_ADDR_T_INIT(otbn_mldsa44_sign_test_ver1, messagelen);
    static const otbn_addr_t kSkSVer1 = OTBN_ADDR_T_INIT(otbn_mldsa44_sign_test_ver1, sk);
    static const otbn_addr_t kCtxSVer1 = OTBN_ADDR_T_INIT(otbn_mldsa44_sign_test_ver1, ctx);

    OTBN_DECLARE_APP_SYMBOLS(otbn_mldsa44_verify_test_ver1);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_verify_test_ver1, signature);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_verify_test_ver1, message);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_verify_test_ver1, messagelen);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_verify_test_ver1, pk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_verify_test_ver1, ctx);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_verify_test_ver1, result);

    static const otbn_app_t kAppMLDSAVer1Verify = OTBN_APP_T_INIT(otbn_mldsa44_verify_test_ver1);
    static const otbn_addr_t kSigVVer1 = OTBN_ADDR_T_INIT(otbn_mldsa44_verify_test_ver1, signature);
    static const otbn_addr_t kMsgVVer1 = OTBN_ADDR_T_INIT(otbn_mldsa44_verify_test_ver1, message);
    static const otbn_addr_t kMlenVVer1 = OTBN_ADDR_T_INIT(otbn_mldsa44_verify_test_ver1, messagelen);
    static const otbn_addr_t kPkVVer1 = OTBN_ADDR_T_INIT(otbn_mldsa44_verify_test_ver1, pk);
    static const otbn_addr_t kCtxVVer1 = OTBN_ADDR_T_INIT(otbn_mldsa44_verify_test_ver1, ctx);
    static const otbn_addr_t kResVer1 = OTBN_ADDR_T_INIT(otbn_mldsa44_verify_test_ver1, result);
  #elif DILITHIUM_MODE == 3
    OTBN_DECLARE_APP_SYMBOLS(otbn_mldsa65_keypair_test_ver1);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_keypair_test_ver1, zeta);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_keypair_test_ver1, pk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_keypair_test_ver1, sk);

    static const otbn_app_t kAppMLDSAVer1Keypair = OTBN_APP_T_INIT(otbn_mldsa65_keypair_test_ver1);
    static const otbn_addr_t kZetaVer1 = OTBN_ADDR_T_INIT(otbn_mldsa65_keypair_test_ver1, zeta);
    static const otbn_addr_t kPkVer1 = OTBN_ADDR_T_INIT(otbn_mldsa65_keypair_test_ver1, pk);
    static const otbn_addr_t kSkVer1 = OTBN_ADDR_T_INIT(otbn_mldsa65_keypair_test_ver1, sk);

    OTBN_DECLARE_APP_SYMBOLS(otbn_mldsa65_sign_test_ver1);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_sign_test_ver1, signature);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_sign_test_ver1, message);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_sign_test_ver1, messagelen);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_sign_test_ver1, sk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_sign_test_ver1, ctx);

    static const otbn_app_t kAppMLDSAVer1Sign = OTBN_APP_T_INIT(otbn_mldsa65_sign_test_ver1);
    static const otbn_addr_t kSigSVer1 = OTBN_ADDR_T_INIT(otbn_mldsa65_sign_test_ver1, signature);
    static const otbn_addr_t kMsgSVer1 = OTBN_ADDR_T_INIT(otbn_mldsa65_sign_test_ver1, message);
    static const otbn_addr_t kMlenSVer1 = OTBN_ADDR_T_INIT(otbn_mldsa65_sign_test_ver1, messagelen);
    static const otbn_addr_t kSkSVer1 = OTBN_ADDR_T_INIT(otbn_mldsa65_sign_test_ver1, sk);
    static const otbn_addr_t kCtxSVer1 = OTBN_ADDR_T_INIT(otbn_mldsa65_sign_test_ver1, ctx);

    OTBN_DECLARE_APP_SYMBOLS(otbn_mldsa65_verify_test_ver1);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_verify_test_ver1, signature);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_verify_test_ver1, message);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_verify_test_ver1, messagelen);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_verify_test_ver1, pk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_verify_test_ver1, ctx);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_verify_test_ver1, result);

    static const otbn_app_t kAppMLDSAVer1Verify = OTBN_APP_T_INIT(otbn_mldsa65_verify_test_ver1);
    static const otbn_addr_t kSigVVer1 = OTBN_ADDR_T_INIT(otbn_mldsa65_verify_test_ver1, signature);
    static const otbn_addr_t kMsgVVer1 = OTBN_ADDR_T_INIT(otbn_mldsa65_verify_test_ver1, message);
    static const otbn_addr_t kMlenVVer1 = OTBN_ADDR_T_INIT(otbn_mldsa65_verify_test_ver1, messagelen);
    static const otbn_addr_t kPkVVer1 = OTBN_ADDR_T_INIT(otbn_mldsa65_verify_test_ver1, pk);
    static const otbn_addr_t kCtxVVer1 = OTBN_ADDR_T_INIT(otbn_mldsa65_verify_test_ver1, ctx);
    static const otbn_addr_t kResVer1 = OTBN_ADDR_T_INIT(otbn_mldsa65_verify_test_ver1, result);
  #elif DILITHIUM_MODE == 5
    OTBN_DECLARE_APP_SYMBOLS(otbn_mldsa87_keypair_test_ver1);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_keypair_test_ver1, zeta);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_keypair_test_ver1, pk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_keypair_test_ver1, sk);

    static const otbn_app_t kAppMLDSAVer1Keypair = OTBN_APP_T_INIT(otbn_mldsa87_keypair_test_ver1);
    static const otbn_addr_t kZetaVer1 = OTBN_ADDR_T_INIT(otbn_mldsa87_keypair_test_ver1, zeta);
    static const otbn_addr_t kPkVer1 = OTBN_ADDR_T_INIT(otbn_mldsa87_keypair_test_ver1, pk);
    static const otbn_addr_t kSkVer1 = OTBN_ADDR_T_INIT(otbn_mldsa87_keypair_test_ver1, sk);

    OTBN_DECLARE_APP_SYMBOLS(otbn_mldsa87_sign_test_ver1);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_sign_test_ver1, signature);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_sign_test_ver1, message);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_sign_test_ver1, messagelen);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_sign_test_ver1, sk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_sign_test_ver1, ctx);

    static const otbn_app_t kAppMLDSAVer1Sign = OTBN_APP_T_INIT(otbn_mldsa87_sign_test_ver1);
    static const otbn_addr_t kSigSVer1 = OTBN_ADDR_T_INIT(otbn_mldsa87_sign_test_ver1, signature);
    static const otbn_addr_t kMsgSVer1 = OTBN_ADDR_T_INIT(otbn_mldsa87_sign_test_ver1, message);
    static const otbn_addr_t kMlenSVer1 = OTBN_ADDR_T_INIT(otbn_mldsa87_sign_test_ver1, messagelen);
    static const otbn_addr_t kSkSVer1 = OTBN_ADDR_T_INIT(otbn_mldsa87_sign_test_ver1, sk);
    static const otbn_addr_t kCtxSVer1 = OTBN_ADDR_T_INIT(otbn_mldsa87_sign_test_ver1, ctx);

    OTBN_DECLARE_APP_SYMBOLS(otbn_mldsa87_verify_test_ver1);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_verify_test_ver1, signature);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_verify_test_ver1, message);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_verify_test_ver1, messagelen);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_verify_test_ver1, pk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_verify_test_ver1, ctx);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_verify_test_ver1, result);

    static const otbn_app_t kAppMLDSAVer1Verify = OTBN_APP_T_INIT(otbn_mldsa87_verify_test_ver1);
    static const otbn_addr_t kSigVVer1 = OTBN_ADDR_T_INIT(otbn_mldsa87_verify_test_ver1, signature);
    static const otbn_addr_t kMsgVVer1 = OTBN_ADDR_T_INIT(otbn_mldsa87_verify_test_ver1, message);
    static const otbn_addr_t kMlenVVer1 = OTBN_ADDR_T_INIT(otbn_mldsa87_verify_test_ver1, messagelen);
    static const otbn_addr_t kPkVVer1 = OTBN_ADDR_T_INIT(otbn_mldsa87_verify_test_ver1, pk);
    static const otbn_addr_t kCtxVVer1 = OTBN_ADDR_T_INIT(otbn_mldsa87_verify_test_ver1, ctx);
    static const otbn_addr_t kResVer1 = OTBN_ADDR_T_INIT(otbn_mldsa87_verify_test_ver1, result);
  #endif
#elif BNMULV_VER == 2
  #if DILITHIUM_MODE == 2
    OTBN_DECLARE_APP_SYMBOLS(otbn_mldsa44_keypair_test_ver2);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_keypair_test_ver2, zeta);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_keypair_test_ver2, pk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_keypair_test_ver2, sk);

    static const otbn_app_t kAppMLDSAVer2Keypair = OTBN_APP_T_INIT(otbn_mldsa44_keypair_test_ver2);
    static const otbn_addr_t kZetaVer2 = OTBN_ADDR_T_INIT(otbn_mldsa44_keypair_test_ver2, zeta);
    static const otbn_addr_t kPkVer2 = OTBN_ADDR_T_INIT(otbn_mldsa44_keypair_test_ver2, pk);
    static const otbn_addr_t kSkVer2 = OTBN_ADDR_T_INIT(otbn_mldsa44_keypair_test_ver2, sk);

    OTBN_DECLARE_APP_SYMBOLS(otbn_mldsa44_sign_test_ver2);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_sign_test_ver2, signature);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_sign_test_ver2, message);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_sign_test_ver2, messagelen);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_sign_test_ver2, sk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_sign_test_ver2, ctx);

    static const otbn_app_t kAppMLDSAVer2Sign = OTBN_APP_T_INIT(otbn_mldsa44_sign_test_ver2);
    static const otbn_addr_t kSigSVer2 = OTBN_ADDR_T_INIT(otbn_mldsa44_sign_test_ver2, signature);
    static const otbn_addr_t kMsgSVer2 = OTBN_ADDR_T_INIT(otbn_mldsa44_sign_test_ver2, message);
    static const otbn_addr_t kMlenSVer2 = OTBN_ADDR_T_INIT(otbn_mldsa44_sign_test_ver2, messagelen);
    static const otbn_addr_t kSkSVer2 = OTBN_ADDR_T_INIT(otbn_mldsa44_sign_test_ver2, sk);
    static const otbn_addr_t kCtxSVer2 = OTBN_ADDR_T_INIT(otbn_mldsa44_sign_test_ver2, ctx);

    OTBN_DECLARE_APP_SYMBOLS(otbn_mldsa44_verify_test_ver2);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_verify_test_ver2, signature);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_verify_test_ver2, message);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_verify_test_ver2, messagelen);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_verify_test_ver2, pk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_verify_test_ver2, ctx);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_verify_test_ver2, result);

    static const otbn_app_t kAppMLDSAVer2Verify = OTBN_APP_T_INIT(otbn_mldsa44_verify_test_ver2);
    static const otbn_addr_t kSigVVer2 = OTBN_ADDR_T_INIT(otbn_mldsa44_verify_test_ver2, signature);
    static const otbn_addr_t kMsgVVer2 = OTBN_ADDR_T_INIT(otbn_mldsa44_verify_test_ver2, message);
    static const otbn_addr_t kMlenVVer2 = OTBN_ADDR_T_INIT(otbn_mldsa44_verify_test_ver2, messagelen);
    static const otbn_addr_t kPkVVer2 = OTBN_ADDR_T_INIT(otbn_mldsa44_verify_test_ver2, pk);
    static const otbn_addr_t kCtxVVer2 = OTBN_ADDR_T_INIT(otbn_mldsa44_verify_test_ver2, ctx);
    static const otbn_addr_t kResVer2 = OTBN_ADDR_T_INIT(otbn_mldsa44_verify_test_ver2, result);
  #elif DILITHIUM_MODE == 3
    OTBN_DECLARE_APP_SYMBOLS(otbn_mldsa65_keypair_test_ver2);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_keypair_test_ver2, zeta);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_keypair_test_ver2, pk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_keypair_test_ver2, sk);

    static const otbn_app_t kAppMLDSAVer2Keypair = OTBN_APP_T_INIT(otbn_mldsa65_keypair_test_ver2);
    static const otbn_addr_t kZetaVer2 = OTBN_ADDR_T_INIT(otbn_mldsa65_keypair_test_ver2, zeta);
    static const otbn_addr_t kPkVer2 = OTBN_ADDR_T_INIT(otbn_mldsa65_keypair_test_ver2, pk);
    static const otbn_addr_t kSkVer2 = OTBN_ADDR_T_INIT(otbn_mldsa65_keypair_test_ver2, sk);

    OTBN_DECLARE_APP_SYMBOLS(otbn_mldsa65_sign_test_ver2);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_sign_test_ver2, signature);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_sign_test_ver2, message);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_sign_test_ver2, messagelen);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_sign_test_ver2, sk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_sign_test_ver2, ctx);

    static const otbn_app_t kAppMLDSAVer2Sign = OTBN_APP_T_INIT(otbn_mldsa65_sign_test_ver2);
    static const otbn_addr_t kSigSVer2 = OTBN_ADDR_T_INIT(otbn_mldsa65_sign_test_ver2, signature);
    static const otbn_addr_t kMsgSVer2 = OTBN_ADDR_T_INIT(otbn_mldsa65_sign_test_ver2, message);
    static const otbn_addr_t kMlenSVer2 = OTBN_ADDR_T_INIT(otbn_mldsa65_sign_test_ver2, messagelen);
    static const otbn_addr_t kSkSVer2 = OTBN_ADDR_T_INIT(otbn_mldsa65_sign_test_ver2, sk);
    static const otbn_addr_t kCtxSVer2 = OTBN_ADDR_T_INIT(otbn_mldsa65_sign_test_ver2, ctx);

    OTBN_DECLARE_APP_SYMBOLS(otbn_mldsa65_verify_test_ver2);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_verify_test_ver2, signature);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_verify_test_ver2, message);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_verify_test_ver2, messagelen);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_verify_test_ver2, pk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_verify_test_ver2, ctx);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_verify_test_ver2, result);

    static const otbn_app_t kAppMLDSAVer2Verify = OTBN_APP_T_INIT(otbn_mldsa65_verify_test_ver2);
    static const otbn_addr_t kSigVVer2 = OTBN_ADDR_T_INIT(otbn_mldsa65_verify_test_ver2, signature);
    static const otbn_addr_t kMsgVVer2 = OTBN_ADDR_T_INIT(otbn_mldsa65_verify_test_ver2, message);
    static const otbn_addr_t kMlenVVer2 = OTBN_ADDR_T_INIT(otbn_mldsa65_verify_test_ver2, messagelen);
    static const otbn_addr_t kPkVVer2 = OTBN_ADDR_T_INIT(otbn_mldsa65_verify_test_ver2, pk);
    static const otbn_addr_t kCtxVVer2 = OTBN_ADDR_T_INIT(otbn_mldsa65_verify_test_ver2, ctx);
    static const otbn_addr_t kResVer2 = OTBN_ADDR_T_INIT(otbn_mldsa65_verify_test_ver2, result);
  #elif DILITHIUM_MODE == 5
      OTBN_DECLARE_APP_SYMBOLS(otbn_mldsa87_keypair_test_ver2);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_keypair_test_ver2, zeta);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_keypair_test_ver2, pk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_keypair_test_ver2, sk);

    static const otbn_app_t kAppMLDSAVer2Keypair = OTBN_APP_T_INIT(otbn_mldsa87_keypair_test_ver2);
    static const otbn_addr_t kZetaVer2 = OTBN_ADDR_T_INIT(otbn_mldsa87_keypair_test_ver2, zeta);
    static const otbn_addr_t kPkVer2 = OTBN_ADDR_T_INIT(otbn_mldsa87_keypair_test_ver2, pk);
    static const otbn_addr_t kSkVer2 = OTBN_ADDR_T_INIT(otbn_mldsa87_keypair_test_ver2, sk);

    OTBN_DECLARE_APP_SYMBOLS(otbn_mldsa87_sign_test_ver2);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_sign_test_ver2, signature);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_sign_test_ver2, message);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_sign_test_ver2, messagelen);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_sign_test_ver2, sk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_sign_test_ver2, ctx);

    static const otbn_app_t kAppMLDSAVer2Sign = OTBN_APP_T_INIT(otbn_mldsa87_sign_test_ver2);
    static const otbn_addr_t kSigSVer2 = OTBN_ADDR_T_INIT(otbn_mldsa87_sign_test_ver2, signature);
    static const otbn_addr_t kMsgSVer2 = OTBN_ADDR_T_INIT(otbn_mldsa87_sign_test_ver2, message);
    static const otbn_addr_t kMlenSVer2 = OTBN_ADDR_T_INIT(otbn_mldsa87_sign_test_ver2, messagelen);
    static const otbn_addr_t kSkSVer2 = OTBN_ADDR_T_INIT(otbn_mldsa87_sign_test_ver2, sk);
    static const otbn_addr_t kCtxSVer2 = OTBN_ADDR_T_INIT(otbn_mldsa87_sign_test_ver2, ctx);

    OTBN_DECLARE_APP_SYMBOLS(otbn_mldsa87_verify_test_ver2);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_verify_test_ver2, signature);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_verify_test_ver2, message);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_verify_test_ver2, messagelen);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_verify_test_ver2, pk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_verify_test_ver2, ctx);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_verify_test_ver2, result);

    static const otbn_app_t kAppMLDSAVer2Verify = OTBN_APP_T_INIT(otbn_mldsa87_verify_test_ver2);
    static const otbn_addr_t kSigVVer2 = OTBN_ADDR_T_INIT(otbn_mldsa87_verify_test_ver2, signature);
    static const otbn_addr_t kMsgVVer2 = OTBN_ADDR_T_INIT(otbn_mldsa87_verify_test_ver2, message);
    static const otbn_addr_t kMlenVVer2 = OTBN_ADDR_T_INIT(otbn_mldsa87_verify_test_ver2, messagelen);
    static const otbn_addr_t kPkVVer2 = OTBN_ADDR_T_INIT(otbn_mldsa87_verify_test_ver2, pk);
    static const otbn_addr_t kCtxVVer2 = OTBN_ADDR_T_INIT(otbn_mldsa87_verify_test_ver2, ctx);
    static const otbn_addr_t kResVer2 = OTBN_ADDR_T_INIT(otbn_mldsa87_verify_test_ver2, result);
  #endif
#elif BNMULV_VER == 3
  #if DILITHIUM_MODE == 2
    OTBN_DECLARE_APP_SYMBOLS(otbn_mldsa44_keypair_test_ver3);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_keypair_test_ver3, zeta);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_keypair_test_ver3, pk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_keypair_test_ver3, sk);

    static const otbn_app_t kAppMLDSAVer3Keypair = OTBN_APP_T_INIT(otbn_mldsa44_keypair_test_ver3);
    static const otbn_addr_t kZetaVer3 = OTBN_ADDR_T_INIT(otbn_mldsa44_keypair_test_ver3, zeta);
    static const otbn_addr_t kPkVer3 = OTBN_ADDR_T_INIT(otbn_mldsa44_keypair_test_ver3, pk);
    static const otbn_addr_t kSkVer3 = OTBN_ADDR_T_INIT(otbn_mldsa44_keypair_test_ver3, sk);

    OTBN_DECLARE_APP_SYMBOLS(otbn_mldsa44_sign_test_ver3);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_sign_test_ver3, signature);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_sign_test_ver3, message);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_sign_test_ver3, messagelen);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_sign_test_ver3, sk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_sign_test_ver3, ctx);

    static const otbn_app_t kAppMLDSAVer3Sign = OTBN_APP_T_INIT(otbn_mldsa44_sign_test_ver3);
    static const otbn_addr_t kSigSVer3 = OTBN_ADDR_T_INIT(otbn_mldsa44_sign_test_ver3, signature);
    static const otbn_addr_t kMsgSVer3 = OTBN_ADDR_T_INIT(otbn_mldsa44_sign_test_ver3, message);
    static const otbn_addr_t kMlenSVer3 = OTBN_ADDR_T_INIT(otbn_mldsa44_sign_test_ver3, messagelen);
    static const otbn_addr_t kSkSVer3 = OTBN_ADDR_T_INIT(otbn_mldsa44_sign_test_ver3, sk);
    static const otbn_addr_t kCtxSVer3 = OTBN_ADDR_T_INIT(otbn_mldsa44_sign_test_ver3, ctx);

    OTBN_DECLARE_APP_SYMBOLS(otbn_mldsa44_verify_test_ver3);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_verify_test_ver3, signature);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_verify_test_ver3, message);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_verify_test_ver3, messagelen);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_verify_test_ver3, pk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_verify_test_ver3, ctx);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa44_verify_test_ver3, result);

    static const otbn_app_t kAppMLDSAVer3Verify = OTBN_APP_T_INIT(otbn_mldsa44_verify_test_ver3);
    static const otbn_addr_t kSigVVer3 = OTBN_ADDR_T_INIT(otbn_mldsa44_verify_test_ver3, signature);
    static const otbn_addr_t kMsgVVer3 = OTBN_ADDR_T_INIT(otbn_mldsa44_verify_test_ver3, message);
    static const otbn_addr_t kMlenVVer3 = OTBN_ADDR_T_INIT(otbn_mldsa44_verify_test_ver3, messagelen);
    static const otbn_addr_t kPkVVer3 = OTBN_ADDR_T_INIT(otbn_mldsa44_verify_test_ver3, pk);
    static const otbn_addr_t kCtxVVer3 = OTBN_ADDR_T_INIT(otbn_mldsa44_verify_test_ver3, ctx);
    static const otbn_addr_t kResVer3 = OTBN_ADDR_T_INIT(otbn_mldsa44_verify_test_ver3, result);
  #elif DILITHIUM_MODE == 3
    OTBN_DECLARE_APP_SYMBOLS(otbn_mldsa65_keypair_test_ver3);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_keypair_test_ver3, zeta);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_keypair_test_ver3, pk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_keypair_test_ver3, sk);

    static const otbn_app_t kAppMLDSAVer3Keypair = OTBN_APP_T_INIT(otbn_mldsa65_keypair_test_ver3);
    static const otbn_addr_t kZetaVer3 = OTBN_ADDR_T_INIT(otbn_mldsa65_keypair_test_ver3, zeta);
    static const otbn_addr_t kPkVer3 = OTBN_ADDR_T_INIT(otbn_mldsa65_keypair_test_ver3, pk);
    static const otbn_addr_t kSkVer3 = OTBN_ADDR_T_INIT(otbn_mldsa65_keypair_test_ver3, sk);

    OTBN_DECLARE_APP_SYMBOLS(otbn_mldsa65_sign_test_ver3);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_sign_test_ver3, signature);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_sign_test_ver3, message);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_sign_test_ver3, messagelen);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_sign_test_ver3, sk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_sign_test_ver3, ctx);

    static const otbn_app_t kAppMLDSAVer3Sign = OTBN_APP_T_INIT(otbn_mldsa65_sign_test_ver3);
    static const otbn_addr_t kSigSVer3 = OTBN_ADDR_T_INIT(otbn_mldsa65_sign_test_ver3, signature);
    static const otbn_addr_t kMsgSVer3 = OTBN_ADDR_T_INIT(otbn_mldsa65_sign_test_ver3, message);
    static const otbn_addr_t kMlenSVer3 = OTBN_ADDR_T_INIT(otbn_mldsa65_sign_test_ver3, messagelen);
    static const otbn_addr_t kSkSVer3 = OTBN_ADDR_T_INIT(otbn_mldsa65_sign_test_ver3, sk);
    static const otbn_addr_t kCtxSVer3 = OTBN_ADDR_T_INIT(otbn_mldsa65_sign_test_ver3, ctx);

    OTBN_DECLARE_APP_SYMBOLS(otbn_mldsa65_verify_test_ver3);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_verify_test_ver3, signature);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_verify_test_ver3, message);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_verify_test_ver3, messagelen);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_verify_test_ver3, pk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_verify_test_ver3, ctx);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa65_verify_test_ver3, result);

    static const otbn_app_t kAppMLDSAVer3Verify = OTBN_APP_T_INIT(otbn_mldsa65_verify_test_ver3);
    static const otbn_addr_t kSigVVer3 = OTBN_ADDR_T_INIT(otbn_mldsa65_verify_test_ver3, signature);
    static const otbn_addr_t kMsgVVer3 = OTBN_ADDR_T_INIT(otbn_mldsa65_verify_test_ver3, message);
    static const otbn_addr_t kMlenVVer3 = OTBN_ADDR_T_INIT(otbn_mldsa65_verify_test_ver3, messagelen);
    static const otbn_addr_t kPkVVer3 = OTBN_ADDR_T_INIT(otbn_mldsa65_verify_test_ver3, pk);
    static const otbn_addr_t kCtxVVer3 = OTBN_ADDR_T_INIT(otbn_mldsa65_verify_test_ver3, ctx);
    static const otbn_addr_t kResVer3 = OTBN_ADDR_T_INIT(otbn_mldsa65_verify_test_ver3, result);
  #elif DILITHIUM_MODE == 5
    OTBN_DECLARE_APP_SYMBOLS(otbn_mldsa87_keypair_test_ver3);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_keypair_test_ver3, zeta);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_keypair_test_ver3, pk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_keypair_test_ver3, sk);

    static const otbn_app_t kAppMLDSAVer3Keypair = OTBN_APP_T_INIT(otbn_mldsa87_keypair_test_ver3);
    static const otbn_addr_t kZetaVer3 = OTBN_ADDR_T_INIT(otbn_mldsa87_keypair_test_ver3, zeta);
    static const otbn_addr_t kPkVer3 = OTBN_ADDR_T_INIT(otbn_mldsa87_keypair_test_ver3, pk);
    static const otbn_addr_t kSkVer3 = OTBN_ADDR_T_INIT(otbn_mldsa87_keypair_test_ver3, sk);

    OTBN_DECLARE_APP_SYMBOLS(otbn_mldsa87_sign_test_ver3);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_sign_test_ver3, signature);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_sign_test_ver3, message);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_sign_test_ver3, messagelen);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_sign_test_ver3, sk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_sign_test_ver3, ctx);

    static const otbn_app_t kAppMLDSAVer3Sign = OTBN_APP_T_INIT(otbn_mldsa87_sign_test_ver3);
    static const otbn_addr_t kSigSVer3 = OTBN_ADDR_T_INIT(otbn_mldsa87_sign_test_ver3, signature);
    static const otbn_addr_t kMsgSVer3 = OTBN_ADDR_T_INIT(otbn_mldsa87_sign_test_ver3, message);
    static const otbn_addr_t kMlenSVer3 = OTBN_ADDR_T_INIT(otbn_mldsa87_sign_test_ver3, messagelen);
    static const otbn_addr_t kSkSVer3 = OTBN_ADDR_T_INIT(otbn_mldsa87_sign_test_ver3, sk);
    static const otbn_addr_t kCtxSVer3 = OTBN_ADDR_T_INIT(otbn_mldsa87_sign_test_ver3, ctx);

    OTBN_DECLARE_APP_SYMBOLS(otbn_mldsa87_verify_test_ver3);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_verify_test_ver3, signature);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_verify_test_ver3, message);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_verify_test_ver3, messagelen);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_verify_test_ver3, pk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_verify_test_ver3, ctx);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mldsa87_verify_test_ver3, result);

    static const otbn_app_t kAppMLDSAVer3Verify = OTBN_APP_T_INIT(otbn_mldsa87_verify_test_ver3);
    static const otbn_addr_t kSigVVer3 = OTBN_ADDR_T_INIT(otbn_mldsa87_verify_test_ver3, signature);
    static const otbn_addr_t kMsgVVer3 = OTBN_ADDR_T_INIT(otbn_mldsa87_verify_test_ver3, message);
    static const otbn_addr_t kMlenVVer3 = OTBN_ADDR_T_INIT(otbn_mldsa87_verify_test_ver3, messagelen);
    static const otbn_addr_t kPkVVer3 = OTBN_ADDR_T_INIT(otbn_mldsa87_verify_test_ver3, pk);
    static const otbn_addr_t kCtxVVer3 = OTBN_ADDR_T_INIT(otbn_mldsa87_verify_test_ver3, ctx);
    static const otbn_addr_t kResVer3 = OTBN_ADDR_T_INIT(otbn_mldsa87_verify_test_ver3, result);
  #endif
#endif

OTTF_DEFINE_TEST_CONFIG();
 
/* Deterministic randombytes by Daniel J. Bernstein */
/* taken from SUPERCOP (https://bench.cr.yp.to)     */
static keccak_state rngstate = {
  {0x1F, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (1ULL << 63),
  0, 0, 0, 0},
  SHAKE128_RATE};

void randombytes(uint8_t *x,size_t xlen)
{
  shake128_squeeze(x, xlen, &rngstate);
}

static void test_sec_wipe(dif_otbn_t *otbn) {
  dif_otbn_status_t otbn_status;

  CHECK_DIF_OK(dif_otbn_write_cmd(otbn, kDifOtbnCmdSecWipeDmem));
  CHECK_DIF_OK(dif_otbn_get_status(otbn, &otbn_status));
  CHECK(otbn_status == kDifOtbnStatusBusySecWipeDmem);
  CHECK_STATUS_OK(otbn_testutils_wait_for_done(otbn, kDifOtbnErrBitsNoError));

  CHECK_DIF_OK(dif_otbn_write_cmd(otbn, kDifOtbnCmdSecWipeImem));
  CHECK_DIF_OK(dif_otbn_get_status(otbn, &otbn_status));
  CHECK(otbn_status == kDifOtbnStatusBusySecWipeImem);
  CHECK_STATUS_OK(otbn_testutils_wait_for_done(otbn, kDifOtbnErrBitsNoError));
}

static void test_mldsa(dif_otbn_t *otbn) {
  LOG_INFO("Generate zeta");
  uint8_t zeta[SEEDBYTES];
  randombytes(zeta, SEEDBYTES);
  LOG_INFO("%02x %02x %02x", zeta[0], zeta[1], zeta[2]);

  LOG_INFO("Generate message");
  /* mlen must be uint32_t to be correctly written to OTBN's DMEM. */
  uint32_t mlen = MLEN;
  uint8_t m[MLEN];
  randombytes(m, MLEN);

  // Prepare context
  uint8_t pre[2+CTXLEN];
  pre[0] = 0;
  pre[1] = CTXLEN;
  for(int i = 0; i < CTXLEN; i++)
    pre[2 + i] = context[i];

  LOG_INFO("Run C implementation");
  uint8_t pk_expected[CRYPTO_PUBLICKEYBYTES];
  uint8_t sk_expected[CRYPTO_SECRETKEYBYTES];
  size_t siglen;
  uint8_t sig_expected[CRYPTO_BYTES_ALIGNED];
  uint8_t rnd[RNDBYTES] = {0};
  int res_expected;
  crypto_sign_keypair_internal(pk_expected, sk_expected, zeta);
  crypto_sign_signature_internal(sig_expected, &siglen, m, mlen, pre, sizeof(pre), rnd, sk_expected);
  res_expected = crypto_sign_verify_internal(sig_expected, CRYPTO_BYTES, m, mlen, pre, sizeof(pre), pk_expected);

  uint8_t pk[CRYPTO_PUBLICKEYBYTES];
  uint8_t sk[CRYPTO_SECRETKEYBYTES];
  uint8_t sig[CRYPTO_BYTES_ALIGNED];
  int res;

  /* Run keypair */
  /* ------------------------------------------------------------------------ */
  LOG_INFO("Load VER%d keypair", BNMULV_VER);
#if BNMULV_VER == 1
  CHECK_STATUS_OK(otbn_testutils_load_app(otbn, kAppMLDSAVer1Keypair));
  LOG_INFO("Write inputs to OTBN's DMEM");
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, SEEDBYTES, &zeta, kZetaVer1));
#elif BNMULV_VER == 2
  CHECK_STATUS_OK(otbn_testutils_load_app(otbn, kAppMLDSAVer2Keypair));
  LOG_INFO("Write inputs to OTBN's DMEM");
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, SEEDBYTES, &zeta, kZetaVer2));
#elif BNMULV_VER == 3
  CHECK_STATUS_OK(otbn_testutils_load_app(otbn, kAppMLDSAVer3Keypair));
  LOG_INFO("Write inputs to OTBN's DMEM");
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, SEEDBYTES, &zeta, kZetaVer3));
#endif

  LOG_INFO("Run VER%d keypair", BNMULV_VER); 
  CHECK_DIF_OK(dif_otbn_set_ctrl_software_errs_fatal(otbn, true));
  CHECK_STATUS_OK(otbn_testutils_execute(otbn));
  CHECK(dif_otbn_set_ctrl_software_errs_fatal(otbn, false) == kDifUnavailable);
  CHECK_STATUS_OK(otbn_testutils_wait_for_done(otbn, kDifOtbnErrBitsNoError));

  LOG_INFO("Retrieve results");
#if BNMULV_VER == 1
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, CRYPTO_PUBLICKEYBYTES, kPkVer1, &pk));
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, CRYPTO_SECRETKEYBYTES, kSkVer1, &sk));
#elif BNMULV_VER == 2
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, CRYPTO_PUBLICKEYBYTES, kPkVer2, &pk));
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, CRYPTO_SECRETKEYBYTES, kSkVer2, &sk));
#elif BNMULV_VER == 3
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, CRYPTO_PUBLICKEYBYTES, kPkVer3, &pk));
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, CRYPTO_SECRETKEYBYTES, kSkVer3, &sk));
#endif

  LOG_INFO("Check VER%d keys", BNMULV_VER);
  CHECK_ARRAYS_EQ(pk, pk_expected, CRYPTO_PUBLICKEYBYTES);
  CHECK_ARRAYS_EQ(sk, sk_expected, CRYPTO_SECRETKEYBYTES);

  /* Run sign */
  /* ------------------------------------------------------------------------ */
  LOG_INFO("Load VER%d sign", BNMULV_VER);
#if BNMULV_VER == 1
  CHECK_STATUS_OK(otbn_testutils_load_app(otbn, kAppMLDSAVer1Sign));
  LOG_INFO("Write inputs to OTBN's DMEM");
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, MLEN, &m, kMsgSVer1));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, sizeof(uint32_t), &mlen, kMlenSVer1));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, CRYPTO_SECRETKEYBYTES, &sk_expected, kSkSVer1));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, CTXLEN, &context, kCtxSVer1));
#elif BNMULV_VER == 2
  CHECK_STATUS_OK(otbn_testutils_load_app(otbn, kAppMLDSAVer2Sign));
  LOG_INFO("Write inputs to OTBN's DMEM");
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, MLEN, &m, kMsgSVer2));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, sizeof(uint32_t), &mlen, kMlenSVer2));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, CRYPTO_SECRETKEYBYTES, &sk_expected, kSkSVer2));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, CTXLEN, &context, kCtxSVer2));
#elif BNMULV_VER == 3
  CHECK_STATUS_OK(otbn_testutils_load_app(otbn, kAppMLDSAVer3Sign));
  LOG_INFO("Write inputs to OTBN's DMEM");
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, MLEN, &m, kMsgSVer3));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, sizeof(uint32_t), &mlen, kMlenSVer3));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, CRYPTO_SECRETKEYBYTES, &sk_expected, kSkSVer3));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, CTXLEN, &context, kCtxSVer3));
#endif

  LOG_INFO("Run VER%d sign", BNMULV_VER); 
  CHECK_DIF_OK(dif_otbn_set_ctrl_software_errs_fatal(otbn, true));
  CHECK_STATUS_OK(otbn_testutils_execute(otbn));
  CHECK(dif_otbn_set_ctrl_software_errs_fatal(otbn, false) == kDifUnavailable);
  CHECK_STATUS_OK(otbn_testutils_wait_for_done(otbn, kDifOtbnErrBitsNoError));

  LOG_INFO("Retrieve results");
#if BNMULV_VER == 1
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, CRYPTO_BYTES_ALIGNED, kSigSVer1, &sig));
#elif BNMULV_VER == 2
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, CRYPTO_BYTES_ALIGNED, kSigSVer2, &sig));
#elif BNMULV_VER == 3
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, CRYPTO_BYTES_ALIGNED, kSigSVer3, &sig));
#endif

  LOG_INFO("Check VER%d signature", BNMULV_VER);
    for (int i = 0; i < CRYPTO_BYTES; ++i) {
    CHECK(sig[i] == sig_expected[i],
          "Unexpected result c at byte %d: 0x%02x (actual) != 0x%02x (expected)", i,
          sig[i], sig_expected[i]);
  }

  /* Run verify */
  /* ------------------------------------------------------------------------ */
  LOG_INFO("Load VER%d verify", BNMULV_VER);
#if BNMULV_VER == 1
  CHECK_STATUS_OK(otbn_testutils_load_app(otbn, kAppMLDSAVer1Verify));
  LOG_INFO("Write inputs to OTBN's DMEM");
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, CRYPTO_BYTES_ALIGNED, &sig, kSigVVer1));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, MLEN, &m, kMsgVVer1));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, sizeof(uint32_t), &mlen, kMlenVVer1));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, CRYPTO_PUBLICKEYBYTES, &pk, kPkVVer1));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, CTXLEN, &context, kCtxVVer1));
#elif BNMULV_VER == 2
  CHECK_STATUS_OK(otbn_testutils_load_app(otbn, kAppMLDSAVer2Verify));
  LOG_INFO("Write inputs to OTBN's DMEM");
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, CRYPTO_BYTES_ALIGNED, &sig, kSigVVer2));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, MLEN, &m, kMsgVVer2));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, sizeof(uint32_t), &mlen, kMlenVVer2));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, CRYPTO_PUBLICKEYBYTES, &pk, kPkVVer2));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, CTXLEN, &context, kCtxVVer2));
#elif BNMULV_VER == 3
  CHECK_STATUS_OK(otbn_testutils_load_app(otbn, kAppMLDSAVer3Verify));
  LOG_INFO("Write inputs to OTBN's DMEM");
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, CRYPTO_BYTES_ALIGNED, &sig, kSigVVer3));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, MLEN, &m, kMsgVVer3));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, sizeof(uint32_t), &mlen, kMlenVVer3));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, CRYPTO_PUBLICKEYBYTES, &pk, kPkVVer3));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, CTXLEN, &context, kCtxVVer3));
#endif

  LOG_INFO("Run VER%d verify", BNMULV_VER); 
  CHECK_DIF_OK(dif_otbn_set_ctrl_software_errs_fatal(otbn, true));
  CHECK_STATUS_OK(otbn_testutils_execute(otbn));
  CHECK(dif_otbn_set_ctrl_software_errs_fatal(otbn, false) == kDifUnavailable);
  CHECK_STATUS_OK(otbn_testutils_wait_for_done(otbn, kDifOtbnErrBitsNoError));
 
  LOG_INFO("Retrieve results");
#if BNMULV_VER == 1
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, sizeof(uint32_t), kResVer1, &res));
#elif BNMULV_VER == 2
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, sizeof(uint32_t), kResVer2, &res));
#elif BNMULV_VER == 3
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, sizeof(uint32_t), kResVer3, &res));
#endif

  LOG_INFO("Check VER%d verify", BNMULV_VER);
  CHECK(res == res_expected, "Verification failed: got %d != %d (expected)", res, res_expected);
  LOG_INFO("res = %d", res);
}

bool test_main(void) {

  CHECK_STATUS_OK(entropy_testutils_auto_mode_init());

  // Initialize OTBN
  LOG_INFO("Initialize OTBN");
  dif_otbn_t otbn;
  CHECK_DIF_OK(
      dif_otbn_init(mmio_region_from_addr(TOP_EARLGREY_OTBN_BASE_ADDR), &otbn));

  for(int i = 0; i < NTESTS; i++) {
    LOG_INFO("Iteration %d", i);
    test_mldsa(&otbn);
  }

  test_sec_wipe(&otbn);

  return true;
}
