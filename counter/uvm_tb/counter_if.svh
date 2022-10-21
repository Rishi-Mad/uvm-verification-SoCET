`ifndef COUNTER_IF_SVH
`define COUNTER_IF_SVH

interface counter_if #(parameter NBITS = 4) (input logic CLK);

    logic clear;
    logic nRST;
    logic count_enable;
    logic [NBITS - 1 : 0] overflow_val;
    logic [NBITS - 1 : 0] count_out;
    logic [NBITS - 1 : 0] overflow_flag; // Shouldn't this just be logic?
    logic check; // check result if high
    int enable_time; // clock cycles to run count_enable

    modport tester
    (
        input count_out, overflow_flag, CLK;
        output nRST, clear, count_enable, overflow_val, check, enable_time
    );

    modport counter
    (
        output count_out, overflow_flag,
        input nRST, clear, count_enable, overflow_flag, CLK
    );
endinterface

`endif
