`timescale 1ns / 1ps


module IMEM(
    input clk,
    input [31:0] addr,
    output [31:0] inst
    );
    reg [31:0] mem [255:0];

    initial begin 
        $readmemh("../additional_inst_data1", mem);
    end

    assign inst = mem[addr/4];
    
endmodule

