# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
# Modified by Authors of "Towards ML-KEM & ML-DSA on OpenTitan" (https://eprint.iacr.org/2024/1192).
# Copyright "Towards ML-KEM & ML-DSA on OpenTitan" Authors.

load("//rules:otbn.bzl", "otbn_binary", "otbn_consttime_test", "otbn_library", "otbn_sim_test", "otbn_sim_py_test")

package(default_visibility = ["//visibility:public"])

# Refactor ML-KEM VER0 BASE

otbn_sim_test(
    name = "mlkem512_keypair_test_ver0_base",
    srcs = [
        "mlkem_base_keypair_test.s",
    ],
    copts = ["-DKYBER_K=2"],
    dexp = "mlkem512_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem512_keypair",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver0_base:basemul",
        "//sw/otbn/crypto/mlkem_ver0_base:cbd",
        "//sw/otbn/crypto/mlkem_ver0_base:ntt",
        "//sw/otbn/crypto/mlkem_ver0_base:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver0_base:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem512_encap_test_ver0_base",
    srcs = [
        "mlkem_base_encap_test.s",
    ],
    copts = ["-DKYBER_K=2"],
    dexp = "mlkem512_encap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem512_encap",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem512_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver0_base:basemul",
        "//sw/otbn/crypto/mlkem_ver0_base:cbd",
        "//sw/otbn/crypto/mlkem_ver0_base:intt",
        "//sw/otbn/crypto/mlkem_ver0_base:ntt",
        "//sw/otbn/crypto/mlkem_ver0_base:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver0_base:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem512_decap_test_ver0_base",
    srcs = [
        "mlkem_base_decap_test.s",
    ],
    copts = ["-DKYBER_K=2"],
    dexp = "mlkem512_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem512_decap",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem512_encap",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem512_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver0_base:basemul",
        "//sw/otbn/crypto/mlkem_ver0_base:cbd",
        "//sw/otbn/crypto/mlkem_ver0_base:intt",
        "//sw/otbn/crypto/mlkem_ver0_base:ntt",
        "//sw/otbn/crypto/mlkem_ver0_base:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver0_base:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem512_false_decap_test_ver0_base",
    srcs = [
        "mlkem_base_false_decap_test.s",
    ],
    copts = ["-DKYBER_K=2"],
    dexp = "mlkem512_false_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem512_decap",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem512_encap",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem512_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver0_base:basemul",
        "//sw/otbn/crypto/mlkem_ver0_base:cbd",
        "//sw/otbn/crypto/mlkem_ver0_base:intt",
        "//sw/otbn/crypto/mlkem_ver0_base:ntt",
        "//sw/otbn/crypto/mlkem_ver0_base:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver0_base:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem768_keypair_test_ver0_base",
    srcs = [
        "mlkem_base_keypair_test.s",
    ],
    copts = ["-DKYBER_K=3"],
    dexp = "mlkem768_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem768_keypair",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver0_base:basemul",
        "//sw/otbn/crypto/mlkem_ver0_base:cbd",
        "//sw/otbn/crypto/mlkem_ver0_base:ntt",
        "//sw/otbn/crypto/mlkem_ver0_base:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver0_base:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem768_encap_test_ver0_base",
    srcs = [
        "mlkem_base_encap_test.s",
    ],
    copts = ["-DKYBER_K=3"],
    dexp = "mlkem768_encap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem768_encap",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem768_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver0_base:basemul",
        "//sw/otbn/crypto/mlkem_ver0_base:cbd",
        "//sw/otbn/crypto/mlkem_ver0_base:intt",
        "//sw/otbn/crypto/mlkem_ver0_base:ntt",
        "//sw/otbn/crypto/mlkem_ver0_base:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver0_base:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem768_decap_test_ver0_base",
    srcs = [
        "mlkem_base_decap_test.s",
    ],
    copts = ["-DKYBER_K=3"],
    dexp = "mlkem768_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem768_decap",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem768_encap",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem768_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver0_base:basemul",
        "//sw/otbn/crypto/mlkem_ver0_base:cbd",
        "//sw/otbn/crypto/mlkem_ver0_base:intt",
        "//sw/otbn/crypto/mlkem_ver0_base:ntt",
        "//sw/otbn/crypto/mlkem_ver0_base:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver0_base:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem768_false_decap_test_ver0_base",
    srcs = [
        "mlkem_base_false_decap_test.s",
    ],
    copts = ["-DKYBER_K=3"],
    dexp = "mlkem768_false_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem768_decap",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem768_encap",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem768_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver0_base:basemul",
        "//sw/otbn/crypto/mlkem_ver0_base:cbd",
        "//sw/otbn/crypto/mlkem_ver0_base:intt",
        "//sw/otbn/crypto/mlkem_ver0_base:ntt",
        "//sw/otbn/crypto/mlkem_ver0_base:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver0_base:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem1024_keypair_test_ver0_base",
    srcs = [
        "mlkem_base_keypair_test.s",
    ],
    copts = ["-DKYBER_K=4"],
    dexp = "mlkem1024_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem1024_keypair",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver0_base:basemul",
        "//sw/otbn/crypto/mlkem_ver0_base:cbd",
        "//sw/otbn/crypto/mlkem_ver0_base:ntt",
        "//sw/otbn/crypto/mlkem_ver0_base:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver0_base:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem1024_encap_test_ver0_base",
    srcs = [
        "mlkem_base_encap_test.s",
    ],
    copts = ["-DKYBER_K=4"],
    dexp = "mlkem1024_encap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem1024_encap",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem1024_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver0_base:basemul",
        "//sw/otbn/crypto/mlkem_ver0_base:cbd",
        "//sw/otbn/crypto/mlkem_ver0_base:intt",
        "//sw/otbn/crypto/mlkem_ver0_base:ntt",
        "//sw/otbn/crypto/mlkem_ver0_base:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver0_base:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem1024_decap_test_ver0_base",
    srcs = [
        "mlkem_base_decap_test.s",
    ],
    copts = ["-DKYBER_K=4"],
    dexp = "mlkem1024_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem1024_decap",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem1024_encap",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem1024_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver0_base:basemul",
        "//sw/otbn/crypto/mlkem_ver0_base:cbd",
        "//sw/otbn/crypto/mlkem_ver0_base:intt",
        "//sw/otbn/crypto/mlkem_ver0_base:ntt",
        "//sw/otbn/crypto/mlkem_ver0_base:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver0_base:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem1024_false_decap_test_ver0_base",
    srcs = [
        "mlkem_base_false_decap_test.s",
    ],
    copts = ["-DKYBER_K=4"],
    dexp = "mlkem1024_false_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem1024_decap",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem1024_encap",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem1024_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver0_base:basemul",
        "//sw/otbn/crypto/mlkem_ver0_base:cbd",
        "//sw/otbn/crypto/mlkem_ver0_base:intt",
        "//sw/otbn/crypto/mlkem_ver0_base:ntt",
        "//sw/otbn/crypto/mlkem_ver0_base:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver0_base:kmac_send_msg",
    ],
)

# Refactor ML-KEM VER0

otbn_sim_test(
    name = "mlkem512_keypair_test_ver0",
    srcs = [
        "mlkem_keypair_test.s",
    ],
    copts = ["-DKYBER_K=2"],
    dexp = "mlkem512_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver0:mlkem512_keypair",
        "//sw/otbn/crypto/mlkem_ver0:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver0:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver0:basemul",
        "//sw/otbn/crypto/mlkem_ver0:cbd",
        "//sw/otbn/crypto/mlkem_ver0:ntt",
        "//sw/otbn/crypto/mlkem_ver0:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver0:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem512_encap_test_ver0",
    srcs = [
        "mlkem_encap_test.s",
    ],
    copts = ["-DKYBER_K=2"],
    dexp = "mlkem512_encap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver0:mlkem512_encap",
        "//sw/otbn/crypto/mlkem_ver0:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver0:mlkem512_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver0:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver0:basemul",
        "//sw/otbn/crypto/mlkem_ver0:cbd",
        "//sw/otbn/crypto/mlkem_ver0:intt",
        "//sw/otbn/crypto/mlkem_ver0:ntt",
        "//sw/otbn/crypto/mlkem_ver0:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver0:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem512_decap_test_ver0",
    srcs = [
        "mlkem_decap_test.s",
    ],
    copts = ["-DKYBER_K=2"],
    dexp = "mlkem512_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver0:mlkem512_decap",
        "//sw/otbn/crypto/mlkem_ver0:mlkem512_encap",
        "//sw/otbn/crypto/mlkem_ver0:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver0:mlkem512_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver0:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver0:basemul",
        "//sw/otbn/crypto/mlkem_ver0:cbd",
        "//sw/otbn/crypto/mlkem_ver0:intt",
        "//sw/otbn/crypto/mlkem_ver0:ntt",
        "//sw/otbn/crypto/mlkem_ver0:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver0:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem512_false_decap_test_ver0",
    srcs = [
        "mlkem_false_decap_test.s",
    ],
    copts = ["-DKYBER_K=2"],
    dexp = "mlkem512_false_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver0:mlkem512_decap",
        "//sw/otbn/crypto/mlkem_ver0:mlkem512_encap",
        "//sw/otbn/crypto/mlkem_ver0:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver0:mlkem512_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver0:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver0:basemul",
        "//sw/otbn/crypto/mlkem_ver0:cbd",
        "//sw/otbn/crypto/mlkem_ver0:intt",
        "//sw/otbn/crypto/mlkem_ver0:ntt",
        "//sw/otbn/crypto/mlkem_ver0:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver0:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem768_keypair_test_ver0",
    srcs = [
        "mlkem_keypair_test.s",
    ],
    copts = ["-DKYBER_K=3"],
    dexp = "mlkem768_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver0:mlkem768_keypair",
        "//sw/otbn/crypto/mlkem_ver0:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver0:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver0:basemul",
        "//sw/otbn/crypto/mlkem_ver0:cbd",
        "//sw/otbn/crypto/mlkem_ver0:ntt",
        "//sw/otbn/crypto/mlkem_ver0:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver0:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem768_encap_test_ver0",
    srcs = [
        "mlkem_encap_test.s",
    ],
    copts = ["-DKYBER_K=3"],
    dexp = "mlkem768_encap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver0:mlkem768_encap",
        "//sw/otbn/crypto/mlkem_ver0:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver0:mlkem768_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver0:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver0:basemul",
        "//sw/otbn/crypto/mlkem_ver0:cbd",
        "//sw/otbn/crypto/mlkem_ver0:intt",
        "//sw/otbn/crypto/mlkem_ver0:ntt",
        "//sw/otbn/crypto/mlkem_ver0:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver0:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem768_decap_test_ver0",
    srcs = [
        "mlkem_decap_test.s",
    ],
    copts = ["-DKYBER_K=3"],
    dexp = "mlkem768_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver0:mlkem768_decap",
        "//sw/otbn/crypto/mlkem_ver0:mlkem768_encap",
        "//sw/otbn/crypto/mlkem_ver0:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver0:mlkem768_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver0:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver0:basemul",
        "//sw/otbn/crypto/mlkem_ver0:cbd",
        "//sw/otbn/crypto/mlkem_ver0:intt",
        "//sw/otbn/crypto/mlkem_ver0:ntt",
        "//sw/otbn/crypto/mlkem_ver0:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver0:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem768_false_decap_test_ver0",
    srcs = [
        "mlkem_false_decap_test.s",
    ],
    copts = ["-DKYBER_K=3"],
    dexp = "mlkem768_false_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver0:mlkem768_decap",
        "//sw/otbn/crypto/mlkem_ver0:mlkem768_encap",
        "//sw/otbn/crypto/mlkem_ver0:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver0:mlkem768_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver0:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver0:basemul",
        "//sw/otbn/crypto/mlkem_ver0:cbd",
        "//sw/otbn/crypto/mlkem_ver0:intt",
        "//sw/otbn/crypto/mlkem_ver0:ntt",
        "//sw/otbn/crypto/mlkem_ver0:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver0:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem1024_keypair_test_ver0",
    srcs = [
        "mlkem_keypair_test.s",
    ],
    copts = ["-DKYBER_K=4"],
    dexp = "mlkem1024_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver0:mlkem1024_keypair",
        "//sw/otbn/crypto/mlkem_ver0:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver0:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver0:basemul",
        "//sw/otbn/crypto/mlkem_ver0:cbd",
        "//sw/otbn/crypto/mlkem_ver0:ntt",
        "//sw/otbn/crypto/mlkem_ver0:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver0:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem1024_encap_test_ver0",
    srcs = [
        "mlkem_encap_test.s",
    ],
    copts = ["-DKYBER_K=4"],
    dexp = "mlkem1024_encap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver0:mlkem1024_encap",
        "//sw/otbn/crypto/mlkem_ver0:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver0:mlkem1024_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver0:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver0:basemul",
        "//sw/otbn/crypto/mlkem_ver0:cbd",
        "//sw/otbn/crypto/mlkem_ver0:intt",
        "//sw/otbn/crypto/mlkem_ver0:ntt",
        "//sw/otbn/crypto/mlkem_ver0:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver0:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem1024_decap_test_ver0",
    srcs = [
        "mlkem_decap_test.s",
    ],
    copts = ["-DKYBER_K=4"],
    dexp = "mlkem1024_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver0:mlkem1024_decap",
        "//sw/otbn/crypto/mlkem_ver0:mlkem1024_encap",
        "//sw/otbn/crypto/mlkem_ver0:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver0:mlkem1024_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver0:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver0:basemul",
        "//sw/otbn/crypto/mlkem_ver0:cbd",
        "//sw/otbn/crypto/mlkem_ver0:intt",
        "//sw/otbn/crypto/mlkem_ver0:ntt",
        "//sw/otbn/crypto/mlkem_ver0:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver0:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem1024_false_decap_test_ver0",
    srcs = [
        "mlkem_false_decap_test.s",
    ],
    copts = ["-DKYBER_K=4"],
    dexp = "mlkem1024_false_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver0:mlkem1024_decap",
        "//sw/otbn/crypto/mlkem_ver0:mlkem1024_encap",
        "//sw/otbn/crypto/mlkem_ver0:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver0:mlkem1024_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver0:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver0:basemul",
        "//sw/otbn/crypto/mlkem_ver0:cbd",
        "//sw/otbn/crypto/mlkem_ver0:intt",
        "//sw/otbn/crypto/mlkem_ver0:ntt",
        "//sw/otbn/crypto/mlkem_ver0:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver0:kmac_send_msg",
    ],
)

# Refactor ML-KEM VER1 without lazy reduction

otbn_sim_test(
    name = "mlkem512_keypair_test_ver1_nold",
    srcs = [
        "mlkem_keypair_test.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=1",
    ],
    dexp = "mlkem512_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem512_keypair",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver1_nold:basemul",
        "//sw/otbn/crypto/mlkem_ver1_nold:cbd",
        "//sw/otbn/crypto/mlkem_ver1_nold:ntt",
        "//sw/otbn/crypto/mlkem_ver1_nold:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem512_encap_test_ver1_nold",
    srcs = [
        "mlkem_encap_test.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=1",
    ],
    dexp = "mlkem512_encap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem512_encap",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem512_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver1_nold:basemul",
        "//sw/otbn/crypto/mlkem_ver1_nold:cbd",
        "//sw/otbn/crypto/mlkem_ver1_nold:intt",
        "//sw/otbn/crypto/mlkem_ver1_nold:ntt",
        "//sw/otbn/crypto/mlkem_ver1_nold:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem512_decap_test_ver1_nold",
    srcs = [
        "mlkem_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=1",
    ],
    dexp = "mlkem512_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem512_decap",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem512_encap",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem512_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver1_nold:basemul",
        "//sw/otbn/crypto/mlkem_ver1_nold:cbd",
        "//sw/otbn/crypto/mlkem_ver1_nold:intt",
        "//sw/otbn/crypto/mlkem_ver1_nold:ntt",
        "//sw/otbn/crypto/mlkem_ver1_nold:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem512_false_decap_test_ver1_nold",
    srcs = [
        "mlkem_false_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=1",
    ],
    dexp = "mlkem512_false_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem512_decap",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem512_encap",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem512_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver1_nold:basemul",
        "//sw/otbn/crypto/mlkem_ver1_nold:cbd",
        "//sw/otbn/crypto/mlkem_ver1_nold:intt",
        "//sw/otbn/crypto/mlkem_ver1_nold:ntt",
        "//sw/otbn/crypto/mlkem_ver1_nold:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem768_keypair_test_ver1_nold",
    srcs = [
        "mlkem_keypair_test.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=1",
    ],
    dexp = "mlkem768_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem768_keypair",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver1_nold:basemul",
        "//sw/otbn/crypto/mlkem_ver1_nold:cbd",
        "//sw/otbn/crypto/mlkem_ver1_nold:ntt",
        "//sw/otbn/crypto/mlkem_ver1_nold:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem768_encap_test_ver1_nold",
    srcs = [
        "mlkem_encap_test.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=1",
    ],
    dexp = "mlkem768_encap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem768_encap",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem768_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver1_nold:basemul",
        "//sw/otbn/crypto/mlkem_ver1_nold:cbd",
        "//sw/otbn/crypto/mlkem_ver1_nold:intt",
        "//sw/otbn/crypto/mlkem_ver1_nold:ntt",
        "//sw/otbn/crypto/mlkem_ver1_nold:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem768_decap_test_ver1_nold",
    srcs = [
        "mlkem_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=1",
    ],
    dexp = "mlkem768_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem768_decap",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem768_encap",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem768_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver1_nold:basemul",
        "//sw/otbn/crypto/mlkem_ver1_nold:cbd",
        "//sw/otbn/crypto/mlkem_ver1_nold:intt",
        "//sw/otbn/crypto/mlkem_ver1_nold:ntt",
        "//sw/otbn/crypto/mlkem_ver1_nold:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem768_false_decap_test_ver1_nold",
    srcs = [
        "mlkem_false_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=1",
    ],
    dexp = "mlkem768_false_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem768_decap",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem768_encap",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem768_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver1_nold:basemul",
        "//sw/otbn/crypto/mlkem_ver1_nold:cbd",
        "//sw/otbn/crypto/mlkem_ver1_nold:intt",
        "//sw/otbn/crypto/mlkem_ver1_nold:ntt",
        "//sw/otbn/crypto/mlkem_ver1_nold:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem1024_keypair_test_ver1_nold",
    srcs = [
        "mlkem_keypair_test.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=1",
    ],
    dexp = "mlkem1024_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem1024_keypair",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver1_nold:basemul",
        "//sw/otbn/crypto/mlkem_ver1_nold:cbd",
        "//sw/otbn/crypto/mlkem_ver1_nold:ntt",
        "//sw/otbn/crypto/mlkem_ver1_nold:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem1024_encap_test_ver1_nold",
    srcs = [
        "mlkem_encap_test.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=1",
    ],
    dexp = "mlkem1024_encap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem1024_encap",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem1024_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver1_nold:basemul",
        "//sw/otbn/crypto/mlkem_ver1_nold:cbd",
        "//sw/otbn/crypto/mlkem_ver1_nold:intt",
        "//sw/otbn/crypto/mlkem_ver1_nold:ntt",
        "//sw/otbn/crypto/mlkem_ver1_nold:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem1024_decap_test_ver1_nold",
    srcs = [
        "mlkem_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=1",
    ],
    dexp = "mlkem1024_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem1024_decap",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem1024_encap",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem1024_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver1_nold:basemul",
        "//sw/otbn/crypto/mlkem_ver1_nold:cbd",
        "//sw/otbn/crypto/mlkem_ver1_nold:intt",
        "//sw/otbn/crypto/mlkem_ver1_nold:ntt",
        "//sw/otbn/crypto/mlkem_ver1_nold:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem1024_false_decap_test_ver1_nold",
    srcs = [
        "mlkem_false_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=1",
    ],
    dexp = "mlkem1024_false_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem1024_decap",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem1024_encap",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem1024_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver1_nold:basemul",
        "//sw/otbn/crypto/mlkem_ver1_nold:cbd",
        "//sw/otbn/crypto/mlkem_ver1_nold:intt",
        "//sw/otbn/crypto/mlkem_ver1_nold:ntt",
        "//sw/otbn/crypto/mlkem_ver1_nold:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1_nold:kmac_send_msg",
    ],
)

# Refactor ML-KEM VER1

otbn_sim_test(
    name = "mlkem512_keypair_test_ver1",
    srcs = [
        "mlkem_keypair_test.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=1",
    ],
    dexp = "mlkem512_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver1:mlkem512_keypair",
        "//sw/otbn/crypto/mlkem_ver1:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver1:basemul",
        "//sw/otbn/crypto/mlkem_ver1:cbd",
        "//sw/otbn/crypto/mlkem_ver1:ntt",
        "//sw/otbn/crypto/mlkem_ver1:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem512_encap_test_ver1",
    srcs = [
        "mlkem_encap_test.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=1",
    ],
    dexp = "mlkem512_encap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver1:mlkem512_encap",
        "//sw/otbn/crypto/mlkem_ver1:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1:mlkem512_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver1:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver1:basemul",
        "//sw/otbn/crypto/mlkem_ver1:cbd",
        "//sw/otbn/crypto/mlkem_ver1:intt",
        "//sw/otbn/crypto/mlkem_ver1:ntt",
        "//sw/otbn/crypto/mlkem_ver1:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem512_decap_test_ver1",
    srcs = [
        "mlkem_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=1",
    ],
    dexp = "mlkem512_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver1:mlkem512_decap",
        "//sw/otbn/crypto/mlkem_ver1:mlkem512_encap",
        "//sw/otbn/crypto/mlkem_ver1:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1:mlkem512_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver1:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver1:basemul",
        "//sw/otbn/crypto/mlkem_ver1:cbd",
        "//sw/otbn/crypto/mlkem_ver1:intt",
        "//sw/otbn/crypto/mlkem_ver1:ntt",
        "//sw/otbn/crypto/mlkem_ver1:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem512_false_decap_test_ver1",
    srcs = [
        "mlkem_false_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=1",
    ],
    dexp = "mlkem512_false_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver1:mlkem512_decap",
        "//sw/otbn/crypto/mlkem_ver1:mlkem512_encap",
        "//sw/otbn/crypto/mlkem_ver1:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1:mlkem512_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver1:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver1:basemul",
        "//sw/otbn/crypto/mlkem_ver1:cbd",
        "//sw/otbn/crypto/mlkem_ver1:intt",
        "//sw/otbn/crypto/mlkem_ver1:ntt",
        "//sw/otbn/crypto/mlkem_ver1:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem768_keypair_test_ver1",
    srcs = [
        "mlkem_keypair_test.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=1",
    ],
    dexp = "mlkem768_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver1:mlkem768_keypair",
        "//sw/otbn/crypto/mlkem_ver1:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver1:basemul",
        "//sw/otbn/crypto/mlkem_ver1:cbd",
        "//sw/otbn/crypto/mlkem_ver1:ntt",
        "//sw/otbn/crypto/mlkem_ver1:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem768_encap_test_ver1",
    srcs = [
        "mlkem_encap_test.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=1",
    ],
    dexp = "mlkem768_encap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver1:mlkem768_encap",
        "//sw/otbn/crypto/mlkem_ver1:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1:mlkem768_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver1:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver1:basemul",
        "//sw/otbn/crypto/mlkem_ver1:cbd",
        "//sw/otbn/crypto/mlkem_ver1:intt",
        "//sw/otbn/crypto/mlkem_ver1:ntt",
        "//sw/otbn/crypto/mlkem_ver1:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem768_decap_test_ver1",
    srcs = [
        "mlkem_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=1",
    ],
    dexp = "mlkem768_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver1:mlkem768_decap",
        "//sw/otbn/crypto/mlkem_ver1:mlkem768_encap",
        "//sw/otbn/crypto/mlkem_ver1:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1:mlkem768_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver1:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver1:basemul",
        "//sw/otbn/crypto/mlkem_ver1:cbd",
        "//sw/otbn/crypto/mlkem_ver1:intt",
        "//sw/otbn/crypto/mlkem_ver1:ntt",
        "//sw/otbn/crypto/mlkem_ver1:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem768_false_decap_test_ver1",
    srcs = [
        "mlkem_false_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=1",
    ],
    dexp = "mlkem768_false_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver1:mlkem768_decap",
        "//sw/otbn/crypto/mlkem_ver1:mlkem768_encap",
        "//sw/otbn/crypto/mlkem_ver1:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1:mlkem768_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver1:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver1:basemul",
        "//sw/otbn/crypto/mlkem_ver1:cbd",
        "//sw/otbn/crypto/mlkem_ver1:intt",
        "//sw/otbn/crypto/mlkem_ver1:ntt",
        "//sw/otbn/crypto/mlkem_ver1:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem1024_keypair_test_ver1",
    srcs = [
        "mlkem_keypair_test.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=1",
    ],
    dexp = "mlkem1024_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver1:mlkem1024_keypair",
        "//sw/otbn/crypto/mlkem_ver1:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver1:basemul",
        "//sw/otbn/crypto/mlkem_ver1:cbd",
        "//sw/otbn/crypto/mlkem_ver1:ntt",
        "//sw/otbn/crypto/mlkem_ver1:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem1024_encap_test_ver1",
    srcs = [
        "mlkem_encap_test.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=1",
    ],
    dexp = "mlkem1024_encap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver1:mlkem1024_encap",
        "//sw/otbn/crypto/mlkem_ver1:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1:mlkem1024_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver1:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver1:basemul",
        "//sw/otbn/crypto/mlkem_ver1:cbd",
        "//sw/otbn/crypto/mlkem_ver1:intt",
        "//sw/otbn/crypto/mlkem_ver1:ntt",
        "//sw/otbn/crypto/mlkem_ver1:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem1024_decap_test_ver1",
    srcs = [
        "mlkem_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=1",
    ],
    dexp = "mlkem1024_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver1:mlkem1024_decap",
        "//sw/otbn/crypto/mlkem_ver1:mlkem1024_encap",
        "//sw/otbn/crypto/mlkem_ver1:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1:mlkem1024_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver1:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver1:basemul",
        "//sw/otbn/crypto/mlkem_ver1:cbd",
        "//sw/otbn/crypto/mlkem_ver1:intt",
        "//sw/otbn/crypto/mlkem_ver1:ntt",
        "//sw/otbn/crypto/mlkem_ver1:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem1024_false_decap_test_ver1",
    srcs = [
        "mlkem_false_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=1",
    ],
    dexp = "mlkem1024_false_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver1:mlkem1024_decap",
        "//sw/otbn/crypto/mlkem_ver1:mlkem1024_encap",
        "//sw/otbn/crypto/mlkem_ver1:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1:mlkem1024_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver1:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver1:basemul",
        "//sw/otbn/crypto/mlkem_ver1:cbd",
        "//sw/otbn/crypto/mlkem_ver1:intt",
        "//sw/otbn/crypto/mlkem_ver1:ntt",
        "//sw/otbn/crypto/mlkem_ver1:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1:kmac_send_msg",
    ],
)

# Refactor ML-KEM VER2 without lazy reduction

otbn_sim_test(
    name = "mlkem512_keypair_test_ver2_nold",
    srcs = [
        "mlkem_keypair_test.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=2",
    ],
    dexp = "mlkem512_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem512_keypair",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver2_nold:basemul",
        "//sw/otbn/crypto/mlkem_ver2_nold:cbd",
        "//sw/otbn/crypto/mlkem_ver2_nold:ntt",
        "//sw/otbn/crypto/mlkem_ver2_nold:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem512_encap_test_ver2_nold",
    srcs = [
        "mlkem_encap_test.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=2",
    ],
    dexp = "mlkem512_encap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem512_encap",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem512_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver2_nold:basemul",
        "//sw/otbn/crypto/mlkem_ver2_nold:cbd",
        "//sw/otbn/crypto/mlkem_ver2_nold:intt",
        "//sw/otbn/crypto/mlkem_ver2_nold:ntt",
        "//sw/otbn/crypto/mlkem_ver2_nold:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem512_decap_test_ver2_nold",
    srcs = [
        "mlkem_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=2",
    ],
    dexp = "mlkem512_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem512_decap",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem512_encap",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem512_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver2_nold:basemul",
        "//sw/otbn/crypto/mlkem_ver2_nold:cbd",
        "//sw/otbn/crypto/mlkem_ver2_nold:intt",
        "//sw/otbn/crypto/mlkem_ver2_nold:ntt",
        "//sw/otbn/crypto/mlkem_ver2_nold:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem512_false_decap_test_ver2_nold",
    srcs = [
        "mlkem_false_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=2",
    ],
    dexp = "mlkem512_false_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem512_decap",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem512_encap",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem512_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver2_nold:basemul",
        "//sw/otbn/crypto/mlkem_ver2_nold:cbd",
        "//sw/otbn/crypto/mlkem_ver2_nold:intt",
        "//sw/otbn/crypto/mlkem_ver2_nold:ntt",
        "//sw/otbn/crypto/mlkem_ver2_nold:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem768_keypair_test_ver2_nold",
    srcs = [
        "mlkem_keypair_test.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=2",
    ],
    dexp = "mlkem768_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem768_keypair",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver2_nold:basemul",
        "//sw/otbn/crypto/mlkem_ver2_nold:cbd",
        "//sw/otbn/crypto/mlkem_ver2_nold:ntt",
        "//sw/otbn/crypto/mlkem_ver2_nold:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem768_encap_test_ver2_nold",
    srcs = [
        "mlkem_encap_test.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=2",
    ],
    dexp = "mlkem768_encap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem768_encap",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem768_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver2_nold:basemul",
        "//sw/otbn/crypto/mlkem_ver2_nold:cbd",
        "//sw/otbn/crypto/mlkem_ver2_nold:intt",
        "//sw/otbn/crypto/mlkem_ver2_nold:ntt",
        "//sw/otbn/crypto/mlkem_ver2_nold:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem768_decap_test_ver2_nold",
    srcs = [
        "mlkem_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=2",
    ],
    dexp = "mlkem768_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem768_decap",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem768_encap",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem768_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver2_nold:basemul",
        "//sw/otbn/crypto/mlkem_ver2_nold:cbd",
        "//sw/otbn/crypto/mlkem_ver2_nold:intt",
        "//sw/otbn/crypto/mlkem_ver2_nold:ntt",
        "//sw/otbn/crypto/mlkem_ver2_nold:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem768_false_decap_test_ver2_nold",
    srcs = [
        "mlkem_false_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=2",
    ],
    dexp = "mlkem768_false_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem768_decap",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem768_encap",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem768_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver2_nold:basemul",
        "//sw/otbn/crypto/mlkem_ver2_nold:cbd",
        "//sw/otbn/crypto/mlkem_ver2_nold:intt",
        "//sw/otbn/crypto/mlkem_ver2_nold:ntt",
        "//sw/otbn/crypto/mlkem_ver2_nold:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem1024_keypair_test_ver2_nold",
    srcs = [
        "mlkem_keypair_test.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=2",
    ],
    dexp = "mlkem1024_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem1024_keypair",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver2_nold:basemul",
        "//sw/otbn/crypto/mlkem_ver2_nold:cbd",
        "//sw/otbn/crypto/mlkem_ver2_nold:ntt",
        "//sw/otbn/crypto/mlkem_ver2_nold:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem1024_encap_test_ver2_nold",
    srcs = [
        "mlkem_encap_test.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=2",
    ],
    dexp = "mlkem1024_encap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem1024_encap",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem1024_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver2_nold:basemul",
        "//sw/otbn/crypto/mlkem_ver2_nold:cbd",
        "//sw/otbn/crypto/mlkem_ver2_nold:intt",
        "//sw/otbn/crypto/mlkem_ver2_nold:ntt",
        "//sw/otbn/crypto/mlkem_ver2_nold:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem1024_decap_test_ver2_nold",
    srcs = [
        "mlkem_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=2",
    ],
    dexp = "mlkem1024_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem1024_decap",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem1024_encap",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem1024_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver2_nold:basemul",
        "//sw/otbn/crypto/mlkem_ver2_nold:cbd",
        "//sw/otbn/crypto/mlkem_ver2_nold:intt",
        "//sw/otbn/crypto/mlkem_ver2_nold:ntt",
        "//sw/otbn/crypto/mlkem_ver2_nold:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2_nold:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem1024_false_decap_test_ver2_nold",
    srcs = [
        "mlkem_false_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=2",
    ],
    dexp = "mlkem1024_false_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem1024_decap",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem1024_encap",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem1024_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver2_nold:basemul",
        "//sw/otbn/crypto/mlkem_ver2_nold:cbd",
        "//sw/otbn/crypto/mlkem_ver2_nold:intt",
        "//sw/otbn/crypto/mlkem_ver2_nold:ntt",
        "//sw/otbn/crypto/mlkem_ver2_nold:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2_nold:kmac_send_msg",
    ],
)

# Refactor ML-KEM VER2

otbn_sim_test(
    name = "mlkem512_keypair_test_ver2",
    srcs = [
        "mlkem_keypair_test.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=2",
    ],
    dexp = "mlkem512_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver2:mlkem512_keypair",
        "//sw/otbn/crypto/mlkem_ver2:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver2:basemul",
        "//sw/otbn/crypto/mlkem_ver2:cbd",
        "//sw/otbn/crypto/mlkem_ver2:ntt",
        "//sw/otbn/crypto/mlkem_ver2:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem512_encap_test_ver2",
    srcs = [
        "mlkem_encap_test.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=2",
    ],
    dexp = "mlkem512_encap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver2:mlkem512_encap",
        "//sw/otbn/crypto/mlkem_ver2:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2:mlkem512_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver2:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver2:basemul",
        "//sw/otbn/crypto/mlkem_ver2:cbd",
        "//sw/otbn/crypto/mlkem_ver2:intt",
        "//sw/otbn/crypto/mlkem_ver2:ntt",
        "//sw/otbn/crypto/mlkem_ver2:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem512_decap_test_ver2",
    srcs = [
        "mlkem_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=2",
    ],
    dexp = "mlkem512_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver2:mlkem512_decap",
        "//sw/otbn/crypto/mlkem_ver2:mlkem512_encap",
        "//sw/otbn/crypto/mlkem_ver2:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2:mlkem512_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver2:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver2:basemul",
        "//sw/otbn/crypto/mlkem_ver2:cbd",
        "//sw/otbn/crypto/mlkem_ver2:intt",
        "//sw/otbn/crypto/mlkem_ver2:ntt",
        "//sw/otbn/crypto/mlkem_ver2:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem512_false_decap_test_ver2",
    srcs = [
        "mlkem_false_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=2",
    ],
    dexp = "mlkem512_false_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver2:mlkem512_decap",
        "//sw/otbn/crypto/mlkem_ver2:mlkem512_encap",
        "//sw/otbn/crypto/mlkem_ver2:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2:mlkem512_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver2:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver2:basemul",
        "//sw/otbn/crypto/mlkem_ver2:cbd",
        "//sw/otbn/crypto/mlkem_ver2:intt",
        "//sw/otbn/crypto/mlkem_ver2:ntt",
        "//sw/otbn/crypto/mlkem_ver2:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem768_keypair_test_ver2",
    srcs = [
        "mlkem_keypair_test.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=2",
    ],
    dexp = "mlkem768_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver2:mlkem768_keypair",
        "//sw/otbn/crypto/mlkem_ver2:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver2:basemul",
        "//sw/otbn/crypto/mlkem_ver2:cbd",
        "//sw/otbn/crypto/mlkem_ver2:ntt",
        "//sw/otbn/crypto/mlkem_ver2:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem768_encap_test_ver2",
    srcs = [
        "mlkem_encap_test.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=2",
    ],
    dexp = "mlkem768_encap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver2:mlkem768_encap",
        "//sw/otbn/crypto/mlkem_ver2:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2:mlkem768_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver2:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver2:basemul",
        "//sw/otbn/crypto/mlkem_ver2:cbd",
        "//sw/otbn/crypto/mlkem_ver2:intt",
        "//sw/otbn/crypto/mlkem_ver2:ntt",
        "//sw/otbn/crypto/mlkem_ver2:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem768_decap_test_ver2",
    srcs = [
        "mlkem_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=2",
    ],
    dexp = "mlkem768_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver2:mlkem768_decap",
        "//sw/otbn/crypto/mlkem_ver2:mlkem768_encap",
        "//sw/otbn/crypto/mlkem_ver2:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2:mlkem768_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver2:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver2:basemul",
        "//sw/otbn/crypto/mlkem_ver2:cbd",
        "//sw/otbn/crypto/mlkem_ver2:intt",
        "//sw/otbn/crypto/mlkem_ver2:ntt",
        "//sw/otbn/crypto/mlkem_ver2:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem768_false_decap_test_ver2",
    srcs = [
        "mlkem_false_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=2",
    ],
    dexp = "mlkem768_false_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver2:mlkem768_decap",
        "//sw/otbn/crypto/mlkem_ver2:mlkem768_encap",
        "//sw/otbn/crypto/mlkem_ver2:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2:mlkem768_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver2:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver2:basemul",
        "//sw/otbn/crypto/mlkem_ver2:cbd",
        "//sw/otbn/crypto/mlkem_ver2:intt",
        "//sw/otbn/crypto/mlkem_ver2:ntt",
        "//sw/otbn/crypto/mlkem_ver2:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem1024_keypair_test_ver2",
    srcs = [
        "mlkem_keypair_test.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=2",
    ],
    dexp = "mlkem1024_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver2:mlkem1024_keypair",
        "//sw/otbn/crypto/mlkem_ver2:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver2:basemul",
        "//sw/otbn/crypto/mlkem_ver2:cbd",
        "//sw/otbn/crypto/mlkem_ver2:ntt",
        "//sw/otbn/crypto/mlkem_ver2:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem1024_encap_test_ver2",
    srcs = [
        "mlkem_encap_test.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=2",
    ],
    dexp = "mlkem1024_encap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver2:mlkem1024_encap",
        "//sw/otbn/crypto/mlkem_ver2:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2:mlkem1024_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver2:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver2:basemul",
        "//sw/otbn/crypto/mlkem_ver2:cbd",
        "//sw/otbn/crypto/mlkem_ver2:intt",
        "//sw/otbn/crypto/mlkem_ver2:ntt",
        "//sw/otbn/crypto/mlkem_ver2:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem1024_decap_test_ver2",
    srcs = [
        "mlkem_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=2",
    ],
    dexp = "mlkem1024_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver2:mlkem1024_decap",
        "//sw/otbn/crypto/mlkem_ver2:mlkem1024_encap",
        "//sw/otbn/crypto/mlkem_ver2:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2:mlkem1024_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver2:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver2:basemul",
        "//sw/otbn/crypto/mlkem_ver2:cbd",
        "//sw/otbn/crypto/mlkem_ver2:intt",
        "//sw/otbn/crypto/mlkem_ver2:ntt",
        "//sw/otbn/crypto/mlkem_ver2:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem1024_false_decap_test_ver2",
    srcs = [
        "mlkem_false_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=2",
    ],
    dexp = "mlkem1024_false_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver2:mlkem1024_decap",
        "//sw/otbn/crypto/mlkem_ver2:mlkem1024_encap",
        "//sw/otbn/crypto/mlkem_ver2:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2:mlkem1024_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver2:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver2:basemul",
        "//sw/otbn/crypto/mlkem_ver2:cbd",
        "//sw/otbn/crypto/mlkem_ver2:intt",
        "//sw/otbn/crypto/mlkem_ver2:ntt",
        "//sw/otbn/crypto/mlkem_ver2:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2:kmac_send_msg",
    ],
)

# Refactor ML-KEM VER3

otbn_sim_test(
    name = "mlkem512_keypair_test_ver3",
    srcs = [
        "mlkem_keypair_test.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=3",
    ],
    dexp = "mlkem512_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver3:mlkem512_keypair",
        "//sw/otbn/crypto/mlkem_ver3:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver3:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver3:basemul",
        "//sw/otbn/crypto/mlkem_ver3:cbd",
        "//sw/otbn/crypto/mlkem_ver3:ntt",
        "//sw/otbn/crypto/mlkem_ver3:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver3:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem512_encap_test_ver3",
    srcs = [
        "mlkem_encap_test.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=3",
    ],
    dexp = "mlkem512_encap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver3:mlkem512_encap",
        "//sw/otbn/crypto/mlkem_ver3:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver3:mlkem512_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver3:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver3:basemul",
        "//sw/otbn/crypto/mlkem_ver3:cbd",
        "//sw/otbn/crypto/mlkem_ver3:intt",
        "//sw/otbn/crypto/mlkem_ver3:ntt",
        "//sw/otbn/crypto/mlkem_ver3:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver3:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem512_decap_test_ver3",
    srcs = [
        "mlkem_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=3",
    ],
    dexp = "mlkem512_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver3:mlkem512_decap",
        "//sw/otbn/crypto/mlkem_ver3:mlkem512_encap",
        "//sw/otbn/crypto/mlkem_ver3:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver3:mlkem512_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver3:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver3:basemul",
        "//sw/otbn/crypto/mlkem_ver3:cbd",
        "//sw/otbn/crypto/mlkem_ver3:intt",
        "//sw/otbn/crypto/mlkem_ver3:ntt",
        "//sw/otbn/crypto/mlkem_ver3:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver3:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem512_false_decap_test_ver3",
    srcs = [
        "mlkem_false_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=3",
    ],
    dexp = "mlkem512_false_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver3:mlkem512_decap",
        "//sw/otbn/crypto/mlkem_ver3:mlkem512_encap",
        "//sw/otbn/crypto/mlkem_ver3:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver3:mlkem512_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver3:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver3:basemul",
        "//sw/otbn/crypto/mlkem_ver3:cbd",
        "//sw/otbn/crypto/mlkem_ver3:intt",
        "//sw/otbn/crypto/mlkem_ver3:ntt",
        "//sw/otbn/crypto/mlkem_ver3:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver3:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem768_keypair_test_ver3",
    srcs = [
        "mlkem_keypair_test.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=3",
    ],
    dexp = "mlkem768_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver3:mlkem768_keypair",
        "//sw/otbn/crypto/mlkem_ver3:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver3:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver3:basemul",
        "//sw/otbn/crypto/mlkem_ver3:cbd",
        "//sw/otbn/crypto/mlkem_ver3:ntt",
        "//sw/otbn/crypto/mlkem_ver3:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver3:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem768_encap_test_ver3",
    srcs = [
        "mlkem_encap_test.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=3",
    ],
    dexp = "mlkem768_encap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver3:mlkem768_encap",
        "//sw/otbn/crypto/mlkem_ver3:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver3:mlkem768_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver3:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver3:basemul",
        "//sw/otbn/crypto/mlkem_ver3:cbd",
        "//sw/otbn/crypto/mlkem_ver3:intt",
        "//sw/otbn/crypto/mlkem_ver3:ntt",
        "//sw/otbn/crypto/mlkem_ver3:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver3:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem768_decap_test_ver3",
    srcs = [
        "mlkem_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=3",
    ],
    dexp = "mlkem768_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver3:mlkem768_decap",
        "//sw/otbn/crypto/mlkem_ver3:mlkem768_encap",
        "//sw/otbn/crypto/mlkem_ver3:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver3:mlkem768_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver3:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver3:basemul",
        "//sw/otbn/crypto/mlkem_ver3:cbd",
        "//sw/otbn/crypto/mlkem_ver3:intt",
        "//sw/otbn/crypto/mlkem_ver3:ntt",
        "//sw/otbn/crypto/mlkem_ver3:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver3:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem768_false_decap_test_ver3",
    srcs = [
        "mlkem_false_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=3",
    ],
    dexp = "mlkem768_false_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver3:mlkem768_decap",
        "//sw/otbn/crypto/mlkem_ver3:mlkem768_encap",
        "//sw/otbn/crypto/mlkem_ver3:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver3:mlkem768_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver3:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver3:basemul",
        "//sw/otbn/crypto/mlkem_ver3:cbd",
        "//sw/otbn/crypto/mlkem_ver3:intt",
        "//sw/otbn/crypto/mlkem_ver3:ntt",
        "//sw/otbn/crypto/mlkem_ver3:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver3:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem1024_keypair_test_ver3",
    srcs = [
        "mlkem_keypair_test.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=3",
    ],
    dexp = "mlkem1024_keypair_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver3:mlkem1024_keypair",
        "//sw/otbn/crypto/mlkem_ver3:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver3:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver3:basemul",
        "//sw/otbn/crypto/mlkem_ver3:cbd",
        "//sw/otbn/crypto/mlkem_ver3:ntt",
        "//sw/otbn/crypto/mlkem_ver3:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver3:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem1024_encap_test_ver3",
    srcs = [
        "mlkem_encap_test.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=3",
    ],
    dexp = "mlkem1024_encap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver3:mlkem1024_encap",
        "//sw/otbn/crypto/mlkem_ver3:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver3:mlkem1024_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver3:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver3:basemul",
        "//sw/otbn/crypto/mlkem_ver3:cbd",
        "//sw/otbn/crypto/mlkem_ver3:intt",
        "//sw/otbn/crypto/mlkem_ver3:ntt",
        "//sw/otbn/crypto/mlkem_ver3:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver3:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem1024_decap_test_ver3",
    srcs = [
        "mlkem_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=3",
    ],
    dexp = "mlkem1024_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver3:mlkem1024_decap",
        "//sw/otbn/crypto/mlkem_ver3:mlkem1024_encap",
        "//sw/otbn/crypto/mlkem_ver3:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver3:mlkem1024_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver3:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver3:basemul",
        "//sw/otbn/crypto/mlkem_ver3:cbd",
        "//sw/otbn/crypto/mlkem_ver3:intt",
        "//sw/otbn/crypto/mlkem_ver3:ntt",
        "//sw/otbn/crypto/mlkem_ver3:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver3:kmac_send_msg",
    ],
)

otbn_sim_test(
    name = "mlkem1024_false_decap_test_ver3",
    srcs = [
        "mlkem_false_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=3",
    ],
    dexp = "mlkem1024_false_decap_test.dexp",
    deps = [
        "//sw/otbn/crypto/mlkem_ver3:mlkem1024_decap",
        "//sw/otbn/crypto/mlkem_ver3:mlkem1024_encap",
        "//sw/otbn/crypto/mlkem_ver3:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver3:mlkem1024_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver3:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver3:basemul",
        "//sw/otbn/crypto/mlkem_ver3:cbd",
        "//sw/otbn/crypto/mlkem_ver3:intt",
        "//sw/otbn/crypto/mlkem_ver3:ntt",
        "//sw/otbn/crypto/mlkem_ver3:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver3:kmac_send_msg",
    ],
)

# Binaries for Verilator tests VER0

otbn_binary(
    name = "otbn_mlkem512_keypair_test_ver0",
    srcs = [
        "mlkem_keypair_test.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=0",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem:kyber512_mlkem",
        "//sw/otbn/crypto/mlkem:kyber512_packing",
        "//sw/otbn/crypto/mlkem:kyber512_poly",
        "//sw/otbn/crypto/mlkem:kyber_basemul",
        "//sw/otbn/crypto/mlkem:kyber_cbd_isaext",
        "//sw/otbn/crypto/mlkem:kyber_intt",
        "//sw/otbn/crypto/mlkem:kyber_ntt",
        "//sw/otbn/crypto/mlkem:kyber_poly_gen_matrix",
    ],
)

otbn_binary(
    name = "otbn_mlkem512_encap_test_ver0",
    srcs = [
        "mlkem_encap_test.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=0",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem:kyber512_mlkem",
        "//sw/otbn/crypto/mlkem:kyber512_packing",
        "//sw/otbn/crypto/mlkem:kyber512_poly",
        "//sw/otbn/crypto/mlkem:kyber_basemul",
        "//sw/otbn/crypto/mlkem:kyber_cbd_isaext",
        "//sw/otbn/crypto/mlkem:kyber_intt",
        "//sw/otbn/crypto/mlkem:kyber_ntt",
        "//sw/otbn/crypto/mlkem:kyber_poly_gen_matrix",
    ],
)

otbn_binary(
    name = "otbn_mlkem512_decap_test_ver0",
    srcs = [
        "mlkem_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=0",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem:kyber512_mlkem",
        "//sw/otbn/crypto/mlkem:kyber512_packing",
        "//sw/otbn/crypto/mlkem:kyber512_poly",
        "//sw/otbn/crypto/mlkem:kyber_basemul",
        "//sw/otbn/crypto/mlkem:kyber_cbd_isaext",
        "//sw/otbn/crypto/mlkem:kyber_intt",
        "//sw/otbn/crypto/mlkem:kyber_ntt",
        "//sw/otbn/crypto/mlkem:kyber_poly_gen_matrix",
    ],
)

otbn_binary(
    name = "otbn_mlkem768_keypair_test_ver0",
    srcs = [
        "mlkem_keypair_test.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=0",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem:kyber768_mlkem",
        "//sw/otbn/crypto/mlkem:kyber768_packing",
        "//sw/otbn/crypto/mlkem:kyber768_poly",
        "//sw/otbn/crypto/mlkem:kyber_basemul",
        "//sw/otbn/crypto/mlkem:kyber_cbd_isaext",
        "//sw/otbn/crypto/mlkem:kyber_intt",
        "//sw/otbn/crypto/mlkem:kyber_ntt",
        "//sw/otbn/crypto/mlkem:kyber_poly_gen_matrix",
    ],
)

otbn_binary(
    name = "otbn_mlkem768_encap_test_ver0",
    srcs = [
        "mlkem_encap_test.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=0",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem:kyber768_mlkem",
        "//sw/otbn/crypto/mlkem:kyber768_packing",
        "//sw/otbn/crypto/mlkem:kyber768_poly",
        "//sw/otbn/crypto/mlkem:kyber_basemul",
        "//sw/otbn/crypto/mlkem:kyber_cbd_isaext",
        "//sw/otbn/crypto/mlkem:kyber_intt",
        "//sw/otbn/crypto/mlkem:kyber_ntt",
        "//sw/otbn/crypto/mlkem:kyber_poly_gen_matrix",
    ],
)

otbn_binary(
    name = "otbn_mlkem768_decap_test_ver0",
    srcs = [
        "mlkem_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=0",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem:kyber768_mlkem",
        "//sw/otbn/crypto/mlkem:kyber768_packing",
        "//sw/otbn/crypto/mlkem:kyber768_poly",
        "//sw/otbn/crypto/mlkem:kyber_basemul",
        "//sw/otbn/crypto/mlkem:kyber_cbd_isaext",
        "//sw/otbn/crypto/mlkem:kyber_intt",
        "//sw/otbn/crypto/mlkem:kyber_ntt",
        "//sw/otbn/crypto/mlkem:kyber_poly_gen_matrix",
    ],
)

otbn_binary(
    name = "otbn_mlkem1024_keypair_test_ver0",
    srcs = [
        "mlkem_keypair_test.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=0",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem:kyber1024_mlkem",
        "//sw/otbn/crypto/mlkem:kyber1024_packing",
        "//sw/otbn/crypto/mlkem:kyber1024_poly",
        "//sw/otbn/crypto/mlkem:kyber_basemul",
        "//sw/otbn/crypto/mlkem:kyber_cbd_isaext",
        "//sw/otbn/crypto/mlkem:kyber_intt",
        "//sw/otbn/crypto/mlkem:kyber_ntt",
        "//sw/otbn/crypto/mlkem:kyber_poly_gen_matrix",
    ],
)

otbn_binary(
    name = "otbn_mlkem1024_encap_test_ver0",
    srcs = [
        "mlkem_encap_test.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=0",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem:kyber1024_mlkem",
        "//sw/otbn/crypto/mlkem:kyber1024_packing",
        "//sw/otbn/crypto/mlkem:kyber1024_poly",
        "//sw/otbn/crypto/mlkem:kyber_basemul",
        "//sw/otbn/crypto/mlkem:kyber_cbd_isaext",
        "//sw/otbn/crypto/mlkem:kyber_intt",
        "//sw/otbn/crypto/mlkem:kyber_ntt",
        "//sw/otbn/crypto/mlkem:kyber_poly_gen_matrix",
    ],
)

otbn_binary(
    name = "otbn_mlkem1024_decap_test_ver0",
    srcs = [
        "mlkem_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=0",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem:kyber1024_mlkem",
        "//sw/otbn/crypto/mlkem:kyber1024_packing",
        "//sw/otbn/crypto/mlkem:kyber1024_poly",
        "//sw/otbn/crypto/mlkem:kyber_basemul",
        "//sw/otbn/crypto/mlkem:kyber_cbd_isaext",
        "//sw/otbn/crypto/mlkem:kyber_intt",
        "//sw/otbn/crypto/mlkem:kyber_ntt",
        "//sw/otbn/crypto/mlkem:kyber_poly_gen_matrix",
    ],
)

# Binaries for Verilator tests VER1

otbn_binary(
    name = "otbn_mlkem512_keypair_test_ver1",
    srcs = [
        "mlkem_keypair_test.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver1:mlkem512_keypair",
        "//sw/otbn/crypto/mlkem_ver1:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver1:basemul",
        "//sw/otbn/crypto/mlkem_ver1:cbd",
        "//sw/otbn/crypto/mlkem_ver1:ntt",
        "//sw/otbn/crypto/mlkem_ver1:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mlkem512_encap_test_ver1",
    srcs = [
        "mlkem_encap_test.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver1:mlkem512_encap",
        "//sw/otbn/crypto/mlkem_ver1:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1:mlkem512_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver1:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver1:basemul",
        "//sw/otbn/crypto/mlkem_ver1:cbd",
        "//sw/otbn/crypto/mlkem_ver1:intt",
        "//sw/otbn/crypto/mlkem_ver1:ntt",
        "//sw/otbn/crypto/mlkem_ver1:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mlkem512_decap_test_ver1",
    srcs = [
        "mlkem_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver1:mlkem512_decap",
        "//sw/otbn/crypto/mlkem_ver1:mlkem512_encap",
        "//sw/otbn/crypto/mlkem_ver1:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1:mlkem512_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver1:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver1:basemul",
        "//sw/otbn/crypto/mlkem_ver1:cbd",
        "//sw/otbn/crypto/mlkem_ver1:intt",
        "//sw/otbn/crypto/mlkem_ver1:ntt",
        "//sw/otbn/crypto/mlkem_ver1:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mlkem768_keypair_test_ver1",
    srcs = [
        "mlkem_keypair_test.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver1:mlkem768_keypair",
        "//sw/otbn/crypto/mlkem_ver1:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver1:basemul",
        "//sw/otbn/crypto/mlkem_ver1:cbd",
        "//sw/otbn/crypto/mlkem_ver1:ntt",
        "//sw/otbn/crypto/mlkem_ver1:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mlkem768_encap_test_ver1",
    srcs = [
        "mlkem_encap_test.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver1:mlkem768_encap",
        "//sw/otbn/crypto/mlkem_ver1:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1:mlkem768_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver1:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver1:basemul",
        "//sw/otbn/crypto/mlkem_ver1:cbd",
        "//sw/otbn/crypto/mlkem_ver1:intt",
        "//sw/otbn/crypto/mlkem_ver1:ntt",
        "//sw/otbn/crypto/mlkem_ver1:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mlkem768_decap_test_ver1",
    srcs = [
        "mlkem_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver1:mlkem768_decap",
        "//sw/otbn/crypto/mlkem_ver1:mlkem768_encap",
        "//sw/otbn/crypto/mlkem_ver1:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1:mlkem768_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver1:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver1:basemul",
        "//sw/otbn/crypto/mlkem_ver1:cbd",
        "//sw/otbn/crypto/mlkem_ver1:intt",
        "//sw/otbn/crypto/mlkem_ver1:ntt",
        "//sw/otbn/crypto/mlkem_ver1:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mlkem1024_keypair_test_ver1",
    srcs = [
        "mlkem_keypair_test.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver1:mlkem1024_keypair",
        "//sw/otbn/crypto/mlkem_ver1:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver1:basemul",
        "//sw/otbn/crypto/mlkem_ver1:cbd",
        "//sw/otbn/crypto/mlkem_ver1:ntt",
        "//sw/otbn/crypto/mlkem_ver1:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mlkem1024_encap_test_ver1",
    srcs = [
        "mlkem_encap_test.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver1:mlkem1024_encap",
        "//sw/otbn/crypto/mlkem_ver1:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1:mlkem1024_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver1:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver1:basemul",
        "//sw/otbn/crypto/mlkem_ver1:cbd",
        "//sw/otbn/crypto/mlkem_ver1:intt",
        "//sw/otbn/crypto/mlkem_ver1:ntt",
        "//sw/otbn/crypto/mlkem_ver1:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mlkem1024_decap_test_ver1",
    srcs = [
        "mlkem_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver1:mlkem1024_decap",
        "//sw/otbn/crypto/mlkem_ver1:mlkem1024_encap",
        "//sw/otbn/crypto/mlkem_ver1:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1:mlkem1024_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver1:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver1:basemul",
        "//sw/otbn/crypto/mlkem_ver1:cbd",
        "//sw/otbn/crypto/mlkem_ver1:intt",
        "//sw/otbn/crypto/mlkem_ver1:ntt",
        "//sw/otbn/crypto/mlkem_ver1:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1:kmac_send_msg",
    ],
)

# Binaries for Verilator tests VER2

otbn_binary(
    name = "otbn_mlkem512_keypair_test_ver2",
    srcs = [
        "mlkem_keypair_test.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=2",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver2:mlkem512_keypair",
        "//sw/otbn/crypto/mlkem_ver2:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver2:basemul",
        "//sw/otbn/crypto/mlkem_ver2:cbd",
        "//sw/otbn/crypto/mlkem_ver2:ntt",
        "//sw/otbn/crypto/mlkem_ver2:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mlkem512_encap_test_ver2",
    srcs = [
        "mlkem_encap_test.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=2",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver2:mlkem512_encap",
        "//sw/otbn/crypto/mlkem_ver2:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2:mlkem512_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver2:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver2:basemul",
        "//sw/otbn/crypto/mlkem_ver2:cbd",
        "//sw/otbn/crypto/mlkem_ver2:intt",
        "//sw/otbn/crypto/mlkem_ver2:ntt",
        "//sw/otbn/crypto/mlkem_ver2:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mlkem512_decap_test_ver2",
    srcs = [
        "mlkem_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=2",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver2:mlkem512_decap",
        "//sw/otbn/crypto/mlkem_ver2:mlkem512_encap",
        "//sw/otbn/crypto/mlkem_ver2:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2:mlkem512_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver2:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver2:basemul",
        "//sw/otbn/crypto/mlkem_ver2:cbd",
        "//sw/otbn/crypto/mlkem_ver2:intt",
        "//sw/otbn/crypto/mlkem_ver2:ntt",
        "//sw/otbn/crypto/mlkem_ver2:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mlkem768_keypair_test_ver2",
    srcs = [
        "mlkem_keypair_test.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=2",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver2:mlkem768_keypair",
        "//sw/otbn/crypto/mlkem_ver2:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver2:basemul",
        "//sw/otbn/crypto/mlkem_ver2:cbd",
        "//sw/otbn/crypto/mlkem_ver2:ntt",
        "//sw/otbn/crypto/mlkem_ver2:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mlkem768_encap_test_ver2",
    srcs = [
        "mlkem_encap_test.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=2",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver2:mlkem768_encap",
        "//sw/otbn/crypto/mlkem_ver2:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2:mlkem768_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver2:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver2:basemul",
        "//sw/otbn/crypto/mlkem_ver2:cbd",
        "//sw/otbn/crypto/mlkem_ver2:intt",
        "//sw/otbn/crypto/mlkem_ver2:ntt",
        "//sw/otbn/crypto/mlkem_ver2:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mlkem768_decap_test_ver2",
    srcs = [
        "mlkem_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=2",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver2:mlkem768_decap",
        "//sw/otbn/crypto/mlkem_ver2:mlkem768_encap",
        "//sw/otbn/crypto/mlkem_ver2:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2:mlkem768_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver2:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver2:basemul",
        "//sw/otbn/crypto/mlkem_ver2:cbd",
        "//sw/otbn/crypto/mlkem_ver2:intt",
        "//sw/otbn/crypto/mlkem_ver2:ntt",
        "//sw/otbn/crypto/mlkem_ver2:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mlkem1024_keypair_test_ver2",
    srcs = [
        "mlkem_keypair_test.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=2",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver2:mlkem1024_keypair",
        "//sw/otbn/crypto/mlkem_ver2:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver2:basemul",
        "//sw/otbn/crypto/mlkem_ver2:cbd",
        "//sw/otbn/crypto/mlkem_ver2:ntt",
        "//sw/otbn/crypto/mlkem_ver2:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mlkem1024_encap_test_ver2",
    srcs = [
        "mlkem_encap_test.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=2",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver2:mlkem1024_encap",
        "//sw/otbn/crypto/mlkem_ver2:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2:mlkem1024_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver2:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver2:basemul",
        "//sw/otbn/crypto/mlkem_ver2:cbd",
        "//sw/otbn/crypto/mlkem_ver2:intt",
        "//sw/otbn/crypto/mlkem_ver2:ntt",
        "//sw/otbn/crypto/mlkem_ver2:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mlkem1024_decap_test_ver2",
    srcs = [
        "mlkem_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=2",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver2:mlkem1024_decap",
        "//sw/otbn/crypto/mlkem_ver2:mlkem1024_encap",
        "//sw/otbn/crypto/mlkem_ver2:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2:mlkem1024_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver2:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver2:basemul",
        "//sw/otbn/crypto/mlkem_ver2:cbd",
        "//sw/otbn/crypto/mlkem_ver2:intt",
        "//sw/otbn/crypto/mlkem_ver2:ntt",
        "//sw/otbn/crypto/mlkem_ver2:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2:kmac_send_msg",
    ],
)

# Binaries for Verilator tests VER3

otbn_binary(
    name = "otbn_mlkem512_keypair_test_ver3",
    srcs = [
        "mlkem_keypair_test.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=3",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver3:mlkem512_keypair",
        "//sw/otbn/crypto/mlkem_ver3:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver3:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver3:basemul",
        "//sw/otbn/crypto/mlkem_ver3:cbd",
        "//sw/otbn/crypto/mlkem_ver3:ntt",
        "//sw/otbn/crypto/mlkem_ver3:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver3:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mlkem512_encap_test_ver3",
    srcs = [
        "mlkem_encap_test.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=3",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver3:mlkem512_encap",
        "//sw/otbn/crypto/mlkem_ver3:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver3:mlkem512_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver3:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver3:basemul",
        "//sw/otbn/crypto/mlkem_ver3:cbd",
        "//sw/otbn/crypto/mlkem_ver3:intt",
        "//sw/otbn/crypto/mlkem_ver3:ntt",
        "//sw/otbn/crypto/mlkem_ver3:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver3:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mlkem512_decap_test_ver3",
    srcs = [
        "mlkem_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=3",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver3:mlkem512_decap",
        "//sw/otbn/crypto/mlkem_ver3:mlkem512_encap",
        "//sw/otbn/crypto/mlkem_ver3:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver3:mlkem512_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver3:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver3:basemul",
        "//sw/otbn/crypto/mlkem_ver3:cbd",
        "//sw/otbn/crypto/mlkem_ver3:intt",
        "//sw/otbn/crypto/mlkem_ver3:ntt",
        "//sw/otbn/crypto/mlkem_ver3:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver3:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mlkem768_keypair_test_ver3",
    srcs = [
        "mlkem_keypair_test.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=3",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver3:mlkem768_keypair",
        "//sw/otbn/crypto/mlkem_ver3:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver3:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver3:basemul",
        "//sw/otbn/crypto/mlkem_ver3:cbd",
        "//sw/otbn/crypto/mlkem_ver3:ntt",
        "//sw/otbn/crypto/mlkem_ver3:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver3:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mlkem768_encap_test_ver3",
    srcs = [
        "mlkem_encap_test.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=3",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver3:mlkem768_encap",
        "//sw/otbn/crypto/mlkem_ver3:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver3:mlkem768_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver3:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver3:basemul",
        "//sw/otbn/crypto/mlkem_ver3:cbd",
        "//sw/otbn/crypto/mlkem_ver3:intt",
        "//sw/otbn/crypto/mlkem_ver3:ntt",
        "//sw/otbn/crypto/mlkem_ver3:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver3:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mlkem768_decap_test_ver3",
    srcs = [
        "mlkem_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=3",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver3:mlkem768_decap",
        "//sw/otbn/crypto/mlkem_ver3:mlkem768_encap",
        "//sw/otbn/crypto/mlkem_ver3:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver3:mlkem768_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver3:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver3:basemul",
        "//sw/otbn/crypto/mlkem_ver3:cbd",
        "//sw/otbn/crypto/mlkem_ver3:intt",
        "//sw/otbn/crypto/mlkem_ver3:ntt",
        "//sw/otbn/crypto/mlkem_ver3:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver3:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mlkem1024_keypair_test_ver3",
    srcs = [
        "mlkem_keypair_test.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=3",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver3:mlkem1024_keypair",
        "//sw/otbn/crypto/mlkem_ver3:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver3:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver3:basemul",
        "//sw/otbn/crypto/mlkem_ver3:cbd",
        "//sw/otbn/crypto/mlkem_ver3:ntt",
        "//sw/otbn/crypto/mlkem_ver3:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver3:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mlkem1024_encap_test_ver3",
    srcs = [
        "mlkem_encap_test.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=3",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver3:mlkem1024_encap",
        "//sw/otbn/crypto/mlkem_ver3:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver3:mlkem1024_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver3:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver3:basemul",
        "//sw/otbn/crypto/mlkem_ver3:cbd",
        "//sw/otbn/crypto/mlkem_ver3:intt",
        "//sw/otbn/crypto/mlkem_ver3:ntt",
        "//sw/otbn/crypto/mlkem_ver3:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver3:kmac_send_msg",
    ],
)

otbn_binary(
    name = "otbn_mlkem1024_decap_test_ver3",
    srcs = [
        "mlkem_decap_test.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=3",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver3:mlkem1024_decap",
        "//sw/otbn/crypto/mlkem_ver3:mlkem1024_encap",
        "//sw/otbn/crypto/mlkem_ver3:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver3:mlkem1024_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver3:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver3:basemul",
        "//sw/otbn/crypto/mlkem_ver3:cbd",
        "//sw/otbn/crypto/mlkem_ver3:intt",
        "//sw/otbn/crypto/mlkem_ver3:ntt",
        "//sw/otbn/crypto/mlkem_ver3:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver3:kmac_send_msg",
    ],
)

# otbn_sim_py_test VER 0 BASE

otbn_sim_py_test(
    name = "mlkem512_keypair_bench_ver0_base",
    deps = [":mlkem512_keypair_test_ver0_base"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem512_encap_bench_ver0_base",
    deps = [":mlkem512_encap_test_ver0_base"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem512_decap_bench_ver0_base",
    deps = [":mlkem512_decap_test_ver0_base"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem768_keypair_bench_ver0_base",
    deps = [":mlkem768_keypair_test_ver0_base"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem768_encap_bench_ver0_base",
    deps = [":mlkem768_encap_test_ver0_base"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem768_decap_bench_ver0_base",
    deps = [":mlkem768_decap_test_ver0_base"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem1024_keypair_bench_ver0_base",
    deps = [":mlkem1024_keypair_test_ver0_base"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem1024_encap_bench_ver0_base",
    deps = [":mlkem1024_encap_test_ver0_base"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem1024_decap_bench_ver0_base",
    deps = [":mlkem1024_decap_test_ver0_base"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

# otbn_sim_py_test VER 0

otbn_sim_py_test(
    name = "mlkem512_keypair_bench_ver0",
    deps = [":mlkem512_keypair_test_ver0"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem512_encap_bench_ver0",
    deps = [":mlkem512_encap_test_ver0"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem512_decap_bench_ver0",
    deps = [":mlkem512_decap_test_ver0"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem768_keypair_bench_ver0",
    deps = [":mlkem768_keypair_test_ver0"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem768_encap_bench_ver0",
    deps = [":mlkem768_encap_test_ver0"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem768_decap_bench_ver0",
    deps = [":mlkem768_decap_test_ver0"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem1024_keypair_bench_ver0",
    deps = [":mlkem1024_keypair_test_ver0"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem1024_encap_bench_ver0",
    deps = [":mlkem1024_encap_test_ver0"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem1024_decap_bench_ver0",
    deps = [":mlkem1024_decap_test_ver0"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

# otbn_sim_py_test VER 1 without lazy reduction

otbn_sim_py_test(
    name = "mlkem512_keypair_bench_ver1_nold",
    copts = ["--bnmulv_version_id=1"],
    deps = [":mlkem512_keypair_test_ver1_nold"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem512_encap_bench_ver1_nold",
    copts = ["--bnmulv_version_id=1"],
    deps = [":mlkem512_encap_test_ver1_nold"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem512_decap_bench_ver1_nold",
    copts = ["--bnmulv_version_id=1"],
    deps = [":mlkem512_decap_test_ver1_nold"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem768_keypair_bench_ver1_nold",
    copts = ["--bnmulv_version_id=1"],
    deps = [":mlkem768_keypair_test_ver1_nold"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem768_encap_bench_ver1_nold",
    copts = ["--bnmulv_version_id=1"],
    deps = [":mlkem768_encap_test_ver1_nold"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem768_decap_bench_ver1_nold",
    copts = ["--bnmulv_version_id=1"],
    deps = [":mlkem768_decap_test_ver1_nold"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem1024_keypair_bench_ver1_nold",
    copts = ["--bnmulv_version_id=1"],
    deps = [":mlkem1024_keypair_test_ver1_nold"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem1024_encap_bench_ver1_nold",
    copts = ["--bnmulv_version_id=1"],
    deps = [":mlkem1024_encap_test_ver1_nold"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem1024_decap_bench_ver1_nold",
    copts = ["--bnmulv_version_id=1"],
    deps = [":mlkem1024_decap_test_ver1_nold"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

# otbn_sim_py_test VER 1

otbn_sim_py_test(
    name = "mlkem512_keypair_bench_ver1",
    copts = ["--bnmulv_version_id=1"],
    deps = [":mlkem512_keypair_test_ver1"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem512_encap_bench_ver1",
    copts = ["--bnmulv_version_id=1"],
    deps = [":mlkem512_encap_test_ver1"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem512_decap_bench_ver1",
    copts = ["--bnmulv_version_id=1"],
    deps = [":mlkem512_decap_test_ver1"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem768_keypair_bench_ver1",
    copts = ["--bnmulv_version_id=1"],
    deps = [":mlkem768_keypair_test_ver1"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem768_encap_bench_ver1",
    copts = ["--bnmulv_version_id=1"],
    deps = [":mlkem768_encap_test_ver1"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem768_decap_bench_ver1",
    copts = ["--bnmulv_version_id=1"],
    deps = [":mlkem768_decap_test_ver1"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem1024_keypair_bench_ver1",
    copts = ["--bnmulv_version_id=1"],
    deps = [":mlkem1024_keypair_test_ver1"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem1024_encap_bench_ver1",
    copts = ["--bnmulv_version_id=1"],
    deps = [":mlkem1024_encap_test_ver1"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem1024_decap_bench_ver1",
    copts = ["--bnmulv_version_id=1"],
    deps = [":mlkem1024_decap_test_ver1"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

# otbn_sim_py_test VER 2 without lazy reduction

otbn_sim_py_test(
    name = "mlkem512_keypair_bench_ver2_nold",
    copts = ["--bnmulv_version_id=2"],
    deps = [":mlkem512_keypair_test_ver2_nold"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem512_encap_bench_ver2_nold",
    copts = ["--bnmulv_version_id=2"],
    deps = [":mlkem512_encap_test_ver2_nold"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem512_decap_bench_ver2_nold",
    copts = ["--bnmulv_version_id=2"],
    deps = [":mlkem512_decap_test_ver2_nold"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem768_keypair_bench_ver2_nold",
    copts = ["--bnmulv_version_id=2"],
    deps = [":mlkem768_keypair_test_ver2_nold"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem768_encap_bench_ver2_nold",
    copts = ["--bnmulv_version_id=2"],
    deps = [":mlkem768_encap_test_ver2_nold"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem768_decap_bench_ver2_nold",
    copts = ["--bnmulv_version_id=2"],
    deps = [":mlkem768_decap_test_ver2_nold"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem1024_keypair_bench_ver2_nold",
    copts = ["--bnmulv_version_id=2"],
    deps = [":mlkem1024_keypair_test_ver2_nold"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem1024_encap_bench_ver2_nold",
    copts = ["--bnmulv_version_id=2"],
    deps = [":mlkem1024_encap_test_ver2_nold"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem1024_decap_bench_ver2_nold",
    copts = ["--bnmulv_version_id=2"],
    deps = [":mlkem1024_decap_test_ver2_nold"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

# otbn_sim_py_test VER 2

otbn_sim_py_test(
    name = "mlkem512_keypair_bench_ver2",
    copts = ["--bnmulv_version_id=2"],
    deps = [":mlkem512_keypair_test_ver2"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem512_encap_bench_ver2",
    copts = ["--bnmulv_version_id=2"],
    deps = [":mlkem512_encap_test_ver2"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem512_decap_bench_ver2",
    copts = ["--bnmulv_version_id=2"],
    deps = [":mlkem512_decap_test_ver2"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem768_keypair_bench_ver2",
    copts = ["--bnmulv_version_id=2"],
    deps = [":mlkem768_keypair_test_ver2"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem768_encap_bench_ver2",
    copts = ["--bnmulv_version_id=2"],
    deps = [":mlkem768_encap_test_ver2"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem768_decap_bench_ver2",
    copts = ["--bnmulv_version_id=2"],
    deps = [":mlkem768_decap_test_ver2"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem1024_keypair_bench_ver2",
    copts = ["--bnmulv_version_id=2"],
    deps = [":mlkem1024_keypair_test_ver2"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem1024_encap_bench_ver2",
    copts = ["--bnmulv_version_id=2"],
    deps = [":mlkem1024_encap_test_ver2"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem1024_decap_bench_ver2",
    copts = ["--bnmulv_version_id=2"],
    deps = [":mlkem1024_decap_test_ver2"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

# otbn_sim_py_test VER 3

otbn_sim_py_test(
    name = "mlkem512_keypair_bench_ver3",
    copts = ["--bnmulv_version_id=3"],
    deps = [":mlkem512_keypair_test_ver3"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem512_encap_bench_ver3",
    copts = ["--bnmulv_version_id=3"],
    deps = [":mlkem512_encap_test_ver3"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem512_decap_bench_ver3",
    copts = ["--bnmulv_version_id=3"],
    deps = [":mlkem512_decap_test_ver3"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem768_keypair_bench_ver3",
    copts = ["--bnmulv_version_id=3"],
    deps = [":mlkem768_keypair_test_ver3"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem768_encap_bench_ver3",
    copts = ["--bnmulv_version_id=3"],
    deps = [":mlkem768_encap_test_ver3"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem768_decap_bench_ver3",
    copts = ["--bnmulv_version_id=3"],
    deps = [":mlkem768_decap_test_ver3"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem1024_keypair_bench_ver3",
    copts = ["--bnmulv_version_id=3"],
    deps = [":mlkem1024_keypair_test_ver3"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem1024_encap_bench_ver3",
    copts = ["--bnmulv_version_id=3"],
    deps = [":mlkem1024_encap_test_ver3"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

otbn_sim_py_test(
    name = "mlkem1024_decap_bench_ver3",
    copts = ["--bnmulv_version_id=3"],
    deps = [":mlkem1024_decap_test_ver3"],
    sim_test_wrapper = "kyberpy_bench_otbn/run_kyber.py",
)

# ML-KEM code size targets for VER0 BASE

otbn_binary(
    name = "mlkem512_code_size_ver0_base",
    srcs = [
        "mlkem_base_codesize.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=0",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem512_keypair",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem512_encap",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem512_decap",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem512_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver0_base:basemul",
        "//sw/otbn/crypto/mlkem_ver0_base:cbd",
        "//sw/otbn/crypto/mlkem_ver0_base:intt",
        "//sw/otbn/crypto/mlkem_ver0_base:ntt",
        "//sw/otbn/crypto/mlkem_ver0_base:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver0_base:kmac_send_msg",
    ],
)

otbn_binary(
    name = "mlkem768_code_size_ver0_base",
    srcs = [
        "mlkem_base_codesize.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=0",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem768_keypair",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem768_encap",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem768_decap",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem768_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver0_base:basemul",
        "//sw/otbn/crypto/mlkem_ver0_base:cbd",
        "//sw/otbn/crypto/mlkem_ver0_base:intt",
        "//sw/otbn/crypto/mlkem_ver0_base:ntt",
        "//sw/otbn/crypto/mlkem_ver0_base:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver0_base:kmac_send_msg",
    ],
)

otbn_binary(
    name = "mlkem1024_code_size_ver0_base",
    srcs = [
        "mlkem_base_codesize.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=0",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem1024_keypair",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem1024_encap",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem1024_decap",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem1024_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver0_base:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver0_base:basemul",
        "//sw/otbn/crypto/mlkem_ver0_base:cbd",
        "//sw/otbn/crypto/mlkem_ver0_base:intt",
        "//sw/otbn/crypto/mlkem_ver0_base:ntt",
        "//sw/otbn/crypto/mlkem_ver0_base:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver0_base:kmac_send_msg",
    ],
)

# ML-KEM code size targets for VER0

otbn_binary(
    name = "mlkem512_code_size_ver0",
    srcs = [
        "mlkem_codesize.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=0",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver0:mlkem512_keypair",
        "//sw/otbn/crypto/mlkem_ver0:mlkem512_encap",
        "//sw/otbn/crypto/mlkem_ver0:mlkem512_decap",
        "//sw/otbn/crypto/mlkem_ver0:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver0:mlkem512_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver0:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver0:basemul",
        "//sw/otbn/crypto/mlkem_ver0:cbd",
        "//sw/otbn/crypto/mlkem_ver0:intt",
        "//sw/otbn/crypto/mlkem_ver0:ntt",
        "//sw/otbn/crypto/mlkem_ver0:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver0:kmac_send_msg",
    ],
)

otbn_binary(
    name = "mlkem768_code_size_ver0",
    srcs = [
        "mlkem_codesize.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=0",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver0:mlkem768_keypair",
        "//sw/otbn/crypto/mlkem_ver0:mlkem768_encap",
        "//sw/otbn/crypto/mlkem_ver0:mlkem768_decap",
        "//sw/otbn/crypto/mlkem_ver0:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver0:mlkem768_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver0:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver0:basemul",
        "//sw/otbn/crypto/mlkem_ver0:cbd",
        "//sw/otbn/crypto/mlkem_ver0:intt",
        "//sw/otbn/crypto/mlkem_ver0:ntt",
        "//sw/otbn/crypto/mlkem_ver0:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver0:kmac_send_msg",
    ],
)

otbn_binary(
    name = "mlkem1024_code_size_ver0",
    srcs = [
        "mlkem_codesize.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=0",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver0:mlkem1024_keypair",
        "//sw/otbn/crypto/mlkem_ver0:mlkem1024_encap",
        "//sw/otbn/crypto/mlkem_ver0:mlkem1024_decap",
        "//sw/otbn/crypto/mlkem_ver0:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver0:mlkem1024_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver0:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver0:basemul",
        "//sw/otbn/crypto/mlkem_ver0:cbd",
        "//sw/otbn/crypto/mlkem_ver0:intt",
        "//sw/otbn/crypto/mlkem_ver0:ntt",
        "//sw/otbn/crypto/mlkem_ver0:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver0:kmac_send_msg",
    ],
)

# ML-KEM code size targets for VER1 without lazy reduction

otbn_binary(
    name = "mlkem512_code_size_ver1_nold",
    srcs = [
        "mlkem_codesize.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem512_keypair",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem512_encap",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem512_decap",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem512_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver1_nold:basemul",
        "//sw/otbn/crypto/mlkem_ver1_nold:cbd",
        "//sw/otbn/crypto/mlkem_ver1_nold:intt",
        "//sw/otbn/crypto/mlkem_ver1_nold:ntt",
        "//sw/otbn/crypto/mlkem_ver1_nold:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1_nold:kmac_send_msg",
    ],
)

otbn_binary(
    name = "mlkem768_code_size_ver1_nold",
    srcs = [
        "mlkem_codesize.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem768_keypair",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem768_encap",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem768_decap",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem768_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver1_nold:basemul",
        "//sw/otbn/crypto/mlkem_ver1_nold:cbd",
        "//sw/otbn/crypto/mlkem_ver1_nold:intt",
        "//sw/otbn/crypto/mlkem_ver1_nold:ntt",
        "//sw/otbn/crypto/mlkem_ver1_nold:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1_nold:kmac_send_msg",
    ],
)

otbn_binary(
    name = "mlkem1024_code_size_ver1_nold",
    srcs = [
        "mlkem_codesize.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem1024_keypair",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem1024_encap",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem1024_decap",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem1024_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver1_nold:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver1_nold:basemul",
        "//sw/otbn/crypto/mlkem_ver1_nold:cbd",
        "//sw/otbn/crypto/mlkem_ver1_nold:intt",
        "//sw/otbn/crypto/mlkem_ver1_nold:ntt",
        "//sw/otbn/crypto/mlkem_ver1_nold:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1_nold:kmac_send_msg",
    ],
)

# ML-KEM code size targets for VER1

otbn_binary(
    name = "mlkem512_code_size_ver1",
    srcs = [
        "mlkem_codesize.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver1:mlkem512_keypair",
        "//sw/otbn/crypto/mlkem_ver1:mlkem512_encap",
        "//sw/otbn/crypto/mlkem_ver1:mlkem512_decap",
        "//sw/otbn/crypto/mlkem_ver1:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1:mlkem512_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver1:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver1:basemul",
        "//sw/otbn/crypto/mlkem_ver1:cbd",
        "//sw/otbn/crypto/mlkem_ver1:intt",
        "//sw/otbn/crypto/mlkem_ver1:ntt",
        "//sw/otbn/crypto/mlkem_ver1:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1:kmac_send_msg",
    ],
)

otbn_binary(
    name = "mlkem768_code_size_ver1",
    srcs = [
        "mlkem_codesize.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver1:mlkem768_keypair",
        "//sw/otbn/crypto/mlkem_ver1:mlkem768_encap",
        "//sw/otbn/crypto/mlkem_ver1:mlkem768_decap",
        "//sw/otbn/crypto/mlkem_ver1:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1:mlkem768_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver1:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver1:basemul",
        "//sw/otbn/crypto/mlkem_ver1:cbd",
        "//sw/otbn/crypto/mlkem_ver1:intt",
        "//sw/otbn/crypto/mlkem_ver1:ntt",
        "//sw/otbn/crypto/mlkem_ver1:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1:kmac_send_msg",
    ],
)

otbn_binary(
    name = "mlkem1024_code_size_ver1",
    srcs = [
        "mlkem_codesize.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=1",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver1:mlkem1024_keypair",
        "//sw/otbn/crypto/mlkem_ver1:mlkem1024_encap",
        "//sw/otbn/crypto/mlkem_ver1:mlkem1024_decap",
        "//sw/otbn/crypto/mlkem_ver1:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver1:mlkem1024_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver1:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver1:basemul",
        "//sw/otbn/crypto/mlkem_ver1:cbd",
        "//sw/otbn/crypto/mlkem_ver1:intt",
        "//sw/otbn/crypto/mlkem_ver1:ntt",
        "//sw/otbn/crypto/mlkem_ver1:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver1:kmac_send_msg",
    ],
)

# ML-KEM code size targets for VER2 without lazy reduction

otbn_binary(
    name = "mlkem512_code_size_ver2_nold",
    srcs = [
        "mlkem_codesize.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=2",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem512_keypair",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem512_encap",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem512_decap",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem512_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver2_nold:basemul",
        "//sw/otbn/crypto/mlkem_ver2_nold:cbd",
        "//sw/otbn/crypto/mlkem_ver2_nold:intt",
        "//sw/otbn/crypto/mlkem_ver2_nold:ntt",
        "//sw/otbn/crypto/mlkem_ver2_nold:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2_nold:kmac_send_msg",
    ],
)

otbn_binary(
    name = "mlkem768_code_size_ver2_nold",
    srcs = [
        "mlkem_codesize.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=2",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem768_keypair",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem768_encap",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem768_decap",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem768_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver2_nold:basemul",
        "//sw/otbn/crypto/mlkem_ver2_nold:cbd",
        "//sw/otbn/crypto/mlkem_ver2_nold:intt",
        "//sw/otbn/crypto/mlkem_ver2_nold:ntt",
        "//sw/otbn/crypto/mlkem_ver2_nold:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2_nold:kmac_send_msg",
    ],
)

otbn_binary(
    name = "mlkem1024_code_size_ver2_nold",
    srcs = [
        "mlkem_codesize.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=2",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem1024_keypair",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem1024_encap",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem1024_decap",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem1024_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver2_nold:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver2_nold:basemul",
        "//sw/otbn/crypto/mlkem_ver2_nold:cbd",
        "//sw/otbn/crypto/mlkem_ver2_nold:intt",
        "//sw/otbn/crypto/mlkem_ver2_nold:ntt",
        "//sw/otbn/crypto/mlkem_ver2_nold:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2_nold:kmac_send_msg",
    ],
)

# ML-KEM code size targets for VER2

otbn_binary(
    name = "mlkem512_code_size_ver2",
    srcs = [
        "mlkem_codesize.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=2",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver2:mlkem512_keypair",
        "//sw/otbn/crypto/mlkem_ver2:mlkem512_encap",
        "//sw/otbn/crypto/mlkem_ver2:mlkem512_decap",
        "//sw/otbn/crypto/mlkem_ver2:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2:mlkem512_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver2:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver2:basemul",
        "//sw/otbn/crypto/mlkem_ver2:cbd",
        "//sw/otbn/crypto/mlkem_ver2:intt",
        "//sw/otbn/crypto/mlkem_ver2:ntt",
        "//sw/otbn/crypto/mlkem_ver2:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2:kmac_send_msg",
    ],
)

otbn_binary(
    name = "mlkem768_code_size_ver2",
    srcs = [
        "mlkem_codesize.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=2",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver2:mlkem768_keypair",
        "//sw/otbn/crypto/mlkem_ver2:mlkem768_encap",
        "//sw/otbn/crypto/mlkem_ver2:mlkem768_decap",
        "//sw/otbn/crypto/mlkem_ver2:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2:mlkem768_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver2:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver2:basemul",
        "//sw/otbn/crypto/mlkem_ver2:cbd",
        "//sw/otbn/crypto/mlkem_ver2:intt",
        "//sw/otbn/crypto/mlkem_ver2:ntt",
        "//sw/otbn/crypto/mlkem_ver2:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2:kmac_send_msg",
    ],
)

otbn_binary(
    name = "mlkem1024_code_size_ver2",
    srcs = [
        "mlkem_codesize.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=2",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver2:mlkem1024_keypair",
        "//sw/otbn/crypto/mlkem_ver2:mlkem1024_encap",
        "//sw/otbn/crypto/mlkem_ver2:mlkem1024_decap",
        "//sw/otbn/crypto/mlkem_ver2:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver2:mlkem1024_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver2:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver2:basemul",
        "//sw/otbn/crypto/mlkem_ver2:cbd",
        "//sw/otbn/crypto/mlkem_ver2:intt",
        "//sw/otbn/crypto/mlkem_ver2:ntt",
        "//sw/otbn/crypto/mlkem_ver2:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver2:kmac_send_msg",
    ],
)

# ML-KEM code size targets for VER3

otbn_binary(
    name = "mlkem512_code_size_ver3",
    srcs = [
        "mlkem_codesize.s",
    ],
    copts = [
        "-DKYBER_K=2",
        "--bnmulv_version_id=3",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver3:mlkem512_keypair",
        "//sw/otbn/crypto/mlkem_ver3:mlkem512_encap",
        "//sw/otbn/crypto/mlkem_ver3:mlkem512_decap",
        "//sw/otbn/crypto/mlkem_ver3:mlkem512_pack_keys",
        "//sw/otbn/crypto/mlkem_ver3:mlkem512_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver3:mlkem512_poly",
        "//sw/otbn/crypto/mlkem_ver3:basemul",
        "//sw/otbn/crypto/mlkem_ver3:cbd",
        "//sw/otbn/crypto/mlkem_ver3:intt",
        "//sw/otbn/crypto/mlkem_ver3:ntt",
        "//sw/otbn/crypto/mlkem_ver3:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver3:kmac_send_msg",
    ],
)

otbn_binary(
    name = "mlkem768_code_size_ver3",
    srcs = [
        "mlkem_codesize.s",
    ],
    copts = [
        "-DKYBER_K=3",
        "--bnmulv_version_id=3",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver3:mlkem768_keypair",
        "//sw/otbn/crypto/mlkem_ver3:mlkem768_encap",
        "//sw/otbn/crypto/mlkem_ver3:mlkem768_decap",
        "//sw/otbn/crypto/mlkem_ver3:mlkem768_pack_keys",
        "//sw/otbn/crypto/mlkem_ver3:mlkem768_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver3:mlkem768_poly",
        "//sw/otbn/crypto/mlkem_ver3:basemul",
        "//sw/otbn/crypto/mlkem_ver3:cbd",
        "//sw/otbn/crypto/mlkem_ver3:intt",
        "//sw/otbn/crypto/mlkem_ver3:ntt",
        "//sw/otbn/crypto/mlkem_ver3:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver3:kmac_send_msg",
    ],
)

otbn_binary(
    name = "mlkem1024_code_size_ver3",
    srcs = [
        "mlkem_codesize.s",
    ],
    copts = [
        "-DKYBER_K=4",
        "--bnmulv_version_id=3",
    ],
    deps = [
        "//sw/otbn/crypto/mlkem_ver3:mlkem1024_keypair",
        "//sw/otbn/crypto/mlkem_ver3:mlkem1024_encap",
        "//sw/otbn/crypto/mlkem_ver3:mlkem1024_decap",
        "//sw/otbn/crypto/mlkem_ver3:mlkem1024_pack_keys",
        "//sw/otbn/crypto/mlkem_ver3:mlkem1024_pack_ciphertext",
        "//sw/otbn/crypto/mlkem_ver3:mlkem1024_poly",
        "//sw/otbn/crypto/mlkem_ver3:basemul",
        "//sw/otbn/crypto/mlkem_ver3:cbd",
        "//sw/otbn/crypto/mlkem_ver3:intt",
        "//sw/otbn/crypto/mlkem_ver3:ntt",
        "//sw/otbn/crypto/mlkem_ver3:poly_gen_matrix",
        "//sw/otbn/crypto/mlkem_ver3:kmac_send_msg",
    ],
)
