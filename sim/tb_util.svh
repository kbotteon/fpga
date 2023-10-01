/*******************************************************************************
* Testbench Macros
*******************************************************************************/

//------------------------------------------------------------------------------
// Process Timeout
//
// Good for wrapping things that might hang
//
// Usage:
//   `BEGIN_TIMEOUT_FORK(1000, read_clock_net, "A message")
//        my_test_task();
//   `END_TIMEOUT_FORK
//------------------------------------------------------------------------------

`define BEGIN_TIMEOUT_FORK(cycles, ref_clk, msg) \
    fork begin \
        fork \
            begin \
                repeat(cycles) @(posedge ref_clk); \
                $error("Timeout: %s", msg); \
                $stop(); \
            end \
            begin

`define END_TIMEOUT_FORK \
            end \
        join_any \
        disable fork; \
    end join

//------------------------------------------------------------------------------
// Testbench Timeout
//
// Prevents runaway simulation stuck on something
//
// Usage:
//   `SET_SIM_TIMEOUT(10ms)
//------------------------------------------------------------------------------

`define SET_SIM_TIMEOUT(max_testbench_runtime) \
    initial begin \
        #(max_testbench_runtime); \
        $error("[ERR!] Simulation Timeout"); \
        $stop(); \
    end
