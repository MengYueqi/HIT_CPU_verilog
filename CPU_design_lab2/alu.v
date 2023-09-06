`define ADD 5'b00001
`define ADD_CIN 5'b00010
`define SUB 5'b00011
`define SUB_CIN 5'b00100
`define SUB_N 5'b00101
`define SUB_N_CIN 5'b00110
`define A 5'b00111
`define B 5'b01000
`define NOT_A 5'b01001
`define NOT_B 5'b01010
`define A_OR_B 5'b01011
`define A_AND_B 5'b01100
`define A_SAME_B 5'b01101
`define A_NOTS_B 5'b01110
`define NOT_A_AND_B 5'b01111
`define ZERO 5'b10000

module alu (
input [31:0] A ,
input [31:0] B ,
input Cin ,
input [4 :0] alusel,
output [31:0] F ,
output Cout,
output Zero
);
wire [31:0] add_result;
wire [31:0] add_cin_result;
wire [31:0] sub_result;
wire [31:0] sub_cin_result;
wire [31:0] sub_n_result;
wire [31:0] sub_n_cin_result;
wire [31:0] a_result;
wire [31:0] b_result;
wire [31:0] not_a_result;
wire [31:0] not_b_result;
wire [31:0] a_or_b_result;
wire [31:0] a_and_b_result;
wire [31:0] a_same_b_result;
wire [31:0] a_nots_b_result;
wire [31:0] not_a_and_b_result;
wire [31:0] zero_result;

assign add_result = A + B;
assign add_cin_result = A + B + Cin;
assign sub_result = A - B;
assign sub_cin_result = A - B - Cin;
assign sub_n_result = B - A;
assign sub_n_cin_result = B - A - Cin;
assign a_result = A;
assign b_result = B;
assign not_a_result = ~A;
assign not_b_result = ~B;
assign a_or_b_result = A | B;
assign a_and_b_result = A & B;
assign a_same_b_result = A ^~ B;
assign a_nots_b_result = A ^ B;
assign not_a_and_b_result = ~ (A & B);
assign zero_result = 32'd0;

assign F = ({32{alusel == `ADD}} & add_result) |  
          ({32{alusel == `SUB}} & sub_result) |
          ({32{alusel == `ADD_CIN}} & add_cin_result) | 
          ({32{alusel == `SUB_CIN}} & sub_cin_result) |
          ({32{alusel == `SUB_N}} & sub_n_result) |
          ({32{alusel == `SUB_N_CIN}} & sub_n_cin_result) | 
          ({32{alusel == `A}} & a_result) |
          ({32{alusel == `B}} & b_result) |
          ({32{alusel == `NOT_A}} & not_a_result) |
          ({32{alusel == `NOT_B}} & not_b_result) |  
          ({32{alusel == `A_OR_B}} & a_or_b_result) |
          ({32{alusel == `A_AND_B}} & a_and_b_result) |
          ({32{alusel == `A_SAME_B}} & a_same_b_result) |
          ({32{alusel == `A_NOTS_B}} & a_nots_b_result) |
          ({32{alusel == `NOT_A_AND_B}} & not_a_and_b_result) |
          ({32{alusel == `ZERO}} & zero_result);
          
wire [31:0] S;
wire [30:0]C;

FullAdder FA0 (A[0],B[0],Cin,S[0],C[0]);
FullAdder FA1 (A[1],B[1],C[0],S[1],C[1]);
FullAdder FA2 (A[2],B[2],C[1],S[2],C[2]);
FullAdder FA3 (A[3],B[3],C[2],S[3],C[3]);
FullAdder FA4 (A[4],B[4],C[3],S[4],C[4]);
FullAdder FA5 (A[5],B[5],C[4],S[5],C[5]);
FullAdder FA6 (A[6],B[6],C[5],S[6],C[6]);
FullAdder FA7 (A[7],B[7],C[6],S[7],C[7]);
FullAdder FA8 (A[8],B[8],C[7],S[8],C[8]);
FullAdder FA9 (A[9],B[9],C[8],S[9],C[9]);
FullAdder FA10 (A[10],B[10],C[9],S[10],C[10]);
FullAdder FA11 (A[11],B[11],C[10],S[11],C[11]);
FullAdder FA12 (A[12],B[12],C[11],S[12],C[12]);
FullAdder FA13 (A[13],B[13],C[12],S[13],C[13]);
FullAdder FA14 (A[14],B[14],C[13],S[14],C[14]);
FullAdder FA15 (A[15],B[15],C[14],S[15],C[15]);
FullAdder FA16 (A[16],B[16],C[15],S[16],C[16]);
FullAdder FA17 (A[17],B[17],C[16],S[17],C[17]);
FullAdder FA18 (A[18],B[18],C[17],S[18],C[18]);
FullAdder FA19 (A[19],B[19],C[18],S[19],C[19]);
FullAdder FA20 (A[20],B[20],C[19],S[20],C[20]);
FullAdder FA21 (A[21],B[21],C[20],S[21],C[21]);
FullAdder FA22 (A[22],B[22],C[21],S[22],C[22]);
FullAdder FA23 (A[23],B[23],C[22],S[23],C[23]);
FullAdder FA24 (A[24],B[24],C[23],S[24],C[24]);
FullAdder FA25 (A[25],B[25],C[24],S[25],C[25]);
FullAdder FA26 (A[26],B[26],C[25],S[26],C[26]);
FullAdder FA27 (A[27],B[27],C[26],S[27],C[27]);
FullAdder FA28 (A[28],B[28],C[27],S[28],C[28]);
FullAdder FA29 (A[29],B[29],C[28],S[29],C[29]);
FullAdder FA30 (A[30],B[30],C[29],S[30],C[30]);
FullAdder FA31 (A[31],B[31],C[30],S[31],Cout);

assign Zero = (F == 32'b0);
endmodule

module FullAdder(A,B,CarryIn,Sum,CarryOut);
	input wire A;
	input wire B;
	input wire CarryIn;
	output wire Sum;
	output wire CarryOut;
	assign Sum=A^B^CarryIn;
	assign CarryOut=(A&B)|(A&CarryIn)|(B&CarryIn);
endmodule
