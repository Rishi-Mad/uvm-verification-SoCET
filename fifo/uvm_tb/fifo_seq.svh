import uvm_pkg::*;
`include "uvm_macros.svh"
`include "fifo_transaction.svh"

class fifo_seq #(type T = logic [7:0], int DEPTH = 8) extends uvm_sequence#(transaction#(T, DEPTH));
    `uvm_object_utils(fifo_seq#(T, DEPTH))

    function new(string name = "");
        super.new(name);
    endfunction //new()

    task body();
        transaction#(T, DEPTH) req_item;
        req_item = transaction#(T, DEPTH)::type_id::create("req_item");

        repeat(10001) begin  // parameterize
            start_item(req_item);
            if (!req_item.randomize()) begin
                `uvm_fatal("FIFO_Sequence", "Unable to randomize")
            end
            finish_item(req_item);
        end
    endtask
endclass //fifo_seq extends uvm_sequence

class fifo_sequencer#(type T = logic [7:0], int DEPTH = 8) extends uvm_sequencer#(transaction#(T, DEPTH));
    `uvm_component_utils(fifo_sequencer#(T, DEPTH))

    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()
endclass //fifo_sequencer extends uvm_sequencer
