`timescale 1ns / 1ps

`define ALU 6'b000000
`define SW 6'b101011
`define LW 6'b100011

module forwarding_unit(
    input [31:0] id_ex_ir,
    input [31:0] ex_mem_ir,
    input [31:0] mem_wb_ir,
    input [31:0] mem_rt,
    input [31:0] wb_rt,
    output reg [1:0] forward_A,
    output reg [1:0] forward_B
    );
    
    reg mem_reg_write, wb_reg_write;
    reg [4:0] rs, rt, mem_rd, wb_rd;

    always @(*) begin
        forward_A <= 2'b00;
        forward_B <= 2'b00;
        // ������·������ѡ���жϣ�����movez����rt = 0ʱ����������·��������Ҫ��������
        mem_reg_write <= (ex_mem_ir[31:26] == `LW) ||
                         ((ex_mem_ir[31:26] == `ALU) && 
                            ((ex_mem_ir[10:0] == 11'b00000_001010 && mem_rt != 32'h0) || (ex_mem_ir[10:0] != 11'b00000_001010)));
        wb_reg_write <= (mem_wb_ir[31:26] == `LW) ||
                        ((mem_wb_ir[31:26] == `ALU) && ((mem_wb_ir[10:0] == 11'b00000_001010 && wb_rt != 32'h0) || (mem_wb_ir[10:0] != 11'b00000_001010)));

        // �������ALUָ����ڴ˹����в��������ݳ�ͻ������·ѡ���ź�Ϊ0
        if ((id_ex_ir[31:26] != `ALU) || (mem_reg_write == 1'b0) || (wb_reg_write == 1'b0)) begin
            forward_A <= 2'b00;
            forward_B <= 2'b00;
        end

        // ����ָ��
        rs <= id_ex_ir[25:21];
        rt <= id_ex_ir[20:16];

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
        
        // �ж���mem���Ƿ��г�ͻ
        if (mem_reg_write && (mem_rd != 5'h0) && (mem_rd == rs)) begin
            forward_A <= 2'b01;
        end
        if (mem_reg_write && (mem_rd != 5'h0) && (mem_rd == rt)) begin
            forward_B <= 2'b01;
        end

        // �ж���wb���Ƿ��г�ͻ
        if (wb_reg_write && (wb_rd != 5'h0) && (wb_rd == rs) && !(mem_reg_write && (mem_rd != 5'h0) && (mem_rd == rs))) begin
            forward_A <= 2'b10;
        end
        if (wb_reg_write && (wb_rd != 5'h0) && (wb_rd == rt) && !(mem_reg_write && (mem_rd != 5'h0) && (mem_rd == rt))) begin
            forward_B <= 2'b10;
        end

    end


endmodule
