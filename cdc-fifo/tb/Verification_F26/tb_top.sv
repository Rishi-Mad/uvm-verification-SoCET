`timescale 1ns/1ps
// CDC FIFO UVM Verification pls commit the changes bro

module tb_top;
import uvm_pkg::*;
`include "uvm_macros.svh"
import cdc_fifo_pkg::*;

parameter int DATA_WIDTH = 4;

// interface instanstiation
cdc_fifo_if #(DATA_WIDTH) fifo_if();

// DUT instantiation
socetlib_cdc_fifo #(.DATA_WIDTH(DATA_WIDTH), .FIFO_DEPTH(16)) DUT (.wdata(fifo_if.wdata),
.winc(fifo_if.winc),.wclk(fifo_if.wclk), .wnrst(fifo_if.wnrst), .wfull(fifo_if.wfull),
.rdata(fifo_if.rdata), .rinc(fifo_if.rinc), .rclk(fifo_if.rclk), .rnrst(fifo_if.rnrst),
.rempty(fifo_if.rempty));

// Clock generation
initial begin
    fifo_if.wclk = 0;
    fifo_if.rclk = 0;
end

always #5 fifo_if.wclk = ~fifo_if.wclk;
always #7 fifo_if.rclk = ~fifo_if.rclk;

// Reset
initial begin
    fifo_if.wnrst = 0;
    fifo_if.rnrst = 0;
    fifo_if.winc = 0;
    fifo_if.rinc = 0;
    fifo_if.wdata = 0;

    @(negedge fifo_if.wclk);
    @(negedge fifo_if.wclk);
    @(negedge fifo_if.wclk);

    fifo_if.wnrst = 1;

    @(negedge fifo_if.rclk);
    @(negedge fifo_if.wclk);
    @(negedge fifo_if.wclk);

    fifo_if.rnrst = 1;
end

initial begin
    uvm_config_db#(virtual cdc_fifo_if #(DATA_WIDTH))::set( // UVM Configuration Database
    null,
    "*", // Avail to components
    "vif", // Name
    fifo_if
    );

    run_test("cdc_fifo_basic_test"); // starts the uvm test
end


endmodule