/*******************************************************************************
* \file
* \brief HDL equivalent of std::memcpy() in C
*******************************************************************************/
`timescale C_TIMESCALE

module memcpy #(
    parameter DWIDTH = 12 // Data bus width
)(
    input logic i_clk,
    input logic i_rst,
    // Command Port ------------------------------------------------------------
    input integer i_src_addr,
    input integer i_dst_addr,
    input integer i_len,
    input logic i_go,
    output logic o_done,
    // Memory Port -------------------------------------------------------------
    input logic i_mem_ready,
    input [DWIDTH-1:0] i_mem_data,
    output logic o_mem_strobe,
    output logic o_mem_wrn, // Write/Read'
    output integer o_mem_addr,
    output logic [DWIDTH-1:0] o_mem_data
);

typedef enum integer {
    S_IDLE,
    S_LOAD,
    S_READ_CMD,
    S_READ_WAIT,
    S_WRITE_CMD,
    S_WRITE_WAIT,
    S_UPDATE
} state_t;

//------------------------------------------------------------------------------
// Nets
//------------------------------------------------------------------------------

// State machine
state_t current_state = S_IDLE;
state_t next_state;

// State nets
logic idle;
logic update;

// Address registers
integer read_addr = 0;
integer write_addr = 0;
integer count = 0;

// Data staging
logic [DWIDTH-1:0] staged_data;

//------------------------------------------------------------------------------
// Output Registers
//------------------------------------------------------------------------------

always_ff@(posedge i_clk) begin : output_regs
    if(i_rst) begin
        o_done <= 0;
        o_mem_wrn <= 0;
        o_mem_strobe <= 0;
        o_mem_addr <= 0;
        o_mem_data <= 0;
    end else begin

        if(next_state == S_IDLE) begin
            o_done <= 1;
        end else begin
            o_done <= 0;
        end

        if(next_state == S_WRITE_CMD) begin
            o_mem_wrn <= 1;
        end else begin
            o_mem_wrn <= 0;
        end

        if(next_state == S_READ_CMD || next_state == S_WRITE_CMD) begin
            o_mem_strobe <= 1;
        end else begin
            o_mem_strobe <= 0;
        end

        if(next_state == S_READ_CMD) begin
            o_mem_addr <= read_addr;
        end else if(next_state == S_WRITE_CMD) begin
            o_mem_addr <= write_addr;
        end

        if(next_state == S_WRITE_CMD) begin
            o_mem_data <= staged_data;
        end

    end
end

//------------------------------------------------------------------------------
// State Registers
//------------------------------------------------------------------------------

always_ff@(posedge i_clk) begin : counters
    if(i_rst) begin
        read_addr <= '0;
        write_addr <= '0;
        count <= '0;
    end else begin
        // Ignore i_go if operation is underway
        if(i_go && idle) begin
            read_addr <= i_src_addr;
            write_addr <= i_dst_addr;
            count <= i_len;
        end else begin
            if(update && count != 0) begin
                read_addr <= read_addr + 1;
                write_addr <= write_addr + 1;
                count <= count - 1;
            end
        end
    end
end

always_ff@(posedge i_clk) begin : data_staging
    // Reset not required
    if(current_state == S_READ_WAIT && i_mem_ready) begin
        data_staging <= i_mem_data;
    end
end

// TODO: Timeout counter, for states that wait on i_mem_ready
// counter #(.WIDTH(...)) timeout_counter();

//------------------------------------------------------------------------------
// State Machine
//------------------------------------------------------------------------------

always_comb begin : state_nets
    idle = current_state == S_IDLE;
    update = current_state == S_UPDATE;
end

always_ff@(posedge i_clk) begin : state_reg
    if(i_rst) begin
        current_state <= S_IDLE;
    end else begin
        current_state <= next_state;
    end
end

always_comb begin : state_transitions

    next_state = S_IDLE;

    case(current_state)

        S_IDLE : begin
            next_state = S_LOAD;
        end

        S_LOAD : begin
            if(i_mem_ready) begin
                next_state = S_READ_CMD;
            end
        end

        S_READ_CMD : begin
            next_state = S_READ_WAIT;
        end

        S_READ_WAIT : begin
            if(i_mem_ready) begin
                next_state = S_WRITE_CMD;
            end
        end

        S_WRITE_CMD : begin
            next_state = S_WRITE_WAIT;
        end

        S_WRITE_WAIT : begin
            if(i_mem_ready) begin
                next_state = S_UPDATE;
            end
        end

        S_UPDATE : begin
            if(count == 0) begin
                next_state = S_IDLE;
            end else begin
                next_state = S_READ_CMD;
            end
        end

        default : begin
            assert(0);
        end

    endcase

end

//------------------------------------------------------------------------------

endmodule
