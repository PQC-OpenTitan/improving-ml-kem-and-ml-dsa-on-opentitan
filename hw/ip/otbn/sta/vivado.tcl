# Copyright Ruben Niederhagen and Hoang Nguyen Hien Pham - authors of
# "Improving ML-KEM & ML-DSA on OpenTitan - Efficient Multiplication Vector Instructions for OTBN"
# (https://eprint.iacr.org/2025/2028)
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

set start_f 10

set outdir reports

set help_text {
Usage: vivado -mode batch -source my_script.tcl -tclargs [options]

Options:
  --top_module <name>   Name of the top module to synthesize.
  --start_freq <freq>   Start frequrncy for search (default: $start_f MHz).
  --outdir <dir>        Output directory for reports (default: reports).
  -h, --help            Show this help and exit.
}

if {$argc == 0 || [lindex $argv 0] in {"-h" "--help"}} {
    puts $help_text
    exit 0
}

set top_module ""

for {set i 0} {$i < $argc} {incr i} {
  set arg [lindex $argv $i]
  switch -- $arg {
    --top_module {
      incr i
      set top_module [lindex $argv $i]
    }
    --start_freq {
      incr i
      set start_f [lindex $argv $i]
    }
    --outdir {
      incr i
      set outdir [lindex $argv $i]
    }
    default {
      puts "Unknown option: $arg"
    }
  }
}

set file_utilization $outdir/utilization.txt
set file_utilization_hierarchical $outdir/utilization_hierarchical.txt
set file_timing $outdir/timing.txt
set file_timing_summary $outdir/timing_summary.txt
set file_clocks $outdir/clocks.txt

puts "top_module=$top_module, start_freq=$start_f"

proc set_timing_paths {clk clk_period} {
  global outdir

  open_checkpoint $outdir/synth.dcp

  if {[llength [get_ports -quiet $clk]] > 0} {
    # Create clock to attach it to a clock buffer.
    create_clock -name $clk -period $clk_period [get_ports $clk]
    set_property HD.CLK_SRC BUFGCTRL_X0Y2 [get_ports $clk]
    
    # ---- in2reg: inputs -> regs captured by clk
    set_max_delay $clk_period -from [get_ports [all_inputs]] -to [get_clocks $clk]
    
    # ---- reg2out: regs launched by clk -> output ports
    set_max_delay $clk_period -from [get_clocks $clk] -to [get_ports [all_outputs]]
  }
  
  # ---- in2out: pure combinational ports -> ports
  set_max_delay $clk_period -from [get_ports [all_inputs]] -to [get_ports [all_outputs]] -datapath_only
}

proc get_slack {} {
  set slack [get_property SLACK [get_timing_paths -nworst 1]]

  return $slack
}

proc place_and_route {} {
  place_design
  set ACTIVE_STEP place_design
  
  phys_opt_design
  set ACTIVE_STEP phys_opt_design
  
  route_design
  set ACTIVE_STEP route_design
}

source lowrisc_ip_otbn_0.1.tcl

source rounding.tcl
source timing.tcl

synth_design -mode out_of_context -top $top_module

opt_design
set ACTIVE_STEP opt_design
 
write_checkpoint -force $outdir/synth.dcp

# Set clock port name
set clk "clk_i"
set scale_factor 1000.0

# Get maxium frequency using binary search
set max_f [timing::get_max_freq $clk $start_f $scale_factor]

set best_period [expr {$scale_factor/$max_f}]

set_timing_paths $clk $best_period

place_and_route

#write_verilog -force  $outdir/test.v

report_utilization -file $file_utilization
report_utilization -hierarchical -hierarchical_depth 6 -file $file_utilization_hierarchical

report_timing -file $file_timing

report_timing_summary -file $file_timing_summary

report_clocks -file $file_clocks

set f [open ${outdir}/summary.txt w]

puts "Fmax: $max_f MHz"
puts $f "Fmax: $max_f MHz"

close $f

puts "================================================\n"
puts "Maximum Achievable Frequency: $max_f MHz"
puts "Clock Period: $best_period ns"
puts "\n================================================\n"
