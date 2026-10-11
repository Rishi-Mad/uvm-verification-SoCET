class cdc_write_sequence #(parameter int DATA_WIDTH = 4) extends uvm_sequence #(cdc_write_item #(DATA_WIDTH));

    `uvm_object_param_utils(cdc_write_sequence #(DATA_WIDTH))

    function new(string name = "cdc_write_sequence");
        super.new(name);
    endfunction

    task body();
        cdc_write_item #(DATA_WIDTH) item;
        repeat (10) begin
            item = cdc_write_item #(DATA_WIDTH)::type_id::create("item");
            start_item(item);
            if (!item.randomize())
                `uvm_fatal("RAND", "Randomization failed")
            finish_item(item);
        end
    endtask
endclass

// Create: Make a new transaction object.
// Start: Request permission from the sequencer to send it.
// Randomize: Generate random values for data and write_enable.
// Finish: Send the transaction to the driver through the sequencer, waiting for driver completion.