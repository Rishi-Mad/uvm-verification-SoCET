

module socetlib_fifo #(
    parameter WIDTH = 8, // bits per data word
    parameter DEPTH = 8, // total FIFO entries
    parameter ADDR_BITS = $clog2(DEPTH)
)(
    input CLK,
    input nRST,
    input WEN,
    input REN,
    input clear,
    input [WIDTH-1:0] wdata,
    output logic full,
    output logic empty,
    output logic underrun, 
    output logic overrun,
    output logic [ADDR_BITS-1:0] count,
    output logic [WIDTH-1:0] rdata
);

    // Parameter checking
    //
    // Width can be any number of bits > 1, but depth must be a power-of-2 to accomodate addressing scheme
    // Address bits should not be changed by the user.
    generate
        if(WIDTH < 1) begin
            $error("%m: WIDTH must be >= 1!");
        end

        if(DEPTH == 0 || (DEPTH & (DEPTH - 1) != 0)) begin
            $error("%m: DEPTH must be a power of 2 >= 1!");
        end

        if(ADDR_BITS != $clog2(DEPTH)) begin
            $error("%m: ADDR_BITS is automatically calculated, please do not override!");
        end
    endgenerate
    
    // FIFO data word internal typedef 
    typedef logic [WIDTH-1:0] FIFOWord;
    
    logic full_internal, full_next, empty_internal, empty_next;
    logic overrun_next, underrun_next;
    logic [ADDR_BITS-1:0] write_ptr, write_ptr_next, read_ptr, read_ptr_next;
    FIFOWord [DEPTH-1:0] fifo, fifo_next;

    always_ff @(posedge CLK, negedge nRST) begin
        if(!nRST) begin
            fifo <= '{default: '0};
            write_ptr <= '0;
            read_ptr <= '0;
            full_internal <= 1'b0;
            empty_internal <= 1'b1;
            overrun <= 1'b0;
            underrun <= 1'b0;
        end else begin
            fifo <= fifo_next;
            write_ptr <= write_ptr_next;
            read_ptr <= read_ptr_next;
            full_internal <= full_next;
            empty_internal <= empty_next;
            overrun <= overrun_next;
            underrun <= underrun_next;
        end
    end

    always_comb begin
        fifo_next = fifo;
        full_next = full_internal;
        empty_next = empty_internal;
        write_ptr_next = write_ptr;
        read_ptr_next = read_ptr;
        overrun_next = overrun;
        underrun_next = underrun;

        if(clear) begin
            // No need to actually reset FIFO data,
            // changing pointers/flags to "empty" state is OK
            full_next = 1'b0;
            empty_next = 1'b1;
            write_ptr_next = '0;
            read_ptr_next = '0;
            overrun_next = 1'b0;
            underrun_next = 1'b0;
        end else begin
            if(REN && !empty) begin
                read_ptr_next = read_ptr + 1;
                full_next = 1'b0;
                empty_next = (read_ptr_next == write_ptr_next);
            end else if(REN && empty) begin
                underrun_next = 1'b1;
            end

            if(WEN && !full) begin
                write_ptr_next = write_ptr + 1;
                fifo_next[write_ptr] = wdata;
                empty_next = 1'b0;
                full_next = (write_ptr_next == read_ptr_next);
            end else if(WEN && full) begin
                overrun_next = 1'b1;
            end
        end
    end

    //assign count = (write_ptr > read_ptr) ? (write_ptr - read_ptr) : (ADDR_BITS - (read_ptr - write_ptr));
    assign count = write_ptr - read_ptr;
    assign rdata = fifo[read_ptr];

    assign full = full_internal;
    assign empty = empty_internal;


endmodule
