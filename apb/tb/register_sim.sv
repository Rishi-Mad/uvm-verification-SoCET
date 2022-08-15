
/*
*
*   Model of a 'memory' with configurable latency
*
*/
`include "bus_protocol_if.vh"

module register_sim #(
    parameter NREGS = 32,
    parameter WIDTH = 32
)(
    input CLK,
    input nRST,
    input int latency,
    bus_protocol_if.peripheral_vital prif,
    bus_protocol_if.peripheral_hint hintif
);

    typedef logic [WIDTH-1:0] word_t;

    word_t [NREGS-1:0] regs, regs_next;
    int lat_cnt, lat_cnt_next;
    logic ready;
    

    always_ff @(posedge CLK, negedge nRST) begin
        if(!nRST) begin
            regs <= '{default: '0};
            lat_cnt <= '0;
        end else begin
            regs <= regs_next;
            lat_cnt <= lat_cnt_next;
        end
    end


    always_comb begin
        regs_next = regs;

        if(lat_cnt < latency && (prif.ren || prif.wen)) begin
            lat_cnt_next = lat_cnt + 1;
        end else begin
            lat_cnt_next = 0;
        end

        if(prif.wen && ready) begin
            regs_next[prif.addr][0+:8] = prif.strobe[0] ? prif.wdata[0+:8] : regs_next[prif.addr][0+:8];
            regs_next[prif.addr][8+:8] = prif.strobe[1] ? prif.wdata[8+:8] : regs_next[prif.addr][8+:8];
            regs_next[prif.addr][16+:8] = prif.strobe[2] ? prif.wdata[16+:8] : regs_next[prif.addr][16+:8];
            regs_next[prif.addr][24+:8] = prif.strobe[3] ? prif.wdata[24+:8] : regs_next[prif.addr][24+:8];
        end
    end

    assign ready = (lat_cnt == latency);
    assign prif.rdata = regs[prif.addr];
    assign prif.request_stall = !ready;

    assign prif.error = 0;

endmodule
