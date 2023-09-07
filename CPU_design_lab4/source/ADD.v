module ADD(
    input	[31:0] 	data1,
	 input	[31:0]	data2,
	 
    output	[31:0] 	result
);

	assign result = data1 + data2;
	
endmodule
