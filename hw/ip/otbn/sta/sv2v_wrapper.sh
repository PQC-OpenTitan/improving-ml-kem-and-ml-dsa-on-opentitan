#!/bin/bash
# Copyright Ruben Niederhagen and Hoang Nguyen Hien Pham - authors of
# "Improving ML-KEM & ML-DSA on OpenTitan - Efficient Multiplication Vector Instructions for OTBN"
# (https://eprint.iacr.org/2025/2028)
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

set -e -x

DEFINES=$1
PKGS=$2
INC_FILES=$3
SRC=$4
OUT_FILE=$5

# Run sv2v
sv2v --define=SYNTHESIS --define=YOSYS \
   $DEFINES $PKGS $INC_FILES $SRC > $OUT_FILE

# Make sure auto-generated primitives are resolved to generic or Xilinx-specific primitives
# where available.
sed -i 's/prim_flop/prim_xilinx_flop/g'              $OUT_FILE
sed -i 's/prim_xilinx_flop_2sync/prim_generic_flop_2sync/g' $OUT_FILE
sed -i 's/prim_sec_anchor_flop/prim_xilinx_flop/g'   $OUT_FILE
sed -i 's/prim_buf/prim_xilinx_buf/g'                $OUT_FILE
sed -i 's/prim_sec_anchor_buf/prim_xilinx_buf/g'     $OUT_FILE
sed -i 's/prim_xor2/prim_xilinx_xor2/g'              $OUT_FILE
sed -i 's/prim_xnor2/prim_xilinx_xnor2/g'            $OUT_FILE
sed -i 's/prim_and2/prim_xilinx_and2/g'              $OUT_FILE
sed -i 's/prim_ram_1p/prim_generic_ram_1p/g'         $OUT_FILE

# Remove calls to $value$plusargs(). Yosys doesn't seem to support this.
sed -i '/$value$plusargs(.*/d' $OUT_FILE

if [ "$OUT_FILE" = "src/prim_sparse_fsm_flop.v" ]; then
  # Rename the prim_sparse_fsm_flop module. For some reason, sv2v decides to append a suffix.
  sed -i 's/module prim_sparse_fsm_flop_.*/module prim_sparse_fsm_flop \(/g' $OUT_FILE
fi

# Rename prim_sparse_fsm_flop instances. For some reason, sv2v decides to append a suffix.
sed -i 's/prim_sparse_fsm_flop_.*/prim_sparse_fsm_flop \#(/g' $OUT_FILE

# Remove the StateEnumT parameter from prim_sparse_fsm_flop instances. Yosys doesn't seem to
# support this.
sed -i '/\.StateEnumT(logic \[.*/d' $OUT_FILE
sed -i '/\.StateEnumT_otbn_pkg.*Width.*(.*/d' $OUT_FILE

