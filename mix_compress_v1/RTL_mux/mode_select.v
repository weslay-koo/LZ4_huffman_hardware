`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:10:32 03/29/2017 
// Design Name: 
// Module Name:    mode_select 
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
module mode_select(
// Global clock and reset
input wire				clk,
input wire				rstN,
// control signal for variable statistic length
input wire	[15:0]	max_stat_len,
input wire				max_stat_valid,
// data from LZ4 output fifo
input wire	[31:0]	lz4_data,
input wire				lz4_valid,
input wire				lz4_empty,
input wire				lz4_full,
input wire				lz4_hfull,
output reg				lz4_oen,
// data to huffman input fifo
input wire				huff_full,
output reg	[31:0]	huff_data,
output reg				huff_valid,
output reg	[2:0]		huff_lmask,
output reg				in_end
);



endmodule
