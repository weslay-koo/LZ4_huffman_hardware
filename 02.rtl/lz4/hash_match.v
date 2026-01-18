`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:40:32 04/27/2016 
// Design Name: 
// Module Name:    hash_match 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: paralla match 4 Bytes, compare data from external 
//								between data from hash table
//
//////////////////////////////////////////////////////////////////////////////////
module hash_match(
// global clock and reset signal
input wire				clk,
input wire				rstN,
// input source data
input wire	[31:0]	hash_idata1,
input wire	[31:0]	hash_iaddr1,
input wire	[31:0]	hash_idata2,
input wire	[31:0]	hash_iaddr2,
input wire	[31:0]	hash_idata3,
input wire	[31:0]	hash_iaddr3,
input wire	[31:0]	hash_idata4,
input wire	[31:0]	hash_iaddr4,
// input hash table outpout data    
input wire	[31:0]	hash_odata1,
input wire	[31:0]	hash_oaddr1,
input wire				hash_flag1,
input wire	[31:0]	hash_odata2,
input wire	[31:0]	hash_oaddr2,
input wire				hash_flag2,
input wire	[31:0]	hash_odata3,
input wire	[31:0]	hash_oaddr3,
input wire				hash_flag3,
input wire	[31:0]	hash_odata4,
input wire	[31:0]	hash_oaddr4,	 
input wire				hash_flag4,
// output hash match status
output reg				hash_hit,
output reg	[2:0]		hit_status,
output reg	[31:0]	hash_oaddr,
output reg	[31:0]	hit_dist
);

always @ (*)
begin
	if((hash_odata1 == hash_idata1) && hash_flag1) 
	begin		//  Could be optimous for LAZY MATCH
		hash_hit		=	1'b1;
		hit_status	=	3'h0;
		hash_oaddr	=	hash_oaddr1;
		hit_dist		=	hash_iaddr1 - hash_oaddr1;
	end
	else if((hash_odata2 == hash_idata2) && hash_flag2)
	begin
		hash_hit		=	1'b1;
		hit_status	=	3'h1;
		hash_oaddr	=	hash_oaddr2;
		hit_dist		=	hash_iaddr2 - hash_oaddr2;
	end
	else if((hash_odata3 == hash_idata3) && hash_flag3)
	begin
		hash_hit		=	1'b1;
		hit_status	=	3'h2;
		hash_oaddr	=	hash_oaddr3;
		hit_dist		=	hash_iaddr3 - hash_oaddr3;
	end
	else if((hash_odata4 == hash_idata4) && hash_flag4)
	begin
		hash_hit		=	1'b1;
		hit_status	=	3'h3;
		hash_oaddr	=	hash_oaddr4;
		hit_dist		=	hash_iaddr4 - hash_oaddr4;
	end
	else
	begin
		hash_oaddr	=	32'b0;
		hit_status	=	3'b0;
		hash_hit		=	1'b0;
		hit_dist		=	32'b0;
	end
end

endmodule
