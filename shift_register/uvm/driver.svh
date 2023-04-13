import uvm_pkg::*;
`include "uvm_macros.svh"
`include "sr_if.svh"

class driver extends uvm_driver#(transaction);
    `uvm_component_utils(driver)

    virtual sr_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual counter_if)::get(this, "", "counter_vif", vif)) begin
            `uvm_fatal("Driver", "No virtual interface specified for this test instance");
        end
    endfunction

    task run_phase(uvm_phase phase);
        transaction req_item;
        //DUT_reset();
        super.run_phase(phase);
        vif.check = 0;

        forever begin
            seq_item_port.get_next_item(req_item);
            DUT_reset();
            vif.shift_en = req_item.shift_en;
            vif.serial_in = req_item.serial_in;
            vif.parallel_in = req_item.parallel_in;
            vif.parallel_en = req_item.parallel_en;
            
            repeat(req_item.num_clk) begin
                @(posedge vif.clk);
            end
            vif.shift_en = 0;
            vif.parallel_en = 0;
            #(0.2)
            vif.check = 1;
            @(posedge vif.clk);
            seq_item_port.item_done();
        end
    endtask

    task DUT_reset();
        vif.check = 0;
        @(posedge vif.clk);
        vif.nRST = 1;
        vif.shift_en = 0;
        vif.parallel_en = 0;
        @(posedge vif.clk);
        vif.nRST = 0;
        @(posedge vif.clk); 
        vif.nRST = 1;
        @(posedge vif.clk);
    endtask
endclass
