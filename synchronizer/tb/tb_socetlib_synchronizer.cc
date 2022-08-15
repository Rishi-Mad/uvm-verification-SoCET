#include <iostream>

#include "verilated.h"
#include "verilated_vcd_c.h"
#include "verilated_cov.h"
#include "Vsocetlib_synchronizer.h"

vluint64_t sim_time = 0;


void tick(Vsocetlib_synchronizer& dut, VerilatedVcdC& trace) {
    dut.CLK = 0;
    dut.eval();
    trace.dump(sim_time);
    sim_time++;
    dut.CLK = 1;
    dut.eval();
    trace.dump(sim_time);
    sim_time++;
}

void reset(Vsocetlib_synchronizer& dut, VerilatedVcdC& trace) {
    dut.CLK = 0;
    dut.nRST = 1;
    dut.async_in = 0;
    
    tick(dut, trace);
    dut.nRST = 0;
    tick(dut, trace);
    dut.nRST = 1;
    tick(dut, trace);
}


int main(int argc, char **argv) {
    Vsocetlib_synchronizer dut;
    VerilatedVcdC m_trace;

    Verilated::traceEverOn(true);
    dut.trace(&m_trace, 5);
    m_trace.open("socetlib_synchronizer.vcd");

    
    reset(dut, m_trace);

    for(int i = 0; i < 32; i++) {
        dut.async_in = ~dut.async_in;
        tick(dut, m_trace);
    }

    Verilated::threadContextp()->coveragep()->write("coverage.dat");

    m_trace.close();
    
    return 0;
}
