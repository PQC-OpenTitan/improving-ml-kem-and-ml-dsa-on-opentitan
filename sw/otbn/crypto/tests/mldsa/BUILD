# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
# Modified by Authors of "Towards ML-KEM & ML-DSA on OpenTitan" (https://eprint.iacr.org/2024/1192).
# Copyright "Towards ML-KEM & ML-DSA on OpenTitan" Authors.

load("//rules:otbn.bzl", "otbn_binary", "otbn_consttime_test", "otbn_library", "otbn_sim_test", "otbn_sim_py_test")

package(default_visibility = ["//visibility:public"])

otbn_sim_test(
    name = "poly_add_dilithium_test",
    srcs = [
        "poly_add_dilithium_test.s",
    ],
    dexp = "poly_add_dilithium_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa:poly_add_dilithium",
    ],
)

otbn_sim_test(
    name = "dilithium2_keypair_test",
    srcs = [
        "dilithium_keypair_test.s",
    ],
    copts = ["-DDILITHIUM_MODE=2"],
    dexp = "dilithium2_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa:intt_dilithium",
        "//sw/otbn/crypto/mldsa:key_pair_dilithium2",
        "//sw/otbn/crypto/mldsa:ntt_dilithium",
        "//sw/otbn/crypto/mldsa:poly_add_dilithium",
        "//sw/otbn/crypto/mldsa:poly_dilithium2",
        "//sw/otbn/crypto/mldsa:poly_pointwise_dilithium",
        "//sw/otbn/crypto/mldsa:rounding_dilithium2",
    ],
)

otbn_sim_test(
    name = "dilithium2_sign_test",
    srcs = [
        "dilithium_sign_test.s",
    ],
    copts = ["-DDILITHIUM_MODE=2"],
    dexp = "dilithium2_sign_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa:intt_dilithium",
        "//sw/otbn/crypto/mldsa:ntt_dilithium",
        "//sw/otbn/crypto/mldsa:poly_add_dilithium",
        "//sw/otbn/crypto/mldsa:poly_dilithium2",
        "//sw/otbn/crypto/mldsa:poly_pointwise_dilithium",
        "//sw/otbn/crypto/mldsa:poly_sub_dilithium",
        "//sw/otbn/crypto/mldsa:rounding_dilithium2",
        "//sw/otbn/crypto/mldsa:sign_dilithium2",
    ],
)

otbn_sim_test(
    name = "dilithium2_verify_test",
    srcs = [
        "dilithium_verify_test.s",
    ],
    copts = ["-DDILITHIUM_MODE=2"],
    dexp = "dilithium2_verify_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa:intt_dilithium",
        "//sw/otbn/crypto/mldsa:ntt_dilithium",
        "//sw/otbn/crypto/mldsa:poly_add_dilithium",
        "//sw/otbn/crypto/mldsa:poly_dilithium2",
        "//sw/otbn/crypto/mldsa:poly_pointwise_dilithium",
        "//sw/otbn/crypto/mldsa:poly_sub_dilithium",
        "//sw/otbn/crypto/mldsa:rounding_dilithium2",
        "//sw/otbn/crypto/mldsa:verify_dilithium2",
    ],
)

otbn_sim_test(
    name = "dilithium3_keypair_test",
    srcs = [
        "dilithium_keypair_test.s",
    ],
    copts = ["-DDILITHIUM_MODE=3"],
    dexp = "dilithium3_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa:intt_dilithium",
        "//sw/otbn/crypto/mldsa:key_pair_dilithium3",
        "//sw/otbn/crypto/mldsa:ntt_dilithium",
        "//sw/otbn/crypto/mldsa:poly_add_dilithium",
        "//sw/otbn/crypto/mldsa:poly_dilithium3",
        "//sw/otbn/crypto/mldsa:poly_pointwise_dilithium",
        "//sw/otbn/crypto/mldsa:rounding_dilithium3",
    ],
)

otbn_sim_test(
    name = "dilithium3_sign_test",
    srcs = [
        "dilithium_sign_test.s",
    ],
    copts = ["-DDILITHIUM_MODE=3"],
    dexp = "dilithium3_sign_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa:intt_dilithium",
        "//sw/otbn/crypto/mldsa:ntt_dilithium",
        "//sw/otbn/crypto/mldsa:poly_add_dilithium",
        "//sw/otbn/crypto/mldsa:poly_dilithium3",
        "//sw/otbn/crypto/mldsa:poly_pointwise_dilithium",
        "//sw/otbn/crypto/mldsa:poly_sub_dilithium",
        "//sw/otbn/crypto/mldsa:rounding_dilithium3",
        "//sw/otbn/crypto/mldsa:sign_dilithium3",
    ],
)

otbn_sim_test(
    name = "dilithium3_verify_test",
    srcs = [
        "dilithium_verify_test.s",
    ],
    copts = ["-DDILITHIUM_MODE=3"],
    dexp = "dilithium3_verify_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa:intt_dilithium",
        "//sw/otbn/crypto/mldsa:ntt_dilithium",
        "//sw/otbn/crypto/mldsa:poly_add_dilithium",
        "//sw/otbn/crypto/mldsa:poly_dilithium3",
        "//sw/otbn/crypto/mldsa:poly_pointwise_dilithium",
        "//sw/otbn/crypto/mldsa:poly_sub_dilithium",
        "//sw/otbn/crypto/mldsa:rounding_dilithium3",
        "//sw/otbn/crypto/mldsa:verify_dilithium3",
    ],
)

otbn_sim_test(
    name = "dilithium5_keypair_test",
    srcs = [
        "dilithium_keypair_test.s",
    ],
    copts = ["-DDILITHIUM_MODE=5"],
    dexp = "dilithium5_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa:intt_dilithium",
        "//sw/otbn/crypto/mldsa:key_pair_dilithium5",
        "//sw/otbn/crypto/mldsa:ntt_dilithium",
        "//sw/otbn/crypto/mldsa:poly_add_dilithium",
        "//sw/otbn/crypto/mldsa:poly_dilithium5",
        "//sw/otbn/crypto/mldsa:poly_pointwise_dilithium",
        "//sw/otbn/crypto/mldsa:rounding_dilithium5",
    ],
)

otbn_sim_test(
    name = "dilithium5_sign_test",
    srcs = [
        "dilithium_sign_test.s",
    ],
    copts = ["-DDILITHIUM_MODE=5"],
    dexp = "dilithium5_sign_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa:intt_dilithium",
        "//sw/otbn/crypto/mldsa:ntt_dilithium",
        "//sw/otbn/crypto/mldsa:poly_add_dilithium",
        "//sw/otbn/crypto/mldsa:poly_dilithium5",
        "//sw/otbn/crypto/mldsa:poly_pointwise_dilithium",
        "//sw/otbn/crypto/mldsa:poly_sub_dilithium",
        "//sw/otbn/crypto/mldsa:rounding_dilithium5",
        "//sw/otbn/crypto/mldsa:sign_dilithium5",
    ],
)

otbn_sim_test(
    name = "dilithium5_verify_test",
    srcs = [
        "dilithium_verify_test.s",
    ],
    copts = ["-DDILITHIUM_MODE=5"],
    dexp = "dilithium5_verify_test.dexp",
    deps = [
        "//sw/otbn/crypto/mldsa:intt_dilithium",
        "//sw/otbn/crypto/mldsa:ntt_dilithium",
        "//sw/otbn/crypto/mldsa:poly_add_dilithium",
        "//sw/otbn/crypto/mldsa:poly_dilithium5",
        "//sw/otbn/crypto/mldsa:poly_pointwise_dilithium",
        "//sw/otbn/crypto/mldsa:poly_sub_dilithium",
        "//sw/otbn/crypto/mldsa:rounding_dilithium5",
        "//sw/otbn/crypto/mldsa:verify_dilithium5",
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

# Binaries for Verilator tests VER0

otbn_binary(
    name = "otbn_mldsa44_keypair_test_ver0",
    srcs = [
        "dilithium_keypair_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=0",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa:intt_dilithium",
        "//sw/otbn/crypto/mldsa:key_pair_dilithium2",
        "//sw/otbn/crypto/mldsa:ntt_dilithium",
        "//sw/otbn/crypto/mldsa:poly_add_dilithium",
        "//sw/otbn/crypto/mldsa:poly_dilithium2",
        "//sw/otbn/crypto/mldsa:poly_pointwise_dilithium",
        "//sw/otbn/crypto/mldsa:rounding_dilithium2",
    ],
)

otbn_binary(
    name = "otbn_mldsa44_sign_test_ver0",
    srcs = [
        "dilithium_sign_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=0",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa:intt_dilithium",
        "//sw/otbn/crypto/mldsa:ntt_dilithium",
        "//sw/otbn/crypto/mldsa:poly_add_dilithium",
        "//sw/otbn/crypto/mldsa:poly_dilithium2",
        "//sw/otbn/crypto/mldsa:poly_pointwise_dilithium",
        "//sw/otbn/crypto/mldsa:poly_sub_dilithium",
        "//sw/otbn/crypto/mldsa:rounding_dilithium2",
        "//sw/otbn/crypto/mldsa:sign_dilithium2",
    ],
)

otbn_binary(
    name = "otbn_mldsa44_verify_test_ver0",
    srcs = [
        "dilithium_verify_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=2",
        "--bnmulv_version_id=0",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa:intt_dilithium",
        "//sw/otbn/crypto/mldsa:ntt_dilithium",
        "//sw/otbn/crypto/mldsa:poly_add_dilithium",
        "//sw/otbn/crypto/mldsa:poly_dilithium2",
        "//sw/otbn/crypto/mldsa:poly_pointwise_dilithium",
        "//sw/otbn/crypto/mldsa:poly_sub_dilithium",
        "//sw/otbn/crypto/mldsa:rounding_dilithium2",
        "//sw/otbn/crypto/mldsa:verify_dilithium2",
    ],
)

otbn_binary(
    name = "otbn_mldsa65_keypair_test_ver0",
    srcs = [
        "dilithium_keypair_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=0",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa:intt_dilithium",
        "//sw/otbn/crypto/mldsa:key_pair_dilithium3",
        "//sw/otbn/crypto/mldsa:ntt_dilithium",
        "//sw/otbn/crypto/mldsa:poly_add_dilithium",
        "//sw/otbn/crypto/mldsa:poly_dilithium3",
        "//sw/otbn/crypto/mldsa:poly_pointwise_dilithium",
        "//sw/otbn/crypto/mldsa:rounding_dilithium3",
    ],
)

otbn_binary(
    name = "otbn_mldsa65_sign_test_ver0",
    srcs = [
        "dilithium_sign_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=0",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa:intt_dilithium",
        "//sw/otbn/crypto/mldsa:ntt_dilithium",
        "//sw/otbn/crypto/mldsa:poly_add_dilithium",
        "//sw/otbn/crypto/mldsa:poly_dilithium3",
        "//sw/otbn/crypto/mldsa:poly_pointwise_dilithium",
        "//sw/otbn/crypto/mldsa:poly_sub_dilithium",
        "//sw/otbn/crypto/mldsa:rounding_dilithium3",
        "//sw/otbn/crypto/mldsa:sign_dilithium3",
    ],
)

otbn_binary(
    name = "otbn_mldsa65_verify_test_ver0",
    srcs = [
        "dilithium_verify_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=3",
        "--bnmulv_version_id=0",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa:intt_dilithium",
        "//sw/otbn/crypto/mldsa:ntt_dilithium",
        "//sw/otbn/crypto/mldsa:poly_add_dilithium",
        "//sw/otbn/crypto/mldsa:poly_dilithium3",
        "//sw/otbn/crypto/mldsa:poly_pointwise_dilithium",
        "//sw/otbn/crypto/mldsa:poly_sub_dilithium",
        "//sw/otbn/crypto/mldsa:rounding_dilithium3",
        "//sw/otbn/crypto/mldsa:verify_dilithium3",
    ],
)

otbn_binary(
    name = "otbn_mldsa87_keypair_test_ver0",
    srcs = [
        "dilithium_keypair_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=0",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa:intt_dilithium",
        "//sw/otbn/crypto/mldsa:key_pair_dilithium5",
        "//sw/otbn/crypto/mldsa:ntt_dilithium",
        "//sw/otbn/crypto/mldsa:poly_add_dilithium",
        "//sw/otbn/crypto/mldsa:poly_dilithium5",
        "//sw/otbn/crypto/mldsa:poly_pointwise_dilithium",
        "//sw/otbn/crypto/mldsa:rounding_dilithium5",
    ],
)

otbn_binary(
    name = "otbn_mldsa87_sign_test_ver0",
    srcs = [
        "dilithium_sign_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=0",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa:intt_dilithium",
        "//sw/otbn/crypto/mldsa:ntt_dilithium",
        "//sw/otbn/crypto/mldsa:poly_add_dilithium",
        "//sw/otbn/crypto/mldsa:poly_dilithium5",
        "//sw/otbn/crypto/mldsa:poly_pointwise_dilithium",
        "//sw/otbn/crypto/mldsa:poly_sub_dilithium",
        "//sw/otbn/crypto/mldsa:rounding_dilithium5",
        "//sw/otbn/crypto/mldsa:sign_dilithium5",
    ],
)

otbn_binary(
    name = "otbn_mldsa87_verify_test_ver0",
    srcs = [
        "dilithium_verify_test.s",
    ],
    copts = [
        "-DDILITHIUM_MODE=5",
        "--bnmulv_version_id=0",
    ],
    deps = [
        "//sw/otbn/crypto/mldsa:intt_dilithium",
        "//sw/otbn/crypto/mldsa:ntt_dilithium",
        "//sw/otbn/crypto/mldsa:poly_add_dilithium",
        "//sw/otbn/crypto/mldsa:poly_dilithium5",
        "//sw/otbn/crypto/mldsa:poly_pointwise_dilithium",
        "//sw/otbn/crypto/mldsa:poly_sub_dilithium",
        "//sw/otbn/crypto/mldsa:rounding_dilithium5",
        "//sw/otbn/crypto/mldsa:verify_dilithium5",
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

# otbn_sim_py_test VER 0

otbn_sim_py_test(
    name = "mldsa44_keypair_bench",
    deps = [":dilithium2_keypair_test"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa44_sign_bench",
    deps = [":dilithium2_sign_test"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa44_verify_bench",
    deps = [":dilithium2_verify_test"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa65_keypair_bench",
    deps = [":dilithium3_keypair_test"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa65_sign_bench",
    deps = [":dilithium3_sign_test"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa65_verify_bench",
    deps = [":dilithium3_verify_test"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa87_keypair_bench",
    deps = [":dilithium5_keypair_test"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa87_sign_bench",
    deps = [":dilithium5_sign_test"],
    sim_test_wrapper = "dilithiumpy_bench_otbn/run_dilithium.py",
)

otbn_sim_py_test(
    name = "mldsa87_verify_bench",
    deps = [":dilithium5_verify_test"],
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
