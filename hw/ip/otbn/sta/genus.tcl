# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

set TOP_MODULE $env(TOP_MODULE)
set start_f $env(START_F)
set REPORT_DIR $env(OUTDIR)

puts "top_module=$TOP_MODULE, start_freq=$start_f"


############################################
#
# TCL script for Synthesis with Genus
#
############################################
# Required if SRAM blocks are synthesized
set_db hdl_max_memory_address_range 65536

############################################
# Read Sources
############################################
source ${READ_SOURCES}.tcl

source config_genus.tcl

############################################
# Elaborate Design
############################################

# Effort: none, low, medium, high, express
set_db syn_global_effort low

elaborate ${TOP_MODULE}

check_design -unresolved ${TOP_MODULE} 
check_design -combo_loops ${TOP_MODULE}
check_design -multiple_driver ${TOP_MODULE}

############################################
# Perform binary search for Fmax
############################################

proc set_timing_paths {clk clk_period} {
  if {[llength [get_ports -quiet $clk]] > 0} {
    # Create clock to attach it to a clock buffer.
    create_clock -name $clk -period $clk_period [get_ports $clk]
    
    # ---- in2reg: inputs -> regs captured by clk
    set_max_delay $clk_period -from [get_ports [all_inputs]] -to [get_clocks $clk]
    
    # ---- reg2out: regs launched by clk -> output ports
    set_max_delay $clk_period -from [get_clocks $clk] -to [get_ports [all_outputs]]
  }
  
  # ---- in2out: pure combinational ports -> ports
  set_max_delay $clk_period -from [get_ports [all_inputs]] -to [get_ports [all_outputs]]
  # -datapath_only
}

proc place_and_route {} {
  #SYN GENERIC - Prepare Logic
  syn_gen
  #SYN MAP - Map Design for Target Technology
  syn_map
  #SYN OPT - Optimize final results
  syn_opt
}

proc get_slack {} {
  set temp_file /tmp/timing.rpt

  report_timing -nworst 1 > $temp_file

  set file_handle [open $temp_file r]
  set report_output [read $file_handle]
  close $file_handle

  file delete $temp_file

  if {[regexp -- {MET} $report_output]} {
      puts "Timing constraint is MET."
      set slack 100
  } else {
      puts "Timing constraint is NOT MET."
      set slack -100
  }

  return $slack
}

source rounding.tcl
source timing.tcl

# Set clock port name
set clk "clk_i"

set scale_factor 1000000.0

# Get maxium frequency using binary search
set max_f [timing::get_max_freq $clk $start_f $scale_factor]

set_timing_paths $clk [expr {$scale_factor/$max_f}]

place_and_route

# REPORTS
report timing > ${REPORT_DIR}/timing.rpt
report area >   ${REPORT_DIR}/area.rpt
report power >  ${REPORT_DIR}/power.rpt

set f [open ${REPORT_DIR}/summary.txt w]

puts "Fmax: $max_f MHz"
puts $f "Fmax: $max_f MHz"

close $f

quit
