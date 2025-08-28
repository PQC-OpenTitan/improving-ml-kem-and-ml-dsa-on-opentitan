source $::env(SCRIPTS_DIR)/open.tcl

report_units

report_tns -max
report_wns -max

#set clock [lindex [all_clocks] 0]
#set clock_period [get_property $clock period]

# Open output file
set f [open $::env(OUTPUT) w]

# Helper procedure to write to both file and console
proc write_both {file_handle message} {
    puts $file_handle $message
    puts $message
}

write_both $f "name: $::env(DESIGN_NAME)"

set shortest_slack 100000.0

#foreach group {in2reg reg2out reg2reg in2out} {
foreach group {in2out} {
    #set paths [find_timing_paths -path_group $group -sort_by_slack -group_path_count 1]
    set paths [find_timing_paths -path_group $group -path_delay max ]
    set path [lindex $paths 0]

    set slack [get_property $path slack]
    write_both $f "${group}_slack: $slack"

    # List of path points (start pin -> ... -> end pin)
    set points [get_property $path points]

    # End-point arrival is the arrival at the last point
    set end_point        [lindex $points end]
    set end_arrival_time [get_property $end_point arrival]

    # (Optional) start-point arrival, if you want pure path delay = end - start
    set start_point       [lindex $points 0]
    set start_arrival_time [get_property $start_point arrival]

    set required [get_property $end_point required]
#    set arrival [expr {$end_arrival_time - $start_arrival_time}]
    set arrival [expr {$required - $start_arrival_time}]

    write_both $f "${group}_required: $required"

#    puts "start_arrival_time=$start_arrival_time  end_arrival=$end_arrival_time  slack=$slack  required=$required"

#    write_both $f "${group}_arrival: $arrival"
#    set slowest_path [expr { $arrival > $slowest_path ? $arrival : $slowest_path }]
    set shortest_slack [expr { $slack < $shortest_slack ? $slack : $shortest_slack }]
}

write_both $f "shortest_slack: $shortest_slack"

#set clock_period_ps [sta::find_clk_min_period $clock 1]
#set fmax [expr round(1.0e-6 / $clock_period_ps)]

#set fmax [expr round(1000000.0 / $slowest_path)]
#write_both $f "fmax: $fmax MHz"

#set freq [expr round(1000000.0 / $clock_period)]
#write_both $f "clock setting: $clock_period ($freq)"
#write_both $f "clock setting: $clock_period"

set instance_count [llength [get_cells *]]
write_both $f "instances: $instance_count"

set design_area [sta::format_area [rsz::design_area] 0]
write_both $f "design_area: $design_area"

set util [format %.0f [expr [rsz::utilization] * 100]]
write_both $f "utilization: $util"

#set core_area [sta::format_area [rsz::core_area] 0]
#write_both $f "core_area: $core_area"

# set_power_activity -input -activity 0.5
# 
# report_power > tmp.txt
# exec cat tmp.txt
# set f2 [open tmp.txt r]
# set power_line [lindex [split [read $f2] "\n"] 9]
# regexp {(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)} $power_line -> _ _ _ _ power
# close $f2
# 
# write_both $f "power: $power mW"

# # Inspect that single endpoint
# report_checks -path_delay max -to [get_ports {operation_flags_o[3]}] \
#   -fields {path_type clock startpoint endpoint delay slack} -digits 4 -group_count 3
# 
# # Also see if anything is unconstrained more broadly
# #report_unconstrained_points
# 
# report_checks -path_delay max \
#               -fields {path_type startpoint endpoint slack} \
#               -digits 4

# report_checks -path_delay max -fields {startpoint endpoint slack} -digits 4

# set p [lindex [find_timing_paths -path_delay max -max_paths 1 -sort_by_slack] 0]
# puts "Worst endpoint: [get_property $p endpoint], slack = [get_property $p slack]"

close $f
puts "Results written to: $::env(OUTPUT)"

