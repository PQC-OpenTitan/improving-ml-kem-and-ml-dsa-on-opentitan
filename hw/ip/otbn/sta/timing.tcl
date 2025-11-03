# Copyright Ruben Niederhagen and Hoang Nguyen Hien Pham - authors of
# "Improving ML-KEM & ML-DSA on OpenTitan - Efficient Multiplication Vector Instructions for OTBN"
# (https://eprint.iacr.org/2025/2028)
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

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
    set mid_f [rounding::round_largest_error $mid_f]

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
    set_timing_paths $clk [ expr {$scale_factor/$mid_f} ]

    place_and_route

    set slack [ get_slack ]

    puts "\n\n***********************************************"
    puts "***********************************************"
    puts "Slow frequency: $slow_f MHz (period: [expr {$scale_factor/$slow_f}] $unit)"
    puts "Fast frequency: $fast_f MHz (period: [expr {$scale_factor/$fast_f}] $unit)"
    puts "Tested clock period: $mid_f MHz (Frequency: [expr {$scale_factor/$mid_f}] $unit)"
    puts "***********************************************"
    puts "Slack: $slack $unit"

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
        set mid_f [expr {2 * $mid_f}]
    } elseif {$slow_f == -1} {
        set mid_f [expr {$mid_f / 2.0}]
    } else {
      set mid_f [expr {$scale_factor/(($scale_factor/$slow_f + $scale_factor/$fast_f) / 2.0)}]
    }

    if {($mid_f < 1.0)} {
      global f_search
      close $f_search
      exit 1
    }
  }
  
  set best_period [expr {$scale_factor/$max_freq}]
  
  puts "\n\n================================================"
  puts "Maximum Achievable Frequency: $max_freq MHz"
  puts "Clock Period: $best_period $unit"
  puts "================================================\n\n"

  return $max_freq
}

