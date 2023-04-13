
import uvm_pkg::*;
`include "uvm_macros.svh"

class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)

    function new( string name , uvm_component parent) ;
	    super.new(name, parent);
 	endfunction

endclass