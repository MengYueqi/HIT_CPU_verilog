`timescale 1ns / 1ps

module select_tb();
reg sel;
reg a;
reg b;
wire out;

select select_inst(
    .sel(sel),
    .b(b),
    .a(a),
    .out(out)
);

initial
begin
sel = 0; a = 0; b = 0;
#200;
sel = 0; a = 0; b = 1;
#200;
sel = 0; a = 1; b = 0;
#200;
sel = 0; a = 1; b = 1;
#200;
sel = 1; a = 0; b = 0;
#200;
sel = 1; a = 0; b = 1;
#200;
sel = 1; a = 1; b = 0;
#200;
sel = 1; a = 1; b = 1;
#200;
end
    
endmodule
