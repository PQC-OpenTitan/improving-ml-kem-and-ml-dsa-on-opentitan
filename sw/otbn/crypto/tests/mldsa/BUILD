# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
# Modified by Authors of "Towards ML-KEM & ML-DSA on OpenTitan" (https://eprint.iacr.org/2024/1192).
# Copyright "Towards ML-KEM & ML-DSA on OpenTitan" Authors.
# Modified by Ruben Niederhagen and Hoang Nguyen Hien Pham - authors of
# "Improving ML-KEM & ML-DSA on OpenTitan - Efficient Multiplication Vector Instructions for OTBN"
# (https://eprint.iacr.org/2025/2028)
# Copyright Ruben Niederhagen and Hoang Nguyen Hien Pham.

load("//rules:otbn.bzl", "otbn_binary", "otbn_consttime_test", "otbn_library", "otbn_sim_test", "otbn_sim_py_test")

package(default_visibility = ["//visibility:public"])

# Refactor ML-DSA VER0 BASE

otbn_sim_test(
    name = "mldsa44_keypair_test_ver0_base",
    srcs = [
        "mldsa_base_keypair_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=0",
    ],
    dexp = "dilithium2_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver0_base:intt",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa44_keypair",
        "//sw/otbn/crypto/mldsa_ver0_base:ntt",
        "//sw/otbn/crypto/mldsa_ver0_base:poly_add",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver0_base:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver0_base:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa44_sign_test_ver0_base",
    srcs = [
        "mldsa_base_sign_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=0",
    ],
    dexp = "dilithium2_sign_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver0_base:intt",
        "//sw/otbn/crypto/mldsa_ver0_base:ntt",
        "//sw/otbn/crypto/mldsa_ver0_base:poly_add",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver0_base:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver0_base:poly_sub",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa44_sign",
        "//sw/otbn/crypto/mldsa_ver0_base:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa44_verify_test_ver0_base",
    srcs = [
        "mldsa_base_verify_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=0",
    ],
    dexp = "dilithium2_verify_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver0_base:intt",
        "//sw/otbn/crypto/mldsa_ver0_base:ntt",
        "//sw/otbn/crypto/mldsa_ver0_base:poly_add",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver0_base:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver0_base:poly_sub",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa44_verify",
        "//sw/otbn/crypto/mldsa_ver0_base:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa65_keypair_test_ver0_base",
    srcs = [
        "mldsa_base_keypair_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=0",
    ],
    dexp = "dilithium3_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver0_base:intt",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa65_keypair",
        "//sw/otbn/crypto/mldsa_ver0_base:ntt",
        "//sw/otbn/crypto/mldsa_ver0_base:poly_add",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver0_base:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver0_base:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa65_sign_test_ver0_base",
    srcs = [
        "mldsa_base_sign_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=0",
    ],
    dexp = "dilithium3_sign_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver0_base:intt",
        "//sw/otbn/crypto/mldsa_ver0_base:ntt",
        "//sw/otbn/crypto/mldsa_ver0_base:poly_add",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver0_base:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver0_base:poly_sub",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa65_sign",
        "//sw/otbn/crypto/mldsa_ver0_base:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa65_verify_test_ver0_base",
    srcs = [
        "mldsa_base_verify_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=0",
    ],
    dexp = "dilithium3_verify_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver0_base:intt",
        "//sw/otbn/crypto/mldsa_ver0_base:ntt",
        "//sw/otbn/crypto/mldsa_ver0_base:poly_add",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver0_base:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver0_base:poly_sub",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa65_verify",
        "//sw/otbn/crypto/mldsa_ver0_base:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa87_keypair_test_ver0_base",
    srcs = [
        "mldsa_base_keypair_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=0",
    ],
    dexp = "dilithium5_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver0_base:intt",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa87_keypair",
        "//sw/otbn/crypto/mldsa_ver0_base:ntt",
        "//sw/otbn/crypto/mldsa_ver0_base:poly_add",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver0_base:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver0_base:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa87_sign_test_ver0_base",
    srcs = [
        "mldsa_base_sign_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=0",
    ],
    dexp = "dilithium5_sign_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver0_base:intt",
        "//sw/otbn/crypto/mldsa_ver0_base:ntt",
        "//sw/otbn/crypto/mldsa_ver0_base:poly_add",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver0_base:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver0_base:poly_sub",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa87_sign",
        "//sw/otbn/crypto/mldsa_ver0_base:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa87_verify_test_ver0_base",
    srcs = [
        "mldsa_base_verify_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=0",
    ],
    dexp = "dilithium5_verify_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver0_base:intt",
        "//sw/otbn/crypto/mldsa_ver0_base:ntt",
        "//sw/otbn/crypto/mldsa_ver0_base:poly_add",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver0_base:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver0_base:poly_sub",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa87_verify",
        "//sw/otbn/crypto/mldsa_ver0_base:kmac_send_msg",
    ],
)

# Refactor ML-DSA VER0

otbn_sim_test(
    name = "mldsa44_keypair_test_ver0",
    srcs = [
        "mldsa_keypair_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=0",
    ],
    dexp = "dilithium2_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver0:intt",
        "//sw/otbn/crypto/mldsa_ver0:mldsa44_keypair",
        "//sw/otbn/crypto/mldsa_ver0:ntt",
        "//sw/otbn/crypto/mldsa_ver0:poly_add",
        "//sw/otbn/crypto/mldsa_ver0:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver0:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver0:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver0:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa44_sign_test_ver0",
    srcs = [
        "mldsa_sign_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=0",
    ],
    dexp = "dilithium2_sign_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver0:intt",
        "//sw/otbn/crypto/mldsa_ver0:ntt",
        "//sw/otbn/crypto/mldsa_ver0:poly_add",
        "//sw/otbn/crypto/mldsa_ver0:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver0:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver0:poly_sub",
        "//sw/otbn/crypto/mldsa_ver0:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver0:mldsa44_sign",
        "//sw/otbn/crypto/mldsa_ver0:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa44_verify_test_ver0",
    srcs = [
        "mldsa_verify_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=0",
    ],
    dexp = "dilithium2_verify_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver0:intt",
        "//sw/otbn/crypto/mldsa_ver0:ntt",
        "//sw/otbn/crypto/mldsa_ver0:poly_add",
        "//sw/otbn/crypto/mldsa_ver0:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver0:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver0:poly_sub",
        "//sw/otbn/crypto/mldsa_ver0:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver0:mldsa44_verify",
        "//sw/otbn/crypto/mldsa_ver0:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa65_keypair_test_ver0",
    srcs = [
        "mldsa_keypair_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=0",
    ],
    dexp = "dilithium3_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver0:intt",
        "//sw/otbn/crypto/mldsa_ver0:mldsa65_keypair",
        "//sw/otbn/crypto/mldsa_ver0:ntt",
        "//sw/otbn/crypto/mldsa_ver0:poly_add",
        "//sw/otbn/crypto/mldsa_ver0:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver0:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver0:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver0:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa65_sign_test_ver0",
    srcs = [
        "mldsa_sign_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=0",
    ],
    dexp = "dilithium3_sign_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver0:intt",
        "//sw/otbn/crypto/mldsa_ver0:ntt",
        "//sw/otbn/crypto/mldsa_ver0:poly_add",
        "//sw/otbn/crypto/mldsa_ver0:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver0:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver0:poly_sub",
        "//sw/otbn/crypto/mldsa_ver0:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver0:mldsa65_sign",
        "//sw/otbn/crypto/mldsa_ver0:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa65_verify_test_ver0",
    srcs = [
        "mldsa_verify_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=0",
    ],
    dexp = "dilithium3_verify_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver0:intt",
        "//sw/otbn/crypto/mldsa_ver0:ntt",
        "//sw/otbn/crypto/mldsa_ver0:poly_add",
        "//sw/otbn/crypto/mldsa_ver0:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver0:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver0:poly_sub",
        "//sw/otbn/crypto/mldsa_ver0:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver0:mldsa65_verify",
        "//sw/otbn/crypto/mldsa_ver0:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa87_keypair_test_ver0",
    srcs = [
        "mldsa_keypair_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=0",
    ],
    dexp = "dilithium5_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver0:intt",
        "//sw/otbn/crypto/mldsa_ver0:mldsa87_keypair",
        "//sw/otbn/crypto/mldsa_ver0:ntt",
        "//sw/otbn/crypto/mldsa_ver0:poly_add",
        "//sw/otbn/crypto/mldsa_ver0:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver0:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver0:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver0:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa87_sign_test_ver0",
    srcs = [
        "mldsa_sign_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=0",
    ],
    dexp = "dilithium5_sign_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver0:intt",
        "//sw/otbn/crypto/mldsa_ver0:ntt",
        "//sw/otbn/crypto/mldsa_ver0:poly_add",
        "//sw/otbn/crypto/mldsa_ver0:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver0:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver0:poly_sub",
        "//sw/otbn/crypto/mldsa_ver0:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver0:mldsa87_sign",
        "//sw/otbn/crypto/mldsa_ver0:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa87_verify_test_ver0",
    srcs = [
        "mldsa_verify_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=0",
    ],
    dexp = "dilithium5_verify_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver0:intt",
        "//sw/otbn/crypto/mldsa_ver0:ntt",
        "//sw/otbn/crypto/mldsa_ver0:poly_add",
        "//sw/otbn/crypto/mldsa_ver0:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver0:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver0:poly_sub",
        "//sw/otbn/crypto/mldsa_ver0:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver0:mldsa87_verify",
        "//sw/otbn/crypto/mldsa_ver0:kmac_send_msg",
    ],
)

# Refactor ML-DSA VER1 without lazy reduction

otbn_sim_test(
    name = "mldsa44_keypair_test_ver1_nold",
    srcs = [
        "mldsa_keypair_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=1",
    ],
    dexp = "dilithium2_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver1_nold:intt",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa44_keypair",
        "//sw/otbn/crypto/mldsa_ver1_nold:ntt",
        "//sw/otbn/crypto/mldsa_ver1_nold:poly_add",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver1_nold:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver1_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa44_sign_test_ver1_nold",
    srcs = [
        "mldsa_sign_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=1",
    ],
    dexp = "dilithium2_sign_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver1_nold:intt",
        "//sw/otbn/crypto/mldsa_ver1_nold:ntt",
        "//sw/otbn/crypto/mldsa_ver1_nold:poly_add",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver1_nold:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver1_nold:poly_sub",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa44_sign",
        "//sw/otbn/crypto/mldsa_ver1_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa44_verify_test_ver1_nold",
    srcs = [
        "mldsa_verify_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=1",
    ],
    dexp = "dilithium2_verify_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver1_nold:intt",
        "//sw/otbn/crypto/mldsa_ver1_nold:ntt",
        "//sw/otbn/crypto/mldsa_ver1_nold:poly_add",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver1_nold:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver1_nold:poly_sub",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa44_verify",
        "//sw/otbn/crypto/mldsa_ver1_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa65_keypair_test_ver1_nold",
    srcs = [
        "mldsa_keypair_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=1",
    ],
    dexp = "dilithium3_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver1_nold:intt",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa65_keypair",
        "//sw/otbn/crypto/mldsa_ver1_nold:ntt",
        "//sw/otbn/crypto/mldsa_ver1_nold:poly_add",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver1_nold:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver1_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa65_sign_test_ver1_nold",
    srcs = [
        "mldsa_sign_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=1",
    ],
    dexp = "dilithium3_sign_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver1_nold:intt",
        "//sw/otbn/crypto/mldsa_ver1_nold:ntt",
        "//sw/otbn/crypto/mldsa_ver1_nold:poly_add",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver1_nold:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver1_nold:poly_sub",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa65_sign",
        "//sw/otbn/crypto/mldsa_ver1_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa65_verify_test_ver1_nold",
    srcs = [
        "mldsa_verify_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=1",
    ],
    dexp = "dilithium3_verify_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver1_nold:intt",
        "//sw/otbn/crypto/mldsa_ver1_nold:ntt",
        "//sw/otbn/crypto/mldsa_ver1_nold:poly_add",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver1_nold:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver1_nold:poly_sub",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa65_verify",
        "//sw/otbn/crypto/mldsa_ver1_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa87_keypair_test_ver1_nold",
    srcs = [
        "mldsa_keypair_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=1",
    ],
    dexp = "dilithium5_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver1_nold:intt",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa87_keypair",
        "//sw/otbn/crypto/mldsa_ver1_nold:ntt",
        "//sw/otbn/crypto/mldsa_ver1_nold:poly_add",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver1_nold:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver1_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa87_sign_test_ver1_nold",
    srcs = [
        "mldsa_sign_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=1",
    ],
    dexp = "dilithium5_sign_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver1_nold:intt",
        "//sw/otbn/crypto/mldsa_ver1_nold:ntt",
        "//sw/otbn/crypto/mldsa_ver1_nold:poly_add",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver1_nold:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver1_nold:poly_sub",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa87_sign",
        "//sw/otbn/crypto/mldsa_ver1_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa87_verify_test_ver1_nold",
    srcs = [
        "mldsa_verify_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=1",
    ],
    dexp = "dilithium5_verify_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver1_nold:intt",
        "//sw/otbn/crypto/mldsa_ver1_nold:ntt",
        "//sw/otbn/crypto/mldsa_ver1_nold:poly_add",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver1_nold:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver1_nold:poly_sub",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa87_verify",
        "//sw/otbn/crypto/mldsa_ver1_nold:kmac_send_msg",
    ],
)

# Refactor ML-DSA VER1

otbn_sim_test(
    name = "mldsa44_keypair_test_ver1",
    srcs = [
        "mldsa_keypair_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=1",
    ],
    dexp = "dilithium2_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver1:intt",
        "//sw/otbn/crypto/mldsa_ver1:mldsa44_keypair",
        "//sw/otbn/crypto/mldsa_ver1:ntt",
        "//sw/otbn/crypto/mldsa_ver1:poly_add",
        "//sw/otbn/crypto/mldsa_ver1:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver1:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver1:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver1:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa44_sign_test_ver1",
    srcs = [
        "mldsa_sign_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=1",
    ],
    dexp = "dilithium2_sign_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver1:intt",
        "//sw/otbn/crypto/mldsa_ver1:ntt",
        "//sw/otbn/crypto/mldsa_ver1:poly_add",
        "//sw/otbn/crypto/mldsa_ver1:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver1:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver1:poly_sub",
        "//sw/otbn/crypto/mldsa_ver1:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver1:mldsa44_sign",
        "//sw/otbn/crypto/mldsa_ver1:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa44_verify_test_ver1",
    srcs = [
        "mldsa_verify_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=1",
    ],
    dexp = "dilithium2_verify_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver1:intt",
        "//sw/otbn/crypto/mldsa_ver1:ntt",
        "//sw/otbn/crypto/mldsa_ver1:poly_add",
        "//sw/otbn/crypto/mldsa_ver1:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver1:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver1:poly_sub",
        "//sw/otbn/crypto/mldsa_ver1:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver1:mldsa44_verify",
        "//sw/otbn/crypto/mldsa_ver1:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa65_keypair_test_ver1",
    srcs = [
        "mldsa_keypair_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=1",
    ],
    dexp = "dilithium3_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver1:intt",
        "//sw/otbn/crypto/mldsa_ver1:mldsa65_keypair",
        "//sw/otbn/crypto/mldsa_ver1:ntt",
        "//sw/otbn/crypto/mldsa_ver1:poly_add",
        "//sw/otbn/crypto/mldsa_ver1:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver1:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver1:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver1:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa65_sign_test_ver1",
    srcs = [
        "mldsa_sign_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=1",
    ],
    dexp = "dilithium3_sign_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver1:intt",
        "//sw/otbn/crypto/mldsa_ver1:ntt",
        "//sw/otbn/crypto/mldsa_ver1:poly_add",
        "//sw/otbn/crypto/mldsa_ver1:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver1:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver1:poly_sub",
        "//sw/otbn/crypto/mldsa_ver1:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver1:mldsa65_sign",
        "//sw/otbn/crypto/mldsa_ver1:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa65_verify_test_ver1",
    srcs = [
        "mldsa_verify_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=1",
    ],
    dexp = "dilithium3_verify_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver1:intt",
        "//sw/otbn/crypto/mldsa_ver1:ntt",
        "//sw/otbn/crypto/mldsa_ver1:poly_add",
        "//sw/otbn/crypto/mldsa_ver1:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver1:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver1:poly_sub",
        "//sw/otbn/crypto/mldsa_ver1:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver1:mldsa65_verify",
        "//sw/otbn/crypto/mldsa_ver1:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa87_keypair_test_ver1",
    srcs = [
        "mldsa_keypair_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=1",
    ],
    dexp = "dilithium5_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver1:intt",
        "//sw/otbn/crypto/mldsa_ver1:mldsa87_keypair",
        "//sw/otbn/crypto/mldsa_ver1:ntt",
        "//sw/otbn/crypto/mldsa_ver1:poly_add",
        "//sw/otbn/crypto/mldsa_ver1:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver1:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver1:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver1:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa87_sign_test_ver1",
    srcs = [
        "mldsa_sign_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=1",
    ],
    dexp = "dilithium5_sign_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver1:intt",
        "//sw/otbn/crypto/mldsa_ver1:ntt",
        "//sw/otbn/crypto/mldsa_ver1:poly_add",
        "//sw/otbn/crypto/mldsa_ver1:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver1:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver1:poly_sub",
        "//sw/otbn/crypto/mldsa_ver1:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver1:mldsa87_sign",
        "//sw/otbn/crypto/mldsa_ver1:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa87_verify_test_ver1",
    srcs = [
        "mldsa_verify_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=1",
    ],
    dexp = "dilithium5_verify_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver1:intt",
        "//sw/otbn/crypto/mldsa_ver1:ntt",
        "//sw/otbn/crypto/mldsa_ver1:poly_add",
        "//sw/otbn/crypto/mldsa_ver1:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver1:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver1:poly_sub",
        "//sw/otbn/crypto/mldsa_ver1:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver1:mldsa87_verify",
        "//sw/otbn/crypto/mldsa_ver1:kmac_send_msg",
    ],
)

# Refactor ML-DSA VER2 without lazy reduction

otbn_sim_test(
    name = "mldsa44_keypair_test_ver2_nold",
    srcs = [
        "mldsa_keypair_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=2",
    ],
    dexp = "dilithium2_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver2_nold:intt",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa44_keypair",
        "//sw/otbn/crypto/mldsa_ver2_nold:ntt",
        "//sw/otbn/crypto/mldsa_ver2_nold:poly_add",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver2_nold:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver2_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa44_sign_test_ver2_nold",
    srcs = [
        "mldsa_sign_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=2",
    ],
    dexp = "dilithium2_sign_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver2_nold:intt",
        "//sw/otbn/crypto/mldsa_ver2_nold:ntt",
        "//sw/otbn/crypto/mldsa_ver2_nold:poly_add",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver2_nold:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver2_nold:poly_sub",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa44_sign",
        "//sw/otbn/crypto/mldsa_ver2_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa44_verify_test_ver2_nold",
    srcs = [
        "mldsa_verify_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=2",
    ],
    dexp = "dilithium2_verify_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver2_nold:intt",
        "//sw/otbn/crypto/mldsa_ver2_nold:ntt",
        "//sw/otbn/crypto/mldsa_ver2_nold:poly_add",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver2_nold:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver2_nold:poly_sub",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa44_verify",
        "//sw/otbn/crypto/mldsa_ver2_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa65_keypair_test_ver2_nold",
    srcs = [
        "mldsa_keypair_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=2",
    ],
    dexp = "dilithium3_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver2_nold:intt",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa65_keypair",
        "//sw/otbn/crypto/mldsa_ver2_nold:ntt",
        "//sw/otbn/crypto/mldsa_ver2_nold:poly_add",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver2_nold:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver2_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa65_sign_test_ver2_nold",
    srcs = [
        "mldsa_sign_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=2",
    ],
    dexp = "dilithium3_sign_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver2_nold:intt",
        "//sw/otbn/crypto/mldsa_ver2_nold:ntt",
        "//sw/otbn/crypto/mldsa_ver2_nold:poly_add",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver2_nold:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver2_nold:poly_sub",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa65_sign",
        "//sw/otbn/crypto/mldsa_ver2_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa65_verify_test_ver2_nold",
    srcs = [
        "mldsa_verify_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=2",
    ],
    dexp = "dilithium3_verify_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver2_nold:intt",
        "//sw/otbn/crypto/mldsa_ver2_nold:ntt",
        "//sw/otbn/crypto/mldsa_ver2_nold:poly_add",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver2_nold:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver2_nold:poly_sub",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa65_verify",
        "//sw/otbn/crypto/mldsa_ver2_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa87_keypair_test_ver2_nold",
    srcs = [
        "mldsa_keypair_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=2",
    ],
    dexp = "dilithium5_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver2_nold:intt",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa87_keypair",
        "//sw/otbn/crypto/mldsa_ver2_nold:ntt",
        "//sw/otbn/crypto/mldsa_ver2_nold:poly_add",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver2_nold:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver2_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa87_sign_test_ver2_nold",
    srcs = [
        "mldsa_sign_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=2",
    ],
    dexp = "dilithium5_sign_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver2_nold:intt",
        "//sw/otbn/crypto/mldsa_ver2_nold:ntt",
        "//sw/otbn/crypto/mldsa_ver2_nold:poly_add",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver2_nold:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver2_nold:poly_sub",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa87_sign",
        "//sw/otbn/crypto/mldsa_ver2_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa87_verify_test_ver2_nold",
    srcs = [
        "mldsa_verify_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=2",
    ],
    dexp = "dilithium5_verify_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver2_nold:intt",
        "//sw/otbn/crypto/mldsa_ver2_nold:ntt",
        "//sw/otbn/crypto/mldsa_ver2_nold:poly_add",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver2_nold:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver2_nold:poly_sub",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa87_verify",
        "//sw/otbn/crypto/mldsa_ver2_nold:kmac_send_msg",
    ],
)

# Refactor ML-DSA VER2

otbn_sim_test(
    name = "mldsa44_keypair_test_ver2",
    srcs = [
        "mldsa_keypair_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=2",
    ],
    dexp = "dilithium2_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver2:intt",
        "//sw/otbn/crypto/mldsa_ver2:mldsa44_keypair",
        "//sw/otbn/crypto/mldsa_ver2:ntt",
        "//sw/otbn/crypto/mldsa_ver2:poly_add",
        "//sw/otbn/crypto/mldsa_ver2:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver2:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver2:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver2:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa44_sign_test_ver2",
    srcs = [
        "mldsa_sign_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=2",
    ],
    dexp = "dilithium2_sign_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver2:intt",
        "//sw/otbn/crypto/mldsa_ver2:ntt",
        "//sw/otbn/crypto/mldsa_ver2:poly_add",
        "//sw/otbn/crypto/mldsa_ver2:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver2:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver2:poly_sub",
        "//sw/otbn/crypto/mldsa_ver2:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver2:mldsa44_sign",
        "//sw/otbn/crypto/mldsa_ver2:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa44_verify_test_ver2",
    srcs = [
        "mldsa_verify_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=2",
    ],
    dexp = "dilithium2_verify_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver2:intt",
        "//sw/otbn/crypto/mldsa_ver2:ntt",
        "//sw/otbn/crypto/mldsa_ver2:poly_add",
        "//sw/otbn/crypto/mldsa_ver2:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver2:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver2:poly_sub",
        "//sw/otbn/crypto/mldsa_ver2:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver2:mldsa44_verify",
        "//sw/otbn/crypto/mldsa_ver2:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa65_keypair_test_ver2",
    srcs = [
        "mldsa_keypair_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=2",
    ],
    dexp = "dilithium3_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver2:intt",
        "//sw/otbn/crypto/mldsa_ver2:mldsa65_keypair",
        "//sw/otbn/crypto/mldsa_ver2:ntt",
        "//sw/otbn/crypto/mldsa_ver2:poly_add",
        "//sw/otbn/crypto/mldsa_ver2:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver2:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver2:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver2:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa65_sign_test_ver2",
    srcs = [
        "mldsa_sign_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=2",
    ],
    dexp = "dilithium3_sign_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver2:intt",
        "//sw/otbn/crypto/mldsa_ver2:ntt",
        "//sw/otbn/crypto/mldsa_ver2:poly_add",
        "//sw/otbn/crypto/mldsa_ver2:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver2:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver2:poly_sub",
        "//sw/otbn/crypto/mldsa_ver2:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver2:mldsa65_sign",
        "//sw/otbn/crypto/mldsa_ver2:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa65_verify_test_ver2",
    srcs = [
        "mldsa_verify_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=2",
    ],
    dexp = "dilithium3_verify_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver2:intt",
        "//sw/otbn/crypto/mldsa_ver2:ntt",
        "//sw/otbn/crypto/mldsa_ver2:poly_add",
        "//sw/otbn/crypto/mldsa_ver2:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver2:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver2:poly_sub",
        "//sw/otbn/crypto/mldsa_ver2:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver2:mldsa65_verify",
        "//sw/otbn/crypto/mldsa_ver2:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa87_keypair_test_ver2",
    srcs = [
        "mldsa_keypair_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=2",
    ],
    dexp = "dilithium5_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver2:intt",
        "//sw/otbn/crypto/mldsa_ver2:mldsa87_keypair",
        "//sw/otbn/crypto/mldsa_ver2:ntt",
        "//sw/otbn/crypto/mldsa_ver2:poly_add",
        "//sw/otbn/crypto/mldsa_ver2:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver2:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver2:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver2:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa87_sign_test_ver2",
    srcs = [
        "mldsa_sign_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=2",
    ],
    dexp = "dilithium5_sign_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver2:intt",
        "//sw/otbn/crypto/mldsa_ver2:ntt",
        "//sw/otbn/crypto/mldsa_ver2:poly_add",
        "//sw/otbn/crypto/mldsa_ver2:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver2:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver2:poly_sub",
        "//sw/otbn/crypto/mldsa_ver2:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver2:mldsa87_sign",
        "//sw/otbn/crypto/mldsa_ver2:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa87_verify_test_ver2",
    srcs = [
        "mldsa_verify_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=2",
    ],
    dexp = "dilithium5_verify_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver2:intt",
        "//sw/otbn/crypto/mldsa_ver2:ntt",
        "//sw/otbn/crypto/mldsa_ver2:poly_add",
        "//sw/otbn/crypto/mldsa_ver2:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver2:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver2:poly_sub",
        "//sw/otbn/crypto/mldsa_ver2:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver2:mldsa87_verify",
        "//sw/otbn/crypto/mldsa_ver2:kmac_send_msg",
    ],
)

# Refactor ML-DSA VER3

otbn_sim_test(
    name = "mldsa44_keypair_test_ver3",
    srcs = [
        "mldsa_keypair_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=3",
    ],
    dexp = "dilithium2_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver3:intt",
        "//sw/otbn/crypto/mldsa_ver3:mldsa44_keypair",
        "//sw/otbn/crypto/mldsa_ver3:ntt",
        "//sw/otbn/crypto/mldsa_ver3:poly_add",
        "//sw/otbn/crypto/mldsa_ver3:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver3:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver3:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver3:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa44_sign_test_ver3",
    srcs = [
        "mldsa_sign_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=3",
    ],
    dexp = "dilithium2_sign_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver3:intt",
        "//sw/otbn/crypto/mldsa_ver3:ntt",
        "//sw/otbn/crypto/mldsa_ver3:poly_add",
        "//sw/otbn/crypto/mldsa_ver3:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver3:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver3:poly_sub",
        "//sw/otbn/crypto/mldsa_ver3:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver3:mldsa44_sign",
        "//sw/otbn/crypto/mldsa_ver3:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa44_verify_test_ver3",
    srcs = [
        "mldsa_verify_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=3",
    ],
    dexp = "dilithium2_verify_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver3:intt",
        "//sw/otbn/crypto/mldsa_ver3:ntt",
        "//sw/otbn/crypto/mldsa_ver3:poly_add",
        "//sw/otbn/crypto/mldsa_ver3:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver3:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver3:poly_sub",
        "//sw/otbn/crypto/mldsa_ver3:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver3:mldsa44_verify",
        "//sw/otbn/crypto/mldsa_ver3:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa65_keypair_test_ver3",
    srcs = [
        "mldsa_keypair_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=3",
    ],
    dexp = "dilithium3_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver3:intt",
        "//sw/otbn/crypto/mldsa_ver3:mldsa65_keypair",
        "//sw/otbn/crypto/mldsa_ver3:ntt",
        "//sw/otbn/crypto/mldsa_ver3:poly_add",
        "//sw/otbn/crypto/mldsa_ver3:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver3:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver3:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver3:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa65_sign_test_ver3",
    srcs = [
        "mldsa_sign_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=3",
    ],
    dexp = "dilithium3_sign_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver3:intt",
        "//sw/otbn/crypto/mldsa_ver3:ntt",
        "//sw/otbn/crypto/mldsa_ver3:poly_add",
        "//sw/otbn/crypto/mldsa_ver3:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver3:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver3:poly_sub",
        "//sw/otbn/crypto/mldsa_ver3:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver3:mldsa65_sign",
        "//sw/otbn/crypto/mldsa_ver3:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa65_verify_test_ver3",
    srcs = [
        "mldsa_verify_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=3",
    ],
    dexp = "dilithium3_verify_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver3:intt",
        "//sw/otbn/crypto/mldsa_ver3:ntt",
        "//sw/otbn/crypto/mldsa_ver3:poly_add",
        "//sw/otbn/crypto/mldsa_ver3:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver3:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver3:poly_sub",
        "//sw/otbn/crypto/mldsa_ver3:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver3:mldsa65_verify",
        "//sw/otbn/crypto/mldsa_ver3:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa87_keypair_test_ver3",
    srcs = [
        "mldsa_keypair_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=3",
    ],
    dexp = "dilithium5_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver3:intt",
        "//sw/otbn/crypto/mldsa_ver3:mldsa87_keypair",
        "//sw/otbn/crypto/mldsa_ver3:ntt",
        "//sw/otbn/crypto/mldsa_ver3:poly_add",
        "//sw/otbn/crypto/mldsa_ver3:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver3:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver3:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver3:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa87_sign_test_ver3",
    srcs = [
        "mldsa_sign_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=3",
    ],
    dexp = "dilithium5_sign_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver3:intt",
        "//sw/otbn/crypto/mldsa_ver3:ntt",
        "//sw/otbn/crypto/mldsa_ver3:poly_add",
        "//sw/otbn/crypto/mldsa_ver3:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver3:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver3:poly_sub",
        "//sw/otbn/crypto/mldsa_ver3:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver3:mldsa87_sign",
        "//sw/otbn/crypto/mldsa_ver3:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mldsa87_verify_test_ver3",
    srcs = [
        "mldsa_verify_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=3",
    ],
    dexp = "dilithium5_verify_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa_ver3:intt",
        "//sw/otbn/crypto/mldsa_ver3:ntt",
        "//sw/otbn/crypto/mldsa_ver3:poly_add",
        "//sw/otbn/crypto/mldsa_ver3:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver3:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver3:poly_sub",
        "//sw/otbn/crypto/mldsa_ver3:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver3:mldsa87_verify",
        "//sw/otbn/crypto/mldsa_ver3:kmac_send_msg",
    ],
)

# Binaries for Verilator tests VER1

otbn_binary(
    name = "otbn_mldsa44_keypair_test_ver1",
    srcs = [
        "mldsa_keypair_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver1:intt",
        "//sw/otbn/crypto/mldsa_ver1:mldsa44_keypair",
        "//sw/otbn/crypto/mldsa_ver1:ntt",
        "//sw/otbn/crypto/mldsa_ver1:poly_add",
        "//sw/otbn/crypto/mldsa_ver1:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver1:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver1:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver1:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mldsa44_sign_test_ver1",
    srcs = [
        "mldsa_sign_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver1:intt",
        "//sw/otbn/crypto/mldsa_ver1:ntt",
        "//sw/otbn/crypto/mldsa_ver1:poly_add",
        "//sw/otbn/crypto/mldsa_ver1:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver1:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver1:poly_sub",
        "//sw/otbn/crypto/mldsa_ver1:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver1:mldsa44_sign",
        "//sw/otbn/crypto/mldsa_ver1:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mldsa44_verify_test_ver1",
    srcs = [
        "mldsa_verify_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver1:intt",
        "//sw/otbn/crypto/mldsa_ver1:ntt",
        "//sw/otbn/crypto/mldsa_ver1:poly_add",
        "//sw/otbn/crypto/mldsa_ver1:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver1:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver1:poly_sub",
        "//sw/otbn/crypto/mldsa_ver1:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver1:mldsa44_verify",
        "//sw/otbn/crypto/mldsa_ver1:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mldsa65_keypair_test_ver1",
    srcs = [
        "mldsa_keypair_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver1:intt",
        "//sw/otbn/crypto/mldsa_ver1:mldsa65_keypair",
        "//sw/otbn/crypto/mldsa_ver1:ntt",
        "//sw/otbn/crypto/mldsa_ver1:poly_add",
        "//sw/otbn/crypto/mldsa_ver1:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver1:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver1:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver1:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mldsa65_sign_test_ver1",
    srcs = [
        "mldsa_sign_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver1:intt",
        "//sw/otbn/crypto/mldsa_ver1:ntt",
        "//sw/otbn/crypto/mldsa_ver1:poly_add",
        "//sw/otbn/crypto/mldsa_ver1:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver1:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver1:poly_sub",
        "//sw/otbn/crypto/mldsa_ver1:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver1:mldsa65_sign",
        "//sw/otbn/crypto/mldsa_ver1:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mldsa65_verify_test_ver1",
    srcs = [
        "mldsa_verify_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver1:intt",
        "//sw/otbn/crypto/mldsa_ver1:ntt",
        "//sw/otbn/crypto/mldsa_ver1:poly_add",
        "//sw/otbn/crypto/mldsa_ver1:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver1:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver1:poly_sub",
        "//sw/otbn/crypto/mldsa_ver1:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver1:mldsa65_verify",
        "//sw/otbn/crypto/mldsa_ver1:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mldsa87_keypair_test_ver1",
    srcs = [
        "mldsa_keypair_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver1:intt",
        "//sw/otbn/crypto/mldsa_ver1:mldsa87_keypair",
        "//sw/otbn/crypto/mldsa_ver1:ntt",
        "//sw/otbn/crypto/mldsa_ver1:poly_add",
        "//sw/otbn/crypto/mldsa_ver1:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver1:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver1:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver1:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mldsa87_sign_test_ver1",
    srcs = [
        "mldsa_sign_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver1:intt",
        "//sw/otbn/crypto/mldsa_ver1:ntt",
        "//sw/otbn/crypto/mldsa_ver1:poly_add",
        "//sw/otbn/crypto/mldsa_ver1:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver1:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver1:poly_sub",
        "//sw/otbn/crypto/mldsa_ver1:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver1:mldsa87_sign",
        "//sw/otbn/crypto/mldsa_ver1:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mldsa87_verify_test_ver1",
    srcs = [
        "mldsa_verify_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver1:intt",
        "//sw/otbn/crypto/mldsa_ver1:ntt",
        "//sw/otbn/crypto/mldsa_ver1:poly_add",
        "//sw/otbn/crypto/mldsa_ver1:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver1:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver1:poly_sub",
        "//sw/otbn/crypto/mldsa_ver1:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver1:mldsa87_verify",
        "//sw/otbn/crypto/mldsa_ver1:kmac_send_msg",
    ],
)

# Binaries for Verilator tests VER2

otbn_binary(
    name = "otbn_mldsa44_keypair_test_ver2",
    srcs = [
        "mldsa_keypair_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=2",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver2:intt",
        "//sw/otbn/crypto/mldsa_ver2:mldsa44_keypair",
        "//sw/otbn/crypto/mldsa_ver2:ntt",
        "//sw/otbn/crypto/mldsa_ver2:poly_add",
        "//sw/otbn/crypto/mldsa_ver2:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver2:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver2:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver2:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mldsa44_sign_test_ver2",
    srcs = [
        "mldsa_sign_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=2",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver2:intt",
        "//sw/otbn/crypto/mldsa_ver2:ntt",
        "//sw/otbn/crypto/mldsa_ver2:poly_add",
        "//sw/otbn/crypto/mldsa_ver2:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver2:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver2:poly_sub",
        "//sw/otbn/crypto/mldsa_ver2:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver2:mldsa44_sign",
        "//sw/otbn/crypto/mldsa_ver2:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mldsa44_verify_test_ver2",
    srcs = [
        "mldsa_verify_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=2",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver2:intt",
        "//sw/otbn/crypto/mldsa_ver2:ntt",
        "//sw/otbn/crypto/mldsa_ver2:poly_add",
        "//sw/otbn/crypto/mldsa_ver2:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver2:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver2:poly_sub",
        "//sw/otbn/crypto/mldsa_ver2:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver2:mldsa44_verify",
        "//sw/otbn/crypto/mldsa_ver2:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mldsa65_keypair_test_ver2",
    srcs = [
        "mldsa_keypair_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=2",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver2:intt",
        "//sw/otbn/crypto/mldsa_ver2:mldsa65_keypair",
        "//sw/otbn/crypto/mldsa_ver2:ntt",
        "//sw/otbn/crypto/mldsa_ver2:poly_add",
        "//sw/otbn/crypto/mldsa_ver2:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver2:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver2:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver2:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mldsa65_sign_test_ver2",
    srcs = [
        "mldsa_sign_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=2",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver2:intt",
        "//sw/otbn/crypto/mldsa_ver2:ntt",
        "//sw/otbn/crypto/mldsa_ver2:poly_add",
        "//sw/otbn/crypto/mldsa_ver2:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver2:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver2:poly_sub",
        "//sw/otbn/crypto/mldsa_ver2:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver2:mldsa65_sign",
        "//sw/otbn/crypto/mldsa_ver2:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mldsa65_verify_test_ver2",
    srcs = [
        "mldsa_verify_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=2",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver2:intt",
        "//sw/otbn/crypto/mldsa_ver2:ntt",
        "//sw/otbn/crypto/mldsa_ver2:poly_add",
        "//sw/otbn/crypto/mldsa_ver2:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver2:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver2:poly_sub",
        "//sw/otbn/crypto/mldsa_ver2:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver2:mldsa65_verify",
        "//sw/otbn/crypto/mldsa_ver2:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mldsa87_keypair_test_ver2",
    srcs = [
        "mldsa_keypair_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=2",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver2:intt",
        "//sw/otbn/crypto/mldsa_ver2:mldsa87_keypair",
        "//sw/otbn/crypto/mldsa_ver2:ntt",
        "//sw/otbn/crypto/mldsa_ver2:poly_add",
        "//sw/otbn/crypto/mldsa_ver2:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver2:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver2:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver2:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mldsa87_sign_test_ver2",
    srcs = [
        "mldsa_sign_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=2",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver2:intt",
        "//sw/otbn/crypto/mldsa_ver2:ntt",
        "//sw/otbn/crypto/mldsa_ver2:poly_add",
        "//sw/otbn/crypto/mldsa_ver2:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver2:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver2:poly_sub",
        "//sw/otbn/crypto/mldsa_ver2:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver2:mldsa87_sign",
        "//sw/otbn/crypto/mldsa_ver2:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mldsa87_verify_test_ver2",
    srcs = [
        "mldsa_verify_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=2",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver2:intt",
        "//sw/otbn/crypto/mldsa_ver2:ntt",
        "//sw/otbn/crypto/mldsa_ver2:poly_add",
        "//sw/otbn/crypto/mldsa_ver2:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver2:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver2:poly_sub",
        "//sw/otbn/crypto/mldsa_ver2:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver2:mldsa87_verify",
        "//sw/otbn/crypto/mldsa_ver2:kmac_send_msg",
    ],
)

# Binaries for Verilator tests VER3

otbn_binary(
    name = "otbn_mldsa44_keypair_test_ver3",
    srcs = [
        "mldsa_keypair_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=3",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver3:intt",
        "//sw/otbn/crypto/mldsa_ver3:mldsa44_keypair",
        "//sw/otbn/crypto/mldsa_ver3:ntt",
        "//sw/otbn/crypto/mldsa_ver3:poly_add",
        "//sw/otbn/crypto/mldsa_ver3:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver3:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver3:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver3:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mldsa44_sign_test_ver3",
    srcs = [
        "mldsa_sign_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=3",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver3:intt",
        "//sw/otbn/crypto/mldsa_ver3:ntt",
        "//sw/otbn/crypto/mldsa_ver3:poly_add",
        "//sw/otbn/crypto/mldsa_ver3:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver3:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver3:poly_sub",
        "//sw/otbn/crypto/mldsa_ver3:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver3:mldsa44_sign",
        "//sw/otbn/crypto/mldsa_ver3:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mldsa44_verify_test_ver3",
    srcs = [
        "mldsa_verify_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=3",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver3:intt",
        "//sw/otbn/crypto/mldsa_ver3:ntt",
        "//sw/otbn/crypto/mldsa_ver3:poly_add",
        "//sw/otbn/crypto/mldsa_ver3:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver3:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver3:poly_sub",
        "//sw/otbn/crypto/mldsa_ver3:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver3:mldsa44_verify",
        "//sw/otbn/crypto/mldsa_ver3:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mldsa65_keypair_test_ver3",
    srcs = [
        "mldsa_keypair_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=3",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver3:intt",
        "//sw/otbn/crypto/mldsa_ver3:mldsa65_keypair",
        "//sw/otbn/crypto/mldsa_ver3:ntt",
        "//sw/otbn/crypto/mldsa_ver3:poly_add",
        "//sw/otbn/crypto/mldsa_ver3:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver3:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver3:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver3:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mldsa65_sign_test_ver3",
    srcs = [
        "mldsa_sign_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=3",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver3:intt",
        "//sw/otbn/crypto/mldsa_ver3:ntt",
        "//sw/otbn/crypto/mldsa_ver3:poly_add",
        "//sw/otbn/crypto/mldsa_ver3:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver3:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver3:poly_sub",
        "//sw/otbn/crypto/mldsa_ver3:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver3:mldsa65_sign",
        "//sw/otbn/crypto/mldsa_ver3:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mldsa65_verify_test_ver3",
    srcs = [
        "mldsa_verify_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=3",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver3:intt",
        "//sw/otbn/crypto/mldsa_ver3:ntt",
        "//sw/otbn/crypto/mldsa_ver3:poly_add",
        "//sw/otbn/crypto/mldsa_ver3:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver3:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver3:poly_sub",
        "//sw/otbn/crypto/mldsa_ver3:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver3:mldsa65_verify",
        "//sw/otbn/crypto/mldsa_ver3:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mldsa87_keypair_test_ver3",
    srcs = [
        "mldsa_keypair_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=3",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver3:intt",
        "//sw/otbn/crypto/mldsa_ver3:mldsa87_keypair",
        "//sw/otbn/crypto/mldsa_ver3:ntt",
        "//sw/otbn/crypto/mldsa_ver3:poly_add",
        "//sw/otbn/crypto/mldsa_ver3:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver3:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver3:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver3:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mldsa87_sign_test_ver3",
    srcs = [
        "mldsa_sign_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=3",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver3:intt",
        "//sw/otbn/crypto/mldsa_ver3:ntt",
        "//sw/otbn/crypto/mldsa_ver3:poly_add",
        "//sw/otbn/crypto/mldsa_ver3:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver3:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver3:poly_sub",
        "//sw/otbn/crypto/mldsa_ver3:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver3:mldsa87_sign",
        "//sw/otbn/crypto/mldsa_ver3:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mldsa87_verify_test_ver3",
    srcs = [
        "mldsa_verify_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=3",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver3:intt",
        "//sw/otbn/crypto/mldsa_ver3:ntt",
        "//sw/otbn/crypto/mldsa_ver3:poly_add",
        "//sw/otbn/crypto/mldsa_ver3:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver3:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver3:poly_sub",
        "//sw/otbn/crypto/mldsa_ver3:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver3:mldsa87_verify",
        "//sw/otbn/crypto/mldsa_ver3:kmac_send_msg",
    ],
)

# otbn_sim_py_test VER 0 BASE

otbn_sim_py_test(
    name = "mldsa44_keypair_bench_ver0_base",
    deps = [":mldsa44_keypair_test_ver0_base"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa44_sign_bench_ver0_base",
    deps = [":mldsa44_sign_test_ver0_base"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa44_verify_bench_ver0_base",
    deps = [":mldsa44_verify_test_ver0_base"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa65_keypair_bench_ver0_base",
    deps = [":mldsa65_keypair_test_ver0_base"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa65_sign_bench_ver0_base",
    deps = [":mldsa65_sign_test_ver0_base"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa65_verify_bench_ver0_base",
    deps = [":mldsa65_verify_test_ver0_base"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa87_keypair_bench_ver0_base",
    deps = [":mldsa87_keypair_test_ver0_base"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa87_sign_bench_ver0_base",
    deps = [":mldsa87_sign_test_ver0_base"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa87_verify_bench_ver0_base",
    deps = [":mldsa87_verify_test_ver0_base"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

# otbn_sim_py_test VER 0

otbn_sim_py_test(
    name = "mldsa44_keypair_bench_ver0",
    deps = [":mldsa44_keypair_test_ver0"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa44_sign_bench_ver0",
    deps = [":mldsa44_sign_test_ver0"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa44_verify_bench_ver0",
    deps = [":mldsa44_verify_test_ver0"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa65_keypair_bench_ver0",
    deps = [":mldsa65_keypair_test_ver0"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa65_sign_bench_ver0",
    deps = [":mldsa65_sign_test_ver0"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa65_verify_bench_ver0",
    deps = [":mldsa65_verify_test_ver0"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa87_keypair_bench_ver0",
    deps = [":mldsa87_keypair_test_ver0"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa87_sign_bench_ver0",
    deps = [":mldsa87_sign_test_ver0"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa87_verify_bench_ver0",
    deps = [":mldsa87_verify_test_ver0"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

# otbn_sim_py_test VER 1 without lazy reduction

otbn_sim_py_test(
    name = "mldsa44_keypair_bench_ver1_nold",
    copts = ["--bnmulv_version_id=1"],
    deps = [":mldsa44_keypair_test_ver1_nold"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa44_sign_bench_ver1_nold",
    copts = ["--bnmulv_version_id=1"],
    deps = [":mldsa44_sign_test_ver1_nold"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa44_verify_bench_ver1_nold",
    copts = ["--bnmulv_version_id=1"],
    deps = [":mldsa44_verify_test_ver1_nold"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa65_keypair_bench_ver1_nold",
    copts = ["--bnmulv_version_id=1"],
    deps = [":mldsa65_keypair_test_ver1_nold"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa65_sign_bench_ver1_nold",
    copts = ["--bnmulv_version_id=1"],
    deps = [":mldsa65_sign_test_ver1_nold"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa65_verify_bench_ver1_nold",
    copts = ["--bnmulv_version_id=1"],
    deps = [":mldsa65_verify_test_ver1_nold"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa87_keypair_bench_ver1_nold",
    copts = ["--bnmulv_version_id=1"],
    deps = [":mldsa87_keypair_test_ver1_nold"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa87_sign_bench_ver1_nold",
    copts = ["--bnmulv_version_id=1"],
    deps = [":mldsa87_sign_test_ver1_nold"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa87_verify_bench_ver1_nold",
    copts = ["--bnmulv_version_id=1"],
    deps = [":mldsa87_verify_test_ver1_nold"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

# otbn_sim_py_test VER 1

otbn_sim_py_test(
    name = "mldsa44_keypair_bench_ver1",
    copts = ["--bnmulv_version_id=1"],
    deps = [":mldsa44_keypair_test_ver1"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa44_sign_bench_ver1",
    copts = ["--bnmulv_version_id=1"],
    deps = [":mldsa44_sign_test_ver1"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa44_verify_bench_ver1",
    copts = ["--bnmulv_version_id=1"],
    deps = [":mldsa44_verify_test_ver1"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa65_keypair_bench_ver1",
    copts = ["--bnmulv_version_id=1"],
    deps = [":mldsa65_keypair_test_ver1"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa65_sign_bench_ver1",
    copts = ["--bnmulv_version_id=1"],
    deps = [":mldsa65_sign_test_ver1"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa65_verify_bench_ver1",
    copts = ["--bnmulv_version_id=1"],
    deps = [":mldsa65_verify_test_ver1"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa87_keypair_bench_ver1",
    copts = ["--bnmulv_version_id=1"],
    deps = [":mldsa87_keypair_test_ver1"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa87_sign_bench_ver1",
    copts = ["--bnmulv_version_id=1"],
    deps = [":mldsa87_sign_test_ver1"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa87_verify_bench_ver1",
    copts = ["--bnmulv_version_id=1"],
    deps = [":mldsa87_verify_test_ver1"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

# otbn_sim_py_test VER 2 without lazy reduction

otbn_sim_py_test(
    name = "mldsa44_keypair_bench_ver2_nold",
    copts = ["--bnmulv_version_id=2"],
    deps = [":mldsa44_keypair_test_ver2_nold"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa44_sign_bench_ver2_nold",
    copts = ["--bnmulv_version_id=2"],
    deps = [":mldsa44_sign_test_ver2_nold"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa44_verify_bench_ver2_nold",
    copts = ["--bnmulv_version_id=2"],
    deps = [":mldsa44_verify_test_ver2_nold"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa65_keypair_bench_ver2_nold",
    copts = ["--bnmulv_version_id=2"],
    deps = [":mldsa65_keypair_test_ver2_nold"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa65_sign_bench_ver2_nold",
    copts = ["--bnmulv_version_id=2"],
    deps = [":mldsa65_sign_test_ver2_nold"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa65_verify_bench_ver2_nold",
    copts = ["--bnmulv_version_id=2"],
    deps = [":mldsa65_verify_test_ver2_nold"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa87_keypair_bench_ver2_nold",
    copts = ["--bnmulv_version_id=2"],
    deps = [":mldsa87_keypair_test_ver2_nold"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa87_sign_bench_ver2_nold",
    copts = ["--bnmulv_version_id=2"],
    deps = [":mldsa87_sign_test_ver2_nold"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa87_verify_bench_ver2_nold",
    copts = ["--bnmulv_version_id=2"],
    deps = [":mldsa87_verify_test_ver2_nold"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

# otbn_sim_py_test VER 2

otbn_sim_py_test(
    name = "mldsa44_keypair_bench_ver2",
    copts = ["--bnmulv_version_id=2"],
    deps = [":mldsa44_keypair_test_ver2"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa44_sign_bench_ver2",
    copts = ["--bnmulv_version_id=2"],
    deps = [":mldsa44_sign_test_ver2"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa44_verify_bench_ver2",
    copts = ["--bnmulv_version_id=2"],
    deps = [":mldsa44_verify_test_ver2"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa65_keypair_bench_ver2",
    copts = ["--bnmulv_version_id=2"],
    deps = [":mldsa65_keypair_test_ver2"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa65_sign_bench_ver2",
    copts = ["--bnmulv_version_id=2"],
    deps = [":mldsa65_sign_test_ver2"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa65_verify_bench_ver2",
    copts = ["--bnmulv_version_id=2"],
    deps = [":mldsa65_verify_test_ver2"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa87_keypair_bench_ver2",
    copts = ["--bnmulv_version_id=2"],
    deps = [":mldsa87_keypair_test_ver2"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa87_sign_bench_ver2",
    copts = ["--bnmulv_version_id=2"],
    deps = [":mldsa87_sign_test_ver2"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa87_verify_bench_ver2",
    copts = ["--bnmulv_version_id=2"],
    deps = [":mldsa87_verify_test_ver2"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

# otbn_sim_py_test VER 3

otbn_sim_py_test(
    name = "mldsa44_keypair_bench_ver3",
    copts = ["--bnmulv_version_id=3"],
    deps = [":mldsa44_keypair_test_ver3"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa44_sign_bench_ver3",
    copts = ["--bnmulv_version_id=3"],
    deps = [":mldsa44_sign_test_ver3"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa44_verify_bench_ver3",
    copts = ["--bnmulv_version_id=3"],
    deps = [":mldsa44_verify_test_ver3"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa65_keypair_bench_ver3",
    copts = ["--bnmulv_version_id=3"],
    deps = [":mldsa65_keypair_test_ver3"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa65_sign_bench_ver3",
    copts = ["--bnmulv_version_id=3"],
    deps = [":mldsa65_sign_test_ver3"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa65_verify_bench_ver3",
    copts = ["--bnmulv_version_id=3"],
    deps = [":mldsa65_verify_test_ver3"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa87_keypair_bench_ver3",
    copts = ["--bnmulv_version_id=3"],
    deps = [":mldsa87_keypair_test_ver3"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa87_sign_bench_ver3",
    copts = ["--bnmulv_version_id=3"],
    deps = [":mldsa87_sign_test_ver3"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa87_verify_bench_ver3",
    copts = ["--bnmulv_version_id=3"],
    deps = [":mldsa87_verify_test_ver3"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

# ML-DSA code size targets for VER0 BASE

otbn_binary(
    name = "mldsa44_code_size_ver0_base",
    srcs = [
        "mldsa_base_codesize.s",
    ],
    copts = ["-DDILITHIUM_MODE=2"],
    deps = [
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa44_keypair",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa44_sign",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa44_verify",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver0_base:intt",
        "//sw/otbn/crypto/mldsa_ver0_base:ntt",
        "//sw/otbn/crypto/mldsa_ver0_base:poly_add",
        "//sw/otbn/crypto/mldsa_ver0_base:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver0_base:poly_sub",
        "//sw/otbn/crypto/mldsa_ver0_base:kmac_send_msg",
    ],
)

otbn_binary(
    name = "mldsa65_code_size_ver0_base",
    srcs = [
        "mldsa_base_codesize.s",
    ],
    copts = ["-DDILITHIUM_MODE=3"],
    deps = [
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa65_keypair",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa65_sign",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa65_verify",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver0_base:intt",
        "//sw/otbn/crypto/mldsa_ver0_base:ntt",
        "//sw/otbn/crypto/mldsa_ver0_base:poly_add",
        "//sw/otbn/crypto/mldsa_ver0_base:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver0_base:poly_sub",
        "//sw/otbn/crypto/mldsa_ver0_base:kmac_send_msg",
    ],
)

otbn_binary(
    name = "mldsa87_code_size_ver0_base",
    srcs = [
        "mldsa_base_codesize.s",
    ],
    copts = ["-DDILITHIUM_MODE=5"],
    deps = [
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa87_keypair",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa87_sign",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa87_verify",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver0_base:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver0_base:intt",
        "//sw/otbn/crypto/mldsa_ver0_base:ntt",
        "//sw/otbn/crypto/mldsa_ver0_base:poly_add",
        "//sw/otbn/crypto/mldsa_ver0_base:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver0_base:poly_sub",
        "//sw/otbn/crypto/mldsa_ver0_base:kmac_send_msg",
    ],
)

# ML-DSA code size targets for VER0

otbn_binary(
    name = "mldsa44_code_size_ver0",
    srcs = [
        "mldsa_codesize.s",
    ],
    copts = ["-DDILITHIUM_MODE=2"],
    deps = [
        "//sw/otbn/crypto/mldsa_ver0:mldsa44_keypair",
        "//sw/otbn/crypto/mldsa_ver0:mldsa44_sign",
        "//sw/otbn/crypto/mldsa_ver0:mldsa44_verify",
        "//sw/otbn/crypto/mldsa_ver0:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver0:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver0:intt",
        "//sw/otbn/crypto/mldsa_ver0:ntt",
        "//sw/otbn/crypto/mldsa_ver0:poly_add",
        "//sw/otbn/crypto/mldsa_ver0:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver0:poly_sub",
        "//sw/otbn/crypto/mldsa_ver0:kmac_send_msg",
    ],
)

otbn_binary(
    name = "mldsa65_code_size_ver0",
    srcs = [
        "mldsa_codesize.s",
    ],
    copts = ["-DDILITHIUM_MODE=3"],
    deps = [
        "//sw/otbn/crypto/mldsa_ver0:mldsa65_keypair",
        "//sw/otbn/crypto/mldsa_ver0:mldsa65_sign",
        "//sw/otbn/crypto/mldsa_ver0:mldsa65_verify",
        "//sw/otbn/crypto/mldsa_ver0:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver0:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver0:intt",
        "//sw/otbn/crypto/mldsa_ver0:ntt",
        "//sw/otbn/crypto/mldsa_ver0:poly_add",
        "//sw/otbn/crypto/mldsa_ver0:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver0:poly_sub",
        "//sw/otbn/crypto/mldsa_ver0:kmac_send_msg",
    ],
)

otbn_binary(
    name = "mldsa87_code_size_ver0",
    srcs = [
        "mldsa_codesize.s",
    ],
    copts = ["-DDILITHIUM_MODE=5"],
    deps = [
        "//sw/otbn/crypto/mldsa_ver0:mldsa87_keypair",
        "//sw/otbn/crypto/mldsa_ver0:mldsa87_sign",
        "//sw/otbn/crypto/mldsa_ver0:mldsa87_verify",
        "//sw/otbn/crypto/mldsa_ver0:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver0:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver0:intt",
        "//sw/otbn/crypto/mldsa_ver0:ntt",
        "//sw/otbn/crypto/mldsa_ver0:poly_add",
        "//sw/otbn/crypto/mldsa_ver0:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver0:poly_sub",
        "//sw/otbn/crypto/mldsa_ver0:kmac_send_msg",
    ],
)

# ML-DSA code size targets for VER1 without lazy reduction

otbn_binary(
    name = "mldsa44_code_size_ver1_nold",
    srcs = [
        "mldsa_codesize.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa44_keypair",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa44_sign",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa44_verify",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver1_nold:intt",
        "//sw/otbn/crypto/mldsa_ver1_nold:ntt",
        "//sw/otbn/crypto/mldsa_ver1_nold:poly_add",
        "//sw/otbn/crypto/mldsa_ver1_nold:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver1_nold:poly_sub",
        "//sw/otbn/crypto/mldsa_ver1_nold:kmac_send_msg",
    ],
)

otbn_binary(
    name = "mldsa65_code_size_ver1_nold",
    srcs = [
        "mldsa_codesize.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa65_keypair",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa65_sign",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa65_verify",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver1_nold:intt",
        "//sw/otbn/crypto/mldsa_ver1_nold:ntt",
        "//sw/otbn/crypto/mldsa_ver1_nold:poly_add",
        "//sw/otbn/crypto/mldsa_ver1_nold:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver1_nold:poly_sub",
        "//sw/otbn/crypto/mldsa_ver1_nold:kmac_send_msg",
    ],
)

otbn_binary(
    name = "mldsa87_code_size_ver1_nold",
    srcs = [
        "mldsa_codesize.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa87_keypair",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa87_sign",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa87_verify",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver1_nold:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver1_nold:intt",
        "//sw/otbn/crypto/mldsa_ver1_nold:ntt",
        "//sw/otbn/crypto/mldsa_ver1_nold:poly_add",
        "//sw/otbn/crypto/mldsa_ver1_nold:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver1_nold:poly_sub",
        "//sw/otbn/crypto/mldsa_ver1_nold:kmac_send_msg",
    ],
)

# ML-DSA code size targets for VER1

otbn_binary(
    name = "mldsa44_code_size_ver1",
    srcs = [
        "mldsa_codesize.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver1:mldsa44_keypair",
        "//sw/otbn/crypto/mldsa_ver1:mldsa44_sign",
        "//sw/otbn/crypto/mldsa_ver1:mldsa44_verify",
        "//sw/otbn/crypto/mldsa_ver1:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver1:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver1:intt",
        "//sw/otbn/crypto/mldsa_ver1:ntt",
        "//sw/otbn/crypto/mldsa_ver1:poly_add",
        "//sw/otbn/crypto/mldsa_ver1:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver1:poly_sub",
        "//sw/otbn/crypto/mldsa_ver1:kmac_send_msg",
    ],
)

otbn_binary(
    name = "mldsa65_code_size_ver1",
    srcs = [
        "mldsa_codesize.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver1:mldsa65_keypair",
        "//sw/otbn/crypto/mldsa_ver1:mldsa65_sign",
        "//sw/otbn/crypto/mldsa_ver1:mldsa65_verify",
        "//sw/otbn/crypto/mldsa_ver1:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver1:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver1:intt",
        "//sw/otbn/crypto/mldsa_ver1:ntt",
        "//sw/otbn/crypto/mldsa_ver1:poly_add",
        "//sw/otbn/crypto/mldsa_ver1:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver1:poly_sub",
        "//sw/otbn/crypto/mldsa_ver1:kmac_send_msg",
    ],
)

otbn_binary(
    name = "mldsa87_code_size_ver1",
    srcs = [
        "mldsa_codesize.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver1:mldsa87_keypair",
        "//sw/otbn/crypto/mldsa_ver1:mldsa87_sign",
        "//sw/otbn/crypto/mldsa_ver1:mldsa87_verify",
        "//sw/otbn/crypto/mldsa_ver1:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver1:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver1:intt",
        "//sw/otbn/crypto/mldsa_ver1:ntt",
        "//sw/otbn/crypto/mldsa_ver1:poly_add",
        "//sw/otbn/crypto/mldsa_ver1:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver1:poly_sub",
        "//sw/otbn/crypto/mldsa_ver1:kmac_send_msg",
    ],
)

# ML-DSA code size targets for VER2 without lazy reduction

otbn_binary(
    name = "mldsa44_code_size_ver2_nold",
    srcs = [
        "mldsa_codesize.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa44_keypair",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa44_sign",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa44_verify",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver2_nold:intt",
        "//sw/otbn/crypto/mldsa_ver2_nold:ntt",
        "//sw/otbn/crypto/mldsa_ver2_nold:poly_add",
        "//sw/otbn/crypto/mldsa_ver2_nold:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver2_nold:poly_sub",
        "//sw/otbn/crypto/mldsa_ver2_nold:kmac_send_msg",
    ],
)

otbn_binary(
    name = "mldsa65_code_size_ver2_nold",
    srcs = [
        "mldsa_codesize.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa65_keypair",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa65_sign",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa65_verify",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver2_nold:intt",
        "//sw/otbn/crypto/mldsa_ver2_nold:ntt",
        "//sw/otbn/crypto/mldsa_ver2_nold:poly_add",
        "//sw/otbn/crypto/mldsa_ver2_nold:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver2_nold:poly_sub",
        "//sw/otbn/crypto/mldsa_ver2_nold:kmac_send_msg",
    ],
)

otbn_binary(
    name = "mldsa87_code_size_ver2_nold",
    srcs = [
        "mldsa_codesize.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa87_keypair",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa87_sign",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa87_verify",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver2_nold:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver2_nold:intt",
        "//sw/otbn/crypto/mldsa_ver2_nold:ntt",
        "//sw/otbn/crypto/mldsa_ver2_nold:poly_add",
        "//sw/otbn/crypto/mldsa_ver2_nold:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver2_nold:poly_sub",
        "//sw/otbn/crypto/mldsa_ver2_nold:kmac_send_msg",
    ],
)

# ML-DSA code size targets for VER2

otbn_binary(
    name = "mldsa44_code_size_ver2",
    srcs = [
        "mldsa_codesize.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver2:mldsa44_keypair",
        "//sw/otbn/crypto/mldsa_ver2:mldsa44_sign",
        "//sw/otbn/crypto/mldsa_ver2:mldsa44_verify",
        "//sw/otbn/crypto/mldsa_ver2:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver2:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver2:intt",
        "//sw/otbn/crypto/mldsa_ver2:ntt",
        "//sw/otbn/crypto/mldsa_ver2:poly_add",
        "//sw/otbn/crypto/mldsa_ver2:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver2:poly_sub",
        "//sw/otbn/crypto/mldsa_ver2:kmac_send_msg",
    ],
)

otbn_binary(
    name = "mldsa65_code_size_ver2",
    srcs = [
        "mldsa_codesize.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver2:mldsa65_keypair",
        "//sw/otbn/crypto/mldsa_ver2:mldsa65_sign",
        "//sw/otbn/crypto/mldsa_ver2:mldsa65_verify",
        "//sw/otbn/crypto/mldsa_ver2:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver2:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver2:intt",
        "//sw/otbn/crypto/mldsa_ver2:ntt",
        "//sw/otbn/crypto/mldsa_ver2:poly_add",
        "//sw/otbn/crypto/mldsa_ver2:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver2:poly_sub",
        "//sw/otbn/crypto/mldsa_ver2:kmac_send_msg",
    ],
)

otbn_binary(
    name = "mldsa87_code_size_ver2",
    srcs = [
        "mldsa_codesize.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver2:mldsa87_keypair",
        "//sw/otbn/crypto/mldsa_ver2:mldsa87_sign",
        "//sw/otbn/crypto/mldsa_ver2:mldsa87_verify",
        "//sw/otbn/crypto/mldsa_ver2:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver2:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver2:intt",
        "//sw/otbn/crypto/mldsa_ver2:ntt",
        "//sw/otbn/crypto/mldsa_ver2:poly_add",
        "//sw/otbn/crypto/mldsa_ver2:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver2:poly_sub",
        "//sw/otbn/crypto/mldsa_ver2:kmac_send_msg",
    ],
)

# ML-DSA code size targets for VER3

otbn_binary(
    name = "mldsa44_code_size_ver3",
    srcs = [
        "mldsa_codesize.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver3:mldsa44_keypair",
        "//sw/otbn/crypto/mldsa_ver3:mldsa44_sign",
        "//sw/otbn/crypto/mldsa_ver3:mldsa44_verify",
        "//sw/otbn/crypto/mldsa_ver3:mldsa44_poly",
        "//sw/otbn/crypto/mldsa_ver3:mldsa44_rounding",
        "//sw/otbn/crypto/mldsa_ver3:intt",
        "//sw/otbn/crypto/mldsa_ver3:ntt",
        "//sw/otbn/crypto/mldsa_ver3:poly_add",
        "//sw/otbn/crypto/mldsa_ver3:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver3:poly_sub",
        "//sw/otbn/crypto/mldsa_ver3:kmac_send_msg",
    ],
)

otbn_binary(
    name = "mldsa65_code_size_ver3",
    srcs = [
        "mldsa_codesize.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver3:mldsa65_keypair",
        "//sw/otbn/crypto/mldsa_ver3:mldsa65_sign",
        "//sw/otbn/crypto/mldsa_ver3:mldsa65_verify",
        "//sw/otbn/crypto/mldsa_ver3:mldsa65_poly",
        "//sw/otbn/crypto/mldsa_ver3:mldsa65_rounding",
        "//sw/otbn/crypto/mldsa_ver3:intt",
        "//sw/otbn/crypto/mldsa_ver3:ntt",
        "//sw/otbn/crypto/mldsa_ver3:poly_add",
        "//sw/otbn/crypto/mldsa_ver3:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver3:poly_sub",
        "//sw/otbn/crypto/mldsa_ver3:kmac_send_msg",
    ],
)

otbn_binary(
    name = "mldsa87_code_size_ver3",
    srcs = [
        "mldsa_codesize.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa_ver3:mldsa87_keypair",
        "//sw/otbn/crypto/mldsa_ver3:mldsa87_sign",
        "//sw/otbn/crypto/mldsa_ver3:mldsa87_verify",
        "//sw/otbn/crypto/mldsa_ver3:mldsa87_poly",
        "//sw/otbn/crypto/mldsa_ver3:mldsa87_rounding",
        "//sw/otbn/crypto/mldsa_ver3:intt",
        "//sw/otbn/crypto/mldsa_ver3:ntt",
        "//sw/otbn/crypto/mldsa_ver3:poly_add",
        "//sw/otbn/crypto/mldsa_ver3:poly_pointwise",
        "//sw/otbn/crypto/mldsa_ver3:poly_sub",
        "//sw/otbn/crypto/mldsa_ver3:kmac_send_msg",
    ],
)
