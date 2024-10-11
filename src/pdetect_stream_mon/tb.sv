/*******************************************************************************
* \brief Testbench for pdetect.sv
* \copyright 2024 Kyle Botteon
* \copyright This file is part of HERMIT. Refer to LICENSE in the repository.
*******************************************************************************/
`timescale 1ns/1ns

module tb;

import tb_util::*;

parameter CLK_T_2 = 5ns;

logic i_clk;
logic i_rst;
logic [7:0] i_m_data;
logic i_m_valid;
logic o_m_ready;
logic [7:0] o_s_data;
logic o_s_valid;
logic i_s_ready;
logic o_detected;

pdetect_stream_mon #(
    .PATTERN(32'h0A0B0C0D)
) DUT (
    .*
);

initial begin
    i_clk <= 0;
    forever #(CLK_T_2) i_clk <= ~i_clk;
end

task automatic apply_pattern (
    input logic [31:0] pattern
);
    i_m_valid <= 1;
    i_m_data <= pattern[31:24];
    @(posedge i_clk);
    i_m_data <= pattern[23:16];
    @(posedge i_clk);
    i_m_data <= pattern[15:8];
    @(posedge i_clk);
    i_m_data <= pattern[7:0];
    @(posedge i_clk);
    i_m_valid <= 0;
    @(posedge i_clk);
endtask

initial begin : test_harness

    i_m_data <= 0;
    i_m_valid <= 0;
    // Assume subordinate is always ready
    i_s_ready <= 1;

    i_rst <= 1;
    repeat(10) @(posedge i_clk);

    i_rst <= 0;
    repeat(10) @(posedge i_clk);

    apply_pattern({8'h0A, 8'h0B, 8'h0C, 8'h0D});
    EXPECT_EQ(o_detected, 1'b1, "Pattern detected");

    @(posedge i_clk);
    EXPECT_EQ(o_detected, 1'b1, "Pattern detected does not deassert while pipeline stalled");

    apply_pattern({8'h0F, 8'h0F, 8'h0F, 8'h0F});
    EXPECT_EQ(o_detected, 1'b0, "Invalid pattern not detected");

    apply_pattern({8'h0A, 8'h0B, 8'h0C, 8'h0D});
    EXPECT_EQ(o_detected, 1'b1, "Second pattern detected");

    $finish();

end

endmodule
