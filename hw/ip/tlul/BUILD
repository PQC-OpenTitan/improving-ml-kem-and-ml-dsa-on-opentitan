# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
# Modified by Ruben Niederhagen and Hoang Nguyen Hien Pham - authors of
# "Improving ML-KEM & ML-DSA on OpenTitan - Efficient Multiplication Vector Instructions for OTBN"
# (https://eprint.iacr.org/2025/2028)
# Copyright Ruben Niederhagen and Hoang Nguyen Hien Pham.

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
        "//hw/ip/tlul/data:all_files",
    ],
)

filegroup(
    name = "doc_files",
    srcs = glob([
        "**/*.md",
        "**/*.svg",
    ]) + ["//hw/ip/tlul/data:tlul_testplan.hjson"],
)

filegroup(
    name = "sta_files",
    srcs = [
      "rtl/tlul_adapter_reg.sv",
      "rtl/tlul_err.sv",
      "rtl/tlul_cmd_intg_chk.sv",
      "rtl/tlul_rsp_intg_gen.sv",
      "rtl/tlul_data_integ_dec.sv",
      "rtl/tlul_data_integ_enc.sv",
      "rtl/tlul_adapter_sram.sv",
      "rtl/tlul_sram_byte.sv",
      "rtl/tlul_socket_1n.sv",
      "rtl/tlul_err_resp.sv",
      "rtl/tlul_fifo_sync.sv"
    ]
)
