`timescale 1ns / 1ps


module regfile(
    input clk,
    input [4:0] raddr1,
    input [4:0] raddr2,
    input we,
    input [4:0] waddr,
    input [31:0] wdata,
    output [31:0] rdata1,
    output [31:0] rdata2
    );
    reg [31:0] regs [31:0];

    initial begin
        $readmemh("../lab_1.data/additional_reg_data1", regs);
    end

    always @(negedge clk) begin 
        if (we) begin 
            regs[waddr] <= wdata;
        end
    end

    assign rdata1 = regs[raddr1];
    assign rdata2 = regs[raddr2];
endmodule
