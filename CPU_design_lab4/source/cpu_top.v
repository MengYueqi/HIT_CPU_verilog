//////////////////////////////////////////////////////////////////////////////////
//  @Copyright HIT team
//  CPU Automated testing environment
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

`define TEST_COUNT 10

module cpu_top(
    input         clk     ,
    input         reset   ,
    output [15 :0] leds ,
    output [31:0] debug_wb_pc,
    output        debug_wb_rf_wen,
    output [4 :0] debug_wb_rf_addr,
    output [31:0] debug_wb_rf_wdata
);

    // Initialize trace file registers
    reg [71:0] trace_data [`TEST_COUNT - 1 :0];

    initial begin
        $readmemh("../cpu_trace" , trace_data);
    end

//    // Instantiate the cpu
//    wire [31:0] debug_wb_pc;
//    wire        debug_wb_rf_wen;
//    wire [4 :0] debug_wb_rf_addr;
//    wire [31:0] debug_wb_rf_wdata;

    cpu U_cpu(
        .clk               (clk               ),
        .rst            (reset             ),
        .debug_wb_pc       (debug_wb_pc       ),
        .debug_wb_rf_wen   (debug_wb_rf_wen   ),
        .debug_wb_rf_addr  (debug_wb_rf_addr  ),
        .debug_wb_rf_wdata (debug_wb_rf_wdata )
    );

    // Compare the cpu data to the reference data
    reg         test_err;
    reg         test_pass;
    reg [31:0] test_counter;
    reg [15 :0] leds_reg;

    wire [31:0] ref_wb_pc       = trace_data[test_counter][71:40];
    wire [4 :0] ref_wb_rf_addr  = trace_data[test_counter][36:32];
    wire [31:0] ref_wb_rf_wdata = trace_data[test_counter][31: 0];
    
    assign leds = leds_reg;

    always @ (posedge clk) begin
        if (!reset) begin
            leds_reg     <= 16'hffff;
            test_err     <= 1'b0;
            test_pass    <= 1'b0;
            test_counter <= 0;
        end
        else if (debug_wb_pc == 32'h00000040 && !test_err && test_counter==`TEST_COUNT-1) begin
                $display("    ----PASS!!!");
                $display("Test end!");
                $display("==============================================================");
                test_pass <= 1'b1;
                leds_reg  <= 16'h0000;
                #5;
                $finish;
        end
        else if (debug_wb_rf_wen && |debug_wb_rf_addr && !test_pass) begin
            if (debug_wb_pc != ref_wb_pc || debug_wb_rf_addr != ref_wb_rf_addr || debug_wb_rf_wdata != ref_wb_rf_wdata) begin
            $display("--------------------------------------------------------------");
                $display("Error!!!");
                $display("    Reference : PC = 0x%8h, write back reg number = %2d, write back data = 0x%8h", ref_wb_pc, ref_wb_rf_addr, ref_wb_rf_wdata);
                $display("    Error     : PC = 0x%8h, write back reg number = %2d, write back data = 0x%8h", debug_wb_pc, debug_wb_rf_addr, debug_wb_rf_wdata);
                $display("--------------------------------------------------------------");
                $display("==============================================================");
                test_err     <= 1'b1;
                #5;
                $finish;
            end
            else begin
                test_counter <= test_counter + 1;
            end
        end
    end

endmodule
