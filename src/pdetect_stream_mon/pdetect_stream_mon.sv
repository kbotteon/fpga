/*******************************************************************************
* \file
* \brief A data stream pattern detector
*
* Detects a pattern in a data stream as a bus monitor i.e. there is no pipeline
* delay for the data or control signals, and the detected signal will lag the
* data being passed through.
*
* Use pdetect_stream_dly if your downstream logic relies on o_detected.
*
* \copyright 2024 Kyle Botteon
* \copyright This file is part of HERMIT. Refer to LICENSE in the repository.
*******************************************************************************/
module pdetect_stream_mon #(
    PATTERN = 32'h0A0B0C0D
)(
    input logic i_clk,
    input logic i_rst,

    // Manager Stream I/F
    input logic [7:0] i_m_data,
    input logic i_m_valid,
    output logic o_m_ready,

    // Subordinate Stream I/F
    output logic [7:0] o_s_data,
    output logic o_s_valid,
    input logic i_s_ready,

    // Discretes
    output logic o_detected
);

logic [7:0] pipeline [3:0];
logic pipeline_enable;

// For a bus monitor, the stream itself can be wired through, and we'll enable
// our pipeline when data get propagated
always_comb begin
    o_m_ready = i_s_ready;
    o_s_valid = i_m_valid;
    o_s_data = i_m_data;
end

always_comb begin
    pipeline_enable = i_s_ready && i_m_valid;
end

always_comb begin
    o_detected =
        pipeline[3] == PATTERN[31:24] &&
        pipeline[2] == PATTERN[23:16] &&
        pipeline[1] == PATTERN[15:8] &&
        pipeline[0] == PATTERN[7:0];
end

always_ff@(posedge i_clk) begin
    if(i_rst) begin
        for(int stage = 0; stage < $size(pipeline); stage = stage + 1) begin
            pipeline[stage] <= 0;
        end
    end else begin
        if(pipeline_enable) begin
            pipeline <= {pipeline[$size(pipeline)-2:0], i_m_data};
        end
    end
end

endmodule
