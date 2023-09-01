`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/28 16:16:42
// Design Name: 
// Module Name: cnt
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




 

`timescale 1ns/1ps

module cnt #(parameter COUNT=100)(

input clk,

input rst_n,

input cnt_en,

output reg [3:0]out

    );

reg set;   

 

always@(posedge clk or negedge rst_n)
if(rst_n) begin
out <= 4'b1000;
end
else begin
out <= {out[0], out[3:1]};
end 
endmodule
