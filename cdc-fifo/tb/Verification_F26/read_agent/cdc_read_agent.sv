class cdc_read_agent #(parameter int DATA_WIDTH = 4) extends uvm_agent;
    `uvm_component_param_utils(cdc_write_agent #(DATA_WIDTH))

    // Componenet Handles

    // Constructor
    function new(string name = "cdc_read_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Build Phase
    function void build_phase(uvm_phase phase)
        super.build_phase(phase);
        sequencer = 
        driver = 
        monitor = 
    endfunction

    //Connect Phase
    function void connect_phase(uvm_phase phase)
        super.connect_phase(phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
endclass