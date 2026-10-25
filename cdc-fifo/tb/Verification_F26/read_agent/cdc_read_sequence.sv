class cdc_read_sequence #(parameter int DATA_WIDTH = 4) extends uvm_sequence #(cdc_write_item #(DATA_WIDTH));

    `uvm_object_param_utils(cdc_write_sequence #(DATA_WIDTH))

    function new(string name = "cdc_write_sequence");
        super.new(name);
    endfunction

    task body();
        cdc_read_item #(DATA_WIDTH) item;
        repeat (10) begin
            item = cdc_read_item #(DATA_WIDTH)::type_id::create("item");
            start_item(item);
            if (!item.randomize())
                `uvm_fatal("RAND", "Randomization failed")
            finish_item(item);
        end
    endtask
endclass