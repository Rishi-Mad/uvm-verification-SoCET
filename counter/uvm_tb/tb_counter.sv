// INCLUDES

`include "~/digital-lib/counter/src/socetlib-counter.sv"
`include "counter_if.sv"

`timescale 1ns/1ps

import uvm_pck::*;
module tb_counter ();
    logic clk;

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    counter_if counterif(clk);    
endmodule
