`include "socetlib_counter.sv"
`include "counter_if.svh"
`include "test.svh"

`timescale 1ns/1ps

import uvm_pkg::*;

module tb_counter ();
    logic clk;

    initial begin
        clk = 0;
        forever #10 clk = !clk;
    end

    counter_if ctr_if(clk);
    
    socetlib_counter counter(ctr_if.counter);

    initial begin
        uvm_config_db#(virtual counter_if)::set(null, "", "vif", ctr_if);
        run_test("test");
    end
endmodule
