import uvm_pkg::*;
`include "uvm_macros.svh"
`include "environment.svh"

class test extends uvm_test; //Declare new class that derives from "uvm_test"
    `uvm_component_utils(test) //Register classs with UVM Factory
    
    function new(string name = "test", uvm_component parent = null); //Define "new" function
        super.new(name, parent);
    endfunction

    //Declare testbench components
    environment env; // testbench environment
    virtual sr_if vif;

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = environment::type_id::create("env", this);
        if (!uvm_config_db#(virtual sr_if)::get(this, "", "sr_vif", vif)) begin 
		   `uvm_fatal("TEST", "No virtual interface specified for this test instance")
		end 
		uvm_config_db#(virtual sr_if)::set(this, "env.agt*", "sr_vif", vif);

    endfunction

    task run_phase(uvm_phase phase);
        sr_sequence seq = sr_sequence::type_id::create("seq");
        phase.raise_objection(this);
        seq.start(env.agt.sqr);
        phase.drop_objection(this);
    endtask

    endclass
