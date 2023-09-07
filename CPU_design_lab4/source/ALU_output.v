module ALU_output(
    input      [31:0] input_data,
    input             clk,
	 
    output reg [31:0] output_data
);

	always@(negedge clk) begin
		output_data = input_data;
	end


endmodule
