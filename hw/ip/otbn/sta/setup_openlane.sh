#!/bin/bash

# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Setup script for synthesizing OTBN with OpenLane V2, which can be found at
# https://github.com/efabless/openlane2.
# This script assumes that the readers successfully installed OpenLane V2
# using Nix, following the instructions at 
# https://openlane2.readthedocs.io/en/latest/getting_started/newcomers/index.html.

set -e
set -o pipefail

error () {
    echo >&2 "$@"
    exit 1
}

#-------------------------------------------------------------------------
# Use sv2v to convert all SystemVerilog files to Verilog.
# Workflow copied from syn_yosys.sh.
#-------------------------------------------------------------------------
#export SV2V_IP_NAME=otbn
#export SV2V_TOP_MODULE=otbn_core

# Setup output directory.
if [ $# -eq 2 ]; then
    export SV2V_SRC_DIR=$1
    export SV2V_OUT_DIR=$2
#elif [ $# -eq 0 ]; then
#    export SV2V_OUT_DIR_PREFIX="sv2v_out/$SV2V_TOP_MODULE"
#    export SV2V_OUT_DIR
else
    echo "Usage: $0 [otbn_src_dir] [sv2v_out_dir]"
    exit 1
fi

# Use sv2v to generate Verilog files from SystemVerilog source files.
# Copy the workflow from syn_yosys.sh.

# Get OpenTitan dependency sources.
OT_DEP_SOURCES=(
    "$SV2V_SRC_DIR"/../tlul/rtl/tlul_adapter_reg.sv
    "$SV2V_SRC_DIR"/../tlul/rtl/tlul_err.sv
    "$SV2V_SRC_DIR"/../tlul/rtl/tlul_cmd_intg_chk.sv
    "$SV2V_SRC_DIR"/../tlul/rtl/tlul_rsp_intg_gen.sv
    "$SV2V_SRC_DIR"/../tlul/rtl/tlul_data_integ_dec.sv
    "$SV2V_SRC_DIR"/../tlul/rtl/tlul_data_integ_enc.sv
    "$SV2V_SRC_DIR"/../tlul/rtl/tlul_adapter_sram.sv
    "$SV2V_SRC_DIR"/../tlul/rtl/tlul_sram_byte.sv
    "$SV2V_SRC_DIR"/../tlul/rtl/tlul_socket_1n.sv
    "$SV2V_SRC_DIR"/../tlul/rtl/tlul_err_resp.sv
    "$SV2V_SRC_DIR"/../tlul/rtl/tlul_fifo_sync.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_secded_inv_64_57_dec.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_secded_inv_64_57_enc.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_secded_inv_39_32_dec.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_secded_inv_39_32_enc.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_sparse_fsm_flop.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_subreg.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_subreg_ext.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_subreg_shadow.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_subreg_arb.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_alert_sender.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_diff_decode.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_lc_sync.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_sync_reqack_data.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_sync_reqack.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_packer_fifo.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_lfsr.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_cdc_rand_delay.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_reg_we_check.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_onehot_check.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_mubi4_sender.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_fifo_sync_cnt.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_intr_hw.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_edn_req.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_fifo_sync.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_arbiter_fixed.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_packer.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_count.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_double_lfsr.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_onehot_mux.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_onehot_enc.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_blanker.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_crc32.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_xoshiro256pp.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_ram_1p_scr.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_ram_1p_adv.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_subst_perm.sv
    "$SV2V_SRC_DIR"/../prim/rtl/prim_prince.sv
    "$SV2V_SRC_DIR"/../prim_generic/rtl/prim_flop.sv
    "$SV2V_SRC_DIR"/../prim_generic/rtl/prim_flop_2sync.sv
    "$SV2V_SRC_DIR"/../prim_generic/rtl/prim_ram_1p.sv
    "$SV2V_SRC_DIR"/../prim_xilinx/rtl/prim_flop.sv
    "$SV2V_SRC_DIR"/../prim_xilinx/rtl/prim_flop_en.sv
    "$SV2V_SRC_DIR"/../prim_xilinx/rtl/prim_buf.sv
    "$SV2V_SRC_DIR"/../prim_xilinx/rtl/prim_xor2.sv
    "$SV2V_SRC_DIR"/../prim_xilinx/rtl/prim_xnor2.sv
    "$SV2V_SRC_DIR"/../prim_xilinx/rtl/prim_and2.sv
)

# Get OpenTitan dependency packages.
OT_DEP_PACKAGES=(
    "$SV2V_SRC_DIR"/../../top_earlgrey/rtl/top_pkg.sv
    "$SV2V_SRC_DIR"/../edn/rtl/*_pkg.sv
    "$SV2V_SRC_DIR"/../csrng/rtl/*_pkg.sv
    "$SV2V_SRC_DIR"/../entropy_src/rtl/*_pkg.sv
    "$SV2V_SRC_DIR"/../lc_ctrl/rtl/*_pkg.sv
    "$SV2V_SRC_DIR"/../tlul/rtl/*_pkg.sv
    "$SV2V_SRC_DIR"/../prim/rtl/*_pkg.sv
    "$SV2V_SRC_DIR"/../prim_generic/rtl/*_pkg.sv
    "$SV2V_SRC_DIR"/../keymgr/rtl/*_pkg.sv
    "$SV2V_SRC_DIR"/../kmac/rtl/*_pkg.sv
    "$SV2V_SRC_DIR"/../otp_ctrl/rtl/*_pkg.sv
)

set -x

# Convert OpenTitan dependency sources.
for file in "${OT_DEP_SOURCES[@]}"; do
    module=`basename -s .sv $file`

#    # Skip packages
#    if echo "$module" | grep -q '_pkg$'; then
#        continue
#    fi

    sv2v \
        --define=SYNTHESIS --define=SYNTHESIS_MEMORY_BLACK_BOXING --define=YOSYS \
        "${OT_DEP_PACKAGES[@]}" \
        -I"$SV2V_SRC_DIR"/../prim/rtl \
        $file \
        > $SV2V_OUT_DIR/${module}.v

    # Make sure auto-generated primitives are resolved to generic or Xilinx-specific primitives
    # where available.
    sed -i 's/prim_flop/prim_xilinx_flop/g'              $SV2V_OUT_DIR/${module}.v
    sed -i 's/prim_xilinx_flop_2sync/prim_generic_flop_2sync/g' \
        $SV2V_OUT_DIR/${module}.v
    sed -i 's/prim_sec_anchor_flop/prim_xilinx_flop/g'   $SV2V_OUT_DIR/${module}.v
    sed -i 's/prim_buf/prim_xilinx_buf/g'                $SV2V_OUT_DIR/${module}.v
    sed -i 's/prim_sec_anchor_buf/prim_xilinx_buf/g'     $SV2V_OUT_DIR/${module}.v
    sed -i 's/prim_xor2/prim_xilinx_xor2/g'              $SV2V_OUT_DIR/${module}.v
    sed -i 's/prim_xnor2/prim_xilinx_xnor2/g'            $SV2V_OUT_DIR/${module}.v
    sed -i 's/prim_and2/prim_xilinx_and2/g'              $SV2V_OUT_DIR/${module}.v
    sed -i 's/prim_ram_1p/prim_generic_ram_1p/g'         $SV2V_OUT_DIR/${module}.v

    # Remove calls to $value$plusargs(). Yosys doesn't seem to support this.
    sed -i '/$value$plusargs(.*/d' $SV2V_OUT_DIR/${module}.v

    if [ "$file" = "prim_sparse_fsm_flop.v" ]; then
      # Rename the prim_sparse_fsm_flop module. For some reason, sv2v decides to append a suffix.
      sed -i 's/module prim_sparse_fsm_flop_.*/module prim_sparse_fsm_flop \(/g' \
          $SV2V_OUT_DIR/prim_sparse_fsm_flop.v
    fi
done

# Get and convert core sources.
find "$SV2V_SRC_DIR"/ -type f -name "*.sv" -print0 | while IFS= read -r -d '' file; do
    module=`basename -s .sv $file`

    # Skip packages
    if echo "$module" | grep -q '_pkg$'; then
        continue
    fi

    sv2v \
        --define=SYNTHESIS \
        --define=BUFFER_BIT \
        "${OT_DEP_PACKAGES[@]}" \
        "$SV2V_SRC_DIR"/rtl/*_pkg.sv \
        -I"$SV2V_SRC_DIR"/../prim/rtl \
        $file \
        > $SV2V_OUT_DIR/${module}.v

    # Make sure auto-generated primitives are resolved to generic or Xilinx-specific primitives
    # where available.
    sed -i 's/prim_flop/prim_xilinx_flop/g'              $SV2V_OUT_DIR/${module}.v
    sed -i 's/prim_xilinx_flop_2sync/prim_generic_flop_2sync/g' \
        $SV2V_OUT_DIR/${module}.v
    sed -i 's/prim_sec_anchor_flop/prim_xilinx_flop/g'   $SV2V_OUT_DIR/${module}.v
    sed -i 's/prim_buf/prim_xilinx_buf/g'                $SV2V_OUT_DIR/${module}.v
    sed -i 's/prim_sec_anchor_buf/prim_xilinx_buf/g'     $SV2V_OUT_DIR/${module}.v
    sed -i 's/prim_xor2/prim_xilinx_xor2/g'              $SV2V_OUT_DIR/${module}.v
    sed -i 's/prim_xnor2/prim_xilinx_xnor2/g'            $SV2V_OUT_DIR/${module}.v
    sed -i 's/prim_and2/prim_xilinx_and2/g'              $SV2V_OUT_DIR/${module}.v
    sed -i 's/prim_ram_1p/prim_generic_ram_1p/g'         $SV2V_OUT_DIR/${module}.v

    # Rename prim_sparse_fsm_flop instances. For some reason, sv2v decides to append a suffix.
    sed -i 's/prim_sparse_fsm_flop_.*/prim_sparse_fsm_flop \#(/g' \
        $SV2V_OUT_DIR/${module}.v

    # Remove the StateEnumT parameter from prim_sparse_fsm_flop instances. Yosys doesn't seem to
    # support this.
    sed -i '/\.StateEnumT(logic \[.*/d' $SV2V_OUT_DIR/${module}.v
    sed -i '/\.StateEnumT_otbn_pkg.*Width.*(.*/d' $SV2V_OUT_DIR/${module}.v
done

# Done converting source codes.
echo "sv2v: Done"


# #-------------------------------------------------------------------------
# # Setup OpenLane environment variables.
# #-------------------------------------------------------------------------
# export OPENLANE_ROOT = /home/phamhnh/Documents/git/public/openlane2
# echo "Set path to openlane installation to OPENLANE_ROOT=$OPENLANE_ROOT"
# if [ ! -d "$OPENLANE_ROOT" ]; then
#     echo "OpenLane directory not found at $OPENLANE_ROOT"
#     exit 1
# fi
# 
# export DESIGN_DIR = $PWD
# echo "Set design directory to DESIGN_DIR=$PWD"
# 
# export CONFIG_FILE = $DESIGN_DIR/config.json
# echo "Set configuration file to CONFIG_FILE=$CONFIG_FILE"
# echo "Set path to openlane installation to OPENLANE_ROOT=$OPENLANE_ROOT"
# if [ ! -f "$CONFIG" ]; then
#     echo "Config file not found at $OPENLANE_ROOT"
#     exit 1
# fi
# 
# echo "Default PDK is sky130A. Default PDK_ROOT is set to $HOME/.volaire"
# echo "To use another PDK, add --pdk PDK to the command line"
# 
# 
# #-------------------------------------------------------------------------
# # Run OpenLane.
# #-------------------------------------------------------------------------
# # Start a nix-shell for OpenLane.
# nix-shell --pure $(OPENLANE_ROOT)/shell.nix || {
#     error "Failed to open a nix-shell"
# }
# 
# # Run OpenLane on the design from synthesis to routing.
# 
# # Use one folder for ouput artifacts. This folder acts like a cache. In
# # case a run fails, using `--run-tag $RUN_TAG` with `-F StepID` will run
# # the OpenLane flow only from StepID.
# export RUN_TAG=${SV2V_TOP_MODULE}_TRY0
# 
# openlane -design-dir $DESIGN_DIR \
#          --show-progress-bar \
#          --run-tag $RUN_TAG \
#          $CONFIG_FILE || {
#             error "OpenLane: Failed"
#          }
# 
# echo "OpenLane: Done"

