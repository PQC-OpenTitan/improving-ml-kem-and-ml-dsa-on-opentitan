# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
# Modified by Ruben Niederhagen and Hoang Nguyen Hien Pham - authors of
# "Improving ML-KEM & ML-DSA on OpenTitan - Efficient Multiplication Vector Instructions for OTBN"
# (https://eprint.iacr.org/2025/2028)
# Copyright Ruben Niederhagen and Hoang Nguyen Hien Pham.

load("@bazel-orfs//:openroad.bzl", "orfs_flow", "orfs_run")
load("@bazel-orfs//:ppa.bzl", "orfs_ppa")
load("@bazel_skylib//lib:dicts.bzl", "dicts")
load("//rules:sv2v.bzl", "sv2v_build")

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
        "//hw/ip/otbn/data:all_files",
    ],
)

filegroup(
    name = "doc_files",
    srcs = glob([
        "**/*.md",
        "**/*.svg",
    ]) + [
        "//hw/ip/otbn/dv/otbnsim:doc_files",
    ],
)

# List of PKDs
PDKS = [
    "sky130hd",
#    "asap7",     # Add asap7 here if neeed.
]

# List of top modules to be synthesized.
TOP_MODULES = [
    "otbn",
    "otbn_alu_bignum",
    "otbn_mac_bignum"
]

MULTIPLIERS = [
   ("otbn_bignum_mul", [None]),
   ("otbn_mul", [None]),
   ("unified_mul", [None, ["WALLACE"]])
]

ADDERS = [
   ("ref_add", [None]),
   ("towards_alu_adder", [None]),
   ("towards_mac_adder", [None]),
   ("buffer_bit", [None]),
   ("brent_kung", [None]),
   ("brent_kung_256", [None]),
   ("sklansky", [None]),
   ("sklansky_256", [None]),
   ("kogge_stone", [None]),
   ("kogge_stone_256", [None]),
]

ARITH = MULTIPLIERS + ADDERS

# List of different versions for our design.
VARIANT = [
  (None,      ["SYNTHESIS_MEMORY_BLACK_BOXING"]),
  ("KMAC",    ["KMAC", "SYNTHESIS_MEMORY_BLACK_BOXING"]),
  ("TOWARDS", ["TOWARDS_BASE", "TOWARDS_ADDER", "TOWARDS_MAC", "SYNTHESIS_MEMORY_BLACK_BOXING"]),
  ("VER1",    ["TOWARDS_BASE", "BNMULV", "BUFFER_BIT", "SYNTHESIS_MEMORY_BLACK_BOXING"]),
  ("VER2",    ["TOWARDS_BASE", "BNMULV", "BNMULV_ACCH", "BUFFER_BIT", "SYNTHESIS_MEMORY_BLACK_BOXING"]),
  ("VER3",    ["TOWARDS_BASE", "BNMULV", "BNMULV_ACCH", "BNMULV_COND_SUB", "BUFFER_BIT", "SYNTHESIS_MEMORY_BLACK_BOXING"]),
]

load(":defs.bzl", "SRC_Set", "CORE_Set")

ARITH_CORES = [
  CORE_Set(
    top_module = top_module,
    name = "_".join([top_module] + defines) if defines else top_module,
    src = SRC_Set(
      name = "_".join([top_module] + defines) if defines else top_module,
      src = ["rtl/bn_vec_core/{}.sv".format(top_module) if top_module != "otbn_mul" else "rtl/{}.sv".format(top_module),
             "//hw/ip/tlul:sta_files",
             "//hw/ip/prim:sta_files",
             "//hw/ip/prim_xilinx:sta_files",
             "//hw/ip/prim_generic:sta_files"
            ],
      defines = defines
    ),
    start_f = 10.0
  )
  for top_module, variants in ARITH for defines in variants
]

OTBN_CORES = [
  CORE_Set(
    top_module = top_module,
    name = "_".join([top_module, variant]) if variant else top_module,
    src = SRC_Set(
      name = "_".join([top_module, variant]) if variant else top_module,
      src = glob(["rtl/*.sv", "rtl/bn_vec_core/*.sv"]) +
                 [
                     "//hw/ip/tlul:sta_files",
                     "//hw/ip/prim:sta_files",
                     "//hw/ip/prim_xilinx:sta_files",
                     "//hw/ip/prim_generic:sta_files"
                 ],
      defines = defines
    ),
    start_f = 10.0
  )
  for top_module in TOP_MODULES for variant, defines in VARIANT
]


CORES = ARITH_CORES + OTBN_CORES

SRCS = list({core.src.name: core.src for core in CORES}.values())


[
    sv2v_build(
        name = "srcs_" + src.name,
        srcs = src.src,
        pkgs = [
            "//hw/top_earlgrey:rtl_files",
            "//hw/ip/edn:rtl_files",
            "//hw/ip/csrng:rtl_files",
            "//hw/ip/entropy_src:rtl_files",
            "//hw/ip/lc_ctrl:rtl_files",
            "//hw/ip/tlul:rtl_files",
            "//hw/ip/prim:rtl_files",
            "//hw/ip/prim_generic:rtl_files",
            "//hw/ip/keymgr:rtl_files",
            "//hw/ip/kmac:rtl_files",
            "//hw/ip/otp_ctrl:rtl_files",
            "//hw/ip/otbn:rtl_files"
        ],
        includes = ["//hw/ip/prim:rtl_files"],
        defines = src.defines,
        outdir = "src/rtl_sv2v_{}".format(src.name),
    )
    for src in SRCS
]

[
    filegroup(
        name = src.name + "_files",
        srcs = [":srcs_" + src.name],
        visibility = ["//visibility:public"],
    )
    for src in SRCS
]


FASTER = {
    # ignore timing repair for now
    "SKIP_REPORT_METRICS": "1",
    "SKIP_LAST_GASP": "1",
    "GPL_ROUTABILITY_DRIVEN": "0",
    "GPL_TIMING_DRIVEN": "0",
    # skip checks for now, faster
    "PWR_NETS_VOLTAGES": "",
    "GND_NETS_VOLTAGES": "",
    "TNS_END_PERCENT": "0",
}

OTHER_ARGS = {
    #"SETUP_SLACK_MARGIN":  "0.05",
    #"HOLD_SLACK_MARGIN":   "0.05",
    "SYNTH_HIERARCHICAL": "1",
    "PLACE_DENSITY": "0.5",
    "CORE_MARGIN": "1",
    "SYNTH_MEMORY_MAX_BITS": "16384",
    #"PL_RESIZER_HOLD_MAX_BUFFER_PCT" : "10",
    #"GRT_RESIZER_HOLD_MAX_BUFFER_PCT": "15",
    #"PL_RESIZER_SETUP_MAX_BUFFER_PCT" : "30",
    #"GRT_RESIZER_SETUP_MAX_BUFFER_PCT": "35",
}

IO_PLACER_ASAP7 = {
    "IO_PLACER_H": "M2 M4",
    "IO_PLACER_V": "M3 M5",
}

IO_PLACER_SKY130HD = {
    "IO_PLACER_H": "met3 met5",
    "IO_PLACER_V": "met2 met4",
}

STAGE_ARGS = {
    "floorplan": {
        # Decrease if not sufficient space for pins
        "CORE_UTILIZATION": "40",
    },
}

[
    orfs_flow(
        name = core.top_module,
        arguments =  FASTER | OTHER_ARGS |
        (
            IO_PLACER_ASAP7 if pdk == "asap7" else IO_PLACER_SKY130HD
        ),
        stage_arguments = STAGE_ARGS,
        pdk = "@docker_orfs//:{}".format(pdk),
        sources = {
            "SDC_FILE": ["//hw/ip/otbn/sta:constraints_{}".format(pdk)],
        },
        variant="_".join([core.name] + [pdk]).replace(core.top_module + "_", ""),
        verilog_files = [core.src.name + "_files"]
    )
    for pdk in PDKS for core in CORES
]

[
    orfs_run(
        name = "{}_{}_results".format(core.name, pdk),
        src = "{}_{}_cts".format(core.name, pdk),
        outs = [
            "{}_{}_stats".format(core.name, pdk),
            "{}_{}_reports".format(core.name, pdk),
            "{}_{}_fsearch".format(core.name, pdk),
        ],
        arguments = {
            "OUTPUT": "$(location :{}_{}_stats)".format(core.name, pdk),
            "REPORTS": "$(location :{}_{}_reports)".format(core.name, pdk),
            "FSEARCH": "$(location :{}_{}_fsearch)".format(core.name, pdk),
            "STARTF": "{}".format(core.start_f),
        },
        script = "//hw/ip/otbn/sta:openroad_combined_tcl",
    )
    for pdk in PDKS for core in CORES
]


filegroup(
    name = "all_adders",
    srcs = [
        ":" + "{}_{}_results".format("_".join([top_module] + defines) if defines else top_module, pdk)
        for pdk in PDKS for top_module, variants in ADDERS for defines in variants
    ],
)

filegroup(
    name = "all_multipliers",
    srcs = [
        ":" + "{}_{}_results".format("_".join([top_module] + defines) if defines else top_module, pdk)
        for pdk in PDKS for top_module, variants in MULTIPLIERS for defines in variants
    ],
)

filegroup(
    name = "all_otbn",
    srcs = [
        ":" + "{}_{}_results".format("_".join(["otbn", variant]) if variant else "otbn", pdk)
        for pdk in PDKS for variant, defines in VARIANT
    ],
)

filegroup(
    name = "all_otbn_sub",
    srcs = [
        ":" + "{}_{}_results".format("_".join([sub, variant]) if variant else sub, pdk)
        for pdk in PDKS for variant, defines in VARIANT for sub in ["otbn_mac_bignum", "otbn_alu_bignum"]
    ],
)

filegroup(
    name = "all",
    srcs = ["all_adders", "all_multipliers", "all_otbn_sub", "all_otbn"]
)

