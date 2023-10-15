`timescale 1ns / 1ps

module extender(
    input [15:0] instr_index,
    output [31:0] ext_instr_index
    );
    assign ext_instr_index = {{16{instr_index[15]}}, instr_index};
endmodule
