/*******************************************************************************
* \file
* \brief A synchronous FIFO
*******************************************************************************/
`timescale C_TIMESCALE

module sync_fifo #(
    parameter WIDTH = 16,
    parameter DEPTH = 16,
    parameter TARGET = "Xilinx"
)(
    input logic i_clk,
    input logic i_rst,
    // Write Bus
    input logic [WIDTH-1:0] i_data,
    input logic i_wr_en,
    output logic o_full,
    output logic o_wr_err,
    // Read Bus
    input logic i_rd_incr,
    output logic [WIDTH-1:0] o_data,
    output logic o_empty,
    output logic o_rd_err
);

localparam ADDR_WIDTH = $clog2(DEPTH)-1;

initial assert(WIDTH <= 256*8196)
    else $error("That's a massive FIFO");

//------------------------------------------------------------------------------
// Nets
//------------------------------------------------------------------------------

logic [ADDR_WIDTH-1:0] read_addr = 0;
logic [ADDR_WIDTH-1:0] write_addr = 0;
logic [ADDR_WIDTH:0] occupancy = 0;

logic do_read;
logic read_allowed;
logic do_write;
logic write_allowed;

//------------------------------------------------------------------------------
// Memories
//------------------------------------------------------------------------------

// In Xilinx devices, distributed RAM repurposes CLBs into a RAM with density
// between using CLB flops and BRAM
(* RAM_STYLE="DISTRIBUTED" *) logic [WIDTH-1:0] ram [0:DEPTH-1];

// Xilinx devices can initialize CLBs and BRAMs using the bitstream
generate
    if(TARGET == "Xilinx") begin
        initial for(int addr = 0; addr < DEPTH; addr = addr + 1) begin
            ram[addr] = 0;
        end
    end
endgenerate

// Write access
always_ff@(posedge i_clk) begin
    if(i_wr_en) begin
        ram[write_addr] <= i_data;
    end
end

// Read access
always_ff@(posedge i_clk) begin
    if(i_rst) begin
        o_data <= '0;
    end else begin
        o_data <= ram[read_addr]
    end
end

//------------------------------------------------------------------------------
// Logic
//------------------------------------------------------------------------------

always_comb begin : access_triggers
    do_read == i_rd_incr && read_allowed;
    do_write = i_wr_en && write_allowed;
end

always_comb begin : access_permissions
    write_allowed = occupancy != DEPTH;
    read_allowed = occupancy != 0;
end

always_ff@(posedge i_clk) begin : occupancy_counter
    if(i_rst) begin
        occupancy <= '0;
    end else begin
        if(do_read && !do_write) begin
            occupancy <= occupancy + 1;
        end else if(do_write && !do_read) begin
            occupancy <= occupancy - 1;
        end else begin // if((do_write && do_read) || (!do_write && !do-read))
            occupancy <= occupancy;
        end
    end
end

always_ff@(posedge i_clk) begin : access_pointers
    if(i_rst) begin
        read_addr <= '0;
        write_addr <= '0;
    end else begin
        // Read pointer
        if(do_read) begin
            // Roll over the counter
            if(read_addr == DEPTH-1) begin
                read_addr <= '0;
            end else begin
                read_addr <= read_addr + 1;
            end
        end
        // Write pointer
        if(do_write) begin
            // Roll over the counter
            if(write_addr == DEPTH-1) begin
                write_addr <= '0;
            end else begin
                write_addr <= write_addr + 1;
            end
        end
    end
end

//------------------------------------------------------------------------------

endmodule
