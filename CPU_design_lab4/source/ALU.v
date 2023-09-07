module ALU(
	input [10:0] alu_op,		
    input [31:0] input_data1,
    input [31:0] input_data2,
	input       clk,
	input       reset,
	 
    output reg [31:0] output_result, 
    output reg equal_mov 
);
	
	reg [31:0] temp;

	always@(input_data1 or input_data2 or alu_op[5:0]) begin		
		if(reset == 0) begin
			output_result = 32'b0;
			temp = 32'b0;
		end
		
		else begin
			case(alu_op[5:0])
				6'b101000 : begin 
				// BNE
				output_result = (input_data2 << 2) + input_data1;	
				equal_mov = (input_data1 - input_data2 == 0) ? 1 : 0;
				end
				6'b000000 : output_result = input_data2 << alu_op[10:6];
				6'b100000 : output_result = input_data1 + input_data2;
				6'b100010 : output_result = input_data1 - input_data2;
				6'b100100 : output_result = input_data1 & input_data2;
				6'b100101 : output_result = input_data1 | input_data2;
				6'b100110 : output_result = input_data1 ^ input_data2;
				6'b101010 : output_result = (input_data1 < input_data2)? 32'h000000001 : 32'h00000000;
				6'b001010 : output_result = (input_data2 == 0)? input_data1 : 32'h00000000;  // ������ֵ
				6'b110000 : begin
								//JMP
								temp = input_data2 << 2;
								output_result = {input_data1[31:28], temp[27:0]};
								output_result = {input_data1[31:28], temp[27:0]};								
							end
				default:
					begin
						output_result = input_data1 + input_data2;
					end
			endcase
		end	
	end
endmodule
