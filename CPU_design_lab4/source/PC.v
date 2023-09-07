module PC(
    input [31:0] new_address,  
    input        clk,
    input		  reset,
    input 		  pc_enable,	
	 
    output reg [31:0] output_address
);
	always@(posedge clk) begin
		if(reset == 1'b0) 
			output_address <= 0 - 4;
		else 
			output_address <= (pc_enable == 1)? new_address : output_address;
	end

endmodule
