`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:35:02 09/15/2015 
// Design Name: 
// Module Name:    lz4_top 
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
module lz4_top(
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
// output compressed encode data
input wire				out_en,
output wire	[31:0]	out_data,
output wire				out_empty,
output wire				out_valid
);

////////////////////////////////////////////
////				wires and regs				/////
//////////////////////////////////////////// 
// match_fifo signal
wire						file_end;
wire						rd_fifo_en,mfifo_valid;
wire		[31:0]		mfifo_data;
// byte_addressing signal
wire		[31:0]		byte4_shift,byte4_dword;  
wire						byte4_svalid,byte4_dvalid; 
wire						byte4_en;
wire						byte4_busy;
wire						rd_shift_en,rd_data_en;
// abs_addr_gen signal
wire		[31:0]		abs_addr_in;
wire		[1:0]			incr_bytes;
// hash_table signal
wire		[31:0]		hash_idata;
wire						hash_hit;  // director of hash match succseefully
wire		[31:0]		hash_oaddr,hash_iaddr;	
wire						hash_ovalid,hash_ivalid;
wire						hash_busy,hash_unable,hash_clean;	
// lz4_buffer signal
wire		[31:0]		buf_odata,buf_idata;		
wire						buf_ovalid,buf_full,buf_empty,
							buf_unable,dict_full,buf_rdreq,
							buf_clear,buf_ivalid,move_valid;		
wire		[15:0]		move_distance;	
wire		[31:0]		head_addr;
wire		[15:0]		buf_rdpointer;
// addr_convert signal	
wire		[31:0]		abs_addr_out;	
wire		[15:0]		relate_raddr;
wire						outofrange;		
// Encode module
wire		[15:0]		match_offset;	
wire		[15:0]		match_length;	
wire		[31:0]		unmatch_length;
wire						info_valid,unmatch_dvalid;		
wire		[31:0]		unmatch_data;	
wire						compress_done,compress_start;
wire						encode_en,encode_done,seg_done,encode_busy;

////////////////////////////////////////////
////					Modules 					/////
////////////////////////////////////////////
control_fsm	U_control_fsm
(
// Global clock and reset
	.clk						(clk),
	.rstN						(rstN),
	.start_compress		(start_compress),
	.file_end				(file_end),
// from byte_addressing
	.byte4_shift			(byte4_shift), 
	.byte4_svalid			(byte4_svalid),
	.byte4_busy				(byte4_busy),
	.rd_shift_en			(rd_shift_en),
	.byte4_en				(byte4_en),
	.byte4_dword			(byte4_dword),
	.byte4_dvalid			(byte4_dvalid),
// from abs_addr_gen		
	.abs_addr_in			(abs_addr_in),
	.incr_bytes				(incr_bytes),
// from hash_table
	.hash_oaddr				(hash_oaddr	),
	.hash_hit				(hash_hit	),
	.hash_ovalid			(hash_ovalid),
	.hash_unable			(hash_unable),
	.hash_clean				(hash_clean	),
	.hash_iaddr				(hash_iaddr	),
	.hash_idata				(hash_idata	),
	.hash_ivalid			(hash_ivalid),
// from lz4_buffer	
	.buf_odata				(buf_odata		),
	.buf_ovalid				(buf_ovalid		),
	.buf_full				(buf_full		),
	.buf_empty				(buf_empty		),
	.buf_unable				(buf_unable		),
	.dict_full				(dict_full		),
	.buf_rdreq				(buf_rdreq		),
	.buf_clear				(buf_clear		),
	.buf_idata				(buf_idata		),
	.buf_ivalid				(buf_ivalid		),
	.move_distance			(move_distance	),
	.move_valid				(move_valid		),
// from addr_convert	
	.outofrange				(outofrange	),
	.abs_addr_out			(abs_addr_out),
// encode module	
	.match_offset			(match_offset	),
	.match_length			(match_length	),
	.unmatch_length		(unmatch_length),		
	.info_valid				(info_valid		),
	.unmatch_data			(unmatch_data	),
	.unmatch_dvalid		(unmatch_dvalid),
	.compress_done			(compress_done	),
	.compress_start		(compress_start),
	.encode_en				(encode_en		),
	.encode_done			(encode_done	),
	.encode_busy			(encode_busy	),
	.seg_done				(seg_done		)	// code segment done signal
);

lz4_buffer	U_lz4_buffer
(
// clk and rst
	.clk					(clk),
	.rstN					(rstN),
	.buf_clear			(buf_clear),
	.buf_unable			(buf_unable),
// external data input
	.buf_idata			(buf_idata	),
	.buf_ivalid			(buf_ivalid	),
	.buf_full			(buf_full	),
// data output
	.buf_rdreq			(buf_rdreq		),
	.buf_rdpointer		(relate_raddr	),	//	(buf_rdpointer	), // Byte addressed
	.buf_odata			(buf_odata		),
	.buf_ovalid			(buf_ovalid		),
	.buf_empty			(buf_empty		),
// dictionart window move distance
	.move_valid			(move_valid		),
	.move_distance		(move_distance	), // Byte addressed
	.dict_full			(dict_full		),
	.head_addr			(head_addr		)  // absolutely address 64kB block head
);

addr_convert	U_addr_convert
(
	.head_addr			(head_addr	),
	.abs_addr_out		(abs_addr_out), // from FSM HashTable
	.relate_raddr		(relate_raddr), // from lz4_buffer
//	.relate_waddr		(), // from lz4_buffer
	.outofrange			(outofrange)
);

abs_addr_gen	U_abs_addr_gen
(
	.clk					(clk),
	.rstN					(rstN),
	.head_addr			(head_addr	),
	.incr_bytes			(incr_bytes	),
	.abs_addr_in		(abs_addr_in) 
);

byte_addressing	U_byte_addressing
(
// clk and rst
	.clk					(clk),
	.rstN					(rstN),
// fifo 32bit data input
	.fifo_data			(mfifo_data), 
	.fifo_valid			(mfifo_valid),
	.fifo_empty			(mfifo_empty),
	.rd_fifo_en			(rd_fifo_en),
// data output
	.byte4_en			(byte4_en),
	.abs_addr			(),
	.rd_shift_en		(rd_shift_en),
	.byte4_busy			(byte4_busy	),
	.byte4_shift		(byte4_shift),
	.byte4_svalid		(byte4_svalid),
	.byte4_dword		(byte4_dword),
	.byte4_dvalid		(byte4_dvalid)
);

match_fifo	U_match_fifo
(
// clk and rst
	.clk					(clk),
	.rstN					(rstN),  
	.data_terminal		(data_terminal),
	.start_compress	(start_compress),
//	fifo signal
	.rd_req				(rd_fifo_en),
	.wr_req				(idata_req),
	.idata				(idata),
	.odata				(mfifo_data),
	.odata_valid		(mfifo_valid),
// status signal
	.empty				(mfifo_empty),
	.full					(mfifo_full),
	.file_end			(file_end)
);

hash_table	U_hash_table
(
// clk and rst
	.clk					(clk),
	.rstN					(rstN),
	.hash_clean			(hash_clean	),
	.hash_unable		(hash_unable),
// external unmatched data 4 byte input 
	.hash_idata			(hash_idata	),
	.hash_iaddr			(hash_iaddr	),  // first char address (64KB range)
	.hash_ivalid		(hash_ivalid),  // single pulse signal with valid data input
// external dictionary data 4 byte input 
	.hash_oaddr			(hash_oaddr	),
	.hash_ovalid		(hash_ovalid),
	.hash_hit			(hash_hit	)
);

lz4_encoder	U_lz4_encoder
(
	// global clock and reset
	.clk					(clk),
	.rstN					(rstN),
	// data from control FSM
	.match_offset		(match_offset	),
	.match_length		(match_length	),
	.unmatch_length	(unmatch_length),		
	.info_valid			(info_valid		),
	.unmatch_data		(unmatch_data	),
	.data_valid			(unmatch_dvalid),
	.compress_done		(compress_done	),
	.compress_start	(compress_start),
	// encoder status
	.encode_en			(encode_en		),
	.encode_done		(encode_done	),
	.encode_busy		(encode_busy	),
	.seg_done			(seg_done		),	// code segment done signal
	// encode output fifo interface
	.out_en				(out_en	),
	.out_data			(out_data),
	.out_empty			(out_empty),
	.out_valid			(out_valid)	
);

endmodule
