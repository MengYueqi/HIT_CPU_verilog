`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/31 13:52:39
// Design Name: 
// Module Name: regfile
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


module regfile(
input clk,
input [4:0] raddr1,
output [31:0] rdata1,
input [4:0] raddr2,
output [31:0] rdata2,
input we,
input [4:0] waddr,
input [31:0] wdata
);

reg [31:0] rf[31:0]; 

always @(posedge clk) begin
if (we)
rf[waddr] <= wdata; 
end

assign rdata1 = rf[raddr1]; 
assign rdata2 = rf[raddr2];

endmodule