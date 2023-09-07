module IMEM(
    input [31:0] address,	
	 
    output [31:0] output_instruction	
);

	reg [31:0] data [255:0];	
	
	initial begin
		$readmemh("../inst_data.txt", data);  
	end
	
	assign output_instruction = data[address / 4];

endmodule
