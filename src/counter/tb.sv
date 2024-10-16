/*******************************************************************************
* \brief Testbench for counter.sv and counter.vhd
*
* Since the module names are the same, you must update the simulation scripts
* to choose the implementation you wish to simulate, rather than simulating both
* at the same time.
*******************************************************************************/
`timescale 1ns/1ns

module tb;

import tb_util::*;

parameter WIDTH = 12;
parameter PLL_LOCK_TIME = 100ns;
parameter CLK_T_2 = 5ns;

logic i_clk;
logic i_rst;
logic i_en;
logic i_clear;
logic [WIDTH-1:0] o_count;

counter #(
    .WIDTH(WIDTH)
) DUT (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_en(i_en),
    .i_clear(i_clear),
    .o_count(o_count)
);

// Clocks
initial begin : clocks
    i_clk = 0;
    #(PLL_LOCK_TIME);
    forever #(CLK_T_2) i_clk = ~i_clk;
end

task automatic test_increment(
    ref logic dut_clk,
    ref logic dut_en,
    ref type(o_count) dut_val
);
    dut_en = 1;
    repeat(10) @(posedge dut_clk);
    dut_en = 0;
    EXPECT_EQ(32'(dut_val), 32'(10), "Increment value");
endtask

task automatic test_hold(
    ref logic dut_clk,
    ref logic dut_en,
    ref type(o_count) dut_val
);
    type(o_count) start;
    type(o_count) stop;
    start = dut_val;
    dut_en = 0;
    repeat(10) @(posedge dut_clk);
    stop = dut_val;
    EXPECT_EQ(32'(stop), 32'(start), "Hold value");
endtask

task automatic test_clear(
    ref logic dut_clk,
    ref logic dut_clear,
    ref type(o_count) dut_val
);
    EXPECT_GT(32'(dut_val), '0, "Clear start value");
    dut_clear = 1;
    @(posedge dut_clk);
    dut_clear = 0;
    @(posedge dut_clk);
    EXPECT_EQ(32'(dut_val), '0, "Clear final value");
endtask

// Test Harness
initial begin : test

    i_en = 0;
    i_clear = 0;

    i_rst = 1;
    #(PLL_LOCK_TIME)
    repeat(16) @(posedge i_clk);
    i_rst = 0;

    test_increment(i_clk, i_en, o_count);

    test_hold(i_clk, i_en, o_count);

    test_clear(i_clk, i_clear, o_count);

    $finish();

end

endmodule
