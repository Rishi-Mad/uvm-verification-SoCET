class cdc_read_item #(parameter int DATA_WIDTH = 4) extends uvm_sequence_item;
//  extends uvm_seq_item means the class inherits the behavior of a UVM sequence item

    rand bit [DATA_WIDTH-1:0] data;
    rand bit read_enable;

    `uvm_object_param_utils(cdc_read_item #(DATA_WIDTH))  // allows uvm to create objects

    function new(string name = "cdc_read_item");
        super.new(name); // initializes the inherited object
    endfunction
endclass

// Define the write transaction