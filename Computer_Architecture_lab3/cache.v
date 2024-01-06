module cache (
    input            clk             ,  // clock, 100MHz
    input            rst             ,  // active low

    //  Sram-Like接口信号，用于CPU访问Cache
    input         cpu_req      ,    //由CPU发送至Cache
    input  [31:0] cpu_addr     ,    //由CPU发送至Cache
    output reg [31:0] cache_rdata  ,    //由Cache返回给CPU
    output   reg    cache_addr_ok,    //由Cache返回给CPU
    output   reg  cache_data_ok,    //由Cache返回给CPU

    //  AXI接口信号，用于Cache访问主存
    output reg [3 :0] arid   ,              //Cache向主存发起读请求时使用的AXI信道的id号
    output reg [31:0] araddr ,              //Cache向主存发起读请求时所使用的地址
    output   reg     arvalid,              //Cache向主存发起读请求的请求信号
    input         arready,              //读请求能否被接收的握手信号

    input  [3 :0] rid    ,              //主存向Cache返回数据时使用的AXI信道的id号
    input  [31:0] rdata  ,              //主存向Cache返回的数据
    input         rlast  ,              //是否是主存向Cache返回的最后一个数据
    input         rvalid ,              //主存向Cache返回数据时的数据有效信号
    output    reg    rready                //标识当前的Cache已经准备好可以接收主存返回的数据
);

    /*TODO：完成指令Cache的设计代码*/
    reg w_tag_1;
    reg w_tag_2;
    wire hit_1;
    wire hit_2;
    reg hit_temp; // 保存hit
    wire [31:0]out_data1;
    wire [31:0]out_data2;
    reg hit; // 确定最终是否命中
    integer i;
    reg data_ok;
    reg miss; // 标记是否缺失
    reg load; // 标记是否正在载入
    reg reset_i; // 重置i信号
    reg [2:0]temp_tr;
//    reg rlast_temp; // 保存last数据
    
    // 当前取数地址的寄存器
    reg [31:0] reg_addr;
    reg [19:0] reg_tag    ;
    reg [6 :0] reg_index  ;
    reg [4 :0] reg_offset ;
    integer switch;
//    reg [9 :0] write_addr;
//    reg [31:0] write_data_temp;
        
    // 实例化两个tag表
    icache_tagv_table tag_table1(
        .clk(clk),
        .resetn(rst),
        .wen(w_tag_1),
        .valid_wdata(1'b1),
        //        .tag_wdata(reg_tag),
        .tag_wdata(reg_addr[31:12]),
//        .windex(reg_index),
        .windex(reg_addr[11:5]),
        .rden(1),
        .cpu_addr(cpu_addr),
        .hit(hit_1)
    );
    
    icache_tagv_table tag_table2(
        .clk(clk),
        .resetn(rst),
        .wen(w_tag_2),
        .valid_wdata(1'b1),
//        .tag_wdata(reg_tag),
        .tag_wdata(reg_addr[31:12]),
//        .windex(reg_index),
        .windex(reg_addr[11:5]),
        .rden(1),
        .cpu_addr(cpu_addr),
        .hit(hit_2)
    );
    
    // 实例化两个存储数据的ram
    blk_mem_gen_0 data_1(
        .clka(clk),
        .wea(w_tag_1),
//        .addra(write_addr),
        .addra({reg_addr[11:5], 3'd0} + i),
//        .dina(write_data_temp),
        .dina(rdata),
        .clkb(clk),
        .enb(1'b1),
        .addrb(i == 0 ?  cpu_addr[11:2] : reg_addr[11:2]),
        .doutb(out_data1)
    );
    
    blk_mem_gen_0 data_2(
        .clka(clk),
        .wea(w_tag_2),
//        .addra(write_addr),
        .addra({reg_addr[11:5], 3'd0} + i),
//        .dina(write_data_temp),
        .dina(rdata),
        .clkb(clk),
        .enb(1'b1),
        .addrb(i == 0 ?  cpu_addr[11:2] : reg_addr[11:2]),
        .doutb(out_data2)
    );
    
    
    always@(i) begin
        if (temp_tr == 3'b111 && i == 7)  begin
                 assign cache_rdata = rdata;
        end
        else begin
            if (w_tag_1) begin
                assign cache_rdata = out_data1;  
            end   
            else begin
                assign cache_rdata = out_data2;
            end
        end
    end
    
    always@(hit, i, load, miss, posedge clk) begin
        if(hit && (i == 7 || i == 0) && load == 1'b0) begin
            if (data_ok) begin
                cache_data_ok = 1'b1;
                cache_addr_ok = 1'b1;
        end
           data_ok = 1'b1;
        end
        if (i == 7 && hit == 1'b0) begin
            cache_data_ok = 1'b1;
            cache_addr_ok = 1'b1;
//            i = 0;
        end
        else if (load == 1'b1) begin
            cache_data_ok <= 1'b0;
            cache_addr_ok <= 1'b0;
        end
        else if (hit == 1'b0 && rst == 1'b1) begin
            cache_data_ok = 1'b0;
            cache_addr_ok = 1'b0;
        end
    end
    
    
    always@(posedge clk, i) begin
    if (!rst) begin
            cache_data_ok = 1'b0;
            cache_addr_ok = 1'b1;
            arvalid = 1'b0;
            rready = 1'b0;
            i = 0;
            w_tag_1 = 1'b0;
            w_tag_2 = 1'b0;
            miss = 1'b0;
            data_ok = 1'b0;
            load = 1'b0;
            switch = 0;
//            rlast_temp = 1'b0;
        end
    else begin
        if (i == 7) begin
             // 关闭写使能
             w_tag_1 <= 1'b0;
             w_tag_2 <= 1'b0;
             reset_i <= 1'b1;
             i = 0;
        end
    
        if (cache_addr_ok) begin
            reg_tag<=cpu_addr[31:12];
            reg_index<=cpu_addr[11:5];
            reg_offset<=cpu_addr[4:0];
            reg_addr<=cpu_addr;
        end
        
        assign hit = hit_1 | hit_2;
        hit_temp <= hit_1; // 保存上一周期的hit数据
        
        if (hit == 1'b1 && (i == 7 || i == 0) && load == 1'b0) begin  // 保证装填完成后再执行
        miss <= 1'b0;
        

            // 准备将要返回的数据
            if (hit_temp) begin
                assign cache_rdata = out_data1;  
            end   
            else begin
                assign cache_rdata = out_data2;
            end
        end
        else begin
            // 阻塞cache
            
            cache_data_ok <= 1'b0;
            cache_addr_ok <= 1'b0;
            miss <= 1'b1;
            load <= 1'b1;
            data_ok = 1'b0;
            
            if (switch % 2) begin
            // 打开写使能
            w_tag_1 <= 1'b0;
            w_tag_2 <= 1'b1;
            end
            
            if (switch % 2) begin
            // 打开写使能
            w_tag_1 <= 1'b1;
            w_tag_2 <= 1'b0;
            end
                     
            // 设置握手信号
            arid <= 3'b000;
            assign araddr = {reg_addr[31:5], 5'd0};
            arvalid <= 1'b1;
            if (arready == 1'b0) begin
                rready <= 1'b1;
                arvalid <= 1'b0;
                if (rvalid) begin
//                write_data_temp <= rdata;
//                rlast_temp <= rlast;
                    if (!rlast) begin
                          // 更新将要写入的addr
//                        write_addr <= {cpu_addr[11:5], 3'd0} + i;
                        i = i+1;
                    end
                    else begin
                        rready = 1'b0;
                    end
                    
                end
            end 
        end
    end
    end
    
    always@(rlast) begin
        if (rlast) begin
            i = 7;
            load = 1'b0;
        end
    end
    
    always@(cache_data_ok) begin
        if(hit == 1'b0 && i != 7) begin
            temp_tr = cpu_addr[4:2];
        end
    end
    
    always@(posedge clk) begin
        switch = switch + 1;
    end
    
    
    

endmodule