`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/29 14:50:11
// Design Name: 
// Module Name: alu_sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module alu_test();

reg [31:0] A, B;
reg Cin;  
reg [4:0] alusel;

wire [31:0] F;
wire Cout, Zero;  

alu alu(
  .A(A),
  .B(B),
  .Cin(Cin),
  .alusel(alusel),
  .F(F),
  .Cout(Cout),
  .Zero(Zero)
);

initial
begin

  // Add
  alusel = 5'b00001; A = 10; B = 5;
  #10;
  
  // Add
  alusel = 5'b00001; A = 32'b11111111111111111111111111111111; B = 32'b11111111111111111111111111111111;
  #10;
  
  // Add with cin
  alusel = 5'b00010; A = 10; B = 5; Cin = 1;
  #10;

  // Sub
  alusel = 5'b00011; A = 15; B = 10;
  #10;

  // Sub with cin
  alusel = 5'b00100; A = 15; B = 10; Cin = 1;  
  #10;

  // Sub reverse
  alusel = 5'b00101; A = 10; B = 15;
  #10;

  // Sub reverse with cin
  alusel = 5'b00110; A = 10; B = 15; Cin = 1;
  #10;

  // NOT A
  alusel = 5'b01001; A = 10;
  #10;

  // NOT B
  alusel = 5'b01010; B = 15;
  #10;

  // A OR B
  alusel = 5'b01011; A = 10; B = 15;
  #10;  

  // A AND B
  alusel = 5'b01100; A = 10; B = 15;
  #10;

  // A SAME B
  alusel = 5'b01101; A = 10; B = 15;
  #10;

  // A NOTS B
  alusel = 5'b01110; A = 10; B = 15;
  #10;

  // NOT A AND B
  alusel = 5'b01111; A = 10; B = 15;
  #10;

  // Zero
  alusel = 5'b10000; 
  #10;

  $finish;

end

endmodule
