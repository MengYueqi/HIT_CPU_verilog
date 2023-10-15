`timescale 1ns / 1ps

`define ADD  6'b100000
`define SUB  6'b100010
`define XOR  6'b100110
`define MOVZ 6'b001010
`define SLL  6'b000000

module alu (
    input  [31:0]   dataA,
    input  [31:0]   dataB,
    input  [5:0]    Card,
    output [31:0]   result
);
    wire [31:0] add_result;
    wire [31:0] sub_result;
    wire [31:0] xor_result;
    wire [31:0] movz_result;
    wire [31:0] sll_result;

    assign add_result  = dataA + dataB;
    assign sub_result  = dataA - dataB;
    assign xor_result  = dataA ^ dataB;
    assign movz_result = (dataB == 32'b0) ? dataA : 32'b0;
    assign sll_result  = dataB << dataA;
    
    assign result = ({32{Card == `ADD}} & add_result) |
                    ({32{Card == `SUB}} & sub_result) |
                    ({32{Card == `XOR}} & xor_result) |
                    ({32{Card == `MOVZ}} & movz_result) |
                    ({32{Card == `SLL}} & sll_result);

endmodule