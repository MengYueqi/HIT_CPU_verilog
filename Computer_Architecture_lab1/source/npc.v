`timescale 1ns / 1ps


module npc(
    input clk,
    input reset,
    input write_enable,
    input [31:0] pc_input,
    output reg [31:0] npc
    );

    initial begin
        npc <= 32'h0000_0000;
    end

    always @(pc_input, reset) begin
        if (!reset) begin
            npc <= 32'h0000_0000;
        end
        else begin
            if (write_enable) begin
                npc <= pc_input;
            end
        end
    end

endmodule
