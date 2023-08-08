// Author:      Huy-Minh Tran
// Description: Flex Shift Register

module socetlib_shift_reg
#(
	parameter NUM_BITS = 4,
	parameter SHIFT_MSB = 1, //1 is MSB, 0 is LSB
	parameter PTS = 0, // if pts is 1, it enables the parallel load. this is to keep current designs from breaking
	parameter RESET_VAL = 1'b1 // reset value of the shift register (1'b1 or 1'b0)
)
(
	input wire clk,
	input wire nRST,
	input wire shift_enable,
	input wire serial_in,
	input wire parallel_load,
	input wire [NUM_BITS-1:0] parallel_in,
	output wire [NUM_BITS-1:0] parallel_out 
);

  	reg [NUM_BITS-1:0] q, n_q;

	assign parallel_out = q;

	always_ff @(posedge clk, negedge nRST) begin
		if (nRST == 1'b0) begin
			q <= {NUM_BITS{RESET_VAL}};
		end
		else begin
			q <= n_q;
		end
	end

	always_comb begin
		n_q = q;
		if (shift_enable && SHIFT_MSB) begin
			n_q = {q[NUM_BITS-2:0], serial_in};
		end
		else if (shift_enable && ~SHIFT_MSB) begin
			n_q = {serial_in, q[NUM_BITS-1:1]};
		end
		// the parallel load should override any shift
		if (parallel_load && PTS) begin
		    n_q = parallel_in;
		end
	end
endmodule