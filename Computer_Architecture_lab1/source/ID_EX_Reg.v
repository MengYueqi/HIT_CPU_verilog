`timescale 1ns / 1ps

`define ALU 6'b000000
`define SW 6'b101011
`define LW 6'b100011
`define ADD  6'b100000

module ID_EX (
    input clk,
    input resetn,
    input write_enable,
    // ��������,
    input [31:0] ir_input,
    input [31:0] reg_A_input,
    input [31:0] reg_B_input,
    input [31:0] imm_input,
    input [31:0] pc_input,
    
    // �������
    output [31:0] ir_output,
    output [31:0] reg_A_output,
    output [31:0] reg_B_output,
    output [31:0] imm_output,
    output [31:0] pc_output,
    
    // �����߼�
    output reg mux_B_select,
    output reg mux_sll_select,
    output reg [5:0] alu_op
);

    initial begin

        mux_B_select <= 1'b0;
        mux_sll_select <= 1'b0;
        alu_op <= 6'b000000;
    end

    always @(ir_output) begin
        case (ir_output[31:26]) 
            `ALU: begin
                mux_B_select <= 1'b0;
                alu_op <= ir_output[5:0];

                //����λָ��Ĵ���������ALUָ����������     
                if (ir_output[5:0] == 6'b000000) begin
                    mux_sll_select <= 1'b0;
                end else begin
                    mux_sll_select <= 1'b1;
                end
            end
            `SW: begin
                mux_B_select <= 1'b1;
                alu_op <= `ADD;
                mux_sll_select <= 1'b1;
            end
            `LW: begin
                mux_B_select <= 1'b1;
                alu_op <= `ADD;
                mux_sll_select <= 1'b1;
            end
        endcase
    end

    // ��һ���ӼĴ�����ȡ��������
    data_holder Data_A (
        .clk (clk),
        .reset(resetn),
        .write_enable (write_enable),
        .reg_input (reg_A_input),
        .reg_output (reg_A_output)
    );

    // �ڶ����ӼĴ�����ȡ��������
    data_holder Data_B (
        .clk (clk),
        .reset (resetn),
        .write_enable (write_enable),
        .reg_input (reg_B_input),
        .reg_output (reg_B_output)
    );

    // �������洢��
    imm imm (
        .clk (clk),
        .reset (resetn),
        .write_enable (write_enable),
        .reg_input (imm_input),
        .reg_output (imm_output)
    );

    // ָ��Ĵ���
    IR ID_EX_IR (
        .clk(clk),
        .reset(resetn),
        .write_enable (write_enable),
        .instr_input (ir_input),
        .instr_output (ir_output)
    );

    // PC�Ĵ���
    pc ID_EX_PC (
        .clk (clk),
        .rst (resetn),
        .pc_enable(write_enable),
        .pc_input (pc_input),
        .pc_output (pc_output)
    );
endmodule