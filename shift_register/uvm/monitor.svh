
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "sr_if.svh"
class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)

    function new(string name, uvm_component parent = null);
    super.new(name, parent);
    endfunction: new

endclass