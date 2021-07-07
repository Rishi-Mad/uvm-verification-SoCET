`include "apb_if.vh"

module apb_completer #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter BASE_ADDR = 'h8000_0000,
    parameter NWORDS = 4, // # of bytes of address space to cover
    apb_pkg::APBAccessControl [NWORDS-1:0] PERMISSIONS = '0
)(
    apb_if.completer apbif,
    input stall,
    input logic [DATA_WIDTH-1:0] wdata,
    output logic WEN,
    output logic REN,
    output logic [(ADDR_WIDTH/8)-1:0] byte_enable,
    output logic [ADDR_WIDTH-1:0] offset,
    output logic [DATA_WIDTH-1:0] rdata
);

    import apb_pkg::*;


    APBState state, state_next;
    APBAccessControl request_permissions;

    logic [ADDR_WIDTH-1:0] offset_next;
    logic WEN_next, REN_next;
    logic byte_enable_next;
    logic error;

    always_ff @(posedge apbif.PCLK, negedge apbif.PRESETn) begin
        if(!apbif.PRESETn) begin
            state <= IDLE;
            byte_enable <= '0;
            WEN <= 1'b0;
            REN <= 1'b0;
            offset <= '0;
        end else begin
            state <= state_next;
            byte_enable <= byte_enable_next;
            WEN <= WEN_next;
            REN <= REN_next;
            offset <= offset_next;
        end
    end

    always_comb begin : STATE_UPDATE
        casez(state)
            IDLE: begin
                if(apbif.PSEL && error) begin
                    state_next = ERROR;
                end else if(apbif.PSEL && !error) begin
                    state_next = ACCESS;
                end else begin
                    state_next = IDLE;
                end
            end

            ACCESS: begin
                if(stall) begin
                    state_next = ACCESS;
                end else begin
                    state_next = IDLE;
                end
            end

            ERROR: begin
                state_next = IDLE;
            end

        endcase
    end : STATE_UPDATE

    assign request_permissions = APBAccessControl'({~apbif.PWRITE, apbif.PWRITE});

    always_comb begin : CONTROL_LATCH
        byte_enable_next = '0;
        WEN_next = 1'b0;
        REN_next = 1'b0;
        offset_next = '0;

        casez(state)
            IDLE: begin
                WEN_next = apbif.PWRITE & ~error;
                REN_next = ~apbif.PWRITE & ~error;
                byte_enable_next = apbif.PSTRB;
                offset_next = apbif.PADDR - BASE_ADDR;
            end

            ACCESS: begin
                // Only case to maintain is when we stall
                if(stall) begin
                    WEN_next = WEN;
                    REN_next = REN;
                    byte_enable_next = byte_enable;
                    offset_next = offset;
                end
            end
        endcase
    end : CONTROL_LATCH

    // Address decoding + error
    always_comb begin : ADDRESS_DECODE
        error = 1'b0;
        if(apbif.PSEL && (apbif.PADDR < BASE_ADDR || apbif.PADDR >= (BASE_ADDR + NWORDS*4))) begin
            error = 1'b1;
        end else if((PERMISSIONS[offset_next] & request_permissions) == '0) begin
            error = 1'b1;
        end
    end : ADDRESS_DECODE

    /*
    *   Data Phase
    */
    assign apbif.PSLVERR = (state == ACCESS);
    assign apbif.PENABLE = (state != IDLE);
    assign apbif.PREADY = !stall;
    assign apbif.PRDATA = rdata;

endmodule
