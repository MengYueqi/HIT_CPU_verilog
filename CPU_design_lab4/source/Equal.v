module Equal(
    input [31:0] data_A,
    input [31:0] data_B,
    input        clk,
    input        reset,
	 
    output reg   equal	// data_A和data_B是否相等
);

	always@(posedge clk) begin
		if(reset == 0) begin
			equal = 1'b0;
		end
		else begin
			equal = (data_A == data_B)? 1'b1 : 1'b0;
		end
	end


endmodule
