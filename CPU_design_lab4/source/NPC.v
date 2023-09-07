module NPC(
    input	[31:0]	input_address,	
    input				clk,				
	input				reset,
	input				npc_enable,		
	 
	 output reg [31:0] output_address	
);

	always@(negedge clk) begin
		if(reset == 1'b0) begin
			output_address <= 0;
		end
		else begin
			output_address <= (npc_enable==1)? input_address : output_address;
		end
	end


endmodule
