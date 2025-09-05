# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

############################################
#
# TCL script for Synthesis Configuration with Genus
#
############################################

#set_db information_level 11

############################################
# Library Setup
############################################
set LIB_PATH 		"/home/ruben/asap7/asap7sc7p5t_28/LIB/NLDM/"
set LEF_PATH		"/home/ruben/asap7/asap7sc7p5t_28/LEF/scaled/"
set TLEF_PATH		"/home/ruben/asap7/asap7sc7p5t_28/techlef_misc"

set LIB_LIST {  asap7sc7p5t_AO_LVT_TT_nldm_211120.lib   asap7sc7p5t_INVBUF_LVT_TT_nldm_220122.lib   asap7sc7p5t_OA_LVT_TT_nldm_211120.lib   asap7sc7p5t_SEQ_LVT_TT_nldm_220123.lib   asap7sc7p5t_SIMPLE_LVT_TT_nldm_211120.lib \
 		asap7sc7p5t_AO_SLVT_TT_nldm_211120.lib  asap7sc7p5t_INVBUF_SLVT_TT_nldm_220122.lib  asap7sc7p5t_OA_SLVT_TT_nldm_211120.lib  asap7sc7p5t_SEQ_SLVT_TT_nldm_220123.lib  asap7sc7p5t_SIMPLE_SLVT_TT_nldm_211120.lib}

set LEF_LIST { asap7_tech_4x_201209.lef asap7sc7p5t_28_L_4x_220121a.lef asap7sc7p5t_28_SL_4x_220121a.lef}

set_db init_lib_search_path "$LIB_PATH $LEF_PATH $TLEF_PATH"

set_db / .library "$LIB_LIST"
set_db lef_library "$LEF_LIST"

#set REPO_TOP ${::env(REPO_TOP)}
