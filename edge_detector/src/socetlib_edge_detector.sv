// File name:   edge_detector.sv
// Created:     4/16/2015
// Author:      John Skubic, Moore mode added by Nicha Muninnimit 8/1/2025
// Version:     1.1 
// Description: Edge detector, added to socetlib by Cole Nelson 8/14/22 
//	

module socetlib_edge_detector #(
    parameter WIDTH = 1,
    parameter bit MOORE = 0
)
(
    input logic CLK, nRST, 
    input logic [WIDTH - 1:0] signal,
    output logic [WIDTH - 1:0] pos_edge, neg_edge
);

    logic [WIDTH - 1 : 0] signal_r, signal_rr;

    //flip flop behavior
    always_ff @ (posedge CLK, negedge nRST) begin
        if(~nRST) begin
            signal_r <= signal;
            signal_rr <= signal_r;
        end else begin 
            signal_r <= signal;
            signal_rr <= signal_r;
        end
    end

    //output logic
    assign pos_edge = MOORE ? (signal_r & ~signal_rr) : (signal & ~signal_r);
    assign neg_edge = MOORE ? (~signal_r & signal_rr) : (~signal & signal_r);

endmodule
