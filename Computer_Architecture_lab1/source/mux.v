`timescale 1ns / 1ps


module mux32(
    input [31:0] dataA,
    input [31:0] dataB,
    input select,
    output [31:0] out
    );

    assign out = select ? dataB : dataA;
endmodule
