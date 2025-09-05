# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

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

# Define paths to synthesis results, cts and stats.
_TOP_MODULE_RESULTS = "{}_{}_{}_results"

_TOP_MODULE_CTS = "{}_{}_{}_cts"

_TOP_MODULE_STATS = "{}_{}_{}_stats"

_TOP_MODULE_OUTPUT = "$(location :{}_{}_{}_stats)"

_ADDER_RESULTS = "{}_{}_results"

_ADDER_CTS = "{}_{}_cts"

_ADDER_STATS = "{}_{}_stats"

_ADDER_OUTPUT = "$(location :{}_{}_stats)"

# List of PKDs
PDKS = [
    "sky130hd",
    "asap7",
]

# List of top modules to be synthesized.
TOP_MODULES = [
    # "otbn_alu_bignum",
    "otbn_mac_bignum"
]

# List of adders used in the design.
ADDERS = ["buffer_bit", "brent_kung", "sklansky", "kogge_stone"]

# Manually established minimum clock period on sky130hd per adder.
ADDERS_CLOCK_PERIOD = {
  "buffer_bit":  "4.3",
  "brent_kung":  "4.1",
  "sklansky":    "4.0",
  "kogge_stone": "5.1"
}

# List of different versions for our design.
VERSION = {
    "TOWARDS": ["TOWARDS_BASE", "TOWARDS_ADDER", "TOWARDS_MAC"],
    "VER1": ["TOWARDS_BASE", "BNMULV", "BUFFER_BIT"],
    "VER2": ["TOWARDS_BASE", "BNMULV", "BNMULV_ACCH", "BUFFER_BIT"],
    "VER3": ["TOWARDS_BASE", "BNMULV", "BNMULV_ACCH", "BNMULV_COND_SUB", "BUFFER_BIT"],
}

#VERSION = dicts.add({
#    "TOWARDS": ["TOWARDS_ADDER"],
#    "VER1": ["BNMULV", "BUFFER_BIT"],
#    "VER2": ["BNMULV", "BNMULV_ACCH", "BUFFER_BIT"],
#    "VER3": ["BNMULV", "BNMULV_ACCH", "BNMULV_COND_SUB", "BUFFER_BIT"],
#}, {
#    "VER1_" + adder: [
#        "BNMULV",
#        "BUFFER_BIT",
#        "MAC_ADDER=" + adder,
#    ]
#    for adder in ADDERS
#})


filegroup(
  name = "compare_adders",
  srcs = [
    "//hw/ip/otbn:buffer_bit_sky130hd_results",
    "//hw/ip/otbn:brent_kung_sky130hd_results",
    "//hw/ip/otbn:sklansky_sky130hd_results",
    "//hw/ip/otbn:kogge_stone_sky130hd_results",
  ]
)

[
    sv2v_build(
        name = "rtl_sv2v_" + name,
        srcs = glob(["rtl/*.sv", "rtl/bn_vec_core/*.sv"]) + 
        [
            "//hw/ip/tlul:sta_files",
            "//hw/ip/prim:sta_files",
            "//hw/ip/prim_xilinx:sta_files",
            "//hw/ip/prim_generic:sta_files"
        ],
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
        defines = defines,
        outdir = "src/rtl_sv2v_{}".format(name),
    )
    for name, defines in VERSION.items()
]

[
    filegroup(
        name = name + "_files", 
        srcs = [":rtl_sv2v_" + name],
        visibility = ["//visibility:public"],
    )
    for name in VERSION.keys()
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
    "SETUP_SLACK_MARGIN": "0",
    "SETUP_HOLD_MARGIN":  "0",
    "SYNTH_HIERARCHICAL": "1",
    "PLACE_DENSITY": "0.5",
    "CORE_MARGIN": "1",
    "SYNTH_MEMORY_MAX_BITS": "16384",
    # "PL_RESIZER_HOLD_MAX_BUFFER_PCT" : "50",
    # "GRT_RESIZER_HOLD_MAX_BUFFER_PCT": "50",
    # "PL_RESIZER_SETUP_MAX_BUFFER_PCT" : "50",
    # "GRT_RESIZER_SETUP_MAX_BUFFER_PCT": "50",
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
        name = base_name,
        arguments =  FASTER | OTHER_ARGS |
        (
            IO_PLACER_ASAP7 if pdk == "asap7" else IO_PLACER_SKY130HD
        ) |
        {
            "CLOCK_PERIOD": ADDERS_CLOCK_PERIOD[base_name],
        },
        stage_arguments = STAGE_ARGS,
        pdk = "@docker_orfs//:{}".format(pdk),
        sources = {
            "SDC_FILE": ["//hw/ip/otbn/sta:constraints_noclk_{}".format(pdk)],
        },
        variant="{}".format(pdk),
        verilog_files = [":VER1_files"],
    )
    for pdk in PDKS for base_name in ADDERS
]

[
    orfs_flow(
        name = base_name,
        arguments =  FASTER | OTHER_ARGS |
        (
            IO_PLACER_ASAP7 if pdk == "asap7" else IO_PLACER_SKY130HD
        ),
        stage_arguments = STAGE_ARGS,
        pdk = "@docker_orfs//:{}".format(pdk),
        sources = {
            "SDC_FILE": ["//hw/ip/otbn/sta:constraints_{}".format(pdk)],
        },
        variant = "{}_{}".format(name, pdk),
        verilog_files = [":" + name + "_files"],
    )
    for pdk in PDKS for name in VERSION.keys() for base_name in TOP_MODULES
]

[
    orfs_run(
        name = _ADDER_RESULTS.format(base_name, pdk),
        src = _ADDER_CTS.format(base_name, pdk),
        outs = [
            _ADDER_STATS.format(base_name, pdk),
        ],
        arguments = {
            "OUTPUT": _ADDER_OUTPUT.format(base_name, pdk),
        },
        script = "//hw/ip/otbn/sta:results_tcl",
    ) for pdk in PDKS for base_name in ADDERS
]

[
    orfs_run(
        name = _TOP_MODULE_RESULTS.format(base_name, name, pdk),
        src = _TOP_MODULE_CTS.format(base_name, name, pdk),
        outs = [
            _TOP_MODULE_STATS.format(base_name, name, pdk),
        ],
        arguments = {
            "OUTPUT": _TOP_MODULE_OUTPUT.format(base_name, name, pdk),
        },
        script = "//hw/ip/otbn/sta:results_tcl",
    )
    for pdk in PDKS for name in VERSION.keys() for base_name in TOP_MODULES
]

filegroup(
    name = "all_adders",
    srcs = [
        ":" + _ADDER_RESULTS.format(base_name, pdk)
        for pdk in PDKS for base_name in ADDERS
    ],
)

[
    filegroup(
        name = base_name + "_" + name + "_" + pdk + "_all_results",
        srcs = [
            ":" + _TOP_MODULE_RESULTS.format(base_name, name, pdk)
        ],
    )
    for pdk in PDKS for name in VERSION.keys() for base_name in TOP_MODULES
]

filegroup(
    name = "all_results",
    srcs = [
        ":" + _TOP_MODULE_RESULTS.format(base_name, name, pdk)
        for pdk in PDKS for name in VERSION.keys() for base_name in TOP_MODULES
    ],
)
