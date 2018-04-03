set_property PACKAGE_PIN L16 [get_ports seri_clk_p]
set_property PACKAGE_PIN K17 [get_ports seri_b_p]
set_property PACKAGE_PIN K19 [get_ports seri_g_p]
set_property PACKAGE_PIN J18 [get_ports seri_r_p]
set_property PACKAGE_PIN D19 [get_ports reset]
set_property PACKAGE_PIN R14 [get_ports led0]
set_property PACKAGE_PIN P14 [get_ports led1]

set_property IOSTANDARD LVCMOS33 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports led0]
set_property IOSTANDARD LVCMOS33 [get_ports led1]


set_property DRIVE 4 [get_ports led0]
set_property DRIVE 4 [get_ports led1]
