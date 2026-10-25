class cdc_read_driver #(parameter int DATA_WIDTH = 4) extends uvm_driver #(cdc_read_item #(DATA_WIDTH));
    `uvm_component_param_utils(cdc_write_driver #(DATA_WIDTH))

    virtual cdc_fifo_if #(DATA_WIDTH) vif; // declares virtual intreface

    // Constructor
    function new(string name  = "cdc_read_driver", uvm_componeent parent = null);
        super.new(name, parent);
    endfunction

    // Build phase: Get virtual interface
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual cdc_fifo_if #(DATA_WIDTH))::get(this, "", "vif", vif))
        `uvm_fatal("NO_VIF", "Cannot retrieve virtual interface")
    endfunction

    // Run phase
endclass