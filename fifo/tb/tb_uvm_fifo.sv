import uvm_pkg::*;
`include "socetlib_fifo.sv"
`include "fifo_if.svh"
`include "test.svh"

module tb_uvm_fifo();
    fifo_if f_if();
    socetlib_fifo DUT(f_if.clk, f_if.nRST, f_if.WEN, f_if.REN, f_if.clear, f_if.wdata, f_if.full, f_if.empty, f_if.underrun, f_if.overrun, f_if.count, f_if.rdata);

    initial begin
        uvm_config_db#(virtual fifo_if)::set(null, "", "fifo_vif", f_if);
        run_test("test");
    end
endmodule
