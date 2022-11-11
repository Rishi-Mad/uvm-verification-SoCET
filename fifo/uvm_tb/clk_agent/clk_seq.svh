import uvm_pkg::*;
`include "uvm_macros.svh"
`include "clk_transaction.svh"
`timescale 1ns/1ns

class clk_seq#(PERIOD = 20) extends uvm_sequence#(clk_transaction);
    `uvm_object_utils(clk_seq#(PERIOD))

    function new(string name = "");
        super.new(name);
    endfunction //new()

    task body();
        clk_transaction req_item;
        req_item = clk_transaction::type_id::create("req_item");
    
        repeat(10001) begin
            #(PERIOD/2)
            start_item(req_item);
            req_item.clk = 1;
            finish_item(req_item);
            #(PERIOD/2)
            start_item(req_item);
            req_item.clk = 0;
            finish_item(req_item);
        end
    endtask
endclass //clk_seq extends uvm_sequence

class clk_sequencer extends uvm_sequencer#(clk_transaction);
    `uvm_component_utils(clk_sequencer)

    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()
endclass //clk_sequencer extends uvm_sequencer
