create_clock -name i_clk -period 5 [get_ports i_clk]

#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets i_clk]

set_property HD.CLK_SRC BUFGCTRL_X0Y2 [get_ports i_clk]
#set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports {i_clk}]


