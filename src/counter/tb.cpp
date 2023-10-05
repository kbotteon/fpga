/*******************************************************************************
* Verilator testbench for counter.sv
*******************************************************************************/
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vtb.h"

int main(int argc, char** argv)
{
    VerilatedContext* context = new VerilatedContext;
    context->commandArgs(argc, argv);
    Vtb* dut = new Vtb(context);

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;

    dut->trace(tfp, 10);
    tfp->open("wave.vcd");

    unsigned cycle = 0;
    while(!context->gotFinish())
    {
        dut->eval();
        if(tfp)
        {
            tfp->dump(cycle);
            cycle++;
        }
        if(cycle > 1000)
        {
            break;
        }
    }

    dut->final();

    delete dut;

    return 0;
}
