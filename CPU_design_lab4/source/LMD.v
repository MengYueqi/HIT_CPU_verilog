module LMD(
    input [31:0] in,
    input        clk,
	 
    output reg [31:0] out
);
	
	always@(negedge clk) begin
		out <= in;
	end


endmodule
