/*******************************************************************************
* \brief Testbench for sync_fifo.sv
* \copyright 2024 Kyle Botteon
* \copyright This file is part of HERMIT. Refer to LICENSE in the repository.
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

task automatic test_half_full();
    logic [WIDTH-1:0] data_q[$];
    logic [WIDTH-1:0] expected;
    logic [WIDTH-1:0] temp;

    // FIFO is empty at start of test
    EXPECT_EQ(o_empty, 1'b1, "FIFO is initially empty");

    // Inject data
    for(int word = 0; word < DEPTH/2; word = word + 1) begin
        @(posedge i_clk);
        data_q.push_back(word);
        i_data = word;
        i_wr_en = 1;
        @(posedge i_clk);
        i_wr_en = 0;
    end

    // FIFO is no longer empty
    EXPECT_EQ(o_empty, 1'b0, "FIFO is no longer empty");

    // Extract data and compare
    // Constant readback i.e. no throttling i.e. no i_rd_incr toggle
    for(int word = 0; word < DEPTH/2; word = word + 1) begin
        i_rd_incr = 1;
        @(posedge i_clk);
        i_rd_incr = 0;
        @(posedge i_clk);
        expected = data_q.pop_front();
        EXPECT_EQ(o_data, expected,
            $sformatf("FIFO read at index 0x%x", word));
    end

endtask

initial begin : test_harness

    i_rst = 1;
    i_data = 0;
    i_wr_en = 0;
    i_rd_incr = 0;

    #100ns;
    i_rst = 0;
    #100ns;

    test_half_full();

    $finish();

end

endmodule
