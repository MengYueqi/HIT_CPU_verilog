module branch_predictor(
    input           clk,
    input           resetn,
    input[31:0]     old_PC,
    input           predict_en,
    output reg[31:0]    new_PC,
    output reg         predict_jump,
    input           upd_en,
    input[31:0]     upd_addr,
    input           upd_jumpinst,
    input           upd_jump,
    input           upd_predfail,
    input[31:0]     upd_target
);

    reg[1:0] flag; // BPB表中的状态值
    reg[31:0] btb_pc [63:0];
    reg[31:0] btb_target [63:0];
    reg btb_vaild[63:0];
    reg [1:0] global_flag[63:0];
    integer i;
    
    // 重置操作
    always@(posedge clk) begin
    if (!resetn) begin
    flag <= 2'b11;
    for (i=0; i<64; i=i+1) begin
    btb_vaild[i] <= 1'b0;
    btb_pc[i] <= 32'h00000000;
    btb_target[i] <= 32'h00000000;
    global_flag[i] <= 2'b00;
    end
    end
    end
    
    always@(negedge clk) begin
//    always@(posedge clk) begin
//    always@(*) begin
    if (upd_en && upd_jumpinst) begin
    
    // 根据当前的flag值和之前是否预测成功更新flag
    if (flag == 2'b11 && upd_predfail) begin
    flag <= 2'b10;
    global_flag[upd_addr[7:2]] <= 2'b10;
    end
    if (flag == 2'b10 && upd_predfail) begin
    flag <= 2'b00;
    global_flag[upd_addr[7:2]] <= 2'b00;
    end 
    if (flag == 2'b10 && !upd_predfail) begin
    flag <= 2'b11;
    end 
    if (flag == 2'b00 && upd_predfail) begin
    flag <= 2'b01;
    global_flag[upd_addr[7:2]] <= 2'b01;
    end
    if (flag == 2'b01 && upd_predfail) begin
    flag <= 2'b11;
    global_flag[upd_addr[7:2]] <= 2'b11;
    end  
    if (flag == 2'b01 && !upd_predfail) begin
    flag <= 2'b00;
    end  
    end
    
    // 如果跳转指令在BTB中无记录，则将指令相关内容存储到BTB中
    if (btb_vaild[upd_addr[7:2]] == 1'b0 && upd_jumpinst) begin
    btb_vaild[upd_addr[7:2]] <= 1'b1;
    btb_pc[upd_addr[7:2]] <= upd_addr;
    btb_target[upd_addr[7:2]] <= upd_target;
    global_flag[upd_addr[7:2]] <= flag;
    end
    
    // 根据当前的PC值和BTB中的历史记录进行预测
    if (btb_vaild[old_PC[7:2]] && (btb_pc[old_PC[7:2]] == old_PC) && predict_en) begin
    if ((global_flag[old_PC[7:2]] == 2'b10) || (global_flag[old_PC[7:2]] == 2'b11)) begin
    new_PC<=btb_target[old_PC[7:2]];
    predict_jump<=1'b1;
    end
    else begin
    // 若预测不跳转，则直接PC+4
    new_PC<=old_PC + 4;
    predict_jump<=1'b0;
    end
    end
    else begin
     // 若BTB中没有记录，则直接PC+4
    new_PC<=old_PC + 4; 
    predict_jump<=1'b0;
    end
    
    end
    
    
      
//    assign new_PC=old_PC + 4;   //ÿ�ζ�Ԥ�ⲻת�ƣ���һ����ַһ��ΪPC+4
//    assign predict_jump=1'b0;

endmodule