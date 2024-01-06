/* 该表仅缓存了一路的tag，对于两路的设计需要例化两个该表 */
module icache_tagv_table(
    input           clk,        //时钟信号
    input           resetn,     //低有效复位信号

    //写端口（Cache miss加载新Cache行后）
    input           wen,        //写使能
    input           valid_wdata,//写入有效位的值（一般为1）
    input[19:0]     tag_wdata,  //写入tag的值
    input[6:0]      windex,     //写入Cache行对应的index

    //读端口（Cache第一级流水段提出请求）
    input           rden,       //读使能
    input[31:0]     cpu_addr,   //来自CPU的地址
    output hit                  //命中结果，在上升沿后输出
    );

    reg[127:0]      valids;     //有效位，实现为128位寄存器
    reg[19:0]       tags[0:127];//每个Cache行的tag

    genvar i;
    generate
        for(i=0; i < 128; i = i + 1) begin
            initial begin
                tags[i]=0;      //将tag ram在初始时清0
                //不需在复位时对tag ram清0，因为复位时已将有效位清0了
            end
        end
    endgenerate

    //写入处理
    always@(posedge clk) begin
        if(~resetn)
            valids <= 0;        //复位时将所有Cache行置为无效
        else begin
            if(wen) begin
                valids[windex] <= valid_wdata;
                tags[windex] <= tag_wdata;
            end
        end
    end

    //一二级流水段间的中间寄存器
    reg[19:0]       reg_tag;    //一级流水段读出的tag
    reg             reg_valid;  //一级流水段读出的有效位
    reg[31:0]       reg_cpu_addr;   //缓存的CPU地址

    wire[6:0]       cpu_index=cpu_addr[11:5];   //CPU地址的index，作为读地址（第一级流水）
    wire[19:0]      r_cpu_tag=reg_cpu_addr[31:12];    //CPU地址的tag，用于选路（第二级流水）

    //读处理
    always@(posedge clk) begin
        if(~resetn) begin
            reg_tag <= 0;
            reg_valid <= 0;
            reg_cpu_addr <= 0;
        end
        else begin
            if(rden) begin
                reg_tag <= tags[cpu_index];
                reg_valid <= valids[cpu_index];
                reg_cpu_addr <= cpu_addr;
            end
        end
    end

    //在第二级流水段根据读出的tag判断命中
    assign hit=(r_cpu_tag == reg_tag) & reg_valid;

endmodule