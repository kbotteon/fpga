/*******************************************************************************
* \brief Testbench for pdetect.sv
*******************************************************************************/
`timescale 1ns/1ns

module tb;

import tb_util::*;

parameter CLK_T_2 = 5ns;

logic i_clk;
logic i_rst;
logic [7:0] i_data;
logic o_detected;

pdetect #(
    .PATTERN(32'h0A0B0C0D)
) DUT (
    .*
);

initial begin : clocks
    i_clk <= 0;
    forever #(CLK_T_2) i_clk <= ~i_clk;
end

task automatic apply_pattern (
    input logic [31:0] pattern
);
    i_data = pattern[31:24];
    @(posedge i_clk);
    i_data = pattern[23:16];
    @(posedge i_clk);
    i_data = pattern[15:8];
    @(posedge i_clk);
    i_data = pattern[7:0];
    @(posedge i_clk);
endtask

initial begin : test_harness

    i_data = 0;

    i_rst = 1;
    repeat(10) @(posedge i_clk);

    i_rst = 0;
    repeat(10) @(posedge i_clk);

    @(posedge i_clk);
    apply_pattern({8'h0A, 8'h0B, 8'h0C, 8'h0D});
    EXPECT_EQ(o_detected, 1'b1, "Pattern detected");

    @(posedge i_clk);
    EXPECT_EQ(o_detected, 1'b0, "Pattern detected deasserts");

    @(posedge i_clk);
    apply_pattern({8'h0A, 8'h0A, 8'h0A, 8'h0A});
    EXPECT_EQ(o_detected, 1'b0, "Invalid pattern not detected");

    @(posedge i_clk);
    apply_pattern({8'h0A, 8'h0B, 8'h0C, 8'h0D});
    EXPECT_EQ(o_detected, 1'b1, "Second pattern detected");

    $finish();

end

endmodule
