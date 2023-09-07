module IR(
    input [31:0] input_instruction,	
    input        ir_enable,			
    input        clk,
	 input        reset,
	 
    output reg [31:0] output_instruction	
);

	always@(negedge clk) begin
		if (reset == 0) begin
			output_instruction <= 32'h00000000;
		end
		else begin
			output_instruction <= (ir_enable == 1)? input_instruction : output_instruction;
		end
		
	end


endmodule
