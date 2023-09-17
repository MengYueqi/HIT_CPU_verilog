module CU(
    input [ 5:0] opcode,	
    input [10:0] ALUfunc,	
    input        clk,		
    input        reset,		//  
	 input        equal,		// R[rs] == R[rt]
	 input [31:0] rt,			// R[rt]
	 
	 output reg   pc_enable,					
	 output reg   pc_select_enable,			
	 output reg   npc_enable,					
	 output reg   ir_enable,					
	 output reg   reg_write_enable,			
	 output reg   writeback_select_enable,	
	 output reg   mux1_select_enable,		
	 output reg   mux2_select_enable,		
	 output reg   [10:0] alu_op,				
	 output reg   mem_write_enable,			
	 output reg   mem_data_select_enable
    );
	 

	parameter [5:0] ALU = 6'b000000;
	parameter [5:0] SW  = 6'b101011;
	parameter [5:0] LW  = 6'b100011;
	parameter [5:0] BNE = 6'b000101;
	parameter [5:0] JMP = 6'b000010;
	parameter [5:0] MOVZ= 6'b001010;

	
	reg [4:0] STATE;
	
	always@(negedge clk) begin
	if(reset == 0) begin
		pc_enable <= 0;	// ***
		pc_select_enable <= 0;
		npc_enable <= 1;
		ir_enable <= 0;
		reg_write_enable <= 0;
		writeback_select_enable <= 0;
		mux1_select_enable <= 0;
		mux2_select_enable <= 0;
		mem_write_enable <= 0;
		mem_data_select_enable <= 0;
		STATE <= 5'b00000;
	end
	if(STATE == 5'b00000) begin
	case(opcode)
		ALU : alu_op <= ALUfunc[10:0];
		BNE : alu_op <= 6'b101000;
		JMP : alu_op <= 6'b110000;
		LW : alu_op <= 6'b100000;
		default: alu_op <= 6'b111000;
	endcase
	pc_enable <= 1'b0;
	ir_enable <= 1'b0;
	mem_write_enable <= 1'b0;
	pc_select_enable <= 1'b0;
	reg_write_enable <= 1'b0;
	writeback_select_enable <= (opcode == LW)? 1'b1 : 1'b0;
	mux1_select_enable <= (opcode == JMP || opcode == BNE)? 1'b0 : 1'b1;
	mux2_select_enable <= (opcode == JMP || opcode == BNE || opcode == LW || opcode == SW)? 1'b1 : 1'b0;
	mem_data_select_enable <= (opcode == LW)? 1'b0 : 1'b1;
	STATE <= STATE + 1;
	end
	end
	
	always@(negedge clk) begin
	if(reset == 0) begin
		pc_enable <= 0;	// ***
		pc_select_enable <= 0;
		npc_enable <= 1;
		ir_enable <= 0;
		reg_write_enable <= 0;
		writeback_select_enable <= 0;
		mux1_select_enable <= 0;
		mux2_select_enable <= 0;
		mem_write_enable <= 0;
		mem_data_select_enable <= 0;
		STATE <= 5'b00000;
	end
	if(STATE == 5'b00001) begin
	case(opcode)
		ALU : alu_op <= ALUfunc[10:0];
		BNE : alu_op <= 6'b101000;
		JMP : alu_op <= 6'b110000;
		LW : alu_op <= 6'b100000;
		default: alu_op <= 6'b111000;
	endcase
	 pc_enable <= 1'b0;
	ir_enable <= 1'b0;
	mem_write_enable <= 1'b0;
	pc_select_enable <= 1'b0;
	reg_write_enable <= 1'b0;
	writeback_select_enable <= (opcode == LW)? 1'b1 : 1'b0;
	mux1_select_enable <= (opcode == JMP || opcode == BNE)? 1'b0 : 1'b1;
	mux2_select_enable <= (opcode == JMP || opcode == BNE || opcode == LW || opcode == SW)? 1'b1 : 1'b0;
	mem_data_select_enable <= (opcode == LW)? 1'b0 : 1'b1;
	STATE <= STATE + 1;
	end
	end
	
	always@(negedge clk) begin
	if(reset == 0) begin
		pc_enable <= 0;	// ***
		pc_select_enable <= 0;
		npc_enable <= 1;
		ir_enable <= 0;
		reg_write_enable <= 0;
		writeback_select_enable <= 0;
		mux1_select_enable <= 0;
		mux2_select_enable <= 0;
		mem_write_enable <= 0;
		mem_data_select_enable <= 0;
		STATE <= 5'b00000;
	end
	if(STATE == 5'b00010) begin
	case(opcode)
		ALU : alu_op <= ALUfunc[10:0];
		BNE : alu_op <= 6'b101000;
		JMP : alu_op <= 6'b110000;
		LW : alu_op <= 6'b100000;
		default: alu_op <= 6'b111000;
	endcase
	 pc_enable <= 1'b0;
	ir_enable <= 1'b0;
	mem_write_enable <= (opcode == SW)? 1'b1 : 1'b0;
	pc_select_enable <= 1'b0;
	reg_write_enable <= 1'b0;
	writeback_select_enable <= (opcode == LW)? 1'b1 : 1'b0;
	mux1_select_enable <= (opcode == JMP || opcode == BNE)? 1'b0 : 1'b1;
	mux2_select_enable <= (opcode == JMP || opcode == BNE || opcode == LW || opcode == SW)? 1'b1 : 1'b0;
	mem_data_select_enable <= (opcode == LW)? 1'b0 : 1'b1;
	STATE <= STATE + 1;
	end
    end
    
    always@(negedge clk) begin
    if(reset == 0) begin
		pc_enable <= 0;	// ***
		pc_select_enable <= 0;
		npc_enable <= 1;
		ir_enable <= 0;
		reg_write_enable <= 0;
		writeback_select_enable <= 0;
		mux1_select_enable <= 0;
		mux2_select_enable <= 0;
		mem_write_enable <= 0;
		mem_data_select_enable <= 0;
		STATE <= 5'b00000;
	end
	if(STATE == 5'b00011) begin
	case(opcode)
		ALU : alu_op <= ALUfunc[10:0];
		BNE : alu_op <= 6'b101000;
		JMP : alu_op <= 6'b110000;
		LW : alu_op <= 6'b100000;
		default: alu_op <= 6'b111000;
	endcase
	pc_enable <= 1'b0;
	ir_enable <= 1'b0;
	mem_write_enable <= 1'b0;
	pc_select_enable <= 1'b0;
	if (opcode == LW || (opcode == ALU && !(ALUfunc[5:0] == MOVZ && rt != 0))) begin
		reg_write_enable <= 1'b1;
	end 
	else begin
		reg_write_enable <= 1'b0;
	end
	writeback_select_enable <= (opcode == LW)? 1'b1 : 1'b0;
	mux1_select_enable <= (opcode == JMP || opcode == BNE)? 1'b0 : 1'b1;
	mux2_select_enable <= (opcode == JMP || opcode == BNE || opcode == LW || opcode == SW)? 1'b1 : 1'b0;
	mem_data_select_enable <= (opcode == LW)? 1'b0 : 1'b1;
	STATE <= STATE + 1;
    end
    end
    
    always@(negedge clk) begin
    if(reset == 0) begin
		pc_enable <= 0;	// ***
		pc_select_enable <= 0;
		npc_enable <= 1;
		ir_enable <= 0;
		reg_write_enable <= 0;
		writeback_select_enable <= 0;
		mux1_select_enable <= 0;
		mux2_select_enable <= 0;
		mem_write_enable <= 0;
		mem_data_select_enable <= 0;
		STATE <= 5'b00000;
	end
	if(STATE == 5'b00100) begin
	case(opcode)
		ALU : alu_op <= ALUfunc[10:0];
		BNE : alu_op <= 6'b101000;
		JMP : alu_op <= 6'b110000;
		LW : alu_op <= 6'b100000;
		default: alu_op <= 6'b111000;
	endcase
	pc_enable <= 1'b1;
    ir_enable <= 1'b1;
	mem_write_enable <= 1'b0;
	pc_select_enable <= (opcode == JMP || (opcode == BNE && equal == 0))? 1'b1 : 1'b0;
	reg_write_enable <= 1'b0;
	writeback_select_enable <= (opcode == LW)? 1'b1 : 1'b0;
	mux1_select_enable <= (opcode == JMP || opcode == BNE)? 1'b0 : 1'b1;
	mux2_select_enable <= (opcode == JMP || opcode == BNE || opcode == LW || opcode == SW)? 1'b1 : 1'b0;
	mem_data_select_enable <= (opcode == LW)? 1'b0 : 1'b1;
	STATE <= 5'b00000;
    end
    end
    endmodule
	

