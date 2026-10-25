class cdc_fifo_basic_test extends uvm_test;

    `uvm_component_utils(cdc_fifo_basic_test)

    // Declare our components
    cdc_write_agent #(4) write_agent;
    cdc_write_sequence #(4) write_seq;

    // Constructor
    function new(string name = "cdc_fifo_basic_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Build Phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        write_agent = cdc_write_agent #(4)::type_id::create(
            "write_agent", this
        );
    endfunction

    // Run Phase
    task run_phase(uvm_phase phase);

        // TODO 1: Raise an objection
        phase.raise_objection(this, "Starting test stimulus");

        // TODO 2: Create the write sequence
        write_seq = cdc_write_sequence #(4)::type_id::create(
            "write_sequence", this
        );

        // TODO 3: Start the sequence on the write sequencer
        write_seq.start(write_agent.sequencer);

        // TODO 4: Drop the objection
        phase.drop_objection(this, "Ending test stimulus");

    endtask

endclass