# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
# Modified by Ruben Niederhagen and Hoang Nguyen Hien Pham - authors of
# "Improving ML-KEM & ML-DSA on OpenTitan - Efficient Multiplication Vector Instructions for OTBN"
# (https://eprint.iacr.org/2025/2028)
# Copyright Ruben Niederhagen and Hoang Nguyen Hien Pham.

load("//rules/opentitan:hw.bzl", "opentitan_ip")

OTBN = opentitan_ip(
    name = "otbn",
    hjson = "//hw/ip/otbn/data:otbn.hjson",
)

SRC_Set = provider(
    doc = "A provider containing source files as input to sv2v.",
    fields = {
        "name": "Name of source file set.",
        "src": "A list of source elements.",
        "defines": "A list of defines."
    },
)

CORE_Set = provider(
    doc = "A provider containing core definitions",
    fields = {
        "name": "Name of core set.",
        "top_module": "Name of the top module.",
        "src": "SRC_set of source elements.",
        "defines": "A list of defines.",
        "start_f": "Starting frequency for Fmax search."
    },
)

