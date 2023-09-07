`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/04 05:41:29
// Design Name: 
// Module Name: cpu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

module cpu (
    input            clk             ,  // clock, 100MHz
    input            rst             ,  // active high, board switch 0 (SW0)

    // debug signals
    output [31:0]    debug_wb_pc     ,	
    output           debug_wb_rf_wen ,	
    output [4 :0]    debug_wb_rf_addr,	
    output [31:0]    debug_wb_rf_wdata 
);

   //data wire
	wire [31:0] new_address;
	wire [31:0] pc_output_address;
	wire [31:0] pc_adder_output;
	wire [31:0] npc_output;
	wire [31:0] imem_ir;
	wire [31:0] current_instruction;
	wire [31:0] writeback_data;
	wire [ 4:0]  writeback_address;
	wire [31:0] reg_output1;
	wire [31:0] reg_output2; 
	wire [31:0] holderA;
	wire [31:0] holderB;
	wire [31:0] imm32b;
	wire [31:0] holderImm;
	wire [31:0] alu_dataA; 
	wire [31:0] alu_dataB;
	wire        zero;
	wire [31:0] alu_temp;
	wire [31:0] alu_result;
	wire [31:0] mem_data_temp;
	wire [31:0] mem_data;
	
	//command wire
	wire [ 5:0] opcode;
	wire [ 4:0] rs1;
	wire [ 4:0] rs2;
	wire [ 4:0] rrd;
	wire [10:0] alu_func;
	wire [25:0] imm26b;
	
	//command bind
	assign opcode   = current_instruction[31:26];
	assign rs1      = current_instruction[25:21];
	assign rs2      = current_instruction[20:16];
	assign rrd      = current_instruction[15:11];
	assign alu_func = current_instruction[10: 0];
	assign imm26b   = current_instruction[25: 0];
	
	//CU enable
	wire 		  pc_enable;
	wire 		  pc_select_enable;
	wire 		  npc_enable;
	wire 		  ir_enable;
	wire 		  reg_write_enable;
	wire 		  writeback_select_enable;
	wire 		  mux1_select_enable;
	wire       mux2_select_enable;
	wire [5:0] alu_op;
	wire       mem_write_enable;
	wire       mem_data_select_enable;
	
	//CU input
	wire equal;
	wire [31:0] rt;
	wire pc_num;
	
	//CPU output
	assign debug_wb_pc = pc_output_address;
	assign debug_wb_rf_wen = reg_write_enable;
	assign debug_wb_rf_addr = writeback_address;
	assign debug_wb_rf_wdata = writeback_data;
	
	//IF state
	PC pc(
		.clk           (clk              ), 		
		.reset         (rst            ), 
		.new_address   (new_address      ), 
		.pc_enable     (pc_enable        ), 
		.output_address(pc_output_address)
	);
	
	ADD pc_adder(
		.data1 (pc_output_address), 
		.data2 (32'h00000004), 
		.result (pc_adder_output	)
	);
	
	MUX32 pc_select(
		.input_data1 (alu_temp        ), 
		.input_data0   (pc_adder_output ), 
		.select   (pc_select_enable), 
		.output_data (new_address     )
	);
	
	
	NPC npc(
		.clk           (clk        ), 
		.reset			(rst		),
		.input_address (new_address), 
		.npc_enable    (npc_enable ),
		.output_address(npc_output )
	);
	
	IMEM instruction_memory(
		.address            (pc_output_address), 
		.output_instruction (imem_ir          )
	);
	
	IR ir(
		.clk               (clk                ), 
		.reset             (rst              ), 
		.input_instruction (imem_ir            ), 
		.ir_enable         (ir_enable          ), 
		.output_instruction(current_instruction)
	);
	
	//ID state
	Registers register_set(
		.clk              (clk              ), 	
		.reset            (rst            ), 		
		.RS_1             (rs1              ), 
		.RS_2             (rs2              ),
		.writeback_address(writeback_address),
		.writeback_data   (writeback_data   ),
		.write_enable     (reg_write_enable ), 
		.output_data_1    (reg_output1      ), 
		.output_data_2    (reg_output2      )
	);			
	
	Data_holder reg_holder_A(
		.clk(clk        ),
		.in (reg_output1),
		.out(holderA    )
	);
	
	Data_holder reg_holder_B(
		.clk(clk        ),
		.in (reg_output2), 
		.out(holderB    )
	);
	
	Extender extender(
		.opcode       (opcode), 
		.input_26bimm (imm26b), 
		.output_32bimm(imm32b)
	);
	
	Data_holder imm_holder(
		.clk(clk      ),
		.in (imm32b   ), 
		.out(holderImm)
	);
	
	MUX32 writeback_select(
		.select           (writeback_select_enable), 
		.input_data1      (rs2                    ),   // ***
		.input_data0       (rrd                    ),
		.output_data(writeback_address      )
	);	
		
	
	MUX32 mux1(
		.input_data0(npc_output        ),
		.input_data1(holderA           ), 
		.select     (mux1_select_enable), 
		.output_data(alu_dataA         )
	);
	
	MUX32 mux2(
		.input_data0(holderB           ), 
		.input_data1(holderImm			), 
		.select     (mux2_select_enable), 
		.output_data(alu_dataB         )
	);
	
	ALU alu( 
		.clk          (clk      ), 
		.reset        (rst    ), 
		.alu_op       (alu_op   ),
		.input_data1  (alu_dataA),
		.input_data2  (alu_dataB), 
		.output_result(alu_temp ),
		.equal_mov(equal)
	);
	
	ALU_output alu_output(
		.clk        (clk       ), 
		.input_data (alu_temp  ), 
		.output_data(alu_result)
	);
	
	//MEM state
	DMEM data_memory(
		.clk           (clk             ), 
		.reset         (rst           ),
		.alu_address   (alu_result      ), 
		.data          (holderB         ), 	// ***
		.write_enable  (mem_write_enable), 
		.out           (mem_data_temp   )
	);
	
	LMD mem_holder(
		.clk(clk          ),
		.in (mem_data_temp),
		.out(mem_data     )
	);
	
	//WB state
	MUX32 mux3(
		.input_data0(mem_data              ), 
		.input_data1(alu_result            ), 
		.select		(mem_data_select_enable), 
		.output_data(writeback_data        )
	);
	 
	//CU
	CU cu(
		.clk                    (clk							), 
		.reset                  (rst						), 
		.opcode                 (opcode						),
		.ALUfunc                (alu_func					), 
		.equal                  (equal						),
		.rt							(reg_output2				),	// ***
		.pc_enable              (pc_enable					),
		.pc_select_enable       (pc_select_enable			),
		.npc_enable             (npc_enable					), 
		.ir_enable              (ir_enable					),
		.reg_write_enable       (reg_write_enable       ),
		.writeback_select_enable(writeback_select_enable),
		.mux1_select_enable     (mux1_select_enable     ),
		.mux2_select_enable     (mux2_select_enable     ), 
		.alu_op						(alu_op						), 
		.mem_write_enable       (mem_write_enable			),
		.mem_data_select_enable (mem_data_select_enable )
	);

endmodule
