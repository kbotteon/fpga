add_wave tb/i_clk
add_wave tb/i_rst
add_wave tb/i_data
add_wave tb/i_wr_en
add_wave tb/o_full
add_wave tb/o_wr_err
add_wave tb/i_rd_incr
add_wave tb/o_data
add_wave tb/o_empty
add_wave tb/o_rd_err
add_wave tb/DUT/read_addr
add_wave tb/DUT/write_addr
add_wave tb/DUT/occupancy
add_wave tb/DUT/do_read
add_wave tb/DUT/do_write
add_wave tb/DUT/ram
run all
exit
