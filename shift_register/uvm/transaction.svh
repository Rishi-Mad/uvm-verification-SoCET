`ifndef TRANSACTION_SVH
`define TRANSACTION_SVH

import uvm_pkg::*;
`include "uvm_macros.svh"

class transaction #(parameter BITS_WIDTH = 4) extends uvm_sequence_item;
    rand bit [BITS_WIDTH - 1 : 0] parallel_in;
    rand bit serial_in;
    rand bit shift_en;
    rand bit parallel_en;

    bit [BITS_WIDTH - 1 : 0] parallel_out;
    bit serial_out;


    `uvm_object_utils_begin(transaction)
        
    `uvm_object_utils_end

    constraint parallel {parallel_in <= 2**(BITS_WIDTH - 1); parallel_in >= 0;}
    //constraint serial_in{num_clk > 0; num_clk < 20;}

    function new(string name = "transaction");
        super.new(name);
    endfunction: new

endclass

`endif
