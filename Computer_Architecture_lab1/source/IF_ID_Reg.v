`timescale 1ns / 1ps


module IF_ID(
    input clk,
    input resetn,
    input flush,
    input write_enable,
    input [31:0] ir_input,
    input [31:0] if_adder_output,
    input [31:0] pc_input,

    output [31:0] ir_output,
    output [31:0] npc,
    output [31:0] pc_output
    );

    // ��һ��Ҫ��������ˮ�ߵ�PCֵ
    npc IF_ID_NPC (
        .clk (clk),
        .reset (resetn),
        .write_enable (write_enable),
        .pc_input (if_adder_output),
        .npc (npc)
    );
    
    // ָ��Ĵ���
    IR IF_ID_IR (
        .clk(clk),
        .reset(resetn),
        .write_enable (write_enable),
        .instr_input (ir_input),
        .instr_output (ir_output)
    );

    // ��ǰִ�е�ָ���PCֵ
    pc IF_ID_PC (
        .clk (clk),
        .rst (resetn),
        .pc_enable(write_enable),
        .pc_input (pc_input),
        .pc_output (pc_output)
    );

endmodule
