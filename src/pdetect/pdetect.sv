/*******************************************************************************
* \file
* \brief A data stream pattern detector
*******************************************************************************/
module pdetect #(
    PATTERN = 32'h0A0B0C0D
)(
    input logic i_clk,
    input logic i_rst,
    input logic [7:0] i_data,
    output logic o_detected
);

logic [7:0] pipeline [3:0];

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
        pipeline <= {pipeline[$size(pipeline)-2:0], i_data};
    end
end

endmodule
