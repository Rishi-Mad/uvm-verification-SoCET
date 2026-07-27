`include "wt_mult_pkg.sv"

import wt_mult_pkg::*;

/// Fully pipelined wallace tree multiplier
/// Three stages:
///     1) Generate partial products (1 stage)
///     2) Reduce partial products in a tree using half and full adders (lgN stages)
///     3) Reduce final two outputs (1 stage)
module wt_mult#(
    parameter int WIDTH = 32,
    parameter logic MERGE_PROD_GEN_REDUCE_STAGES=1,
    parameter int STAGE_DEPTH=8,
    parameter logic MERGE_REDUCE_FINAL_STAGES=0,
    // Generate partial products using Baugh-Wooley method
    parameter int SIGNED=0
)(
    input logic CLK, nRST,
    input logic ready,
    input logic [WIDTH-1:0] a, b,
    output logic done,
    output logic [WIDTH*2-1:0] out
);
    logic [WIDTH*2-1:0] [WIDTH-1:0] partial_prods, reduce_partial_prods;
    logic reduce_ready, reduce_done;
    logic [WIDTH*2-1:0] out_a, out_b;
    logic [WIDTH*2-1:0] int_out;

    // Generate a sequence of [1, 2, 3, ..., WIDTH, WIDTH-1, WIDTH-2, ..., 1, 0]
    function automatic logic [WIDTH*2-1:0] [31:0] init_depth();
        logic [WIDTH*2-1 : 0] [31 : 0] result;
        for (int i = 1; i <= WIDTH*2; i++) begin
            if (i < WIDTH) begin
                result[i - 1] = i;
            end else begin
                result[i - 1] = 2 * WIDTH - i;
            end
            if (SIGNED) begin
                result[WIDTH] = WIDTH;
            end
        end
        return result;
    endfunction

    // Stage 1: Generate partial products
    wt_partial_prod_gen #(
        .WIDTH(WIDTH),
        .SIGNED(SIGNED)
    ) partial_prod_gen (
        .a(a),
        .b(b),
        .partial_prods(partial_prods)
    );

    logic [WIDTH*WIDTH*2-1:0] pp_cast, reduce_pp_cast;
    assign pp_cast = partial_prods;
    opt_pipe #(
        .WIDTH(WIDTH*WIDTH*2),
        .NUM_STAGES(!MERGE_PROD_GEN_REDUCE_STAGES)
    ) pp_pipe (
        .CLK(CLK),
        .nRST(nRST),
        .ready(ready),
        .in(pp_cast),
        .done(reduce_ready),
        .out(reduce_pp_cast)
    );
    assign reduce_partial_prods = reduce_pp_cast;

    // Stage 2: Reduce partial products
    localparam logic [WIDTH*2-1:0] [31:0] DEPTH = init_depth();

    wt_reduction #(
        .WIDTH(WIDTH),
        .STAGE_DEPTH(STAGE_DEPTH),
        .CURR_STAGE_DEPTH(STAGE_DEPTH),
        .DEPTH(DEPTH)
    ) reduce (
        .CLK(CLK),
        .nRST(nRST),
        .ready(reduce_ready),
        .partial_prods(reduce_partial_prods),
        .done(reduce_done),
        .out_a(out_a),
        .out_b(out_b)
    );

    // Stage 3: Add remaining two values
    assign int_out = out_a + out_b;
    opt_pipe #(
        .WIDTH(WIDTH*2),
        .NUM_STAGES(!MERGE_REDUCE_FINAL_STAGES)
    ) sum_pipe (
        .CLK(CLK),
        .nRST(nRST),
        .ready(reduce_done),
        .in(SIGNED ? {!int_out[WIDTH*2-1], int_out[WIDTH*2-2:0]} : int_out),
        .done(done),
        .out(out)
    );
endmodule
