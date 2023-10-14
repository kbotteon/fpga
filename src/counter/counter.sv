/*******************************************************************************
* \file
* \brief A simple up-counter with synchronous clear and enable
*******************************************************************************/

module counter #(
    parameter WIDTH=10
)(
    input logic i_clk,
    input logic i_rst,
    input logic i_en,
    input logic i_clear,
    output logic [WIDTH-1:0] o_count
);

type(o_count) count;
type(o_count) next_count;

always_comb begin : output_wires
    o_count = count;
end

always_comb begin
    // i_en has priority below, so we mux in 0 here too
    if(i_clear) begin
        next_count = 0;
    end else begin
        next_count = count + 1;
    end
end

always_ff@(posedge i_clk) begin
    if(i_rst) begin
        count <= 0;
    end else if(i_en) begin
        count <= next_count;
    end else if (i_clear) begin
        count <= 0;
    end
end

endmodule
