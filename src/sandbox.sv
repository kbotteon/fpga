/*******************************************************************************
* \file
* \brief Wraps a DUT so we can inspect synthesis results
*
* Wrapping the DUT becomes important when we want to apply DONT_TOUCH or other
* attributes to preserve net names for inspection or otherwise control synthesis
*******************************************************************************/


module sandbox (
    (* DONT_TOUCH="TRUE" *)
    input i_clk,
    (* DONT_TOUCH="TRUE" *)
    input i_rst,
    (* DONT_TOUCH="TRUE" *)
    output o_result
);

localparam WIDTH = 12;

(* DONT_TOUCH="TRUE" *)
logic tmp1;
(* DONT_TOUCH="TRUE" *)
logic tmp2;
(* DONT_TOUCH="TRUE" *)
logic [WIDTH-1:0] tmp3;

(* DONT_TOUCH="TRUE" *)
counter #(
    .WIDTH(WIDTH)
) DUT (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .i_en(tmp1),
    .i_clear(tmp2),
    .o_count(tmp3)
);

endmodule
