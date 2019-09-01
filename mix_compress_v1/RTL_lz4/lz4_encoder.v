`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:08:07 09/24/2015 
// Design Name: 
// Module Name:    lz4_encoder 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: The alogrithm of caculate the (n) bytes of match and unmatch length is
//									n = length_corr / 255 = length_corr / 256 + length_corr /65536
//								The remain value (remain) of match and unmatch length is
//									last = length_corr - 255*n = length_corr - 256*n + n
//								The real bytes requairment is 
//									if(last == 255)
//										n_real = n + 1;
//									else
//										n_real = n;
//								length_corr = 		length - 15	(for unmatch length) 
//													or length - 19	(for match length) 
//////////////////////////////////////////////////////////////////////////////////
module lz4_encoder(
// global clock and reset and control signal
input	wire				clk,
input wire				rstN,
input wire				last_5bytes,
// input BLOCKID and Header CRC value
input wire	[7:0]		blocksize_id,
input wire	[7:0]		header_crc,
input wire				head_valid,
// data from control FSM
input wire	[15:0]	match_offset,
input wire	[31:0]	match_length,
input wire	[31:0]	unmatch_length,		
input wire				info_valid,
input wire	[7:0]		unmatch_data,
input	wire				byte_done,
input wire				data_valid,
input wire				compress_done,
input wire				compress_start,
input wire	[31:0]	xxh32_dword,
// encoder status
input	wire				encode_en,
output reg				encode_done,
output wire				encode_busy,
output reg				seg_done,	// code segment done signal
output wire	[13:0]	wr_fifo_count,
// encode output fifo interface
input wire				out_en,
output wire	[31:0]	out_data,
output wire				out_empty,
output wire				out_valid,
output wire				obuf_full,
output wire				ohalf_full,
output reg	[31:0]	compressed_len
);

//////////////// FSM status ////////////////
parameter		IDLE				=	4'h0	;
parameter		ENCODE_MAGIC	=	4'h1	;
parameter		ENCODE_INFO		=	4'h2	;
parameter		ENCODE_BLK_LEN	=	4'h3	;	// for pre-encode and value should be 0
parameter		ENCODE_TOKEN	=	4'h4	;
parameter		ENCODE_LIT_LEN	=	4'h5	;
parameter		ENCODE_LIT		=	4'h6	;
parameter		WAIT_LIT			=	4'h7	;
parameter		ENCODE_OFFSET	=	4'h8	;
parameter		ENCODE_MAT_LEN	=	4'h9	;
parameter		WAIT_FOR_BUF	=	4'hA	;
parameter		SEG_DONE			=	4'hB	;
parameter		ENCODE_REST		=	4'hC	;
parameter		ENCODE_XXH32	=	4'hD	;
parameter		ALL_DONE			=	4'hE	;
////////////////////////////////////////////
// FSM signal
reg	[3:0]		current_state,next_state,prev_state,current_state_d1;
// token signal
reg	[3:0]		match_token,unmatch_token;
wire	[15:0]	match_token_corr;
// for literature length encode
reg	[21:0]	unmatch_len_cnt;
reg				unmatch_len_cnt_en;
wire	[23:0]	unmatch_len_bytes,unmatch_len_n;
reg	[21:0]	unmatch_len_dw;
reg	[2:0]		unmatch_len_mask;//,last_len_mask;		
reg	[7:0]		unmatch_len_remain;
wire	[31:0]	unmatch_len_corr,unmatch_len_last;
wire	[31:0]	unmatch_len_conv;	//	add coeffects tp convert divider 255 to 256
// for data input fifo
reg				fifo_rd_en;
wire	[31:0]	in_data;
wire				in_full,in_empty,in_valid;
wire	[11:0]	rd_fifo_count;
// for unmatch literature encode
reg	[31:0]	unmatch_lit_cnt;
reg				unmatch_lit_cnt_en;
reg	[31:0]	unmatch_length_reg;
// for match length encode
reg	[21:0]	match_len_cnt;
reg				match_len_cnt_en;
wire	[23:0]	match_len_bytes,match_len_n;
reg	[21:0]	match_len_dw;
reg	[2:0]		match_len_mask;
reg	[7:0]		match_len_remain;	
reg	[31:0]	match_length_reg;
wire	[31:0]	match_len_corr,match_len_last;
wire	[31:0]	match_len_conv;
// for store distance
reg	[15:0]	match_offset_reg;
// FSM data output
reg	[2:0]		sep_mask;	
reg				sep_valid;				
reg	[31:0]	sep_data;
// output buffer signal
reg				obuf_full_d1;
// compress_start signal posedge detect
reg				compress_start_d1;
// compressed file length
reg	[2:0]		compressed_len_incr;
reg				compressed_valid;
// input data latch for Header
reg	[7:0]		blocksize_id_reg,header_crc_reg;
// parameter of frame head
parameter		MAGIC_NUMBER  	= 32'h04_22_4D_18;
parameter		FLAG_BYTE	  	= 8'h64;
//parameter		BLOCKID_BYTE  	= 8'h40;	//	00:default 40:64kB 50:256kB 60:1MB 70:4MB
//parameter		HEAD_CHECKSUM 	= 8'hA7;
parameter		BLOCK_LENGTH 	= 32'b0;

/////////////////////////////////////////////////
////			Dividual Combination Logic 		////
/////////////////////////////////////////////////

assign			encode_busy 		= 	in_full;
// for unmatch length encode
assign			unmatch_len_corr	=	unmatch_length - 5'd15;
assign			unmatch_len_conv	=	unmatch_len_corr + {8'b0,unmatch_len_corr[31:8]};
assign			unmatch_len_n		=	unmatch_len_conv[31:8];
assign			unmatch_len_last	=	unmatch_len_corr - {unmatch_len_n,8'b0} + {8'b0,unmatch_len_n};
assign			unmatch_len_bytes	=	(unmatch_len_last==32'hFF) ? (unmatch_len_n + 2'h2) : (unmatch_len_n + 2'h1) ;
// for match length encode
assign			match_len_corr		=	match_length - 5'd19;
assign			match_len_conv		=	match_len_corr + {8'b0,match_len_corr[31:8]};
assign			match_len_n			=	match_len_conv[31:8];
assign			match_len_last		=	match_len_corr - {match_len_n,8'b0} + {8'b0,match_len_n};
assign			match_len_bytes	=	(match_len_last==32'hFF) ? (match_len_n + 2'h2) : (match_len_n + 2'h1) ;
assign			match_token_corr	=	match_length - 4'd4;
// seperate dupulicate logic
function	[2:0] MASK;
	input	[1:0]	code;
	case(code)
	2'b00	:	MASK	=	3'b100	;
	2'b01	:	MASK	=	3'b001	;
	2'b10	:	MASK	=	3'b010	;
	2'b11	:	MASK	=	3'b011	;
	default:	MASK	=	3'b000	;
	endcase
endfunction

// Data shift logic for big endian to right arrangment
function	[31:0] SHIFT;
	input	[31:0] data;
	input	[1:0]  code;
	case(code)
	2'b00	:	SHIFT	=	data;
	2'b01	:	SHIFT	=	{data[23:0],data[31:24]};
	2'b10	:	SHIFT	=	{data[15:0],data[31:16]};
	2'b11	:	SHIFT	=	{data[7:0],data[31:8]};
	default:	SHIFT	=	32'b0	;
	endcase
endfunction

// data endian change
function	[31:0] ENDIAN_CHG;
	input	[31:0] data;
	ENDIAN_CHG	=	{data[7:0],data[15:8],data[23:16],data[31:24]};
endfunction
//function	[3:0] MASK;
//	input	[1:0]	code;
//	case(code)
//	2'b00	:	MASK	=	4'b1111	;
//	2'b01	:	MASK	=	4'b0001	;
//	2'b10	:	MASK	=	4'b0011	;
//	2'b11	:	MASK	=	4'b0111	;
//	default:	MASK	=	4'b0000	;
//	endcase
//endfunction

/////////////////////////////////////////////////
////				 Sequential Logic 				////
/////////////////////////////////////////////////

// main status transfer
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		current_state		<=	IDLE;
		prev_state			<=	IDLE;
		current_state_d1	<=	IDLE;
	end
	else
	begin
		current_state_d1	<=	current_state;
		if({obuf_full,obuf_full_d1}==2'b01)
			current_state	<=	prev_state;
		else
			current_state	<=	next_state;
		if({obuf_full,obuf_full_d1}==2'b10)
			prev_state	<=	current_state_d1;
		else if(obuf_full && info_valid)
			prev_state	<=	ENCODE_TOKEN;
		else
			prev_state	<=	prev_state;
	end
end

// Buffer full signal delay
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		obuf_full_d1	<=	1'b0;
	end
	else
	begin
		obuf_full_d1	<=	obuf_full;
	end
end

// Token for 4bit unmatch length and 4bit match length
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		unmatch_token	<=	4'b0;
		match_token		<=	4'b0;
	end
	else
	begin
		if(info_valid && (!last_5bytes))
		begin
			if(unmatch_length>=32'd15)
				unmatch_token	<=	4'hF;
			else
				unmatch_token	<=	unmatch_length[3:0];
				
			if(match_length>=32'd19)
				match_token		<=	4'hF;
			else
				match_token		<=	match_token_corr[3:0];
		end
		else if(info_valid && last_5bytes)
		begin
			if(unmatch_length>=32'd15)
				unmatch_token	<=	4'hF;  // 4'h5;
			else
				unmatch_token	<=	unmatch_length[3:0];  // 4'h5;
			match_token		<=	4'h0;
		end
		else
		begin
			unmatch_token	<=	unmatch_token;	
			match_token		<=	match_token;
		end
	end
end

// unmatch length calc
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		unmatch_len_remain	<=	8'b0;
		unmatch_len_dw			<=	22'b0;
		unmatch_len_mask		<=	3'b0;
		unmatch_length_reg	<=	32'b0;
	end
	else
	begin
		if(info_valid)
		begin
			unmatch_length_reg	<=	unmatch_length;
			if(unmatch_len_last == 32'hFF)
				unmatch_len_remain	<=	8'b0;
			else
				unmatch_len_remain	<=	unmatch_len_last[7:0];
			unmatch_len_mask		<=	MASK(unmatch_len_bytes[1:0]);//last_len_mask;
			if(unmatch_len_bytes[1:0]==2'b00)
				unmatch_len_dw		<=	unmatch_len_bytes[23:2];
			else
				unmatch_len_dw		<=	unmatch_len_bytes[23:2] + 1'b1;
		end
		else
		begin
			unmatch_length_reg	<=	unmatch_length_reg;
			unmatch_len_dw			<=	unmatch_len_dw	;
			unmatch_len_remain	<=	unmatch_len_remain;
			unmatch_len_mask		<=	unmatch_len_mask;
		end
	end
end

// unmatch length encode counter
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		unmatch_len_cnt	<=	22'b0	;
	end
	else
	begin
		if(info_valid)
		begin
			unmatch_len_cnt	<=	22'd1	;
		end
		else if(unmatch_len_cnt_en)
		begin
			if(unmatch_len_cnt >= unmatch_len_dw)
				unmatch_len_cnt	<=	unmatch_len_cnt;
			else
				unmatch_len_cnt	<=	unmatch_len_cnt + 1'b1;
		end
		else
		begin
			unmatch_len_cnt	<=	unmatch_len_cnt;
		end
	end
end

// unmatch literatures encode counter
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		unmatch_lit_cnt	<=	32'b0;
	end
	else
	begin
		if(info_valid)
			unmatch_lit_cnt	<=	32'b0;
		else if(unmatch_lit_cnt_en) //(fifo_rd_en)	// 
			unmatch_lit_cnt	<=	unmatch_lit_cnt + 3'h4;
		else
			unmatch_lit_cnt	<=	unmatch_lit_cnt;
	end
end

// match length calc
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		match_len_remain	<=	8'b0;
		match_len_dw		<=	22'b0;
		match_len_mask		<=	3'b0;
		match_length_reg	<=	32'b0;
	end
	else
	begin
		if(info_valid)
		begin
			match_length_reg	<=	match_length;
			if(match_len_last	==	32'hFF)
				match_len_remain	<=	8'b0;
			else
				match_len_remain	<=	match_len_last[7:0];
			match_len_mask		<=	MASK(match_len_bytes[1:0]);
			if(match_len_bytes[1:0]==2'b00)
				match_len_dw	<=	match_len_bytes[23:2];
			else
				match_len_dw	<=	match_len_bytes[23:2] + 1'b1;
		end
		else
		begin
			match_length_reg	<=	match_length_reg;
			match_len_dw		<=	match_len_dw	;
			match_len_remain	<=	match_len_remain;
			match_len_mask		<=	match_len_mask;
		end
	end
end

// match length encode counter
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		match_len_cnt	<=	22'b0	;
	end
	else
	begin
		if(info_valid)
		begin
			match_len_cnt	<=	22'd1	;
		end
		else if(match_len_cnt_en)
		begin
			if(match_len_cnt >= match_len_dw)
				match_len_cnt	<=	match_len_cnt;
			else
				match_len_cnt	<=	match_len_cnt + 1'b1;
		end
		else
		begin
			match_len_cnt	<=	match_len_cnt;
		end
	end
end

// for store match distance
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		match_offset_reg	<=	16'b0;
	end
	else
	begin
		if(info_valid)
			match_offset_reg	<=	match_offset;
		else
			match_offset_reg	<=	match_offset_reg;
	end
end

// latch for header blocksize id and header crc checksum
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		blocksize_id_reg	<=	8'b0;
		header_crc_reg		<=	8'b0;
	end
	else
	begin
		if(head_valid)
		begin
			blocksize_id_reg	<=	blocksize_id;
			header_crc_reg		<=	header_crc;
		end
		else
		begin
			blocksize_id_reg	<=	blocksize_id_reg;	
		   header_crc_reg		<=	header_crc_reg;	
		end
	end
end

// compress_start signal posedge detect
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		compress_start_d1	<=	1'b0;
	end
	else
	begin
		compress_start_d1	<=	compress_start;	
	end
end

// compressed file valid length calculate
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		compressed_len	<=	32'b0;
	end
	else
	begin
		if(compressed_valid)
		begin
			compressed_len	<=	compressed_len + compressed_len_incr;
		end
		else
		begin
			compressed_len	<=	compressed_len;
		end
	end
end

//////////////////////////////////////////////
////				Combination Logic 			////
//////////////////////////////////////////////

// status transfer
always @ (*)
begin
	case(current_state)
	IDLE				:	begin
								if(compress_done)
									next_state	=	ENCODE_REST;
								else if({compress_start_d1,compress_start}==2'b01)
									next_state	=	ENCODE_MAGIC;
								else if(encode_en && info_valid && (!obuf_full))
									next_state	=	ENCODE_TOKEN;
								else
									next_state	=	IDLE;
							end
	ENCODE_MAGIC	:	begin
								next_state	=	ENCODE_INFO;
							end
   ENCODE_INFO		:	begin
								next_state	=	ENCODE_BLK_LEN;
							end
	ENCODE_BLK_LEN	:	begin
								if(obuf_full)
								begin
									next_state	=	WAIT_FOR_BUF;
								end
								else
								begin
									if(encode_en&&info_valid)
										next_state	=	ENCODE_TOKEN;
									else
										next_state	=	IDLE;
								end
							end
   ENCODE_TOKEN	:	begin
								if(obuf_full)
								begin
									next_state	=	WAIT_FOR_BUF;
								end
								else
								begin
									if(unmatch_length_reg >= 32'd15)
										next_state	=	ENCODE_LIT_LEN;
									else if(unmatch_length_reg == 32'b0)
										next_state	=	ENCODE_OFFSET;
									else
										next_state	=	ENCODE_LIT;
								end
							end
   ENCODE_LIT_LEN	:	begin
								if(obuf_full)
								begin
									next_state	=	WAIT_FOR_BUF;
								end
								else
								begin
									if(unmatch_len_cnt >= unmatch_len_dw)
									begin
										if(!in_empty)
											next_state	=	ENCODE_LIT;
										else
											next_state	=	WAIT_LIT;
									end
									else
									begin
										next_state	=	ENCODE_LIT_LEN;
									end
								end
							end
   ENCODE_LIT		:	begin		
								if(obuf_full)
								begin
									next_state	=	WAIT_FOR_BUF;
								end
								else
								begin
									if(unmatch_lit_cnt[31:2] >= unmatch_length_reg[31:2])
									begin
										if(last_5bytes)
											next_state	=	SEG_DONE;
										else
											next_state	=	ENCODE_OFFSET;
									end
									else
									begin
										if(in_empty || (rd_fifo_count<=12'd1))
										begin
											next_state	=	WAIT_LIT;
										end
										else
										begin
											next_state	=	ENCODE_LIT;
										end
									end
								end
							end
	WAIT_LIT			:	begin
								if(unmatch_lit_cnt[31:2] >= unmatch_length_reg[31:2])
								begin
									if(last_5bytes)
										next_state	=	SEG_DONE;
									else
										next_state	=	ENCODE_OFFSET;
								end
								else if(obuf_full)
								begin
									next_state	=	WAIT_FOR_BUF;
								end
								else
								begin
									if(!in_empty)
										next_state	=	ENCODE_LIT;
									else
										next_state	=	WAIT_LIT;
								end
							end
   ENCODE_OFFSET	:	begin
								if(obuf_full)
								begin
									next_state	=	WAIT_FOR_BUF;
								end
								else
								begin
									if(match_length_reg >= 32'd19)
										next_state	=	ENCODE_MAT_LEN;
									else
										next_state	=	SEG_DONE;
								end
							end
   ENCODE_MAT_LEN	:	begin
								if(obuf_full)
								begin
									next_state	=	WAIT_FOR_BUF;
								end
								else
								begin
									if(match_len_cnt >= match_len_dw)
										next_state	=	SEG_DONE;
									else
										next_state	=	ENCODE_MAT_LEN;
								end
							end
	WAIT_FOR_BUF	:	begin
								if(!obuf_full)
									next_state	=	prev_state;
								else
									next_state	=	WAIT_FOR_BUF;
							end
	SEG_DONE			:	begin
								if(compress_done)
									next_state	=	ENCODE_REST;
								else
									next_state	=	IDLE;
							end
	ENCODE_REST		:	begin
								next_state	=	ENCODE_XXH32;
							end		
	ENCODE_XXH32	:	begin
								next_state	=	ALL_DONE;
							end								
	ALL_DONE			:	begin
								if({compress_start_d1,compress_start}==2'b01)
									next_state	=	ENCODE_MAGIC;
								else
									next_state	=	ALL_DONE;
							end						
	default			:	begin
								next_state	=	IDLE;
							end
	endcase
end

// control signal


always @ (*)
begin
	case(current_state)
	IDLE				:	begin
								match_len_cnt_en		=	1'b0;
								unmatch_len_cnt_en	=	1'b0;
								unmatch_lit_cnt_en	=	1'b0;
								sep_mask					=	3'b0;
								sep_valid				=	1'b0;
								sep_data					=	32'b0;
								fifo_rd_en				=	1'b0;
								seg_done					=	1'b0;	
								encode_done				=	1'b0;
								compressed_valid		=	1'b0;
								compressed_len_incr	=	3'b0;
							end
	ENCODE_MAGIC	:	begin
								match_len_cnt_en		=	1'b0;
								unmatch_len_cnt_en	=	1'b0;
								unmatch_lit_cnt_en	=	1'b0;
								sep_mask					=	3'b100;
								sep_valid				=	1'b1;
								sep_data					=	MAGIC_NUMBER;
								fifo_rd_en				=	1'b0;
								seg_done					=	1'b0;	
								encode_done				=	1'b0;
								compressed_valid		=	1'b0;
								compressed_len_incr	=	3'b0;
							end
   ENCODE_INFO		:	begin
								match_len_cnt_en		=	1'b0;
								unmatch_len_cnt_en	=	1'b0;
								unmatch_lit_cnt_en	=	1'b0;
								sep_mask					=	3'b011;
								sep_valid				=	1'b1;
								sep_data					=	{8'b0,FLAG_BYTE,blocksize_id_reg,header_crc_reg};
								fifo_rd_en				=	1'b0;
								seg_done					=	1'b0;	
								encode_done				=	1'b0;
								compressed_valid		=	1'b0;
								compressed_len_incr	=	3'b0;
							end
	ENCODE_BLK_LEN	:	begin
								match_len_cnt_en		=	1'b0;
								unmatch_len_cnt_en	=	1'b0;
								unmatch_lit_cnt_en	=	1'b0;
								sep_mask					=	3'b100;
								sep_valid				=	1'b1;
								sep_data					=	BLOCK_LENGTH;
								fifo_rd_en				=	1'b0;
								seg_done					=	1'b0;	
								encode_done				=	1'b0;
								compressed_valid		=	1'b0;
								compressed_len_incr	=	3'b0;
							end
   ENCODE_TOKEN	:	begin
								match_len_cnt_en		=	1'b0;
								unmatch_len_cnt_en	=	1'b0;
								unmatch_lit_cnt_en	=	1'b0;
								sep_mask					=	3'b001;
								sep_valid				=	1'b1;
								sep_data					=	{24'b0,unmatch_token,match_token};
								fifo_rd_en				=	1'b0;
								seg_done					=	1'b0;	
								compressed_valid		=	1'b1;
								compressed_len_incr	=	3'h1;
							end
   ENCODE_LIT_LEN	:	begin
								match_len_cnt_en		=	1'b0;
								unmatch_len_cnt_en	=	1'b1;
								unmatch_lit_cnt_en	=	1'b0;
								fifo_rd_en				=	1'b0;
								sep_valid				=	1'b1;
								seg_done					=	1'b0;
								encode_done				=	1'b0;
								if(unmatch_len_cnt < unmatch_len_dw)
								begin
									sep_mask			=	3'b100;
									sep_data			=	32'hFFFF_FFFF;
								end
								else
								begin
									sep_mask			=	unmatch_len_mask;
									sep_data			=	{24'hFF_FFFF,unmatch_len_remain};
								end
								compressed_valid		=	1'b1;
								compressed_len_incr	=	sep_mask;
							end
   ENCODE_LIT		:	begin
								match_len_cnt_en		=	1'b0;
								unmatch_len_cnt_en	=	1'b1;
								unmatch_lit_cnt_en	=	1'b1;
								sep_valid				=	1'b1;
								seg_done					=	1'b0;
								encode_done				=	1'b0;
								if(unmatch_lit_cnt[31:2] < unmatch_length_reg[31:2])
								begin
									sep_mask		=	3'b100;
									sep_data		=	in_data;
								end
								else
								begin
									sep_mask		=	MASK(unmatch_length_reg[1:0]);
									sep_data		=	SHIFT(in_data,unmatch_length_reg[1:0]);
								end
								if(!in_empty)
									fifo_rd_en	=	1'b1;
								else
									fifo_rd_en	=	1'b0;
								compressed_valid		=	1'b1;
								compressed_len_incr	=	sep_mask;
							end
	WAIT_LIT			:	begin
								match_len_cnt_en		=	1'b0;
								unmatch_len_cnt_en	=	1'b0;
								unmatch_lit_cnt_en	=	1'b0;
								fifo_rd_en				=	1'b0;
								sep_mask					=	3'b0;
								sep_valid				=	1'b0;
								sep_data					=	32'b0;	
								seg_done					=	1'b0;
								encode_done				=	1'b0;
								compressed_valid		=	1'b1;
								compressed_len_incr	=	3'b0;
							end
   ENCODE_OFFSET	:	begin
								match_len_cnt_en		=	1'b0;
								unmatch_len_cnt_en	=	1'b0;
								unmatch_lit_cnt_en	=	1'b0;
								fifo_rd_en				=	1'b0;
								sep_mask					=	3'b010;
								sep_valid				=	1'b1;
								sep_data					=	{16'b0,match_offset_reg[7:0],match_offset_reg[15:8]};
								seg_done					=	1'b0;
								encode_done				=	1'b0;
								compressed_valid		=	1'b1;
								compressed_len_incr	=	3'h2;
							end
   ENCODE_MAT_LEN	:	begin
								match_len_cnt_en		=	1'b1;
								unmatch_len_cnt_en	=	1'b0;
								unmatch_lit_cnt_en	=	1'b0;
								fifo_rd_en				=	1'b0;
								sep_valid				=	1'b1;
								seg_done					=	1'b0;
								encode_done				=	1'b0;
								if(match_len_cnt < match_len_dw)
								begin
									sep_mask			=	3'b100;
									sep_data			=	32'hFFFF_FFFF;
								end
								else
								begin
									sep_mask			=	match_len_mask;
									sep_data			=	{24'hFF_FFFF,match_len_remain};
								end
								compressed_valid		=	1'b1;
								compressed_len_incr	=	sep_mask;
							end
	SEG_DONE			:	begin
								match_len_cnt_en		=	1'b0;
								unmatch_len_cnt_en	=	1'b0;
								unmatch_lit_cnt_en	=	1'b0;
								fifo_rd_en				=	1'b0;
								sep_mask					=	3'b0;
								sep_valid				=	1'b0;
								sep_data					=	32'b0;
								seg_done					=	1'b1;
								encode_done				=	1'b0;
								compressed_valid		=	1'b1;
								compressed_len_incr	=	3'b0;
							end
	ENCODE_REST		:	begin
								match_len_cnt_en		=	1'b0;
								unmatch_len_cnt_en	=	1'b0;
								unmatch_lit_cnt_en	=	1'b0;
								fifo_rd_en				=	1'b0;
								sep_mask					=	3'b100;
								sep_valid				=	1'b1;
								sep_data					=	32'b0;
								seg_done					=	1'b0;
								encode_done				=	1'b0;
								compressed_valid		=	1'b0;
								compressed_len_incr	=	3'b0;
							end		
	ENCODE_XXH32	:	begin
								match_len_cnt_en		=	1'b0;
								unmatch_len_cnt_en	=	1'b0;
								unmatch_lit_cnt_en	=	1'b0;
								fifo_rd_en				=	1'b0;
								sep_mask					=	3'b100;
								sep_valid				=	1'b1;
								sep_data					=	ENDIAN_CHG(xxh32_dword);
								seg_done					=	1'b1;
								encode_done				=	1'b0;
								compressed_valid		=	1'b0;
								compressed_len_incr	=	3'b0;
							end
	ALL_DONE			:	begin
								match_len_cnt_en		=	1'b0;
								unmatch_len_cnt_en	=	1'b0;
								unmatch_lit_cnt_en	=	1'b0;
								fifo_rd_en				=	1'b0;
								sep_mask					=	3'b0;
								sep_valid				=	1'b0;
								sep_data					=	32'b0;
								seg_done					=	1'b0;
								encode_done				=	1'b1;
								compressed_valid		=	1'b0;
								compressed_len_incr	=	3'b0;
							end
	default			:	begin
								match_len_cnt_en		=	1'b0;
								unmatch_len_cnt_en	=	1'b0;
								unmatch_lit_cnt_en	=	1'b0;
								fifo_rd_en				=	1'b0;
								sep_mask					=	3'b0;
								sep_valid				=	1'b0;
								sep_data					=	32'b0;
								seg_done					=	1'b0;
								encode_done				=	1'b0;
								compressed_valid		=	1'b0;
								compressed_len_incr	=	3'b0;
							end
	endcase
end

//////////////////////////////////////////////////
////	Unmatch literature FIFO (First through) ////
//////////////////////////////////////////////////

//fifo_1kx32b	U_unmatch_fifo
//(
//  .rst				(~rstN),
//  .wr_clk			(clk),
//  .rd_clk			(clk),
//  .din				(unmatch_data),
//  .wr_en				(data_valid),
//  .rd_en				(fifo_rd_en),
//	
//  .dout				(in_data),
//  .full				(in_full),
//  .empty				(in_empty),
//  .valid				(in_valid),
//  .rd_data_count	(rd_fifo_count),
//  .wr_data_count	(wr_fifo_count)
//);

unmatch_fifo	U_unmatch_fifo
(
	// input global signal
	.clk					(clk),
	.rstN					(rstN),
	// input data and write signal
	.din					(unmatch_data),
	.wr_en				(data_valid),
	.rd_en				(fifo_rd_en),
	.byte_done			(byte_done),	
	// output data and status signal
	.dout					(in_data),
	.dout_mask			(),
	.valid				(in_valid),
	.full					(in_full),
	.empty				(in_empty),
	.rd_data_count		(rd_fifo_count),
	.wr_data_count		(wr_fifo_count)
);

/////////////////////////////////////////////////
////	output encode Module							////
/////////////////////////////////////////////////
encode_glue	U_encode_glue
(
	.clk				(clk),
	.rstN				(rstN),
	.wr_mask			(sep_mask),  // Mask signal : 100 no mask;001 mask 3Bytes;010 mask 2Bytes;011 mask 1Bytes
	.wr_data			(sep_data),
	.wr_valid		(sep_valid),
	.rd_en			(out_en),
	.encode_done	(encode_done),
	.seg_done		(seg_done),
	
	.rd_data			(out_data),
	.rd_valid		(out_valid),
	.rd_empty		(out_empty),
	.ofifo_full		(obuf_full),
	.ohalf_full		(ohalf_full)
);


endmodule
