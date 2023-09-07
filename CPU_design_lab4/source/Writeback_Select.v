module Writeback_Select(
    input        select,
    input  [4:0] rt_address,
    input  [4:0] rd_address,
	 
    output [4:0] writeback_address
);
	
	assign writeback_address = (select == 1)? rt_address : rd_address;


endmodule
