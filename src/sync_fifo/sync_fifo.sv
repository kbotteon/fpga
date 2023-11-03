/*******************************************************************************
* \file
* \brief A synchronous FIFO
*******************************************************************************/
`timescale 1ns/1ns

module sync_fifo #(
    parameter WIDTH = 16,
    parameter DEPTH = 16,
    parameter TARGET = "Xilinx"
)(
    input logic i_clk,
    input logic i_rst,
    // Write Bus
    input logic [WIDTH-1:0] i_data,
    input logic i_wren,
    output logic o_full,
    output logic o_werr,
    // Read Bus
    input logic i_rden,
    output logic [WIDTH-1:0] o_data,
    output logic o_empty,
    output logic o_rerr
);

localparam ADDR_WIDTH = $clog2(DEPTH)-1;

initial assert(WIDTH*DEPTH <= 1024)
    else $error("That's a pretty large LUTRAM");

//------------------------------------------------------------------------------
// Memories
//------------------------------------------------------------------------------

// Distributed RAM repurposes LUTs as RAM, which is more area efficient than
// using the limited flops in a CLB; use BRAM or true dual-port (async) FIFO
(* RAM_STYLE="distributed") logic [WIDTH-1:0] ram [0:DEPTH-1];

// If it's a Xilinx device, initialize the RAM in the bitfile
// FIXME: This works for BRAM, but does it also work for LUTRAM?
generate if(TARGET == "Xilinx") begin
    initial for(int addr = 0; addr < DEPTH; addr = addr+1) begin
        ram[addr] <= 0;
    end
end

//------------------------------------------------------------------------------
// Nets
//------------------------------------------------------------------------------

logic [ADDR_WIDTH:0] read_addr = 0;
logic [ADDR_WIDTH:0] write_addr = 0;
// The actual occupancy, not occupancy-1
logic [DEPTH:0] occupancy = 0;

logic read_allowed = 0;
logic write_allowed = 0;

//------------------------------------------------------------------------------
// Logic
//------------------------------------------------------------------------------

//
// Access permissions
//

always_comb begin
    write_allowed = occupancy < DEPTH;
    read_allowed = occupancy > 0;
end

//
// Occupancy
// We might want this as an output at some point anyway, and it'll help timing
always_ff@(posedge i_clk) begin
    if(i_rst) begin
        occupancy <= '0;
    end else begin
        if(write_allowed && i_wren) begin
            occupancy <= occupancy + 1;
        end else if(read_allowed && i_rden) begin
            occupancy <= occupancy - 1;
        end
    end
end


//
// Read and Write Pointers
//

// TODO: These should never pass one another
always_ff@(posedge i_clk) begin
    if(i_rst) begin
        read_addr <= 0;
        write_addr <= 0;
    end else begin
        // Read increments as current value is being read, when allowed
        if(i_rden && read_allowed) begin
            read_addr <= read_addr + 1;
        end
        // Write increments as current value is being written, when allowed
        if(i_wren && write_allowed) begin
            write_addr <= write_addr + 1;
        end
    end
end

//
// Ports
//

always_ff@(posedge i_clk) begin
    // FIXME: Can we reset LUTRAM?

    // Read port
    o_data <= ram[read_addr];

    // Write port
    if(i_wren) begin
        ram[write_addr] <= i_data;
    end
end

endmodule
