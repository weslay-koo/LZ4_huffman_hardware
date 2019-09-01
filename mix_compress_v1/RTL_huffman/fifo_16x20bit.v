`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:46:32 08/15/2016 
// Design Name: 
// Module Name:    fifo_16x20bit 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: full signal will set valid when data count over 14
//								when it indicated full it also can be write 2 element
//////////////////////////////////////////////////////////////////////////////////
module fifo_16x20bit(
// global clock and reset
input wire				clk,
input wire				rstN,
// fifo interface
input wire	[19:0]	din,
input wire				wr_en,
input wire				rd_en,
output wire	[19:0]	dout,
output reg				valid,
output wire				empty,
output wire				full
);

reg	[4:0]	wr_addr,rd_addr;
wire	[4:0]	data_cnt;

assign		data_cnt	=	wr_addr - rd_addr;
assign		full		=	(data_cnt >= 5'hE) ? 1'b1 : 1'b0;
assign		empty		=	(data_cnt <= 5'h0) ? 1'b1 : 1'b0;

always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		wr_addr	<=	5'b0;
		rd_addr	<=	5'b0;
	end
	else
	begin
		if(wr_en & (data_cnt < 5'h10))
			wr_addr	<=	wr_addr + 1'b1;
		else if(wr_en & (data_cnt == 5'h10) & rd_en)
			wr_addr	<=	wr_addr + 1'b1;
		else
			wr_addr	<=	wr_addr;
		
		if(rd_en & (~empty))
			rd_addr	<=	rd_addr + 1'b1;
		else if(rd_en & (data_cnt == 5'h0) & wr_en)
			rd_addr	<=	rd_addr + 1'b1;
		else
			rd_addr	<=	rd_addr;
	end
end

always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		valid	<=	1'b0;
	end
	else
	begin
		if(rd_en & (~empty))
			valid	<=	1'b1;
		else
			valid	<=	1'b0;
	end
end

//dram_16x20bit	U_dram_16x20bit
//(
//  .clk				(clk),
//  .a				(wr_addr[3:0]),
//  .d				(din),
//  .dpra			(rd_addr[3:0]),
//  .we				(wr_en),
//  
//  .qdpo			(dout)
//);

bram_16x20bit U_bram_16x20bit
(
  .clka			(clk),
  .wea			(wr_en),
  .addra			(wr_addr[3:0]),
  .dina			(din),
  .clkb			(clk),
  .addrb			(rd_addr[3:0]),
  
  .doutb			(dout)
);


endmodule
