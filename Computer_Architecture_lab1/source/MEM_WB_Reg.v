`timescale 1ns / 1ps

`define ALU 6'b000000
`define SW 6'b101011
`define LW 6'b100011

module MEM_WB (
    input clk,
    input resetn,
    input write_enable,
    input [31:0] ir_input,
    input [31:0] lmd_input,
    input [31:0] wb_rt,
    input [31:0] alureg_input,
    input [31:0] pc_input,
    
    // data output
    output  [31:0] ir_output,
    output  [31:0] lmd_output,
    output  [31:0] alureg_output,
    output [31:0] pc_output,
    // control output 
    output reg reg_write_enable,
    output reg write_back_mux_select,// 0: lmd, 1: alureg
    output reg [4:0] write_back_addr
);
    initial begin
        reg_write_enable <= 1'b0;
        write_back_mux_select <= 1'b0;
        write_back_addr <= 5'b00000;
    end

    always @(ir_output) begin
        case (ir_output[31:26]) 
            `ALU: begin
                write_back_mux_select <= 1'b1;
                write_back_addr <= ir_output[15:11];
                
                // movz
                if (ir_output[10:0] == 11'b00000_001010 && (wb_rt != 32'h0)) begin
                    reg_write_enable <= 1'b0;
                end else begin
                    reg_write_enable <= 1'b1;
                end
            end
            `SW: begin
                write_back_mux_select <= 1'b0;
                write_back_addr <= ir_output[20:16];
                reg_write_enable <= 1'b0;
            end
            `LW: begin
                write_back_mux_select <= 1'b0;
                write_back_addr <= ir_output[20:16];
                reg_write_enable <= 1'b1;
            end
        endcase
        
    end

    // 指令寄存器
    IR MEM_WB_IR (
        .clk(clk),
        .reset(resetn),
        .write_enable (write_enable),
        .instr_input (ir_input),
        .instr_output (ir_output)
    );

    // ALU计算出的结果
    data_holder aluoutput(
        .clk (clk),
        .reset (resetn),
        .write_enable (write_enable),
        .reg_input (alureg_input),
        .reg_output (alureg_output)
    );

    // 从DMEM中取出的数据
    data_holder LMD (
        .clk (clk),
        .reset (resetn),
        .write_enable (write_enable),
        .reg_input (lmd_input),
        .reg_output (lmd_output)
    );

    // PC寄存器
    pc MEM_WB_PC (
        .clk (clk),
        .rst (resetn),
        .pc_enable(write_enable),
        .pc_input (pc_input),
        .pc_output (pc_output)
    );

endmodule 