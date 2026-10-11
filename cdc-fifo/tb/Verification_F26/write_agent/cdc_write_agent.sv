class cdc_write_agent #(parameter int DATA_WIDTH = 4) extends uvm_agent;
    `uvm_component_param_utils(cdc_write_agent #(DATA_WIDTH))

    // Component handles
    cdc_write_sequencer #(DATA_WIDTH) sequencer;
    cdc_write_driver    #(DATA_WIDTH) driver;
    cdc_write_monitor   #(DATA_WIDTH) monitor;

    // Constructor
    function new(string name = "cdc_write_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Build Phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sequencer = cdc_write_sequencer #(DATA_WIDTH)::type_id::create("sequencer", this);
        driver = cdc_write_driver #(DATA_WIDTH)::type_id::create("driver", this);
        monitor = cdc_write_monitor #(DATA_WIDTH)::type_id::create("monitor", this);
    endfunction

    // Connect Phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
endclass