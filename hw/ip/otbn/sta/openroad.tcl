source $::env(SCRIPTS_DIR)/open.tcl

set f_search [open $::env(FSEARCH) w]

# Helper procedure to write to both file and console
proc write_both {file_handle message} {
    puts $file_handle $message
    puts $message
}

proc set_timing_paths {clk clk_period} {
#  read_db $::env(CHECKPOINT)
  global f_search

  write_both $f_search "set clk: $clk_period"

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
#  estimate_parasitics -placement
#
#  repair_timing -setup
#  repair_timing -setup
#
#  global_route
#  detailed_route

  global f_search

  repair_timing -setup
  repair_timing -setup

  repair_timing -hold

  repair_timing -setup

  set tns_setup [get_tns -max]
  set tns_hold  [get_tns -min]

  write_both $f_search "setup: $tns_setup"
  write_both $f_search "hold:  $tns_hold"
 
#  # Setup repair loop
#  set max_buf 20
#  while {1} {
#    repair_timing -setup -setup_margin 0.05 -max_buffer_percent $max_buf
#    set tns_setup [get_tns -max]
#  
#    if {$tns_setup >= 0.0} {
#      puts "Setup violations fixed with max_buffer_percent=$max_buf"
#      break
#    }
#  
#    set max_buf [expr {$max_buf + 5}]
#    if {$max_buf > 40} {
#      puts "ERROR: Could not fix setup violations within buffer limit!"
#      break
#    }
#  }
#  
#  # Hold repair loop
#  set max_buf 20
#  while {1} {
#    repair_timing -hold -hold_margin 0.05 -max_buffer_percent $max_buf
#    set tns_hold [get_tns -min]
#  
#    if {$tns_hold >= 0.0} {
#      puts "Hold violations fixed with max_buffer_percent=$max_buf"
#      break
#    }
#  
#    set max_buf [expr {$max_buf + 5}]
#    if {$max_buf > 40} {
#      puts "ERROR: Could not fix hold violations within buffer limit!"
#      break
#    }
#  }
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

#source rounding.tcl
#source timing.tcl

if { [info exists ::env(PROCESS)] && $::env(PROCESS) eq "7" } {
    # do something for asap7
    puts "PROCESS is asap7 $::env(PROCESS)"
    set start_f 200.0
    set scale_factor 1000000.0
    set unit "ps"
} else {
    # do something else
    puts "PROCESS is not asap7 $::env(PROCESS)"
    set start_f 20.0
    set scale_factor 1000.0
    set unit "ns"
}

# global_route
# detailed_route
# #write_db $::env(CHECKPOINT)


# Set clock port name
set clk "clk_i"

# Get maxium frequency using binary search
set max_f [timing::get_max_freq $clk $start_f $scale_factor]

set_timing_paths $clk [ expr {$scale_factor/$max_f} ]

close $f_search


# Open output file
set f [open $::env(REPORTS) w]

with_output_to_variable data { repair_timing -setup }
write_both $f $data

with_output_to_variable data { repair_timing -hold }
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

