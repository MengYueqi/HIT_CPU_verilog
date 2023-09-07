module Data_holder(
    input [31:0] in,
    input        clk,
    output reg [31:0] out
);

	always@(in) begin
		out = in;
	end

endmodule
