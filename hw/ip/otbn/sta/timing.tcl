namespace eval timing { }

proc timing::get_max_freq { clk start_f scale_factor } {
  set slow_f -1
  set fast_f -1
  
  set best_f $slow_f
  set max_freq $best_f
  
  set mid_f $start_f
  
  set temp_file /tmp/timing.rpt

  if {$scale_factor == 1000.0} {
    set unit "ns"
  } else {
    set unit "ps"
  }
  
  # Binary search for max frequency
  while {1} {
      set mid_f [rounding::round_grid_first_ge_1pct $mid_f]
  
      if {($mid_f == $slow_f) || ($mid_f == $fast_f)} {
        break
      }

      puts "\n\n***********************************************"
      puts "***********************************************"
      puts "Slow frequency: $slow_f MHz (period: [expr {$scale_factor/$slow_f}] $unit)"
      puts "Fast frequency: $fast_f MHz (period: [expr {$scale_factor/$fast_f}] $unit)"
      puts "Testing clock period: $mid_f MHz (Frequency: [expr {$scale_factor/$mid_f}] $unit)"
      puts "***********************************************"
      puts "***********************************************\n\n"
  
      # Apply new clock constraint
      set_timing_paths $clk [expr {$scale_factor/$mid_f}]
  
      place_and_route
  
      #puts "writing schmeatic"
      #write_verilog -force  $outdir/test.v
      #puts "schematic done"
  
      # report_timing_summary -file $file_timing_summary
  
#      set slack [get_property SLACK [get_timing_paths -nworst 1]]

      set slack [ get_slack ]
  
      puts "\n\n***********************************************"
      puts "***********************************************"
      puts "Slow frequency: $slow_f MHz (period: [expr {$scale_factor/$slow_f}] $unit)"
      puts "Fast frequency: $fast_f MHz (period: [expr {$scale_factor/$fast_f}] $unit)"
      puts "Tested clock period: $mid_f MHz (Frequency: [expr {$scale_factor/$mid_f}] $unit)"
      puts "***********************************************"
      puts "Slack: $slack $unit"

#      report_timing -nworst 1 > $temp_file
#  
#      set file_handle [open $temp_file r]
#      set report_output [read $file_handle]
#      close $file_handle
#  
#      file delete $temp_file
#      
#      puts "\n\n***********************************************"
#      puts "***********************************************"
#      puts "Slow frequency: $slow_f MHz (period: [expr {$scale_factor/$slow_f}] $unit)"
#      puts "Fast frequency: $fast_f MHz (period: [expr {$scale_factor/$fast_f}] $unit)"
#      puts "Tested clock period: $mid_f MHz (Frequency: [expr {$scale_factor/$mid_f}] $unit)"
#      puts "***********************************************"
#  
#      if {[regexp -- {MET} $report_output]} {
#          puts "Timing constraint is MET."
#          set slack 100
#      } else {
#          puts "Timing constraint is NOT MET."
#          set slack -100
#      }
 
      if {$slack >= 0} {
        if {$mid_f > $best_f} {
          set best_f $mid_f
          set max_freq $best_f
        }
  
        set slow_f $mid_f
      } else {
        set fast_f $mid_f
      }
  
      puts "New best frequency: $best_f MHz (period: [expr {$scale_factor/$best_f}] $unit)"
      puts "New slow frequency: $slow_f MHz (period: [expr {$scale_factor/$slow_f}] $unit)"
      puts "New fast frequency: $fast_f MHz (period: [expr {$scale_factor/$fast_f}] $unit)"
      puts "***********************************************"
      puts "***********************************************\n\n"
  
 
      if {$fast_f == -1} {
         set mid_f [expr {2*$mid_f}]
      } elseif {$slow_f == -1} {
         set mid_f [expr {0.5*$mid_f}]
      } else {
        set mid_f [expr {$scale_factor/(($scale_factor/$slow_f + $scale_factor/$fast_f) / 2.0)}]
      }
  
  #    open_checkpoint $outdir/synth.dcp
  }
  
  set best_period [expr {$scale_factor/$max_freq}]
  
  puts "\n\n================================================"
  puts "Maximum Achievable Frequency: $max_freq MHz"
  puts "Clock Period: $best_period $unit"
  puts "================================================\n\n"

  return $max_freq
}
