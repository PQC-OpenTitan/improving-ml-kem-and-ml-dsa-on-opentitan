# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
# Modified by Ruben Niederhagen and Hoang Nguyen Hien Pham - authors of
# "Improving ML-KEM & ML-DSA on OpenTitan - Efficient Multiplication Vector Instructions for OTBN"
# (https://eprint.iacr.org/2025/2028)
# Copyright Ruben Niederhagen and Hoang Nguyen Hien Pham.

load("//rules:otbn.bzl", "otbn_binary")

package(default_visibility = ["//visibility:public"])

otbn_binary(
    name = "smoke_test",
    srcs = [
        "smoke_test.s",
    ],
    args = [
        "--defsym",
        "deterministic=1",
    ],
)

otbn_binary(
    name = "smoke_test_ver0",
    srcs = [
        "smoke_test.s",
    ],
    copts = ["--bnmulv_version_id=0"],
)

otbn_binary(
    name = "smoke_test_ver1",
    srcs = [
        "smoke_test.s",
    ],
    copts = ["--bnmulv_version_id=1"],
)

otbn_binary(
    name = "smoke_test_ver2",
    srcs = [
        "smoke_test.s",
    ],
    copts = ["--bnmulv_version_id=2"],
)

otbn_binary(
    name = "smoke_test_ver3",
    srcs = [
        "smoke_test.s",
    ],
    copts = ["--bnmulv_version_id=3"],
)
