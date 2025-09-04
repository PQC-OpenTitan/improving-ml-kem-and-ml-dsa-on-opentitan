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

puts "top_module=$top_module, start_freq=$start_f"

source lowrisc_ip_otbn_0.1.tcl

synth_design -mode out_of_context -top $top_module

#write_verilog -force  $outdir/test.v

set file_utilization $outdir/utilization.txt
set file_utilization_hierarchical $outdir/utilization_hierarchical.txt
set file_timing $outdir/timing.txt
set file_timing_summary $outdir/timing_summary.txt
set file_clocks $outdir/clocks.txt


write_checkpoint -force $outdir/synth.dcp


proc set_timing_paths {clk clk_period} {
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

# Set clock port name
set clk "clk_i"

set_timing_paths $clk [expr {1000.0/$start_f}]


# Define search range
set slow_f    1
set fast_f 1000

set best_f $slow_f
set max_freq $best_f

set mid_f [expr {$start_f/2}]


# Binary search for max frequency
while {1} {

    if {$fast_f - $slow_f <= 5} {
      break
    }

    if {$fast_f == 1000} {
       set mid_f [expr {2*$mid_f}]
    } else {
      set mid_f [expr {1000.0/((1000.0/$slow_f + 1000.0/$fast_f) / 2.0)}]
    }

    if {$mid_f >= $fast_f} {
       puts "$mid_f >= $fast_f"
       exit -1
    }

    set mid_f [expr {((int($mid_f) + 4) / 5) * 5}]

    puts "\n\n***********************************************"
    puts "***********************************************"
    puts "Slow frequency: $slow_f MHz (period: [expr {1000.0/$slow_f}] ns)"
    puts "Fast frequency: $fast_f MHz (period: [expr {1000.0/$fast_f}] ns)"
    puts "Testing clock period: $mid_f MHz (Frequency: [expr {1000.0/$mid_f}] ns)"
    puts "***********************************************"
    puts "***********************************************\n\n"

    # Apply new clock constraint
    set_timing_paths $clk [expr {1000.0/$mid_f}]

    opt_design
    set ACTIVE_STEP opt_design
    
    place_design
    set ACTIVE_STEP place_design
    
    phys_opt_design
    set ACTIVE_STEP phys_opt_design
    
    route_design
    set ACTIVE_STEP route_design

    #puts "writing schmeatic"
    #write_verilog -force  $outdir/test.v
    #puts "schematic done"

    report_timing_summary -file $file_timing_summary

    set slack [get_property SLACK [get_timing_paths -nworst 1]]

    puts "\n\n***********************************************"
    puts "***********************************************"
    puts "Slow frequency: $slow_f MHz (period: [expr {1000.0/$slow_f}] ns)"
    puts "Fast frequency: $fast_f MHz (period: [expr {1000.0/$fast_f}] ns)"
    puts "Tested clock period: $mid_f MHz (Frequency: [expr {1000.0/$mid_f}] ns)"
    puts "***********************************************"
    puts "Slack: $slack ns"

    if {$slack >= 0} {
      if {$mid_f > $best_f} {
        set best_f $mid_f
        set max_freq $best_f
      }

      set slow_f $mid_f
    } else {
      set fast_f $mid_f
    }

    puts "New best frequency: $best_f MHz (period: [expr {1000.0/$best_f}] ns)"
    puts "New slow frequency: $slow_f MHz (period: [expr {1000.0/$slow_f}] ns)"
    puts "New fast frequency: $fast_f MHz (period: [expr {1000.0/$fast_f}] ns)"
    puts "***********************************************"
    puts "***********************************************\n\n"

    open_checkpoint $outdir/synth.dcp
}

set best_period [expr {1000.0/$max_freq}]

puts "\n\n================================================"
puts "Maximum Achievable Frequency: $max_freq MHz"
puts "Clock Period: $best_period ns"
puts "================================================\n\n"

set_timing_paths $clk $best_period

opt_design
set ACTIVE_STEP opt_design

place_design
set ACTIVE_STEP place_design

phys_opt_design
set ACTIVE_STEP phys_opt_design

route_design
set ACTIVE_STEP route_design

#write_verilog -force  $outdir/test.v

report_utilization -file $file_utilization
report_utilization -hierarchical -hierarchical_depth 6 -file $file_utilization_hierarchical

report_timing -file $file_timing

report_timing_summary -file $file_timing_summary

report_clocks -file $file_clocks


set rpt [report_utilization -return_string]
puts "==== Resource Overview ===="
puts $rpt


set p [lindex [get_timing_paths -from [get_clocks $clk] -to [get_clocks $clk] -setup -nworst 1] 0]
report_timing -of_objects $p

set p [lindex [get_timing_paths -from [get_ports [all_inputs]] -to [get_ports [all_outputs]] -setup -nworst 1] 0]
report_timing -of_objects $p


puts "================================================\n"
puts "Maximum Achievable Frequency: $max_freq MHz"
puts "Clock Period: $best_period ns"
puts "\n================================================\n"

