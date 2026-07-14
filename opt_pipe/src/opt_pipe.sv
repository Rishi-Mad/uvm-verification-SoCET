module opt_pipe#(
    parameter int WIDTH,
    parameter int NUM_STAGES
) (
    input logic CLK,
    input logic nRST,
    input logic ready,
    input logic [WIDTH-1:0] in,
    output logic done,
    output logic [WIDTH-1:0] out
);
    generate
        if (NUM_STAGES == 0) begin
            assign done = ready;
            assign out = in;
        end else if (NUM_STAGES == 1) begin
            // Split out from the NUM_STAGES>=2 case below: done_delay[NUM_STAGES-1:1]
            // becomes the illegal range [0:1] when NUM_STAGES==1
            logic done_delay;
            logic [WIDTH-1:0] out_delay;

            assign done = done_delay;
            assign out = out_delay;

            always_ff @(posedge CLK, negedge nRST) begin
                if (!nRST) begin
                    done_delay <= '0;
                    out_delay <= '0;
                end else begin
                    done_delay <= ready;
                    out_delay <= in;
                end
            end
        end else begin
            logic [NUM_STAGES-1:0] done_delay;
            logic [NUM_STAGES-1:0] [WIDTH-1:0] out_delay;

            assign done = done_delay[0];
            assign out = out_delay[0];

            always_ff @(posedge CLK, negedge nRST) begin
                if (!nRST) begin
                    done_delay <= '0;
                    out_delay <= '0;
                end else begin
                    done_delay <= {ready, done_delay[NUM_STAGES-1:1]};
                    out_delay <= {in, out_delay[NUM_STAGES-1:1]};
                end
            end
        end
    endgenerate
endmodule
