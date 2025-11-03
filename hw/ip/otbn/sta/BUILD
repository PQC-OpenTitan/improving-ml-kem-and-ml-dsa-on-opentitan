# Copyright Ruben Niederhagen and Hoang Nguyen Hien Pham - authors of
# "Improving ML-KEM & ML-DSA on OpenTitan - Efficient Multiplication Vector Instructions for OTBN"
# (https://eprint.iacr.org/2025/2028)
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

package(default_visibility = ["//visibility:public"])

sh_binary(
    name = "sv2v_wrapper",
    srcs = ["sv2v_wrapper.sh"],
)

filegroup(
    name = "constraints_asap7",
    srcs = ["constraints_asap7.sdc"],
)

filegroup(
    name = "constraints_sky130hd",
    srcs = ["constraints_sky130hd.sdc"],
)

genrule(
    name = "openroad_combined_tcl",
    srcs = [
        ":openroad.tcl",
        ":rounding.tcl",
        ":timing.tcl"
    ],
    outs = ["openroad_combined.tcl"],
    cmd  = "cat $(location rounding.tcl) $(location timing.tcl) $(location openroad.tcl) > $@",
    visibility = ["//visibility:public"],
)
