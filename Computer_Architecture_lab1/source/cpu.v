`timescale 1ns / 1ps

module cpu(
    input clk,
    input resetn,

    output [31:0] debug_wb_pc,
    output debug_wb_rf_wen,
    output [4:0] debug_wb_rf_addr,
    output [31:0] debug_wb_rf_wdata
    );

    wire reg_write_enable;  
    wire dmem_write_enable;

    wire mux_B_select;

    wire write_back_mux_select; 
    wire mux_sll_select;

    wire pc_write;
    wire if_id_write_enable;
    wire id_ex_reset;

    wire [1:0] forwarding_mux_select_1;
    wire [1:0] forwarding_mux_select_2;

    wire [4:0] write_back_addr;

    wire [5:0] alu_op;

    wire [31:0] pc_input;
    wire [31:0] pc_output;
    wire [31:0] if_adder_output; 
    wire [31:0] imem_output; 
    wire [31:0] npc; 
    wire [31:0] reg_files_outputA; 
    wire [31:0] reg_files_outputB; 
    wire [31:0] ext_instr_index; 
    wire [31:0] reg_A_output; 
    wire [31:0] reg_B_output; 
    wire [31:0] reg_imm_output; 
    wire [31:0] write_back_data; 
    wire [31:0] alu_A_input; 
    wire [31:0] alu_B_input; 
    wire [31:0] alu_output;
    wire [31:0] alureg_output;
    wire [31:0] dmem_data_output;
    wire [31:0] lmd_output;
    wire [31:0] alu_A_sll_input; 
    wire [31:0] npc_adder_output; 
    wire [31:0] jump_select_output;
    wire [31:0] wb_alu_output;
    wire [31:0] forwarding_mux1_output;
    wire [31:0] forwarding_mux2_output;


    wire [31:0] if_id_ir;
    wire [31:0] id_ex_ir;
    wire [31:0] ex_mem_ir;
    wire [31:0] mem_wb_ir;

    wire [31:0] id_ex_npc;
    wire [31:0] if_pc;
    wire [31:0] id_pc;
    wire [31:0] ex_pc;
    wire [31:0] mem_pc;

    wire [31:0] wb_rt;

    reg write_enable;

    assign debug_wb_rf_wen = reg_write_enable;
    assign debug_wb_pc = mem_pc;
    assign debug_wb_rf_addr = write_back_addr;
    assign debug_wb_rf_wdata = write_back_data;


    initial begin
        write_enable <= 1'b1;
    end

    // IF周期
    pc pc(
        .clk (clk),
        .rst (resetn),
        .pc_enable(pc_write),
        .pc_input (npc),
        .pc_output (pc_output)
    );   
    
    ADD adder(
        .dataA(pc_output),
        .dataB(32'h4),
        .result(if_adder_output)
    );
  
    IMEM IMEM (
        .clk (clk),
        .addr (pc_output),
        .inst (imem_output)
    );

    IF_ID IF_ID (
        .clk(clk),
        .resetn(resetn),
        .write_enable (if_id_write_enable),
        
        .ir_input (imem_output),
        .pc_input(pc_output),
        .if_adder_output (if_adder_output),

        .ir_output (if_id_ir),
        .npc (npc),
        .pc_output (if_pc)
    );

    // ID周期

    regfile regfile (
        .clk (clk),
        .raddr1 (if_id_ir[25:21]),
        .raddr2 (if_id_ir[20:16]),
        .we (reg_write_enable),
        .waddr (write_back_addr),
        .wdata (write_back_data),
        .rdata1 (reg_files_outputA),
        .rdata2 (reg_files_outputB)
    );

    extender extender (
        .instr_index (if_id_ir[15:0]),
        .ext_instr_index (ext_instr_index) 
    );

    ID_EX ID_EX(
        .clk(clk),
        .resetn(id_ex_reset),
        .write_enable(write_enable),
        .ir_input (if_id_ir),
        .reg_A_input(reg_files_outputA),
        .reg_B_input (reg_files_outputB),
        .imm_input (ext_instr_index),
        .pc_input (if_pc),

        .ir_output (id_ex_ir),
        .reg_A_output (reg_A_output),
        .reg_B_output (reg_B_output),
        .imm_output (reg_imm_output),
        .pc_output (id_pc),

        .mux_B_select (mux_B_select),
        .mux_sll_select (mux_sll_select),
        .alu_op (alu_op)
    );

    // EX周期
    mux32 move_mux (
        .dataA ({{27'd0}, id_ex_ir[10:6]}),
        .dataB (reg_A_output),
        .select (mux_sll_select),
        .out (alu_A_sll_input)
    ); 

    mux32 alu_mux2 (
        .dataA (reg_B_output),
        .dataB (reg_imm_output),
        .select (mux_B_select),
        .out (alu_B_input)
    );
    
    hazard hazard (
        .if_id_ir (if_id_ir),
        .id_ex_ir (id_ex_ir),
         .ex_mem_ir (ex_mem_ir),
        .mem_wb_ir (mem_wb_ir),
        .mem_rt (forwarding_mux2_output),
        .wb_rt (wb_rt),   
        .pc_write (pc_write),
        .if_id_write_enable (if_id_write_enable),
        .id_ex_reset (id_ex_reset),
        .forward_A (forwarding_mux_select_1),
        .forward_B (forwarding_mux_select_2)
    );

    mux4to1 forwarding_mux_1 (
        .dataA (alu_A_sll_input),
        .dataB (alureg_output),
        .dataC (write_back_data),
        .select (forwarding_mux_select_1),
        .result (forwarding_mux1_output)
    );

    mux4to1 forwarding_mux_2 (
        .dataA (alu_B_input),
        .dataB (alureg_output),
        .dataC (write_back_data),
        .select (forwarding_mux_select_2),
        .result (forwarding_mux2_output)
    );

    alu alu (
        .dataA (forwarding_mux1_output),
        .dataB (forwarding_mux2_output),
        .Card (alu_op),
        .result(alu_output)
    );

    EX_MEM EX_MEM (
        .clk(clk),
        .resetn(resetn),
        .write_enable(write_enable),
        .alureg_input (alu_output),
        .ir_input (id_ex_ir),
        .pc_input (id_pc),
        .mem_rt(forwarding_mux2_output),

        .alureg_output (alureg_output),
        .ir_output (ex_mem_ir),
        .pc_output (ex_pc),
        .wb_rt (wb_rt),
        .dmem_write_enable(dmem_write_enable)
    );


    // MEM周期

    DMEM DMEM (
        .clk(clk),
        .raddr (alureg_output),
        .waddr (alureg_output),
        .write_enable (dmem_write_enable),
        .wdata (reg_B_output),
        .rdata (dmem_data_output)
    );

    MEM_WB MEM_WB(
        .clk(clk),
        .resetn(resetn),
        .write_enable(write_enable),
        .ir_input (ex_mem_ir),
        .lmd_input (dmem_data_output),
        .wb_rt (wb_rt),
        .alureg_input (alureg_output),
        .pc_input (ex_pc),

        .ir_output (mem_wb_ir),
        .lmd_output (lmd_output),
        .alureg_output (wb_alu_output),
        .pc_output(mem_pc),

        .reg_write_enable (reg_write_enable),
        .write_back_mux_select(write_back_mux_select),
        .write_back_addr (write_back_addr)
    );

    // WB周期

    mux32 write_back_mux (
        .dataA (lmd_output),
        .dataB (wb_alu_output),
        .select (write_back_mux_select),
        .out (write_back_data)
    );

endmodule
