`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/31 14:32:59
// Design Name: 
// Module Name: ram_top
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


module ram_top (
input clk ,
input [15:0] ram_addr ,
input [31:0] ram_wdata,
input ram_wen ,
output [31:0] ram_rdata,
input [4:0] raddr1,
input we,
input [4:0] waddr,
input [31:0] wdata
);
block_ram block_ram (
.clka (clk ),
.wea (ram_wen ),
.addra(ram_addr ),
// .dina (ram_wdata ),
.dina (rf[raddr1] ),
.douta(ram_rdata )
);
always @(posedge clk) begin
if (we)
rf[waddr] <= wdata; // 写操作
end
endmodule

