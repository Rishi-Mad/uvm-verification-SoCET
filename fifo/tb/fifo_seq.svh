import uvm_pkg::*;
`include "uvm_macros.svh"
`include "fifo_transaction.svh"

class fifo_seq #(type T = logic [7:0], parameter DEPTH = 8) extends uvm_sequence#(transaction);
    `uvm_object_utils(fifo_seq)

    function new(string name = "");
        super.new(name);
    endfunction //new()

    task body();
        transaction req_item;
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

class fifo_sequencer extends uvm_sequencer#(transaction);
    `uvm_component_utils(fifo_sequencer)

    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()
endclass //fifo_sequencer extends uvm_sequencer
