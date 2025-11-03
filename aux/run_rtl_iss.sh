# Copyright Ruben Niederhagen and Hoang Nguyen Hien Pham - authors of
# "Improving ML-KEM & ML-DSA on OpenTitan - Efficient Multiplication Vector Instructions for OTBN"
# (https://eprint.iacr.org/2025/2028)
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

hw/ip/otbn/dv/smoke/run_rtl_iss_test.py -ver 1
hw/ip/otbn/dv/smoke/run_rtl_iss_test.py -ver 1 -m brent_kung -a brent_kung
hw/ip/otbn/dv/smoke/run_rtl_iss_test.py -ver 1 -m sklansky -a sklansky
hw/ip/otbn/dv/smoke/run_rtl_iss_test.py -ver 1 -m kogge_stone -a kogge_stone
hw/ip/otbn/dv/smoke/run_rtl_iss_test.py -ver 1 -m csa_carry4 -a csa_carry4

hw/ip/otbn/dv/smoke/run_rtl_iss_test.py -ver 2
hw/ip/otbn/dv/smoke/run_rtl_iss_test.py -ver 2 -m brent_kung -a brent_kung
hw/ip/otbn/dv/smoke/run_rtl_iss_test.py -ver 2 -m sklansky -a sklansky
hw/ip/otbn/dv/smoke/run_rtl_iss_test.py -ver 2 -m kogge_stone -a kogge_stone
hw/ip/otbn/dv/smoke/run_rtl_iss_test.py -ver 2 -m csa_carry4 -a csa_carry4

hw/ip/otbn/dv/smoke/run_rtl_iss_test.py -ver 3
hw/ip/otbn/dv/smoke/run_rtl_iss_test.py -ver 3 -m brent_kung -a brent_kung
hw/ip/otbn/dv/smoke/run_rtl_iss_test.py -ver 3 -m sklansky -a sklansky
hw/ip/otbn/dv/smoke/run_rtl_iss_test.py -ver 3 -m kogge_stone -a kogge_stone
hw/ip/otbn/dv/smoke/run_rtl_iss_test.py -ver 3 -m csa_carry4 -a csa_carry4

hw/ip/otbn/dv/smoke/run_rtl_iss_test.py -ver 0