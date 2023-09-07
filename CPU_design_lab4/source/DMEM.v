
module DMEM(
    input [31:0]  alu_address,	
    input [31:0]  data,			
    input         write_enable,
    input         clk,
    input         reset,
	 
    output [31:0] out
);

	reg [31:0] memory [255:0];	
	integer i;
	
	initial begin
		$readmemh("C:/Users/16911/Desktop/cpu_design/data_data.txt", memory);
	end
	
	assign out = memory[alu_address / 4];
		
	
	always@(posedge clk) begin
		if(reset == 0) begin
			//out = 0;
		end
		else begin
			if(write_enable == 1) begin
				memory[alu_address / 4] <= data;
			end	
		end
	end


endmodule
