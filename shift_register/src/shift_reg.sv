// Author:      Huy-Minh Tran
// Description: Flex Shift Register
module shift_reg
#(
	parameter NUM_BITS = 4,
	parameter SHIFT_MSB = 1 //1 is MSB, 0 is LSB
)
(
	input wire clk,
	input wire nRST,
	input wire shift_enable,
	input wire serial_in,
	output wire [NUM_BITS-1:0] parallel_out 
);
  reg [NUM_BITS-1:0] q;
	reg [NUM_BITS-1:0] nRST;

	assign parallel_out = q;

	always_ff @(posedge clk, negedge nRST) begin
		if (nRST == 1'b0) begin
			q <= '1;
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
	end
endmodule