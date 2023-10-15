`timescale 1ns / 1ps

`define ALU 6'b000000
`define SW 6'b101011
`define LW 6'b100011

module hazard(
    input [31:0] if_id_ir,
    input [31:0] id_ex_ir,
    input [31:0] ex_mem_ir,
    input [31:0] mem_wb_ir,
    input [31:0] mem_rt,
    input [31:0] wb_rt,
    output reg pc_write,
    output reg if_id_write_enable,
    output reg id_ex_reset,
    output reg [1:0] forward_A,
    output reg [1:0] forward_B
    );
    reg [4:0] if_id_rs, if_id_rt, id_ex_rd, id_ex_rs, id_ex_rt, mem_rd, wb_rd;
    reg mem_reg_write, wb_reg_write;
    
    always @(*) begin
        pc_write <= 1'b1;
        if_id_write_enable <= 1'b1;
        id_ex_reset <= 1'b1;
        forward_A <= 2'b00;
        forward_B <= 2'b00;

        // ��ȡ��if_id�εļĴ�������
        if_id_rs <= if_id_ir[25:21];
        if_id_rt <= if_id_ir[20:16];

        if (id_ex_ir[31:26] == `ALU) begin
            id_ex_rd <= id_ex_ir[15:11];
        end else if (id_ex_ir[31:26] == `LW) begin
            id_ex_rd <= id_ex_ir[20:16];
        end
        
        // �ж��Ƿ����д��������
        if (id_ex_ir[31:26] == `LW && ((if_id_rs == id_ex_rd) || (if_id_rt == id_ex_rd))) begin
            if_id_write_enable <= 1'b0;
            pc_write <= 1'b0;
            id_ex_reset <= 1'b0;
        end
        
        
        // ����·�ṹ��ѡ���źŽ��и�ֵ
        // ������·������ѡ���жϣ�����movez����rt = 0ʱ����������·��������Ҫ��������
        mem_reg_write <= (ex_mem_ir[31:26] == `LW) || ((ex_mem_ir[31:26] == `ALU) && ((ex_mem_ir[10:0] == 11'b00000_001010 && mem_rt != 32'h0) || (ex_mem_ir[10:0] != 11'b00000_001010)));
        wb_reg_write <= (mem_wb_ir[31:26] == `LW) || ((mem_wb_ir[31:26] == `ALU) && ((mem_wb_ir[10:0] == 11'b00000_001010 && wb_rt != 32'h0) || (mem_wb_ir[10:0] != 11'b00000_001010)));

        // �������ALUָ����ڴ˹����в��������ݳ�ͻ������·ѡ���ź�Ϊ0
        if ((id_ex_ir[31:26] != `ALU) || (mem_reg_write == 1'b0) || (wb_reg_write == 1'b0)) begin
            forward_A <= 2'b00;
            forward_B <= 2'b00;
        end

        // ����ָ��
        id_ex_rs <= id_ex_ir[25:21];
        id_ex_rt <= id_ex_ir[20:16];

        // �ж�mem��Ҫд�ļĴ��������ҽ�����ȡ����
        if (ex_mem_ir[31:26] == `ALU) begin
            mem_rd <= ex_mem_ir[15:11];
        end else if (ex_mem_ir[31:26] == `LW) begin
            mem_rd <= ex_mem_ir[20:16];
        end
        
        // �ж�wb��Ҫд�ļĴ��������ҽ�����ȡ����
        if (mem_wb_ir[31:26] == `ALU) begin
            wb_rd <= mem_wb_ir[15:11];
        end else if (mem_wb_ir[31:26] == `LW) begin
            wb_rd <= mem_wb_ir[20:16];
        end
        
        // �ж�A���ݵĳ�ͻ
        if (mem_reg_write && (mem_rd != 5'h0) && (mem_rd == id_ex_rs)) begin
            forward_A <= 2'b01;
        end
        if (wb_reg_write && (wb_rd != 5'h0) && (wb_rd == id_ex_rs) && !(mem_reg_write && (mem_rd != 5'h0) && (mem_rd == id_ex_rs))) begin
            forward_A <= 2'b10;
        end
        
        // �ж�B���ݵĳ�ͻ
        if (wb_reg_write && (wb_rd != 5'h0) && (wb_rd == id_ex_rt) && !(mem_reg_write && (mem_rd != 5'h0) && (mem_rd == id_ex_rt))) begin
            forward_B <= 2'b10;
        end
        if (mem_reg_write && (mem_rd != 5'h0) && (mem_rd == id_ex_rt)) begin
            forward_B <= 2'b01;
        end

        
    end
endmodule
