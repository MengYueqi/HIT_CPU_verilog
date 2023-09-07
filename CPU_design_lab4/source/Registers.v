module Registers(
    input  [4:0] RS_1,
    input  [4:0] RS_2,	
	 input  [4:0] writeback_address,	
	 input  [31:0] writeback_data,
    input         clk,
    input         write_enable,	
    input         reset,
	 
    output  [31:0] output_data_1,		
    output  [31:0] output_data_2
);

	reg [31:0] memory [31:0];
	integer i;
	
	assign output_data_1 = memory[RS_1];
	assign output_data_2 = memory[RS_2];
	
	
	
	initial begin
	   for (i=0; i<32; i=i+1) begin
	   memory[i] = 32'h00000000;
	   end
	end
	
	always@(posedge clk) begin
		if(reset == 0) begin
			//output_data_1 = 32'h00000000;
			//output_data_2 = 32'h00000000;
		end
		else begin
			if(write_enable == 1) begin
				memory[writeback_address] <= writeback_data;
			end
		end
	end

endmodule
