package cdc_fifo_pkg;

    // Import UVM classes
    import uvm_pkg::*;

    // Import UVM macros
    `include "uvm_macros.svh"

    // Write Agent Components
    `include "write_agent/cdc_write_item.sv"
    `include "write_agent/cdc_write_sequence.sv"
    `include "write_agent/cdc_write_sequencer.sv"
    `include "write_agent/cdc_write_driver.sv"
    `include "write_agent/cdc_write_monitor.sv"
    `include "write_agent/cdc_write_agent.sv"

    // UVM Tests
    `include "tests/cdc_fifo_basic_test.sv"

endpackage