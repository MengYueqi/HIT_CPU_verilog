`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/31 14:18:48
// Design Name: 
// Module Name: ram_test
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


`timescale 1ns / 1ps

module regfile_tb();

parameter PERIOD = 10;

reg clk;
reg [4:0] raddr1;
reg [4:0] raddr2;
reg we;
reg [4:0] waddr;
reg [31:0] wdata;


wire [31:0] rdata1;
wire [31:0] rdata2;

regfile dut (
.clk(clk),
.raddr1(raddr1),

.rdata1(rdata1),
.raddr2(raddr2),
.rdata2(rdata2),
.we(we),
.waddr(waddr),
.wdata(wdata)
);

always #(PERIOD/2) clk = ~clk;

initial begin
clk = 0;
raddr1 = 0;
raddr2 = 0;
we = 0;
waddr = 0;
wdata = 0;


@(posedge clk)
we = 1; waddr = 1; wdata = 32'd10;

@(posedge clk)
we = 1; waddr = 2; wdata = 32'd20;

@(posedge clk)
raddr1 = 1; raddr2 = 2;

@(posedge clk)
we = 1; waddr = 1; wdata = 32'd10;

@(posedge clk)
we = 1; waddr = 2; wdata = 32'd20;

@(posedge clk)
raddr1 = 1; raddr2 = 2;

@(posedge clk)
$finish;
end

endmodule
