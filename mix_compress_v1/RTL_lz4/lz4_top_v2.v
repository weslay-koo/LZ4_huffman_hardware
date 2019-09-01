`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:56:04 01/12/2016 
// Design Name: 
// Module Name:    lz4_top_v2 
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
module lz4_top_v2(
 // Global clock and reset
input wire				clk,
input wire				rstN,
// data and control signal
input wire	[31:0]	idata,
input wire				idata_req,
input wire				data_terminal,
input wire				start_compress,
output wire				mfifo_full,
output wire				mfifo_empty,
output wire				compress_done,
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
output wire	[31:0]	compressed_len,
// Just for simulation or test
output wire				mfifo_valid,
output wire	[31:0]	mfifo_data
);

////////////////////////////////////////////
////				wires and regs				/////
//////////////////////////////////////////// 
// match_fifo signal
wire						rd_fifo_en;
//wire						mfifo_valid;
//wire		[31:0]		mfifo_data;
wire		[14:0]		mfifo_count;
// byte_addressing signal
wire		[31:0]		byte4_shift,byte4_dword;  
wire						byte4_svalid,byte4_dvalid; 
wire						byte4_en;
wire						byte4_busy;
wire						rd_shift_en,rd_dword_en;
wire						last_5bytes,last_2dwords;
wire		[2:0]			match_mask;
// abs_addr_gen signal
wire		[31:0]		abs_addr_in;
wire		[2:0]			incr_bytes;
// hash_table signal
wire		[31:0]		hash_idata1,hash_idata2,hash_idata3,hash_idata4;
wire						hash_hit;  // director of hash match succseefully but may not in distance
wire						hit_valid;
wire		[31:0]		hash_oaddr,hash_iaddr1,hash_iaddr2,hash_iaddr3,hash_iaddr4;	
wire						hash_ovalid,hash_ivalid;
wire						hash_busy,hash_unable,hash_clean,hash_wr_only;	
// lz4_buffer signal
wire		[2:0]			move_dist;
wire						move_valid;
wire		[31:0]		anchor;
wire		[31:0]		head_addr;
wire						matching;
wire						match_start;
wire		[31:0]		dict_abs_addr;	
wire						dict_rd;			
wire		[31:0]		dict_odata;		
wire						dict_ovalid;	
wire						outofrange;		
wire						over_band;
// xxh32_calc signal
wire		[31:0]		digest;
wire						digest_valid;
// Encode module
wire		[31:0]		xxh32_dword;
wire		[15:0]		match_offset;	
wire		[31:0]		match_length;	
wire		[31:0]		unmatch_length;
wire						info_valid,unmatch_dvalid;		
wire		[7:0]			unmatch_data;	
wire						byte_done;
wire						compress_start;
wire						encode_en,encode_done,seg_done,encode_busy;
wire		[13:0]		wr_fifo_count;
wire		[7:0]			blocksize_id;	
wire		[7:0]			header_crc;		
wire						head_valid;		
// global clk management
wire						pll_locked;
wire						clk_1x,clk_2x;

////////////////////////////////////////////
////					Modules 					/////
////////////////////////////////////////////
control_fsm_v3	U_control_fsm
(
// Global clock and reset
	.clk						(clk_1x),
	.rstN						(rstN & pll_locked),
	.start_compress		(start_compress),
	.file_len				(file_length),
	.file_len_valid		(file_length_valid),
// from byte_addressing
	.byte4_shift			(byte4_shift), 
	.byte4_svalid			(byte4_svalid),
	.byte4_busy				(byte4_busy),
	.rd_shift_en			(rd_shift_en),
	.rd_dword_en			(rd_dword_en),
	.match_mask				(match_mask),
	.byte4_en				(byte4_en),
	.byte4_dword			(byte4_dword),
	.byte4_dvalid			(byte4_dvalid),
	.last_5bytes			(last_5bytes),
	.last_2dwords			(last_2dwords),
// from abs_addr_gen		
	.abs_addr_in			(abs_addr_in),
	.incr_bytes				(incr_bytes),
// from hash_table
	.hash_oaddr				(hash_oaddr		),
	.hash_hit				(hash_hit		),
	.hash_ovalid			(hash_ovalid	),
	.hash_unable			(hash_unable	),
	.hash_clean				(hash_clean		),
	.hash_iaddr1			(hash_iaddr1	),
	.hash_idata1			(hash_idata1	),
	.hash_iaddr2			(hash_iaddr2	),
	.hash_idata2			(hash_idata2	),
	.hash_iaddr3			(hash_iaddr3	),
	.hash_idata3			(hash_idata3	),
	.hash_iaddr4			(hash_iaddr4	),
	.hash_idata4			(hash_idata4	),
	.hash_ivalid			(hash_ivalid	),
	.hash_wr_only			(hash_wr_only	),
// from lz4_buffer	
	.move_dist				(move_dist		),		
	.move_valid				(move_valid		),
	.anchor					(anchor			),
	.match_start			(match_start	),
	.fifo_count				(mfifo_count	),
	.hit_valid				(hit_valid		),
	.dict_abs_addr			(dict_abs_addr	),
	.dict_rd					(dict_rd			),
	.dict_odata				(dict_odata		),
	.dict_ovalid			(dict_ovalid	),
	.outofrange				(outofrange		),
	.matching				(matching		),
	.over_band				(over_band		),
// from xxh32_calc
	.digest					(digest			),
	.digest_valid			(digest_valid	),
// to encode module	
	.xxh32_dword			(xxh32_dword	),
	.blocksize_id			(blocksize_id	),
	.header_crc				(header_crc		),
	.head_valid				(head_valid		),
	.match_offset			(match_offset	),
	.match_length			(match_length	),
	.unmatch_length		(unmatch_length),
	.info_valid				(info_valid		),
	.byte_done				(byte_done		),
	.unmatch_data			(unmatch_data	),
	.unmatch_dvalid		(unmatch_dvalid),
	.compress_done			(compress_done	),
	.compress_start		(compress_start),
	.encode_en				(encode_en		),
	.encode_done			(encode_done	),
	.encode_busy			(encode_busy	),
	.seg_done				(seg_done		)	// code segment done signal
);

lz4_buffer_v2	U_lz4_buffer
(
	// global clock and reset signal
	.clk				(clk_1x),
	.rstN				(rstN & pll_locked),
	// control signal
	.compress_start(compress_start),
	.compress_done	(compress_done	),
	.matching		(matching		),
	.match_start	(match_start	),
	.seg_done		(seg_done		),
	.move_dist		(move_dist		),		
	.move_valid		(move_valid		),
	// data input 
	.wr_req			(idata_req	),
	.idata			(idata	),
	// fifo output interface
	.fifo_rd			(rd_fifo_en	),
	.fifo_odata		(mfifo_data	),	
	.fifo_ovalid	(mfifo_valid),	
	// RAM address and data interface -- for dict search  
	.ram_abs_addr	(dict_abs_addr	),                     
	.ram_rd			(dict_rd			),                     
	.ram_odata		(dict_odata		),    
	.ram_ovalid		(dict_ovalid	),
	// status signal
	.outofrange		(outofrange),
	.anchor			(anchor),
	.buf_full		(mfifo_full),
	.fifo_empty		(mfifo_empty),
	.fifo_count		(mfifo_count),
	.over_band		(over_band),
	.head_addr		(head_addr)
);

abs_addr_gen	U_abs_addr_gen
(
	.clk					(clk_1x),
	.rstN					(rstN & pll_locked),
	.head_addr			(head_addr	),
	.incr_bytes			(incr_bytes	),
	.abs_addr_in		(abs_addr_in) 
);

byte_addressing_v2	U_byte_addressing
(
// clk and rst
	.clk					(clk_1x),
	.rstN					(rstN & pll_locked),
	.last_5bytes		(last_5bytes),
//	.last_2dwords		(last_2dwords),
	.hit_valid			(hit_valid),
// fifo 32bit data input
	.fifo_data			(mfifo_data), 
	.fifo_valid			(mfifo_valid),
	.fifo_empty			(mfifo_empty),
	.rd_fifo_en			(rd_fifo_en),
// read signal and data output
	.byte4_en			(byte4_en),
//	.abs_addr			(),
	.rd_shift_en		(rd_shift_en),
	.rd_dword_en		(rd_dword_en),
	.match_mask			(match_mask),
	.byte4_busy			(byte4_busy	),
	.byte4_shift		(byte4_shift),
	.byte4_svalid		(byte4_svalid),
	.byte4_dword		(byte4_dword),
	.byte4_dvalid		(byte4_dvalid)
);

hash_table_v3	U_hash_table
(
// clk and rst
	.clk					(clk_1x),
	.clk_2x				(clk_2x),
	.rstN					(rstN & pll_locked),
	.hash_clean			(hash_clean	),
	.hash_unable		(hash_unable),
	.hash_wr_only		(hash_wr_only), // (1'b0),		// just for test	//	
// external unmatched data 4 byte input 
	.hash_idata1		(hash_idata1),			//	shift by 4Bytes per clk cycles when find match
	.hash_iaddr1		(hash_iaddr1),  		// first char address (64KB range)	[55:24]
	.hash_idata2		(hash_idata2),			//	shift by 4Bytes per clk cycles when find match
	.hash_iaddr2		(hash_iaddr2),  		// first char address (64KB range)	[47:16]
	.hash_idata3		(hash_idata3),			//	shift by 4Bytes per clk cycles when find match
	.hash_iaddr3		(hash_iaddr3),  		// first char address (64KB range)	[39:8]
	.hash_idata4		(hash_idata4),			//	shift by 4Bytes per clk cycles when find match
	.hash_iaddr4		(hash_iaddr4),  		// first char address (64KB range)	[31:0]
	.hash_ivalid		(hash_ivalid), 		// all 4 port data and address input valid signal
// external dictionary data 4 byte input 
	.hash_oaddr			(hash_oaddr	),
	.hash_ovalid		(hash_ovalid),
	.hash_hit			(hash_hit	),
	.hit_status			(hit_status	)
);

lz4_encoder_v3	U_lz4_encoder
(
	// global clock and reset
	.clk					(clk_1x),
	.rstN					(rstN & pll_locked),
	.last_5bytes		(last_5bytes),
	// input BLOCKID and Header CRC value
	.blocksize_id		(blocksize_id),
	.header_crc			(header_crc),
	.head_valid			(head_valid),
	// data from control FSM
	.match_offset		(match_offset	),
	.match_length		(match_length	),
	.unmatch_length	(unmatch_length),	//({20'b0,wr_fifo_count}), // 	
	.info_valid			(info_valid		),
	.unmatch_data		(unmatch_data	),
	.byte_done			(byte_done		),
	.data_valid			(unmatch_dvalid),
	.compress_done		(compress_done	),
	.compress_start	(compress_start),
	.xxh32_dword		(xxh32_dword	),
	// encoder status
	.encode_en			(encode_en		),
	.encode_done		(encode_done	),
	.encode_busy		(encode_busy	),
	.seg_done			(seg_done		),	// code segment done signal
	.wr_fifo_count		(wr_fifo_count	),
	// encode output fifo interface
	.out_en				(out_en	),
	.out_data			(out_data),
	.out_empty			(out_empty),
	.out_valid			(out_valid),
	.obuf_full			(obuf_full),
	.ohalf_full			(ohalf_full),
	.compressed_len	(compressed_len)
);

xxh32_calc_v2	U_xxh32_calc
(
// global clock and reset signal
	.clk					(clk_1x),
	.rstN					(rstN & pll_locked),
// data stream and data length information
	.compress_start	(start_compress), // (compress_start),
	.compress_done		(compress_done),
	.length				(file_length),
	.length_valid		(file_length_valid),
	.data					(idata),
	.data_valid			(idata_req),
// output 32bit calc value
	.digest				(digest),
	.digest_valid		(digest_valid)
);

// double freq pll
hash_pll	U_pll_250_to_500
(
	.CLK_IN		(clk),
	.RESET		(~rstN),
	
	.CLK_250		(clk_1x),
	.CLK_500		(clk_2x),
	.LOCKED		(pll_locked)
);

endmodule
