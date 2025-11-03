# Copyright Ruben Niederhagen and Hoang Nguyen Hien Pham - authors of
# "Improving ML-KEM & ML-DSA on OpenTitan - Efficient Multiplication Vector Instructions for OTBN"
# (https://eprint.iacr.org/2025/2028)
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

report_units

set clk clk_i
set clk_name clk_i
set clk_port_name clk_i

# clk unit: ps
set clk_period 4000
set sdc_version 2.0
set non_clk_inputs [all_inputs -no_clocks]

