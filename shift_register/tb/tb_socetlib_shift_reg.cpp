#include "Vtb_socetlib_shift_reg.h"
#include "verilated.h"

int main(int argc, char **argv) {
    VerilatedContext *contextp = new VerilatedContext;

    contextp->traceEverOn(true);

    contextp->commandArgs(argc, argv);
    Vtb_socetlib_shift_reg *top = new Vtb_socetlib_shift_reg{contextp};


    while (!contextp->gotFinish()) {
        top->eval();

        if (!top->eventsPending()) break;
        contextp->time(top->nextTimeSlot());
    }

    top->final();

//    Verilated::mkdir("logs");
//    contextp->coveragep()->write("logs/coverage_test.dat");

    delete top;
    delete contextp;
    return 0;
}
