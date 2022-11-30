import uvm_pkg::*;
`include "uvm_macros.svh"
`include "fifo_transaction.svh"

class coverage #(type T = logic [7:0], int DEPTH = 8) extends uvm_subscriber#(transaction#(T, DEPTH));
    `uvm_component_utils(coverage#(T, DEPTH))

    uvm_analysis_port#(transaction#(T, DEPTH)) cov_ap;
    transaction#(T,DEPTH) txn;

    covergroup fifo_inp_out;
        wdata_cp: coverpoint txn.wdata;
        wen_cp: coverpoint txn.WEN;
        cross_cp: cross wdata_cp, wen_cp;
    endgroup

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
        fifo_inp_out = new();
    endfunction //new()

    function void build_phase(uvm_phase phase);
        cov_ap = new("cov_ap", this);
    endfunction

    function void write(transaction#(T, DEPTH) t);
        this.txn = t;
        fifo_inp_out.sample(txn);
    endfunction
endclass //coverage extends uvm_subscriber
