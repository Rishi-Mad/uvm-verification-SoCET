`ifndef TEST_SVH
`define TEST_SVH

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "environment.svh"

class test extends uvm_test;
    `uvm_component_utils(test)
    environment env;
    virtual fifo_if vif;
    fifo_seq f_seq;
    clk_seq c_seq;

    function new(string name = "test", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = environment#()::type_id::create("env", this);
        f_seq = fifo_seq#()::type_id::create("f_seq", this);
        c_seq = clk_seq#(5)::type_id::create("c_seq", this);

        if (!uvm_config_db#(virtual fifo_if)::get(this, "", "fifo_vif", vif)) begin
            `uvm_fatal("Test", "No virtual interface specified for this test instance")
        end

        uvm_config_db#(virtual fifo_if)::set(this, "env.agt*", "fifo_vif", vif);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this, "Starting run_phase");
        $display("%t Starting sequence...", $time);
        fork
            begin
                c_seq.start(env.clk_agt.sqr);
            end
            begin
                f_seq.start(env.fifo_agt.sqr);
            end
        join
        #10ns
        phase.drop_objection(this, "Finished run_phase");
    endtask
endclass: test //test extends uvm_test

`endif
