module MUX32(
    input  [31:0] input_data0,
    input  [31:0] input_data1,
    input         select,
	 
    output [31:0] output_data
);
	
	assign output_data = (select == 1)? input_data1 : input_data0;


endmodule
