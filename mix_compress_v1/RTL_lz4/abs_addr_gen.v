`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:40:48 09/15/2015 
// Design Name: 
// Module Name:    abs_addr_gen 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module abs_addr_gen(
input wire				clk,
input wire				rstN,
input wire	[31:0]	head_addr,	//	for absolute addr convert to relative addr
input wire	[2:0]		incr_bytes,
output wire	[31:0]	abs_addr_in 
);

reg	[31:0]	abs_addr_cnt;

assign			abs_addr_in	=	abs_addr_cnt; // + head_addr;

always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
//		abs_addr_in		<=	32'b0	;
		abs_addr_cnt	<=	32'b0	;
	end
	else
	begin
//		abs_addr_in		<=	abs_addr_cnt + head_addr;
		abs_addr_cnt	<=	abs_addr_cnt + incr_bytes;
	end
end

endmodule
