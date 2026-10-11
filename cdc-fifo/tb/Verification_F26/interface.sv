interface cdc_fifo_if #(
    parameter int DATA_WIDTH = 4
);

// Write-side signals
logic [DATA_WIDTH-1:0] wdata;
logic winc, wclk, wnrst, wfull;

// Read-side signals
logic [DATA_WIDTH-1:0] rdata;
logic rinc, rclk, rnrst, rempty;

// write clocking block
clocking write_cb @(posedge wclk);
    default input #1step output #0;
    output winc;
    output wdata;
    input  wfull;
endclocking

// read clocking block
clocking read_cb @(posedge rclk);
    default input #1step output #0;
    output rinc;
    input rdata;
    input rempty;
endclocking

// Interface to DUT
endinterface
