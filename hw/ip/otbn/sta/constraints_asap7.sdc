report_units

set clk_name clk_i
set clk_port_name clk_i

# clk unit: ps
set clk_period 4000

set in2reg_max  $clk_period
set reg2out_max $clk_period
set in2out_max  $clk_period

# The followig is adapted from:
# source $::env(PLATFORM_DIR)/constraints.sdc

set sdc_version 2.0

set clk_port [get_ports $clk_port_name]
create_clock -period $clk_period -waveform [list 0 [expr $clk_period / 2]] -name $clk_name $clk_port

set non_clk_inputs [all_inputs -no_clocks]

set_max_delay [expr { $in2reg_max  }] -from $non_clk_inputs -to [all_registers]
set_max_delay [expr { $reg2out_max }] -from [all_registers] -to [all_outputs]
set_max_delay [expr { $in2out_max  }] -from $non_clk_inputs -to [all_outputs]

# This allows us to view the different groups
# in the histogram in the GUI and also includes these
# groups in the report
group_path -name in2reg -from $non_clk_inputs -to [all_registers]
group_path -name reg2out -from [all_registers] -to [all_outputs]
group_path -name reg2reg -from [all_registers] -to [all_registers]
group_path -name in2out -from $non_clk_inputs -to [all_outputs]

