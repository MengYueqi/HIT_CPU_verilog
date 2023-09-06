`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/28 14:52:17
// Design Name: 
// Module Name: select_tb
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


module select_tb();
reg sel;
reg a;
reg b;
wire out;

select select_inst(
    .sel(sel),
    .b(b),
    .a(a),
    .out(out)
);

initial
begin
sel = 0; a = 0; b = 0;
#200;
sel = 0; a = 0; b = 1;
#200;
sel = 0; a = 1; b = 0;
#200;
sel = 0; a = 1; b = 1;
#200;
sel = 1; a = 0; b = 0;
#200;
sel = 1; a = 0; b = 1;
#200;
sel = 1; a = 1; b = 0;
#200;
sel = 1; a = 1; b = 1;
#200;
end
    
endmodule
