# Copyright Ruben Niederhagen and Hoang Nguyen Hien Pham - authors of
# "Improving ML-KEM & ML-DSA on OpenTitan - Efficient Multiplication Vector Instructions for OTBN"
# (https://eprint.iacr.org/2025/2028)
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

source $::env(SCRIPTS_DIR)/open.tcl

set f_search [open $::env(FSEARCH) w]

# Helper procedure to write to both file and console
proc write_both {file_handle message} {
    puts $file_handle $message
    puts $message
}

proc set_timing_paths {clk clk_period} {
  global f_search

  write_both $f_search "set clk: $clk_period"

  if {[llength [get_ports -quiet $clk]] > 0} {
    # Create clock to attach it to a clock buffer.
    create_clock -name $clk -period $clk_period [get_ports $clk]
    
    # ---- in2reg: inputs -> regs captured by clk
    set_max_delay $clk_period -from [get_ports [all_inputs]] -to [get_clocks $clk] -reset_path
    set_max_delay $clk_period -from [get_ports [all_inputs]] -to [get_clocks $clk] -reset_path
    
    # ---- reg2out: regs launched by clk -> output ports
    set_max_delay $clk_period -from [get_clocks $clk] -to [get_ports [all_outputs]] -reset_path
  }
  
  # ---- in2out: pure combinational ports -> ports
  set_max_delay $clk_period -from [get_ports [all_inputs]] -to [get_ports [all_outputs]] -reset_path
  # -datapath_only
}

proc get_tns {which} {
  if {[llength [info commands sta::total_negative_slack]]} {
    return [sta::total_negative_slack $which]
  }
  redirect -variable rpt { report_tns $which }
  if {[regexp {TNS\s*=\s*([-+]?\d+(\.\d+)?)}
           $rpt -> val]} {
    return $val
  }
  error "Could not parse TNS for $which"
}

proc place_and_route {} {
  global f_search

  repair_timing -setup -max_buffer_percent 50 -max_utilization 85

  set tns_setup [get_tns -max]
  if {$tns_setup < 0.0 } {
    write_both $f_search "first setup failed"

    with_output_to_variable data { report_checks -path_delay max }

    write_both $f_search $data
  }
 
  repair_timing -setup -max_buffer_percent 50 -max_utilization 85

  set tns_setup [get_tns -max]
  if {$tns_setup < 0.0 } {
    write_both $f_search "second setup failed"
    return 1
  }
 
  repair_timing -hold -max_buffer_percent 50 -max_utilization 85

  set tns_hold  [get_tns -min]

  if {$tns_hold < 0.0 } {
    write_both $f_search "hold failed"
    return 1
  }
 
  repair_timing -setup -max_buffer_percent 50 -max_utilization 85

  set tns_setup [get_tns -max]
  set tns_hold  [get_tns -min]

  if {$tns_setup < 0.0 } {
    write_both $f_search "second setup failed"
    return 1
  }

  write_both $f_search "setup: $tns_setup"
  write_both $f_search "hold:  $tns_hold"
}

proc get_slack {} {
  set paths [find_timing_paths -path_delay max ]
  set path [lindex $paths 0]

  set slack [get_property $path slack]

  if { $slack >= 0.0 } {
    set tns_setup [get_tns -max]
    set tns_hold  [get_tns -min]
  
    if {$tns_setup < 0.0 || $tns_hold < 0.0} {
      set slack -100.0
    }
  }

  return $slack
}

if { [info exists ::env(PROCESS)] && $::env(PROCESS) eq "7" } {
    # do something for asap7
    puts "PROCESS is asap7 $::env(PROCESS)"
    set start_f $::env(STARTF)
    set scale_factor 1000000.0
    set unit "ps"
} else {
    # do something else
    puts "PROCESS is not asap7 $::env(PROCESS)"
    set start_f $::env(STARTF)
    set scale_factor 1000.0
    set unit "ns"
}

# Set clock port name
set clk "clk_i"

set_timing_paths $clk [ expr {$scale_factor/$start_f} ]

estimate_parasitics -placement
repair_design
repair_timing -setup -max_buffer_percent 50 -max_utilization 85

# Get maxium frequency using binary search
set max_f [timing::get_max_freq $clk $start_f $scale_factor]

set_timing_paths $clk [ expr {$scale_factor/$max_f} ]

close $f_search

# Open output file
set f [open $::env(REPORTS) w]

with_output_to_variable data { repair_timing -setup -max_buffer_percent 50 -max_utilization 85 }
write_both $f $data

with_output_to_variable data { repair_timing -hold -max_buffer_percent 50 -max_utilization 85 }
write_both $f $data

with_output_to_variable data { report_tns -max }
write_both $f $data
with_output_to_variable data { report_wns -max }
write_both $f $data

with_output_to_variable data { report_units }
write_both $f $data

close $f

# Open output file
set f [open $::env(OUTPUT) w]

write_both $f "name: $::env(DESIGN_NAME)"

set max_period [ expr {$scale_factor/$max_f} ]

write_both $f "Fmax: $max_f MHz ($max_period $unit)"

set paths [find_timing_paths -path_delay max ]
set path [lindex $paths 0]

set slack [get_property $path slack]
write_both $f "slack: $slack"

set points [get_property $path points]
set end_point        [lindex $points end]
set required [get_property $end_point required]

write_both $f "required: $required"

set instance_count [llength [get_cells *]]
write_both $f "instances: $instance_count"

set design_area [sta::format_area [rsz::design_area] 0]
write_both $f "design_area: $design_area"

set util [format %.0f [expr [rsz::utilization] * 100]]
write_both $f "utilization: $util"

close $f
puts "Results written to: $::env(OUTPUT)"
