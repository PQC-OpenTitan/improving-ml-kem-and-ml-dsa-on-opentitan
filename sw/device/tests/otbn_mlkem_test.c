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

#include "sw/device/tests/pq-crystals/kyber_opentitan/ref/params.h"
#include "sw/device/tests/pq-crystals/kyber_opentitan/ref/kem.h"
#include "sw/device/tests/pq-crystals/kyber_opentitan/ref/fips202.h"

#ifndef NTESTS 
  #define NTESTS 1
#endif

#ifndef BNMULV_VER
  #define BNMULV_VER 1
#endif

#if KYBER_K == 2
  #if BNMULV_VER == 1
    OTBN_DECLARE_APP_SYMBOLS(otbn_mlkem512_keypair_test_ver1);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem512_keypair_test_ver1, coins);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem512_keypair_test_ver1, dk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem512_keypair_test_ver1, ek);

    static const otbn_app_t kAppMLKEMVer1Keypair = OTBN_APP_T_INIT(otbn_mlkem512_keypair_test_ver1);
    static const otbn_addr_t kCoinsVer1 = OTBN_ADDR_T_INIT(otbn_mlkem512_keypair_test_ver1, coins);
    static const otbn_addr_t kEkVer1 = OTBN_ADDR_T_INIT(otbn_mlkem512_keypair_test_ver1, ek);
    static const otbn_addr_t kDkVer1 = OTBN_ADDR_T_INIT(otbn_mlkem512_keypair_test_ver1, dk);

    OTBN_DECLARE_APP_SYMBOLS(otbn_mlkem512_encap_test_ver1);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem512_encap_test_ver1, coins);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem512_encap_test_ver1, ct);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem512_encap_test_ver1, ss);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem512_encap_test_ver1, ek);

    static const otbn_app_t kAppMLKEMVer1Encap = OTBN_APP_T_INIT(otbn_mlkem512_encap_test_ver1);
    static const otbn_addr_t kCoinsEVer1 = OTBN_ADDR_T_INIT(otbn_mlkem512_encap_test_ver1, coins);
    static const otbn_addr_t kCtEVer1 = OTBN_ADDR_T_INIT(otbn_mlkem512_encap_test_ver1, ct);
    static const otbn_addr_t kSsEVer1 = OTBN_ADDR_T_INIT(otbn_mlkem512_encap_test_ver1, ss);
    static const otbn_addr_t kEkEVer1 = OTBN_ADDR_T_INIT(otbn_mlkem512_encap_test_ver1, ek);

    OTBN_DECLARE_APP_SYMBOLS(otbn_mlkem512_decap_test_ver1);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem512_decap_test_ver1, ct);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem512_decap_test_ver1, dk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem512_decap_test_ver1, ss);

    static const otbn_app_t kAppMLKEMVer1Decap = OTBN_APP_T_INIT(otbn_mlkem512_decap_test_ver1);
    static const otbn_addr_t kCtDVer1 = OTBN_ADDR_T_INIT(otbn_mlkem512_decap_test_ver1, ct);
    static const otbn_addr_t kDkDVer1 = OTBN_ADDR_T_INIT(otbn_mlkem512_decap_test_ver1, dk);
    static const otbn_addr_t kSsDVer1 = OTBN_ADDR_T_INIT(otbn_mlkem512_decap_test_ver1, ss);
  #elif BNMULV_VER == 2
    OTBN_DECLARE_APP_SYMBOLS(otbn_mlkem512_keypair_test_ver2);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem512_keypair_test_ver2, coins);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem512_keypair_test_ver2, dk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem512_keypair_test_ver2, ek);

    static const otbn_app_t kAppMLKEMVer2Keypair = OTBN_APP_T_INIT(otbn_mlkem512_keypair_test_ver2);
    static const otbn_addr_t kCoinsVer2 = OTBN_ADDR_T_INIT(otbn_mlkem512_keypair_test_ver2, coins);
    static const otbn_addr_t kEkVer2 = OTBN_ADDR_T_INIT(otbn_mlkem512_keypair_test_ver2, ek);
    static const otbn_addr_t kDkVer2 = OTBN_ADDR_T_INIT(otbn_mlkem512_keypair_test_ver2, dk);

    OTBN_DECLARE_APP_SYMBOLS(otbn_mlkem512_encap_test_ver2);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem512_encap_test_ver2, coins);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem512_encap_test_ver2, ct);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem512_encap_test_ver2, ss);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem512_encap_test_ver2, ek);

    static const otbn_app_t kAppMLKEMVer2Encap = OTBN_APP_T_INIT(otbn_mlkem512_encap_test_ver2);
    static const otbn_addr_t kCoinsEVer2 = OTBN_ADDR_T_INIT(otbn_mlkem512_encap_test_ver2, coins);
    static const otbn_addr_t kCtEVer2 = OTBN_ADDR_T_INIT(otbn_mlkem512_encap_test_ver2, ct);
    static const otbn_addr_t kSsEVer2 = OTBN_ADDR_T_INIT(otbn_mlkem512_encap_test_ver2, ss);
    static const otbn_addr_t kEkEVer2 = OTBN_ADDR_T_INIT(otbn_mlkem512_encap_test_ver2, ek);

    OTBN_DECLARE_APP_SYMBOLS(otbn_mlkem512_decap_test_ver2);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem512_decap_test_ver2, ct);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem512_decap_test_ver2, dk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem512_decap_test_ver2, ss);

    static const otbn_app_t kAppMLKEMVer2Decap = OTBN_APP_T_INIT(otbn_mlkem512_decap_test_ver2);
    static const otbn_addr_t kCtDVer2 = OTBN_ADDR_T_INIT(otbn_mlkem512_decap_test_ver2, ct);
    static const otbn_addr_t kDkDVer2 = OTBN_ADDR_T_INIT(otbn_mlkem512_decap_test_ver2, dk);
    static const otbn_addr_t kSsDVer2 = OTBN_ADDR_T_INIT(otbn_mlkem512_decap_test_ver2, ss);
  #elif BNMULV_VER == 3
    OTBN_DECLARE_APP_SYMBOLS(otbn_mlkem512_keypair_test_ver3);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem512_keypair_test_ver3, coins);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem512_keypair_test_ver3, dk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem512_keypair_test_ver3, ek);

    static const otbn_app_t kAppMLKEMVer3Keypair = OTBN_APP_T_INIT(otbn_mlkem512_keypair_test_ver3);
    static const otbn_addr_t kCoinsVer3 = OTBN_ADDR_T_INIT(otbn_mlkem512_keypair_test_ver3, coins);
    static const otbn_addr_t kEkVer3 = OTBN_ADDR_T_INIT(otbn_mlkem512_keypair_test_ver3, ek);
    static const otbn_addr_t kDkVer3 = OTBN_ADDR_T_INIT(otbn_mlkem512_keypair_test_ver3, dk);

    OTBN_DECLARE_APP_SYMBOLS(otbn_mlkem512_encap_test_ver3);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem512_encap_test_ver3, coins);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem512_encap_test_ver3, ct);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem512_encap_test_ver3, ss);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem512_encap_test_ver3, ek);

    static const otbn_app_t kAppMLKEMVer3Encap = OTBN_APP_T_INIT(otbn_mlkem512_encap_test_ver3);
    static const otbn_addr_t kCoinsEVer3 = OTBN_ADDR_T_INIT(otbn_mlkem512_encap_test_ver3, coins);
    static const otbn_addr_t kCtEVer3 = OTBN_ADDR_T_INIT(otbn_mlkem512_encap_test_ver3, ct);
    static const otbn_addr_t kSsEVer3 = OTBN_ADDR_T_INIT(otbn_mlkem512_encap_test_ver3, ss);
    static const otbn_addr_t kEkEVer3 = OTBN_ADDR_T_INIT(otbn_mlkem512_encap_test_ver3, ek);

    OTBN_DECLARE_APP_SYMBOLS(otbn_mlkem512_decap_test_ver3);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem512_decap_test_ver3, ct);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem512_decap_test_ver3, dk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem512_decap_test_ver3, ss);

    static const otbn_app_t kAppMLKEMVer3Decap = OTBN_APP_T_INIT(otbn_mlkem512_decap_test_ver3);
    static const otbn_addr_t kCtDVer3 = OTBN_ADDR_T_INIT(otbn_mlkem512_decap_test_ver3, ct);
    static const otbn_addr_t kDkDVer3 = OTBN_ADDR_T_INIT(otbn_mlkem512_decap_test_ver3, dk);
    static const otbn_addr_t kSsDVer3 = OTBN_ADDR_T_INIT(otbn_mlkem512_decap_test_ver3, ss);
  #endif
#elif KYBER_K == 3
  #if BNMULV_VER == 1
    OTBN_DECLARE_APP_SYMBOLS(otbn_mlkem768_keypair_test_ver1);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem768_keypair_test_ver1, coins);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem768_keypair_test_ver1, dk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem768_keypair_test_ver1, ek);

    static const otbn_app_t kAppMLKEMVer1Keypair = OTBN_APP_T_INIT(otbn_mlkem768_keypair_test_ver1);
    static const otbn_addr_t kCoinsVer1 = OTBN_ADDR_T_INIT(otbn_mlkem768_keypair_test_ver1, coins);
    static const otbn_addr_t kEkVer1 = OTBN_ADDR_T_INIT(otbn_mlkem768_keypair_test_ver1, ek);
    static const otbn_addr_t kDkVer1 = OTBN_ADDR_T_INIT(otbn_mlkem768_keypair_test_ver1, dk);

    OTBN_DECLARE_APP_SYMBOLS(otbn_mlkem768_encap_test_ver1);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem768_encap_test_ver1, coins);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem768_encap_test_ver1, ct);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem768_encap_test_ver1, ss);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem768_encap_test_ver1, ek);

    static const otbn_app_t kAppMLKEMVer1Encap = OTBN_APP_T_INIT(otbn_mlkem768_encap_test_ver1);
    static const otbn_addr_t kCoinsEVer1 = OTBN_ADDR_T_INIT(otbn_mlkem768_encap_test_ver1, coins);
    static const otbn_addr_t kCtEVer1 = OTBN_ADDR_T_INIT(otbn_mlkem768_encap_test_ver1, ct);
    static const otbn_addr_t kSsEVer1 = OTBN_ADDR_T_INIT(otbn_mlkem768_encap_test_ver1, ss);
    static const otbn_addr_t kEkEVer1 = OTBN_ADDR_T_INIT(otbn_mlkem768_encap_test_ver1, ek);

    OTBN_DECLARE_APP_SYMBOLS(otbn_mlkem768_decap_test_ver1);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem768_decap_test_ver1, ct);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem768_decap_test_ver1, dk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem768_decap_test_ver1, ss);

    static const otbn_app_t kAppMLKEMVer1Decap = OTBN_APP_T_INIT(otbn_mlkem768_decap_test_ver1);
    static const otbn_addr_t kCtDVer1 = OTBN_ADDR_T_INIT(otbn_mlkem768_decap_test_ver1, ct);
    static const otbn_addr_t kDkDVer1 = OTBN_ADDR_T_INIT(otbn_mlkem768_decap_test_ver1, dk);
    static const otbn_addr_t kSsDVer1 = OTBN_ADDR_T_INIT(otbn_mlkem768_decap_test_ver1, ss);
  #elif BNMULV_VER == 2
    OTBN_DECLARE_APP_SYMBOLS(otbn_mlkem768_keypair_test_ver2);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem768_keypair_test_ver2, coins);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem768_keypair_test_ver2, dk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem768_keypair_test_ver2, ek);

    static const otbn_app_t kAppMLKEMVer2Keypair = OTBN_APP_T_INIT(otbn_mlkem768_keypair_test_ver2);
    static const otbn_addr_t kCoinsVer2 = OTBN_ADDR_T_INIT(otbn_mlkem768_keypair_test_ver2, coins);
    static const otbn_addr_t kEkVer2 = OTBN_ADDR_T_INIT(otbn_mlkem768_keypair_test_ver2, ek);
    static const otbn_addr_t kDkVer2 = OTBN_ADDR_T_INIT(otbn_mlkem768_keypair_test_ver2, dk);

    OTBN_DECLARE_APP_SYMBOLS(otbn_mlkem768_encap_test_ver2);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem768_encap_test_ver2, coins);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem768_encap_test_ver2, ct);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem768_encap_test_ver2, ss);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem768_encap_test_ver2, ek);

    static const otbn_app_t kAppMLKEMVer2Encap = OTBN_APP_T_INIT(otbn_mlkem768_encap_test_ver2);
    static const otbn_addr_t kCoinsEVer2 = OTBN_ADDR_T_INIT(otbn_mlkem768_encap_test_ver2, coins);
    static const otbn_addr_t kCtEVer2 = OTBN_ADDR_T_INIT(otbn_mlkem768_encap_test_ver2, ct);
    static const otbn_addr_t kSsEVer2 = OTBN_ADDR_T_INIT(otbn_mlkem768_encap_test_ver2, ss);
    static const otbn_addr_t kEkEVer2 = OTBN_ADDR_T_INIT(otbn_mlkem768_encap_test_ver2, ek);

    OTBN_DECLARE_APP_SYMBOLS(otbn_mlkem768_decap_test_ver2);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem768_decap_test_ver2, ct);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem768_decap_test_ver2, dk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem768_decap_test_ver2, ss);

    static const otbn_app_t kAppMLKEMVer2Decap = OTBN_APP_T_INIT(otbn_mlkem768_decap_test_ver2);
    static const otbn_addr_t kCtDVer2 = OTBN_ADDR_T_INIT(otbn_mlkem768_decap_test_ver2, ct);
    static const otbn_addr_t kDkDVer2 = OTBN_ADDR_T_INIT(otbn_mlkem768_decap_test_ver2, dk);
    static const otbn_addr_t kSsDVer2 = OTBN_ADDR_T_INIT(otbn_mlkem768_decap_test_ver2, ss);
  #elif BNMULV_VER == 3
    OTBN_DECLARE_APP_SYMBOLS(otbn_mlkem768_keypair_test_ver3);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem768_keypair_test_ver3, coins);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem768_keypair_test_ver3, dk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem768_keypair_test_ver3, ek);

    static const otbn_app_t kAppMLKEMVer3Keypair = OTBN_APP_T_INIT(otbn_mlkem768_keypair_test_ver3);
    static const otbn_addr_t kCoinsVer3 = OTBN_ADDR_T_INIT(otbn_mlkem768_keypair_test_ver3, coins);
    static const otbn_addr_t kEkVer3 = OTBN_ADDR_T_INIT(otbn_mlkem768_keypair_test_ver3, ek);
    static const otbn_addr_t kDkVer3 = OTBN_ADDR_T_INIT(otbn_mlkem768_keypair_test_ver3, dk);

    OTBN_DECLARE_APP_SYMBOLS(otbn_mlkem768_encap_test_ver3);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem768_encap_test_ver3, coins);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem768_encap_test_ver3, ct);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem768_encap_test_ver3, ss);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem768_encap_test_ver3, ek);

    static const otbn_app_t kAppMLKEMVer3Encap = OTBN_APP_T_INIT(otbn_mlkem768_encap_test_ver3);
    static const otbn_addr_t kCoinsEVer3 = OTBN_ADDR_T_INIT(otbn_mlkem768_encap_test_ver3, coins);
    static const otbn_addr_t kCtEVer3 = OTBN_ADDR_T_INIT(otbn_mlkem768_encap_test_ver3, ct);
    static const otbn_addr_t kSsEVer3 = OTBN_ADDR_T_INIT(otbn_mlkem768_encap_test_ver3, ss);
    static const otbn_addr_t kEkEVer3 = OTBN_ADDR_T_INIT(otbn_mlkem768_encap_test_ver3, ek);

    OTBN_DECLARE_APP_SYMBOLS(otbn_mlkem768_decap_test_ver3);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem768_decap_test_ver3, ct);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem768_decap_test_ver3, dk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem768_decap_test_ver3, ss);

    static const otbn_app_t kAppMLKEMVer3Decap = OTBN_APP_T_INIT(otbn_mlkem768_decap_test_ver3);
    static const otbn_addr_t kCtDVer3 = OTBN_ADDR_T_INIT(otbn_mlkem768_decap_test_ver3, ct);
    static const otbn_addr_t kDkDVer3 = OTBN_ADDR_T_INIT(otbn_mlkem768_decap_test_ver3, dk);
    static const otbn_addr_t kSsDVer3 = OTBN_ADDR_T_INIT(otbn_mlkem768_decap_test_ver3, ss);
  #endif
#elif KYBER_K == 4
  #if BNMULV_VER == 1
    OTBN_DECLARE_APP_SYMBOLS(otbn_mlkem1024_keypair_test_ver1);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem1024_keypair_test_ver1, coins);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem1024_keypair_test_ver1, dk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem1024_keypair_test_ver1, ek);

    static const otbn_app_t kAppMLKEMVer1Keypair = OTBN_APP_T_INIT(otbn_mlkem1024_keypair_test_ver1);
    static const otbn_addr_t kCoinsVer1 = OTBN_ADDR_T_INIT(otbn_mlkem1024_keypair_test_ver1, coins);
    static const otbn_addr_t kEkVer1 = OTBN_ADDR_T_INIT(otbn_mlkem1024_keypair_test_ver1, ek);
    static const otbn_addr_t kDkVer1 = OTBN_ADDR_T_INIT(otbn_mlkem1024_keypair_test_ver1, dk);

    OTBN_DECLARE_APP_SYMBOLS(otbn_mlkem1024_encap_test_ver1);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem1024_encap_test_ver1, coins);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem1024_encap_test_ver1, ct);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem1024_encap_test_ver1, ss);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem1024_encap_test_ver1, ek);

    static const otbn_app_t kAppMLKEMVer1Encap = OTBN_APP_T_INIT(otbn_mlkem1024_encap_test_ver1);
    static const otbn_addr_t kCoinsEVer1 = OTBN_ADDR_T_INIT(otbn_mlkem1024_encap_test_ver1, coins);
    static const otbn_addr_t kCtEVer1 = OTBN_ADDR_T_INIT(otbn_mlkem1024_encap_test_ver1, ct);
    static const otbn_addr_t kSsEVer1 = OTBN_ADDR_T_INIT(otbn_mlkem1024_encap_test_ver1, ss);
    static const otbn_addr_t kEkEVer1 = OTBN_ADDR_T_INIT(otbn_mlkem1024_encap_test_ver1, ek);

    OTBN_DECLARE_APP_SYMBOLS(otbn_mlkem1024_decap_test_ver1);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem1024_decap_test_ver1, ct);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem1024_decap_test_ver1, dk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem1024_decap_test_ver1, ss);

    static const otbn_app_t kAppMLKEMVer1Decap = OTBN_APP_T_INIT(otbn_mlkem1024_decap_test_ver1);
    static const otbn_addr_t kCtDVer1 = OTBN_ADDR_T_INIT(otbn_mlkem1024_decap_test_ver1, ct);
    static const otbn_addr_t kDkDVer1 = OTBN_ADDR_T_INIT(otbn_mlkem1024_decap_test_ver1, dk);
    static const otbn_addr_t kSsDVer1 = OTBN_ADDR_T_INIT(otbn_mlkem1024_decap_test_ver1, ss);
  #elif BNMULV_VER == 2
    OTBN_DECLARE_APP_SYMBOLS(otbn_mlkem1024_keypair_test_ver2);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem1024_keypair_test_ver2, coins);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem1024_keypair_test_ver2, dk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem1024_keypair_test_ver2, ek);

    static const otbn_app_t kAppMLKEMVer2Keypair = OTBN_APP_T_INIT(otbn_mlkem1024_keypair_test_ver2);
    static const otbn_addr_t kCoinsVer2 = OTBN_ADDR_T_INIT(otbn_mlkem1024_keypair_test_ver2, coins);
    static const otbn_addr_t kEkVer2 = OTBN_ADDR_T_INIT(otbn_mlkem1024_keypair_test_ver2, ek);
    static const otbn_addr_t kDkVer2 = OTBN_ADDR_T_INIT(otbn_mlkem1024_keypair_test_ver2, dk);

    OTBN_DECLARE_APP_SYMBOLS(otbn_mlkem1024_encap_test_ver2);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem1024_encap_test_ver2, coins);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem1024_encap_test_ver2, ct);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem1024_encap_test_ver2, ss);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem1024_encap_test_ver2, ek);

    static const otbn_app_t kAppMLKEMVer2Encap = OTBN_APP_T_INIT(otbn_mlkem1024_encap_test_ver2);
    static const otbn_addr_t kCoinsEVer2 = OTBN_ADDR_T_INIT(otbn_mlkem1024_encap_test_ver2, coins);
    static const otbn_addr_t kCtEVer2 = OTBN_ADDR_T_INIT(otbn_mlkem1024_encap_test_ver2, ct);
    static const otbn_addr_t kSsEVer2 = OTBN_ADDR_T_INIT(otbn_mlkem1024_encap_test_ver2, ss);
    static const otbn_addr_t kEkEVer2 = OTBN_ADDR_T_INIT(otbn_mlkem1024_encap_test_ver2, ek);

    OTBN_DECLARE_APP_SYMBOLS(otbn_mlkem1024_decap_test_ver2);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem1024_decap_test_ver2, ct);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem1024_decap_test_ver2, dk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem1024_decap_test_ver2, ss);

    static const otbn_app_t kAppMLKEMVer2Decap = OTBN_APP_T_INIT(otbn_mlkem1024_decap_test_ver2);
    static const otbn_addr_t kCtDVer2 = OTBN_ADDR_T_INIT(otbn_mlkem1024_decap_test_ver2, ct);
    static const otbn_addr_t kDkDVer2 = OTBN_ADDR_T_INIT(otbn_mlkem1024_decap_test_ver2, dk);
    static const otbn_addr_t kSsDVer2 = OTBN_ADDR_T_INIT(otbn_mlkem1024_decap_test_ver2, ss);
  #elif BNMULV_VER == 3
    OTBN_DECLARE_APP_SYMBOLS(otbn_mlkem1024_keypair_test_ver3);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem1024_keypair_test_ver3, coins);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem1024_keypair_test_ver3, dk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem1024_keypair_test_ver3, ek);

    static const otbn_app_t kAppMLKEMVer3Keypair = OTBN_APP_T_INIT(otbn_mlkem1024_keypair_test_ver3);
    static const otbn_addr_t kCoinsVer3 = OTBN_ADDR_T_INIT(otbn_mlkem1024_keypair_test_ver3, coins);
    static const otbn_addr_t kEkVer3 = OTBN_ADDR_T_INIT(otbn_mlkem1024_keypair_test_ver3, ek);
    static const otbn_addr_t kDkVer3 = OTBN_ADDR_T_INIT(otbn_mlkem1024_keypair_test_ver3, dk);

    OTBN_DECLARE_APP_SYMBOLS(otbn_mlkem1024_encap_test_ver3);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem1024_encap_test_ver3, coins);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem1024_encap_test_ver3, ct);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem1024_encap_test_ver3, ss);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem1024_encap_test_ver3, ek);

    static const otbn_app_t kAppMLKEMVer3Encap = OTBN_APP_T_INIT(otbn_mlkem1024_encap_test_ver3);
    static const otbn_addr_t kCoinsEVer3 = OTBN_ADDR_T_INIT(otbn_mlkem1024_encap_test_ver3, coins);
    static const otbn_addr_t kCtEVer3 = OTBN_ADDR_T_INIT(otbn_mlkem1024_encap_test_ver3, ct);
    static const otbn_addr_t kSsEVer3 = OTBN_ADDR_T_INIT(otbn_mlkem1024_encap_test_ver3, ss);
    static const otbn_addr_t kEkEVer3 = OTBN_ADDR_T_INIT(otbn_mlkem1024_encap_test_ver3, ek);

    OTBN_DECLARE_APP_SYMBOLS(otbn_mlkem1024_decap_test_ver3);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem1024_decap_test_ver3, ct);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem1024_decap_test_ver3, dk);
    OTBN_DECLARE_SYMBOL_ADDR(otbn_mlkem1024_decap_test_ver3, ss);

    static const otbn_app_t kAppMLKEMVer3Decap = OTBN_APP_T_INIT(otbn_mlkem1024_decap_test_ver3);
    static const otbn_addr_t kCtDVer3 = OTBN_ADDR_T_INIT(otbn_mlkem1024_decap_test_ver3, ct);
    static const otbn_addr_t kDkDVer3 = OTBN_ADDR_T_INIT(otbn_mlkem1024_decap_test_ver3, dk);
    static const otbn_addr_t kSsDVer3 = OTBN_ADDR_T_INIT(otbn_mlkem1024_decap_test_ver3, ss);
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

static void test_mlkem(dif_otbn_t *otbn) {
  LOG_INFO("KYBER_K = %d", KYBER_K);
  LOG_INFO("BNMULV_VER = %d", BNMULV_VER);

  LOG_INFO("Generate inputs");
  uint8_t coins[2*KYBER_SYMBYTES];
  randombytes(coins, 2*KYBER_SYMBYTES);
  uint8_t coinsE[KYBER_SYMBYTES];
  randombytes(coinsE, KYBER_SYMBYTES);

  // Run C implementation and retrieve result
  LOG_INFO("Run reference implementation");
  uint8_t ek_expected[CRYPTO_PUBLICKEYBYTES];
  uint8_t dk_expected[CRYPTO_SECRETKEYBYTES];
  uint8_t ct_expected[CRYPTO_CIPHERTEXTBYTES];
  uint8_t ssE_expected[CRYPTO_BYTES];
  uint8_t ssD_expected[CRYPTO_BYTES];
  crypto_kem_keypair_derand(ek_expected, dk_expected, coins);
  crypto_kem_enc_derand(ct_expected, ssE_expected, ek_expected, coinsE);
  crypto_kem_dec(ssD_expected, ct_expected, dk_expected);

  uint8_t ek[CRYPTO_PUBLICKEYBYTES];
  uint8_t dk[CRYPTO_SECRETKEYBYTES];
  uint8_t ct[CRYPTO_CIPHERTEXTBYTES];
  uint8_t ssE[CRYPTO_BYTES];
  uint8_t ssD[CRYPTO_BYTES];

  /* Run keypair */
  /* ------------------------------------------------------------------------ */
  LOG_INFO("Load VER%d keypair", BNMULV_VER);
#if BNMULV_VER == 1
  CHECK_STATUS_OK(otbn_testutils_load_app(otbn, kAppMLKEMVer1Keypair));
  LOG_INFO("Write inputs to OTBN's DMEM");
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, 2*KYBER_SYMBYTES, coins, kCoinsVer1));
#elif BNMULV_VER == 2
  CHECK_STATUS_OK(otbn_testutils_load_app(otbn, kAppMLKEMVer2Keypair));
  LOG_INFO("Write inputs to OTBN's DMEM");
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, 2*KYBER_SYMBYTES, coins, kCoinsVer2));
#elif BNMULV_VER == 3
  CHECK_STATUS_OK(otbn_testutils_load_app(otbn, kAppMLKEMVer3Keypair));
  LOG_INFO("Write inputs to OTBN's DMEM");
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, 2*KYBER_SYMBYTES, coins, kCoinsVer3));
#endif

  LOG_INFO("Run VER%d keypair", BNMULV_VER); 
  CHECK_DIF_OK(dif_otbn_set_ctrl_software_errs_fatal(otbn, true));
  CHECK_STATUS_OK(otbn_testutils_execute(otbn));
  CHECK(dif_otbn_set_ctrl_software_errs_fatal(otbn, false) == kDifUnavailable);
  CHECK_STATUS_OK(otbn_testutils_wait_for_done(otbn, kDifOtbnErrBitsNoError));

  LOG_INFO("Retrieve results");
#if BNMULV_VER == 1
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, CRYPTO_PUBLICKEYBYTES, kEkVer1, ek));
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, CRYPTO_SECRETKEYBYTES, kDkVer1, dk));
#elif BNMULV_VER == 2
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, CRYPTO_PUBLICKEYBYTES, kEkVer2, ek));
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, CRYPTO_SECRETKEYBYTES, kDkVer2, dk));
#elif BNMULV_VER == 3
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, CRYPTO_PUBLICKEYBYTES, kEkVer3, ek));
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, CRYPTO_SECRETKEYBYTES, kDkVer3, dk));
#endif

  LOG_INFO("Check VER%d keys", BNMULV_VER);
  CHECK_ARRAYS_EQ(ek, ek_expected, CRYPTO_PUBLICKEYBYTES);
  CHECK_ARRAYS_EQ(dk, dk_expected, CRYPTO_SECRETKEYBYTES);

  /* Run encap */
  /* ------------------------------------------------------------------------ */
  LOG_INFO("Load VER%d encap", BNMULV_VER);
#if BNMULV_VER == 1
  CHECK_STATUS_OK(otbn_testutils_load_app(otbn, kAppMLKEMVer1Encap));
  LOG_INFO("Write inputs to OTBN's DMEM");
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, KYBER_SYMBYTES, coinsE, kCoinsEVer1));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, CRYPTO_PUBLICKEYBYTES, ek_expected, kEkEVer1));
#elif BNMULV_VER == 2
  CHECK_STATUS_OK(otbn_testutils_load_app(otbn, kAppMLKEMVer2Encap));
  LOG_INFO("Write inputs to OTBN's DMEM");
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, KYBER_SYMBYTES, coinsE, kCoinsEVer2));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, CRYPTO_PUBLICKEYBYTES, ek_expected, kEkEVer2));
#elif BNMULV_VER == 3
  CHECK_STATUS_OK(otbn_testutils_load_app(otbn, kAppMLKEMVer3Encap));
  LOG_INFO("Write inputs to OTBN's DMEM");
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, KYBER_SYMBYTES, coinsE, kCoinsEVer3));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, CRYPTO_PUBLICKEYBYTES, ek_expected, kEkEVer3));
#endif

  LOG_INFO("Run VER%d encap", BNMULV_VER); 
  CHECK_DIF_OK(dif_otbn_set_ctrl_software_errs_fatal(otbn, true));
  CHECK_STATUS_OK(otbn_testutils_execute(otbn));
  CHECK(dif_otbn_set_ctrl_software_errs_fatal(otbn, false) == kDifUnavailable);
  CHECK_STATUS_OK(otbn_testutils_wait_for_done(otbn, kDifOtbnErrBitsNoError));

  LOG_INFO("Retrieve results");
#if BNMULV_VER == 1
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, CRYPTO_CIPHERTEXTBYTES, kCtEVer1, ct));
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, CRYPTO_BYTES, kSsEVer1, ssE));
#elif BNMULV_VER == 2
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, CRYPTO_CIPHERTEXTBYTES, kCtEVer2, ct));
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, CRYPTO_BYTES, kSsEVer2, ssE));
#elif BNMULV_VER == 3
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, CRYPTO_CIPHERTEXTBYTES, kCtEVer3, ct));
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, CRYPTO_BYTES, kSsEVer3, ssE));
#endif

  LOG_INFO("Check VER%d ct and ss", BNMULV_VER);
  CHECK_ARRAYS_EQ(ct, ct_expected, CRYPTO_CIPHERTEXTBYTES);
  CHECK_ARRAYS_EQ(ssE, ssE_expected, CRYPTO_BYTES);

  /* Run decap */
  /* ------------------------------------------------------------------------ */
  LOG_INFO("Load VER%d decap", BNMULV_VER);
#if BNMULV_VER == 1
  CHECK_STATUS_OK(otbn_testutils_load_app(otbn, kAppMLKEMVer1Decap));
  LOG_INFO("Write inputs to OTBN's DMEM");
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, CRYPTO_CIPHERTEXTBYTES, ct_expected, kCtDVer1));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, CRYPTO_SECRETKEYBYTES, dk_expected, kDkDVer1));
#elif BNMULV_VER == 2
  CHECK_STATUS_OK(otbn_testutils_load_app(otbn, kAppMLKEMVer2Decap));
  LOG_INFO("Write inputs to OTBN's DMEM");
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, CRYPTO_CIPHERTEXTBYTES, ct_expected, kCtDVer2));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, CRYPTO_SECRETKEYBYTES, dk_expected, kDkDVer2));
#elif BNMULV_VER == 3
  CHECK_STATUS_OK(otbn_testutils_load_app(otbn, kAppMLKEMVer3Decap));
  LOG_INFO("Write inputs to OTBN's DMEM");
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, CRYPTO_CIPHERTEXTBYTES, ct_expected, kCtDVer3));
  CHECK_STATUS_OK(otbn_testutils_write_data(otbn, CRYPTO_SECRETKEYBYTES, dk_expected, kDkDVer3));
#endif

  LOG_INFO("Run VER%d decap", BNMULV_VER); 
  CHECK_DIF_OK(dif_otbn_set_ctrl_software_errs_fatal(otbn, true));
  CHECK_STATUS_OK(otbn_testutils_execute(otbn));
  CHECK(dif_otbn_set_ctrl_software_errs_fatal(otbn, false) == kDifUnavailable);
  CHECK_STATUS_OK(otbn_testutils_wait_for_done(otbn, kDifOtbnErrBitsNoError));

  LOG_INFO("Retrieve results");
#if BNMULV_VER == 1
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, CRYPTO_BYTES, kSsDVer1, ssD));
#elif BNMULV_VER == 2
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, CRYPTO_BYTES, kSsDVer2, ssD));
#elif BNMULV_VER == 3
  CHECK_STATUS_OK(otbn_testutils_read_data(otbn, CRYPTO_BYTES, kSsDVer3, ssD));
#endif

  LOG_INFO("Check VER%d key_a", BNMULV_VER);
  CHECK_ARRAYS_EQ(ssD, ssD_expected, CRYPTO_BYTES);

  LOG_INFO("Check VER%d key_a vs key_b", BNMULV_VER);
  CHECK_ARRAYS_EQ(ssD, ssE_expected, CRYPTO_BYTES);
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
    test_mlkem(&otbn);
  }

  test_sec_wipe(&otbn);

  return true;
}
