/*******************************************************************************
* \brief Testbench for sync_fifo.sv
*******************************************************************************/
`timescale 1ns/1ns

module tb;

import tb_util::*;

parameter CLK_T_2 = 5ns;
parameter WIDTH=19;
parameter DEPTH=128;

logic i_clk;
logic i_rst;
logic [WIDTH-1:0] i_data;
logic i_wr_en;
logic o_full;
logic o_wr_err;
logic i_rd_incr;
logic [WIDTH-1:0] o_data;
logic o_empty;
logic o_rd_err;

sync_fifo #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH),
    .ARCH("Xilinx")
) DUT (
    .*
);

initial begin : clocks
    i_clk = 0;
    forever #(CLK_T_2) i_clk = ~i_clk;
end

task automatic test_push_half(
    ref logic dut_clk,
    ref logic o_empty
);
    EXPECT_EQ(o_empty, 1'b1, "FIFO is initially empty");
endtask

initial begin : test_harness

    i_rst = 1;
    i_data = 0;
    i_wr_en = 0;
    i_rd_incr = 0;

    #100ns;
    i_rst = 0;
    #100ns;

    test_push_half(i_clk, o_empty);

    $finish();

end

endmodule
