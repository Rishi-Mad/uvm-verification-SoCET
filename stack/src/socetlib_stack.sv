

module socetlib_stack #(
    parameter type T = logic [7:0],
    parameter DEPTH = 8,
    parameter ADDR_BITS = $clog2(DEPTH)
)(
    input CLK,
    input nRST,
    input push,
    input pop,
    input clear,
    input T wdata,
    output logic empty,
    output logic full,
    output logic overflow,
    output logic underflow,
    output logic [ADDR_BITS:0] count,
    output T rdata
);

    generate
`ifndef QUARTUS
        if(DEPTH < 1 || (DEPTH & (DEPTH - 1)) != 0) begin
            $error("%m: DEPTH must be a power of 2 greater than 0");
        end

        if(ADDR_BITS != $clog2(DEPTH)) begin
            $error("%m: ADDR_BITS is an automatically computed value and should not be changed.\n");
        end
`endif
    endgenerate

    T [DEPTH-1:0] stack, stack_next;
    logic [ADDR_BITS:0] ptr, ptr_next; // true occupancy count, clamped to [0, DEPTH]
    logic [ADDR_BITS-1:0] windex, windex_next; // circular write/read index into `stack`
    logic overflow_next, underflow_next;

    always_ff @(posedge CLK, negedge nRST) begin
        if(!nRST) begin
            stack <= '{default: '0};
            ptr <= '0;
            windex <= '0;
            overflow <= 1'b0;
            underflow <= 1'b0;
        end else begin
            stack <= stack_next;
            ptr <= ptr_next;
            windex <= windex_next;
            overflow <= overflow_next;
            underflow <= underflow_next;
        end
    end

    // ptr/windex used to be a single combined register (array index, occupancy
    // count, and full/empty guard bit all in one), updated unconditionally as
    // `ptr + push - pop`. It let a pop-while-empty wrap to all-1s
    // (spuriously reporting full) and let sustained push-while-full climb
    // past 2*DEPTH-1 and wrap back through 0 (spuriously deasserting full
    // after DEPTH consecutive overflowing pushes). Fixed by splitting the two 
    // responsibilities: `windex` is a pure circular buffer index (always wraps), 
    // and `ptr` is the true occupancy count, clamped at 0 and DEPTH.
    always_comb begin
        stack_next = stack;
        ptr_next = ptr;
        windex_next = windex;
        overflow_next = overflow;
        underflow_next = underflow;

        if(clear) begin
            ptr_next = '0;
            windex_next = '0;
            overflow_next = 1'b0;
            underflow_next = 1'b0;
        end else begin
            overflow_next = (full && push);
            underflow_next = (empty && pop);
            if(push) begin
                // A lone push appends at the next-empty slot (windex). A
                // simultaneous push+pop doesn't add a slot (occupancy is
                // unchanged), it swaps the *current top* (windex-1) in
                // place.
                stack_next[pop ? (windex - 1'b1) : windex] = wdata;
            end
            windex_next = windex + ADDR_BITS'(push) - ADDR_BITS'(pop);

            if(push && !pop) begin
                ptr_next = full ? ptr : ptr + 1'b1;
            end else if(pop && !push) begin
                ptr_next = empty ? ptr : ptr - 1'b1;
            end
        end
    end


    assign rdata = stack[windex - 1];
    assign count = ptr;

    assign empty = (count == 0);
    assign full = count[ADDR_BITS];

endmodule
