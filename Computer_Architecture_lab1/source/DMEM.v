`timescale 1ns / 1ps


module DMEM(
    input clk,
    input [31:0] raddr,
    input [31:0] waddr,
    input write_enable,
    input [31:0] wdata,
    output [31:0] rdata
    );
    reg [31:0] mem [255:0];

    initial begin 
        $readmemh("../additional_data_data1", mem);
    end

    always @(posedge clk) begin
        if (write_enable) begin
            mem[waddr/4] <= wdata;
        end
    end

    assign rdata = mem[raddr/4];
    
endmodule
