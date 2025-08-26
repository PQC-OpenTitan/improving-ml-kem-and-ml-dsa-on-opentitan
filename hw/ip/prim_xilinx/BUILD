# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "rtl_files",
    srcs = glob(
        ["**"],
        exclude = [
            "dv/**",
            "doc/**",
            "README.md",
        ],
    ) + [
    ],
)

filegroup(
    name = "sta_files",
    srcs = [
      "rtl/prim_flop.sv",
      "rtl/prim_flop_en.sv",
      "rtl/prim_buf.sv",
      "rtl/prim_xor2.sv",
      "rtl/prim_xnor2.sv",
      "rtl/prim_and2.sv"
    ],
)
