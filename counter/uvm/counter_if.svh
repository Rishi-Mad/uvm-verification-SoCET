interface counter_if #(parameter BITS_WIDTH) (input logic clk);
    logic nRST;
    logic clear;
    logic count_enable;
    logic [BITS_WIDTH - 1 : 0] overflow_val;
    logic [BITS_WIDTH - 1 : 0] count_out;
    logic overflow_flag;

modport test ( // test
    input overflow_flag,count_out,
    output nRST, clear, count_enable, overflow_val
);

modport counter ( // DUT
    output overflow_flag, count_out,
    input overflow_val, count_enable, clear, nRST
);
