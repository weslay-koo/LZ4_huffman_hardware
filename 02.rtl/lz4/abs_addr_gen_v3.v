`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:22:58 04/20/2016 
// Design Name: 
// Module Name:    abs_addr_gen_v3 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 3.01 - File Created
// Additional Comments: 	byte seq    	1		2		3		4		5		6		7	
//									dword addr 	addr1	addr2	addr3	addr4
//
//////////////////////////////////////////////////////////////////////////////////
module abs_addr_gen_v3(
input wire				clk,
input wire				rstN,
input wire	[31:0]	head_addr,	//	for absolute addr convert to relative addr
input wire	[2:0]		incr_bytes,
output wire	[31:0]	abs_addr,
output wire	[31:0]	abs_addr1,
output wire	[31:0]	abs_addr2,
output wire	[31:0]	abs_addr3,
output wire	[31:0]	abs_addr4
);

reg	[31:0]	abs_addr_cnt;

assign			abs_addr		=	abs_addr_cnt; // + head_addr;
assign			abs_addr1	=	abs_addr_cnt;			// abs addr value smallest
assign			abs_addr2	=	abs_addr_cnt + 3'h1;
assign			abs_addr3	=	abs_addr_cnt + 3'h2;
assign			abs_addr4	=	abs_addr_cnt + 3'h3;

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

