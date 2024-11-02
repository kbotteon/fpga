# Waveforms should be separate from xsim.tcl so they can be used both for
# specifying what to log when launching xsim and when opening the GUI afterwards
add_wave tb/i_clk
add_wave tb/i_rst
add_wave tb/i_en
add_wave tb/i_clear
add_wave tb/o_count
