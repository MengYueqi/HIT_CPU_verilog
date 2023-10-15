`timescale 1ns / 1ps


module ADD(
input [31:0] dataA,
input [31:0] dataB,
output reg [31:0] result
);

always@(dataA or dataB) begin
result = dataA + dataB;
end

endmodule
