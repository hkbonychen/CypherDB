# SDC file for ORPSoC
# This file is autogenerated - any changes will be overwritten
# See the Makefile in syn/xst/bin to make changes
# Main system clock (50 Mhz)
create_clock -name {sys_clk_pad_i} -period 20.000ns -waveform {0.000 10.000} [get_ports {sys_clk_pad_i}]

# Automatically constrain PLL and other generated clocks
derive_pll_clocks -create_base_clocks

# Automatically calculate clock uncertainty to jitter and other effects.
derive_clock_uncertainty

# Ignore timing on the reset input
set_false_path -through [get_nets {rst_n_pad_i}]

