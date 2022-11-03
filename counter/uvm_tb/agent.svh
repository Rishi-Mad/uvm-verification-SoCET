import uvm_pkg::*;
`include "uvm_macros.svh"
`include "sequence.svh"
`include "driver.svh"
`include "monitor.svh"

class agent extends uvm_agent;
    `uvm_components_util(agent)

    sequencer sqr;
    driver drv;
    monitor mon;

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        sqr = sequence::type_id::create("sqr", this);
        drv = driver::type_id::create("drv", this);
        mon = monitor::type_id::create("mon", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        drv.seq_item.port.connect(sqr.seq_item_export);
    endfunction

endclass
