`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:21:33 08/16/2016 
// Design Name: 
// Module Name:    bl_table 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: This module is used to store 256 element bit length table
//
//////////////////////////////////////////////////////////////////////////////////
module bl_table(
// global clock and reset
input wire				clk,
input wire				rstN,
// bl table ram write RAM interface
input wire	[6:0]		blt_even_waddr,
input wire				blt_even_wr,
input wire	[3:0]		blt_even_wdata,
input wire	[6:0]		blt_odd_waddr,
input wire				blt_odd_wr,
input wire	[3:0]		blt_odd_wdata,
// bl table ram read FIFO interface
input wire				blt_rd,
output wire	[31:0]	blt_dout,
output reg				blt_valid,
output wire				blt_empty
);

wire	[4:0]		blt_even_raddr,blt_odd_raddr;
reg	[5:0]		blt_rd_count;
wire	[15:0]	blt_even_rdata,blt_odd_rdata;

assign			blt_empty		=	(blt_rd_count >= 6'h1F) ? 1'b1 : 1'b0;
assign			blt_even_raddr	=	blt_rd_count[4:0];
assign			blt_odd_raddr	=	blt_rd_count[4:0];

assign			blt_dout			=	{	blt_even_rdata[3:0],blt_odd_rdata[3:0],
												blt_even_rdata[7:4],blt_odd_rdata[7:4],
												blt_even_rdata[11:8],blt_odd_rdata[11:8],
												blt_even_rdata[15:12],blt_odd_rdata[15:12]};

always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		blt_rd_count	<=	6'b0;
		blt_valid		<=	1'b0;
	end
	else
	begin
		if(blt_rd_count <= 6'h1F)
			blt_valid	<=	blt_rd;
		else
			blt_valid	<=	1'b0;
		if(blt_even_wr | blt_odd_wr)
			blt_rd_count	<=	6'b0;
		else if(blt_rd)
			blt_rd_count	<=	blt_rd_count + 1'b1;
		else
			blt_rd_count	<=	blt_rd_count;
	end
end

ram_a128x4_b32x16bit	U_bl_table_even
(
  .clka			(clk),
  .wea			(blt_even_wr),
  .addra			(blt_even_waddr),
  .dina			(blt_even_wdata),
  .clkb			(clk),
  .web			(1'b0),
  .addrb			(blt_even_raddr),
  .dinb			(16'b0),
  
  .douta			(),
  .doutb			(blt_even_rdata)
);

ram_a128x4_b32x16bit	U_bl_table_odd
(
  .clka			(clk),
  .wea			(blt_odd_wr),
  .addra			(blt_odd_waddr),
  .dina			(blt_odd_wdata),
  .clkb			(clk),
  .web			(1'b0),
  .addrb			(blt_odd_raddr),
  .dinb			(16'b0),
  
  .douta			(),
  .doutb			(blt_odd_rdata)
);

endmodule
