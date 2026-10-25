
class cdc_write_monitor #(parameter int DATA_WIDTH = 4) extends uvm_monitor;

    `uvm_component_param_utils(cdc_write_monitor #(DATA_WIDTH))
    virtual cdc_fifo_if #(DATA_WIDTH) vif;

    uvm_analysis_port #(cdc_write_item #(DATA_WIDTH)) ap;

    // Constructor
    function new(string name = "cdc_write_monitor", uvm_component parent = null);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    // Build Phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual cdc_fifo_if #(DATA_WIDTH))::get(this, "", "vif", vif))
            `uvm_fatal("NO_VIF", "Cannot retrieve virtual interface")
    endfunction

    // Run Phase
    task run_phase(uvm_phase phase);

        cdc_write_item #(DATA_WIDTH) observed_item;

        forever begin
            // Wait for write clock event
            @(vif.write_cb);

            // Check whether the FIFO accepted a write
            if (vif.wnrst === 1'b1 && vif.write_cb.winc === 1'b1 && vif.write_cb.wfull === 1'b0) begin
                // Create a transaction containing observed data
                observed_item = cdc_write_item #(DATA_WIDTH)::type_id::create("observed_item");
                observed_item.data = vif.write_cb.wdata;
                observed_item.write_enable = 1'b1;

                // Print accepted write
                `uvm_info("WRITE_MON", $sformatf("Accepted write: data = %h", observed_item.data), UVM_MEDIUM)

                // Send transaction to scoreboard
                ap.write(observed_item);
            end
    endtask
endclass
