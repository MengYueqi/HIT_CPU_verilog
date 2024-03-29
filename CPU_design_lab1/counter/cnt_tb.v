`timescale 1ns / 1ps


module cnt_tst();
reg  clk;
reg  rst_n;
reg  cnt_en;
wire [3:0]out;

 

cnt U_cnt(
.clk(clk),
.rst_n(rst_n),
.cnt_en(cnt_en),
.out(out)
);
initial
begin
clk=1;
rst_n=1;
cnt_en=0;
cnt_en=1;
#1000 rst_n = 0;
#100 cnt_en=0;
#200 cnt_en=1;
#2000 cnt_en=0;
end

always #1 clk=~clk;

endmodule

