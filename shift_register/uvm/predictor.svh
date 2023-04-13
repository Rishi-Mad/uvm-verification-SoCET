import uvm_pkg::*;
`include "uvm_macros.svh"
`include "transaction.svh"

class predictor extends uvm_subscriber #(transaction);
    `uvm_component_utils(predictor)
    
    uvm_analysis_port #(transaction) pred_ap;
    transaction output_tx;

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        pred_ap = new("pred_ap", this);
    endfunction




endclass: predictor
