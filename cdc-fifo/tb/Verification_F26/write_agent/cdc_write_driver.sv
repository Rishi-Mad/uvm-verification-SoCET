class cdc_write_driver #(parameter int DATA_WIDTH = 4) extends uvm_driver #(cdc_write_item #(DATA_WIDTH));

    `uvm_component_param_utils(cdc_write_driver #(DATA_WIDTH))

    virtual cdc_fifo_if #(DATA_WIDTH) vif; // declares virtual intreface

    // Constructor
    function new(string name = "cdc_write_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Build phase: Get virtual interface
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual cdc_fifo_if #(DATA_WIDTH))::get(this, "", "vif", vif))
        `uvm_fatal("NO_VIF", "Cannot retrieve virtual interface")
    endfunction

    // Run phase: Drive transactions to DUT
    task run_phase(uvm_phase phase);
        // Wait until write reset is released
        wait (vif.wnrst === 1'b1);

        forever begin
            seq_item_port.get_next_item(req); // Get transaction from sequencer

            // Synchronize to write clock and drive inputs
            @(vif.write_cb);
            vif.write_cb.wdata <= req.data;
            vif.write_cb.winc <= req.write_enable;

            @(vif.write_cb); // Hold inputs through the next rising edge
            vif.write_cb.winc <= 1'b0; // Return to idle
            seq_item_port.item_done(); // Notify sequencer that transaction is complete
        end
    endtask
endclass
