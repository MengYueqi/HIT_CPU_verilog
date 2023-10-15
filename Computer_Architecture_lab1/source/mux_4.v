`timescale 1ns / 1ps


module mux4to1(
    input [31:0] dataA,
    input [31:0] dataB,
    input [31:0] dataC,
    input [31:0] dataD,
    input [1:0] select,
    output reg [31:0] result
    );

    always @(*) begin
        case (select) 
            2'b00: begin
                result = dataA;
            end
            2'b01: begin
                result = dataB;
            end
            2'b10: begin
                result = dataC;
            end
            2'b11: begin
                result = dataD;
            end
        endcase
    end
endmodule
