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

source ${SCRIPT_DIR}/config_genus.tcl

#read_libs /opt/asap7_pdk_r1p7/cdslib/setup/cds.lib

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
# Set Timing and Design Constraints
############################################

read_sdc ${SCRIPT_DIR}/otbn.sdc


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


#set start_f 100

# Set clock port name
set clk "clk_i"

set_timing_paths $clk [expr {1000.0/$start_f}]


# Define search range
set slow_f $start_f
set fast_f 4000

set best_f $slow_f
set max_freq $best_f

set mid_f [expr {$start_f/2}]


set temp_file /tmp/timing.rpt


# Binary search for max frequency
while {1} {

    if {$fast_f - $slow_f <= 5} {
      break
    }

    if {$fast_f == 1000} {
       set mid_f [expr {2*$mid_f}]
    } else {
      set mid_f [expr {1000000.0/((1000000.0/$slow_f + 1000000.0/$fast_f) / 2.0)}]
    }

    if {$mid_f >= $fast_f} {
       puts "$mid_f >= $fast_f"
       exit -1
    }

    set mid_f [expr {((int($mid_f) + 4) / 5) * 5}]

    puts "\n\n***********************************************"
    puts "***********************************************"
    puts "Slow frequency: $slow_f MHz (period: [expr {1000000.0/$slow_f}] ps)"
    puts "Fast frequency: $fast_f MHz (period: [expr {1000000.0/$fast_f}] ps)"
    puts "Testing clock period: $mid_f MHz (Frequency: [expr {1000000.0/$mid_f}] ps)"
    puts "***********************************************"
    puts "***********************************************\n\n"

    # Apply new clock constraint
    set_timing_paths $clk [expr {1000000.0/$mid_f}]

    #SYN GENERIC - Prepare Logic
    syn_gen
    #SYN MAP - Map Design for Target Technology
    syn_map
    #SYN OPT - Optimize final results
    syn_opt

    report_timing -nworst 1 > $temp_file

    set file_handle [open $temp_file r]
    set report_output [read $file_handle]
    close $file_handle

    file delete $temp_file
    
    puts "\n\n***********************************************"
    puts "***********************************************"
    puts "Slow frequency: $slow_f MHz (period: [expr {1000000.0/$slow_f}] ps)"
    puts "Fast frequency: $fast_f MHz (period: [expr {1000000.0/$fast_f}] ps)"
    puts "Tested frequency: $mid_f MHz (period: [expr {1000000.0/$mid_f}] ps)"
    puts "***********************************************"

    if {[regexp -- {MET} $report_output]} {
        puts "Timing constraint is MET."
        set slack 100
    } else {
        puts "Timing constraint is NOT MET."
        set slack -100
    }

    if {$slack >= 0} {
      if {$mid_f > $best_f} {
        set best_f $mid_f
        set max_freq $best_f
      }

      set slow_f $mid_f
    } else {
      set fast_f $mid_f
    }

    puts "New best frequency: $best_f MHz (period: [expr {1000000.0/$best_f}] ps)"
    puts "New slow frequency: $slow_f MHz (period: [expr {1000000.0/$slow_f}] ps)"
    puts "New fast frequency: $fast_f MHz (period: [expr {1000000.0/$fast_f}] ps)"
    puts "***********************************************"
    puts "***********************************************\n\n"
}

set best_period [expr {1000000.0/$max_freq}]

puts "\n\n================================================"
puts "Maximum Achievable Frequency: $max_freq MHz"
puts "Clock Period: $best_period ps"
puts "================================================\n\n"

set_timing_paths $clk $best_period



############################################
# Apply Optimization Directives
############################################

puts "Apply Optimization Directive"

############################################
# Synthesize Design
############################################

#SYN GENERIC - Prepare Logic
syn_gen
#SYN MAP - Map Design for Target Technology
syn_map
#SYN OPT - Optimize final results
syn_opt



############################################
# Write Output Files
############################################

# REPORTS
report timing > ${REPORT_DIR}/timing.rpt
report area >   ${REPORT_DIR}/area.rpt
report power >  ${REPORT_DIR}/power.rpt

set f [open ${REPORT_DIR}/summary.txt w]

puts "Fmax: $max_freq MHz"
puts $f "Fmax: $max_freq MHz"

close $f

quit
