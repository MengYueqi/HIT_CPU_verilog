`timescale 1ns / 1ps

module pc(
    input clk,
    input rst,
    input pc_enable,
    input [31:0] pc_input,
    output reg [31:0] pc_output 
    );

    initial begin
        pc_output <= 32'h0000_0000;
    end

    always @(posedge clk) begin
        if (!rst) begin
            pc_output <= 32'h0000_0000;
        end
        else begin
            if (pc_enable) begin
                pc_output <= pc_input;
            end
        end
    end
endmodule
