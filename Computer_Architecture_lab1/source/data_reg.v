`timescale 1ns / 1ps

module data_holder(
    input clk,
    input reset,
    input write_enable,
    input [31:0] reg_input,
    output reg [31:0] reg_output
    );

    initial begin 
        reg_output <= 32'h0000_0000;
    end

    always @(posedge clk) begin
        if (!reset) begin
            reg_output <= 32'h0000_0000;
        end
        else begin
            if (write_enable) begin
                reg_output <= reg_input;
            end
        end
    end

endmodule
