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
    .PATTERN(32'hABCD)
) DUT (
    .*
);

initial begin : clocks
    i_clk = 0;
    forever #(CLK_T_2) i_clk = ~i_clk;
end

task automatic apply_pattern (
    input logic [31:0] pattern
);
    i_data = pattern[3];
    @(posedge i_clk);
    i_data = pattern[2];
    @(posedge i_clk);
    i_data = pattern[1];
    @(posedge i_clk);
    i_data = pattern[0];
    @(posedge i_clk);
endtask

initial begin : test_harness

    i_rst = 1;
    i_data = 0;

    @(posedge i_clk);
    i_rst = 0;

    repeat(10) @(posedge i_clk);

    apply_pattern({8'hA, 8'hB, 8'hC, 8'hD});
    EXPECT_EQ(o_detected, 1'b1, "Pattern detected");

    @(posedge i_clk);
    EXPECT_EQ(o_detected, 1'b0, "Pattern detectd deasserts");

    apply_pattern({8'hA, 8'hA, 8'hA, 8'hA});
    EXPECT_EQ(o_detected, 1'b0, "Invalid pattern not detected");

    $finish();

end

endmodule
