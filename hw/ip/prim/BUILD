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
    ),
)

filegroup(
    name = "verilator_files",
    srcs = glob(["dv/**"]) + [
        ":rtl_files",
    ],
)

filegroup(
    name = "doc_files",
    srcs = glob(["**/*.md"]),
)

filegroup(
    name = "sta_files",
    srcs = [
        "rtl/prim_secded_inv_64_57_dec.sv",
        "rtl/prim_secded_inv_64_57_enc.sv",
        "rtl/prim_secded_inv_39_32_dec.sv",
        "rtl/prim_secded_inv_39_32_enc.sv",
        "rtl/prim_sparse_fsm_flop.sv",
        "rtl/prim_subreg.sv",
        "rtl/prim_subreg_ext.sv",
        "rtl/prim_subreg_shadow.sv",
        "rtl/prim_subreg_arb.sv",
        "rtl/prim_alert_sender.sv",
        "rtl/prim_diff_decode.sv",
        "rtl/prim_lc_sync.sv",
        "rtl/prim_sync_reqack_data.sv",
        "rtl/prim_sync_reqack.sv",
        "rtl/prim_packer_fifo.sv",
        "rtl/prim_lfsr.sv",
        "rtl/prim_cdc_rand_delay.sv",
        "rtl/prim_reg_we_check.sv",
        "rtl/prim_onehot_check.sv",
        "rtl/prim_mubi4_sender.sv",
        "rtl/prim_fifo_sync_cnt.sv",
        "rtl/prim_intr_hw.sv",
        "rtl/prim_edn_req.sv",
        "rtl/prim_fifo_sync.sv",
        "rtl/prim_arbiter_fixed.sv",
        "rtl/prim_packer.sv",
        "rtl/prim_count.sv",
        "rtl/prim_double_lfsr.sv",
        "rtl/prim_onehot_mux.sv",
        "rtl/prim_onehot_enc.sv",
        "rtl/prim_blanker.sv",
        "rtl/prim_crc32.sv",
        "rtl/prim_xoshiro256pp.sv",
        "rtl/prim_ram_1p_scr.sv",
        "rtl/prim_ram_1p_adv.sv",
        "rtl/prim_subst_perm.sv",
        "rtl/prim_prince.sv"
    ]
)
