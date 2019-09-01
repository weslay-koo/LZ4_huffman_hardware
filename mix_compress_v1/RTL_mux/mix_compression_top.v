`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:46:05 03/29/2017 
// Design Name: 
// Module Name:    mix_compression_top 
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
`include "include.v"
module mix_compression_top(
// Global clock and reset
input wire				clk,
input wire				rstN,
// data input and control signal
input wire	[31:0]	idata,
input wire				idata_req,
input wire				data_terminal,
input wire				start_compress,
input wire				clean,
output wire				mfifo_full,
output wire				mfifo_empty,
output wire				compress_done,
// control signal for variable statistic length
input wire	[16:0]	max_stat_len,	// max statistic length is 65536
input wire				max_stat_valid,
// file length signal
input wire	[31:0]	file_length,
input wire				file_length_valid,
// output compressed encode data
input wire				out_en,
output wire	[31:0]	out_data,
output wire				out_empty,
output wire				out_valid,
output wire				obuf_full,
output wire				ohalf_full,
output wire	[31:0]	source_len,	// lz4 compressed_len + 19
`ifdef DEBUG_TREE
	// Debug port of huffman tree ram data
	input wire				debug_en,
	input wire				debug_rd,
	input wire	[7:0]		debug_odd_addr,
	input wire	[7:0]		debug_even_addr,
	output wire	[9:0]		debug_odd_data,
	output wire	[9:0]		debug_even_data,
`endif
// Just for simulation or test
output wire				mfifo_valid,
output wire	[31:0]	mfifo_data
);


// LZ4 output fifo signal
wire	[33:0]	lz4_data;
wire				lz4_valid,lz4_empty,lz4_full,lz4_hfull,lz4_done;
wire				lz4_oen;
// Huffman input fifo signal
wire				huff_full,huff_empty,huff_valid,huff_stat_end,huff_in_end;
wire	[31:0]	huff_data;
wire	[2:0]		huff_lmask;		
wire				huff_last;
// compressed_len convert to huffman source length
wire	[31:0]	compressed_len;

/////////////////////////////////////////////////
////			Dividual Combination Logic 		////
/////////////////////////////////////////////////
// compressed_len convert to huffman source length
assign			source_len = compressed_len + 5'd19;

/////////////////////////////////////////////////
////				Combination Logic 				////
/////////////////////////////////////////////////
//	None

/////////////////////////////////////////////////
////				 Sequential Logic 				////
/////////////////////////////////////////////////
// statistic data counter

/////////////////////////////////////////////////
////					Sub Modules						////
/////////////////////////////////////////////////
// LZ4 encoder
lz4_top_v3					U_lz4
(
	// Global clock and reset
	.clk						(clk),
	.rstN						(rstN),
	// data and control signal
	.idata					(idata			),
	.idata_req				(idata_req		),
	.data_terminal			(data_terminal	),
	.start_compress		(start_compress),
	.mfifo_full				(mfifo_full		),
	.mfifo_empty			(mfifo_empty	),
	.compress_done			(lz4_done		),
	// file length signal
	.file_length			(file_length		),
	.file_length_valid	(file_length_valid),
	// output compressed encode data
	.out_en					(lz4_oen),
	.out_data				(lz4_data),
	.out_empty				(lz4_empty),
	.out_valid				(lz4_valid),
	.obuf_full				(lz4_full),
	.ohalf_full				(lz4_hfull),
	.compressed_len		(compressed_len),
	// Just for simulation or test
	.mfifo_valid			(mfifo_valid),
	.mfifo_data				(mfifo_data	)
);

// Huffman encoder
huffman_encoder_v5	U_huffman_encoder
(
	// global clock and reset
	.clk					(clk),
	.rstN					(rstN),
	.start				(start_compress),
	.clean				(clean),
	.done					(compress_done),
	// statistic status indicator
	.stat_empty			(huff_empty),
	// data input
	.in_data				(huff_data),
	.in_valid			(huff_valid),
	.stat_end			(huff_stat_end),
	  //.last_en				(huff_last),
	.last_mask			(huff_lmask),
	.in_end				(huff_in_end),
	.in_full				(huff_full),
	`ifdef DEBUG_TREE
		// Debug port of huffman tree ram data
		.debug_en			(debug_en),
		.debug_rd			(debug_rd),
		.debug_odd_addr	(debug_odd_addr),
		.debug_even_addr	(debug_even_addr),
		.debug_odd_data	(debug_odd_data),
		.debug_even_data	(debug_even_data),
	`endif
	// code output
	.out_en				(out_en		),
	.out_data			(out_data	),
	.out_valid			(out_valid	),
	.out_empty			(out_empty	),
	.out_full			(obuf_full	),
	.out_hfull			(ohalf_full	)
);

// Cascade logic for LZ4+huffman encoder
cascade_logic	U_cascade_logic
(
	// Global clock and reset
	.clk					(clk),
	.rstN					(rstN),
	// control signal for variable statistic length
	.start_compress	(start_compress),
	.max_stat_len		(max_stat_len),	// max statistic length is 65536
	.max_stat_valid	(max_stat_valid),	// this signal will trigger new statistic process
	// data from LZ4 output fifo
	.lz4_data			(lz4_data	),
	.lz4_valid			(lz4_valid	),
	.lz4_empty			(lz4_empty	),
	.lz4_full			(lz4_full	),
	.lz4_hfull			(lz4_hfull	),	// half full
	.lz4_done			(lz4_done	),	// LZ4 encoder done, all data has been stored in output fifo
	.lz4_oen				(lz4_oen		),
	// data to huffman input fifo
	.huff_full			(huff_full	),
	.huff_empty			(huff_empty	),	// indicate all data in statistic fifo has been encoded, wait for new data to encode
	.huff_data			(huff_data	),
	.huff_valid			(huff_valid	),
	.huff_last			(huff_last	),
	.huff_lmask			(huff_lmask	),
	.huff_in_end		(huff_in_end),
	.huff_stat_end		(huff_stat_end)
);

endmodule
