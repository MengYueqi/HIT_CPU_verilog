`timescale 1ns / 1ps

module EX_MEM(
    input clk,
    input resetn,
    input write_enable,
    input [31:0] alureg_input,
    input [31:0] ir_input,
    input [31:0] pc_input,
    input [31:0] mem_rt,

    // data output
    output [31:0] alureg_output,
    output [31:0] ir_output,
    output [31:0] pc_output,
    output reg [31:0] wb_rt,
    // control output
    output reg dmem_write_enable
    );

    initial begin
        wb_rt <= 32'h0;
        dmem_write_enable <= 1'b0;
    end
    

    always @(ir_output) begin
        case (ir_output[31:26]) 
            //alu
            6'b000000: begin
                dmem_write_enable <= 1'b0;
            end
            //lw
            6'b101011: begin
                dmem_write_enable <= 1'b1;
            end
            //sw
            6'b100011: begin
                dmem_write_enable <= 1'b0;
            end
        endcase
        wb_rt <= mem_rt;
    end

    
    // ALUµÄ¼ÆËã½á¹û
    data_holder aluoutput(
        .clk (clk),
        .reset (resetn),
        .write_enable (write_enable),
        .reg_input (alureg_input),
        .reg_output (alureg_output)
    );

    // Ö¸Áî¼Ä´æÆ÷
    IR EX_MEM_IR (
        .clk(clk),
        .reset(resetn),
        .write_enable (write_enable),
        .instr_input (ir_input),
        .instr_output (ir_output)
    );

    // PC¼Ä´æÆ÷
    pc EX_MEM_PC (
        .clk (clk),
        .rst (resetn),
        .pc_enable(write_enable),
        .pc_input (pc_input),
        .pc_output (pc_output)
    );
endmodule
