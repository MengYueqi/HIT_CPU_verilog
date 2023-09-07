module PC_select(
    input  [31:0] JMP_address,	// 执行跳转类指令时PC值
    input  [31:0] PC_address,		// 向下执行时的PC值
    input         pc_select,		// 是否跳转
	 
    output [31:0] next_address
);
	 
	assign next_address = (pc_select == 1)? JMP_address : PC_address;


endmodule
