`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:19:06 03/09/2016 
// Design Name: 
// Module Name:    fifo_16x64bit 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments:  (first byte fall through)
//
//////////////////////////////////////////////////////////////////////////////////
module fifo_64x47bit(
// global clock and reset signal
input	wire				clk,
input wire				rstN,
// input data and signal
input wire	[46:0]	din,
input wire				wr_en,
input wire				rd_en,
// output data and signal
output wire	[46:0]	dout,
output wire				valid,
output wire				empty,
output wire				full,
output wire	[9:0]		data_count
);

wire	[63:0]	data_64bit;

assign			dout	=	data_64bit[46:0];
assign			valid	=	rd_en;

// use xilinx BRAM ipcore, it can be instead of user design little fifo logic (first byte fall through)
fifo_512x64bit_bram	U_fifo_512x64bit_bram
(
  .clk				(clk),
  .rst				(~rstN),
  .din				({17'b0,din}),
  .wr_en				(wr_en),
  .rd_en				(rd_en),
  
  .dout				(data_64bit),
  .full				(full),
  .empty				(empty),
  .valid				(),	//	(valid),
  .data_count		(data_count)
);

endmodule
