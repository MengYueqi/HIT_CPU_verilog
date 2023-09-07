`define JMP 6'b000010
module Extender(
    input  [ 5:0] opcode,	
    input  [25:0] input_26bimm,	
	 
    output [31:0] output_32bimm	
);
	
	assign output_32bimm[31:0] = (opcode == `JMP)? { {6{input_26bimm[25]}}, input_26bimm[25:0]}	: { {16{input_26bimm[15]}}, input_26bimm[15:0]};		


endmodule
