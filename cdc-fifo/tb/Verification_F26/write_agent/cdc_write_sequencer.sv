class cdc_write_sequencer #(parameter int DATA_WIDTH = 4) extends uvm_sequencer #(cdc_write_item #(DATA_WIDTH));

    `uvm_component_param_utils(cdc_write_sequencer #(DATA_WIDTH))
    function new(string name = "cdc_write_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction

endclass