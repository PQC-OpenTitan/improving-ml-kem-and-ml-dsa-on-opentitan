# Read command parameters
set sources [lindex $argv 0]
set constraints_timing [lindex $argv 1]
#set constraints_pin [lindex $argv 2]

set top_module [lindex $argv 2]
set partname [lindex $argv 3]

set outdir [lindex $argv 4]
set parameters [lindex $argv 5]
set macros [lindex $argv 6]

set file_utilization $outdir/utilization.txt
set file_utilization_hierarchical $outdir/utilization_hierarchical.txt
set file_timing $outdir/timing.txt
set file_timing_summary $outdir/timing_summary.txt
set file_clocks $outdir/clocks.txt

#set file_utilization [lindex $argv 5]
#set file_utilization_hierarchical [lindex $argv 6]
#set file_timing [lindex $argv 7]
#set file_timing_summary [lindex $argv 8]
#set file_clocks [lindex $argv 9]
#set parameters [lindex $argv 10]
#set macros [lindex $argv 11]

#Read .v type file
puts $sources
set splitCont [split $sources " "] ;
puts $splitCont
foreach f $splitCont {
    puts $f
    set pat ".vhd"
    set patv ".v"
    set patsv ".sv"
    if [string match *$pat $f] {
        read_vhdl $f
    } elseif [string match *$patv $f] {
        read_verilog $f
    } elseif [string match *$patsv $f] {
        read_verilog -sv $f
    } else {
        # do nothing
    }
}


set_param general.maxThreads 1

puts $parameters
#set splitPar [split $parameters " "] ;
#puts $splitPar
#foreach f $splitPar {
#    puts $f
#	set_property generic {$f} [current_fileset]
#}

puts $macros
#We need to create the clock before synthesis by read xdc timing

#--STEP1: Synthesis design

read_xdc $constraints_timing

set command [list synth_design]

lappend command -part $partname 
lappend command -top $top_module 
#lappend command -mode default
lappend command -mode out_of_context

set splitPar [split $parameters " "] ;
foreach param $splitPar {
    lappend command -generic $param
}

set splitMac [split $macros " "] ;
foreach macro $splitMac {
    lappend command -verilog_define $macro
}

puts $command

eval $command

#    -generic $parameters

# write_edif test.edf

#After synthesis and befor implement we will read xdc pin
#Reference: https://docs.xilinx.com/v/u/2013.2-English/ug903-vivado-using-constraints

#--STEP2: Implement design
#read_xdc $constraints_pin


write_checkpoint -force $outdir/synth.dcp
#open_checkpoint $outdir/synth.dcp


# Set clock port name
set clk_port "clk_i"

# Define search range
set slow_f   50
set fast_f 1000
set best_f $slow_f
set max_freq $best_f


# Binary search for max frequency
#while {[expr $slow_period - $fast_period] > 0.1} {
while {[expr ($fast_f - $slow_f)] > 5} {
    set mid_f [expr 1000.0/((1000.0/$slow_f + 1000.0/$fast_f) / 2.0)]

    set mid_f [expr ((int($mid_f) + 4) / 5) * 5]

    puts "\n\n***********************************************"
    puts "***********************************************"
    puts "Slow frequency: $slow_f MHz (period: [expr 1000.0/$slow_f] ns)\n"
    puts "Fast frequency: $fast_f MHz (period: [expr 1000.0/$fast_f] ns)\n"
    puts "Testing clock period: $mid_f MHz (Frequency: [expr 1000.0/$mid_f] ns)\n"
    puts "***********************************************"
    puts "***********************************************\n\n"

    set mid_period [expr 1000.0/$mid_f]

    # Apply new clock constraint
    create_clock -name $clk_port -period $mid_period [get_ports $clk_port]

    puts "new clock"

    opt_design
    set ACTIVE_STEP opt_design
    
    place_design
    set ACTIVE_STEP place_design
    
    place_design
    
    phys_opt_design
    set ACTIVE_STEP phys_opt_design
    
    route_design
    set ACTIVE_STEP route_design


    report_timing_summary -file $file_timing_summary

    set slack [get_property SLACK [get_timing_paths -nworst 1]]

    puts "\n\n***********************************************"
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

    puts "Best frequency: $best_f MHz (period: [expr 1000.0/$best_f] ns)\n"
    puts "Slow frequency: $slow_f MHz (period: [expr 1000.0/$slow_f] ns)\n"
    puts "Fast frequency: $fast_f MHz (period: [expr 1000.0/$fast_f] ns)\n"
    puts "***********************************************"
    puts "***********************************************\n\n"

    open_checkpoint $outdir/synth.dcp
}

set best_period [expr 1000.0/$max_freq]

# Compute final max frequency
puts "\n\n================================================"
puts "Maximum Achievable Frequency: $max_freq MHz"
puts "Clock Period: $best_period ns"
puts "================================================\n\n"

create_clock -name $clk_port -period $best_period [get_ports $clk_port]

# # Save successful constraint to the XDC file
# set xdc_file "constraints.xdc"
# set xdc_content "create_clock -name my_clk -period $best_period [get_ports $clk_port]"
# set xdc_handle [open $xdc_file w]
# puts $xdc_handle $xdc_content
# close $xdc_handle
# 
# puts "Updated constraints saved to $xdc_file"


opt_design
set ACTIVE_STEP opt_design


place_design
set ACTIVE_STEP place_design

place_design

phys_opt_design
set ACTIVE_STEP phys_opt_design

route_design
set ACTIVE_STEP route_design


#Compute utilization of device and display report
report_utilization -file $file_utilization
report_utilization -hierarchical -hierarchical_depth 6 -file $file_utilization_hierarchical
#Report timing paths
report_timing -file $file_timing
#Report timing summary
report_timing_summary -file $file_timing_summary
#Report clocks
report_clocks -file $file_clocks

write_verilog -force test.v


##--STEP3: Generated bitstream

# write_bitstream -force $top_module.bit
# set ACTIVE_STEP write_bitstream
# 
# open_hw_manager
# connect_hw_server -url localhost:3121
# open_hw_target
# 
# current_hw_device [lindex [get_hw_devices] 0]
# refresh_hw_device -update_hw_probes false [lindex [get_hw_devices] 0]
# set_property PROGRAM.FILE $top_module.bit [lindex [get_hw_devices] 0]
# 
# program_hw_devices [lindex [get_hw_devices] 0]
# refresh_hw_device [lindex [get_hw_devices] 0]

