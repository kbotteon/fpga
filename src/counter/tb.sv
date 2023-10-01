/*******************************************************************************
* Testbench for counter.sv and counter.vhd
*
* Since the module names are the same, you must update the simulation scripts
* to choose the implementation you wish to simulate, rather than simulating both
* at the same time.
*******************************************************************************/
import tb_util::*;

parameter WIDTH = 12;
parameter PLL_LOCK_TIME = 1us;
parameter CLK_T_2 = 5ns;

struct {
    logic i_clk;
    logic i_rst;
    logic i_en;
    logic i_clear;
    logic [WIDTH-1:0] o_count;
} dut_io;

counter #(
    .WIDTH(WIDTH)
) DUT (
    .i_clk(dut_io.i_clk),
    .i_rst(dut_io.i_rst),
    .i_en(dut_io.i_en),
    .i_clear(dut_io.i_clear),
    .o_count(dut_io.o_count)
);

// Clocks
initial begin : clocks
    dut_io.i_clk = 0;
    #(PLL_LOCK_TIME);
    forever #(CLK_T_2) dut_io.i_clk = ~dut_io.i_clk;
end

task test_increment(dut_clk, dut_en, dut_val)
    dut_en = 1;
    repeat(10) @(posedge dut_clk);
    dut_en = 0;
    EXPECT_EQ(dut_val, 10);
endtask

task test_hold(dut_clk, dut_en, dut_val)
    integer start = dut_val;
    dut_en = 0;
    repeat(10) @(posedge dut_clk);
    integer stop = dut_val;
    EXPECT_EQ(stop, start);
endtask

task test_clear(dut_clk, dut_clear, dut_val);
    integer start = dut_val;
    EXPECT_GT(start, 0);
    dut_clear = 1;
    @(posedge dut_clk);
    dut_clear = 0;
    integer stop = dut_val;
    EXPECT_EQ(stop, 0);
endtask

// Test Harness
initial begin : test

    dut_io.i_rst = 1;
    #(PLL_LOCK_TIME)
    repeat(16) @(posedge dut_io.i_clk);
    dut_io.i_rst = 0;

    test_increment(dut_io.i_clk, dut_io.i_en, dut_io.o_count);

    test_hold(dut_io.i_clk, dut_io.i_en, dut_io.o_count);

    test_clear(dut_io.i_clk, dut_io.i_clear, dut_io.o_count);

end
