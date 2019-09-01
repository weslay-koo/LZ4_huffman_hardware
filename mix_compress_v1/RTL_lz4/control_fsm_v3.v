`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:10:56 04/20/2016 
// Design Name: 
// Module Name:    control_fsm_v3 
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
module control_fsm_v3(
// Global clock and reset
input wire				clk,
input wire				rstN,
input wire				start_compress,
input wire	[31:0]	file_len,
input wire				file_len_valid,
// from byte_addressing
input wire	[31:0]	byte4_data1, 
input wire	[31:0]	byte4_data2,
input wire	[31:0]	byte4_data3,
input wire	[31:0]	byte4_data4,
input wire				byte4_valid,
input wire				byte4_busy,
output reg				rd_data_en,
output reg				byte4_en,
output reg	[2:0]		shift_dist,
output reg				shift_en,
output reg				prefetch,
output wire				last_3dwords,
// from abs_addr_gen
input wire	[31:0]	abs_addr,
input wire	[31:0]	abs_addr1,
input wire	[31:0]	abs_addr2,
input wire	[31:0]	abs_addr3,
input wire	[31:0]	abs_addr4,
output reg	[2:0]		incr_bytes,
// from hash_table
input wire	[31:0]	hash_oaddr,
input wire				hash_hit,
input wire	[2:0]		hit_status,
input wire	[31:0]	hit_dist,
input wire				hash_ovalid,
input wire				hash_unable,
output reg				hash_clean,
output reg	[31:0]	hash_iaddr1,
output reg	[31:0]	hash_idata1,
output reg				hash_ivalid1,
output reg	[31:0]	hash_iaddr2,
output reg	[31:0]	hash_idata2,
output reg				hash_ivalid2,
output reg	[31:0]	hash_iaddr3,
output reg	[31:0]	hash_idata3,
output reg				hash_ivalid3,
output reg	[31:0]	hash_iaddr4,
output reg	[31:0]	hash_idata4,
output reg				hash_ivalid4,
output reg				hash_wr_only,
// from lz4_buffer
input wire	[14:0]	fifo_count,	
input wire	[31:0]	anchor,
input wire				match_start,
input wire				outofrange,	
input wire	[31:0]	dict_odata,
input wire				dict_ovalid,
input wire				over_band,
output wire				hit_valid,
output reg	[31:0]	dict_abs_addr,
output reg				dict_rd,	
output reg				matching,
output reg	[2:0]		move_dist,
output reg				move_valid,
// from xxh32_calc
input	wire	[31:0]	digest,
input	wire				digest_valid,
// encode output
input wire				encode_done,			
input wire				encode_busy,			
input wire				seg_done,
output reg	[31:0]	xxh32_dword,
output reg	[7:0]		blocksize_id,
output reg	[7:0]		header_crc,
output reg				head_valid,
output reg	[15:0]	match_offset,			
output reg	[31:0]	match_length,			
output reg	[31:0]	unmatch_length,
output reg				ignore_offset,		
output reg				info_valid,
output reg	[31:0]	unmatch_data,			
output reg				unmatch_dvalid,	
output reg				compress_done,			
output reg				compress_start,		
output reg				encode_en
);

//////// Define Parameters ///////////////
parameter	IDLE 				= 	4'h0;
parameter	WAIT_UNBUSY		= 	4'h1;
parameter	PROC_START 		= 	4'h2;
parameter	READ_BYTES		=	4'h3;
parameter	WAIT_SVALID		=	4'h4;
parameter	UPDATE_HASH		=	4'h5;
parameter	WAIT_HASH		=	4'h6;
parameter	MATCH_STANDBY	=	4'h7;
parameter	MATCH_START		=	4'h8;
parameter	MATCHING			=	4'h9;
parameter	WAIT_FIFO		=	4'hA;
parameter	MATCH_RECV		=	4'hB;
parameter	MATCH_END		=	4'hC;
parameter	ENCODE_START	=	4'hD;
parameter	ENCODE_WAIT		=	4'hE;
parameter	STOP				=	4'hF;
//////////////////////////////////////////
// FSM status
reg	[3:0]		current_state,next_state; 
// hash and match logic
reg				hash_match;
reg	[31:0]	match_distance_cnt;
reg	[31:0]	match_length_cnt;
reg	[2:0]		match_length_incr;
wire	[31:0]	match_last_incr;
reg	[31:0]	unmatch_length_cnt;
reg	[2:0]		unmatch_length_incr;
wire	[3:0]		match_status;
reg				match_goon;
reg	[31:0]	match_addr;
reg				match_addr_en;
reg	[2:0]		match_mask;
reg	[3:0]		match_head;
// file length counter
reg	[31:0]	file_len_reg;
wire	[31:0]	file_len_cnt;
reg	[31:0]	file_remand;
// last 5 byte frame signal
reg				last_5bytes_temp;
wire				last_1dword;
reg				last_seg_en;
wire	[31:0]	last_incr;
reg				last_5bytes;
// match end logic
reg				last_match;
// maxBlockSize
reg	[31:0]	max_bsize;
reg				block_cut;
// hit status delay
reg	[2:0]		hit_status_reg;
// byte4 data1 register for unmatch data
reg	[31:0]	byte4_data1_reg;
// encode frame done signal generation
reg				encode_frame_undone;
reg				encode_en_reg;
reg				wait_encode,wait_encode_reg;

/////////////////////////////////////////////////
////			Dividual Combination Logic 		////
/////////////////////////////////////////////////

assign	match_start	=	hash_hit;

assign	match_status[0]	=	(byte4_data1[7:0]  ==dict_odata[7:0])   ? 1'b1 : 1'b0;
assign	match_status[1]	=	(byte4_data1[15:8] ==dict_odata[15:8])  ? 1'b1 : 1'b0;
assign	match_status[2]	=	(byte4_data1[23:16]==dict_odata[23:16]) ? 1'b1 : 1'b0;
assign	match_status[3]	=	(byte4_data1[31:24]==dict_odata[31:24]) ? 1'b1 : 1'b0;

assign	match_last_incr	=	file_len_reg - file_len_cnt - file_remand;	//	32'd5;
assign	file_len_cnt		=	abs_addr;

assign	last_incr			=	file_len_reg - file_len_cnt;

assign	hit_valid			=	(((abs_addr-hash_oaddr)<=32'hFFFF) && hash_hit) ? 1'b1 : 1'b0;

assign	last_3dwords		=	(file_len_cnt >= (file_len_reg - 32'd13)) ? 1'b1 : 1'b0;
assign	last_1dword			=	(file_len_cnt >= (file_len_reg - 32'd4)) ? 1'b1 : 1'b0;

always @ (*)
begin
	if(matching && dict_ovalid && byte4_valid)	//	((matching)&&(move_valid))
	begin
		case(match_status)
		4'b1000,
		4'b1001,
		4'b1010,
		4'b1011	:	begin
							last_match	=	1'b1;
							match_head	=	4'b1000;
							if(file_len_cnt < (file_len_reg - 32'd5))
							begin
								match_length_incr	=	3'd1;
								match_goon			=	1'b0;
								match_mask			=	3'h1;
								file_remand			=	32'b0;
							end
							else
							begin
								match_length_incr	=	match_last_incr[2:0];
								match_goon			=	1'b0;
								match_mask			=	match_last_incr[2:0];
								file_remand			=	32'd5;
							end
						end
		4'b1100,
		4'b1101	:	begin
							last_match	=	1'b1;
							match_head	=	4'b1100;
							if(file_len_cnt < (file_len_reg - 32'd6))
							begin
								match_length_incr	=	3'd2;
								match_goon			=	1'b0;
								match_mask			=	3'h2;
								file_remand			=	32'b0;
							end
							else
							begin
								match_length_incr	=	match_last_incr[2:0];
								match_goon			=	1'b0;
								match_mask			=	match_last_incr[2:0];
								file_remand			=	32'd5;
							end
						end
		4'b1110	:	begin
							last_match	=	1'b1;
							match_head	=	4'b1110;
							if(file_len_cnt < (file_len_reg - 32'd7))
							begin
								match_length_incr	=	3'd3;
								match_goon			=	1'b0;
								match_mask			=	3'h3;
								file_remand			=	32'b0;
							end
							else
							begin
								match_length_incr	=	match_last_incr[2:0];
								match_goon			=	1'b0;
								match_mask			=	match_last_incr[2:0];
								file_remand			=	32'd5;
							end
						end
		4'b1111	:	begin
							last_match	=	1'b0;
							match_head	=	4'b1111;
							if(file_len_cnt < (file_len_reg - 32'd8))
							begin
								match_length_incr	=	3'd4;
								match_goon			=	1'b1;
								match_mask			=	3'h4;
								file_remand			=	32'b0;
							end
							else
							begin
								match_length_incr	=	match_last_incr[2:0];
								match_goon			=	1'b0;
								match_mask			=	match_last_incr[2:0];
								file_remand			=	32'd5;
							end
						end
		default	:	begin
							match_head			=	4'b0;
							last_match			=	1'b0;
							match_length_incr	=	3'b0;
							match_goon			=	1'b0;
							match_mask			=	3'b0;
							file_remand			=	32'b0;
						end
		endcase
	end
	else
	begin
		match_head			=	4'b0;
		last_match			=	1'b0;
		match_length_incr	=	3'b0;
		match_goon			=	1'b0;
		match_mask			=	3'b0;
		file_remand			=	32'd0;
	end
end


/////////////////////////////////////////////////
////				 Sequential Logic 				////
/////////////////////////////////////////////////

// Main status transfer logic
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		current_state	<=	IDLE;
	end
	else
	begin
		current_state	<=	next_state;
	end
end

// match address generation
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		match_addr	<=	32'b0	;
	end
	else
	begin
		if(hash_ovalid)
		begin
			match_addr	<=	hash_oaddr + 3'h4;
		end
		else if(match_addr_en)
		begin
			match_addr	<=	match_addr + 3'h4;
		end
		else
		begin
			match_addr	<=	match_addr;
		end
	end
end	

// hash match signal generator
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		hash_match				<=	1'b0	;
		match_distance_cnt	<=	32'b0	;
	end
	else
	begin
		if(hash_ovalid)
		begin
			if((hit_dist <=32'hFFFF) && hash_hit)
			begin
				hash_match				<=	1'b1	;
				match_distance_cnt	<=	hit_dist; // hit_dist - 1'b1 ?
			end
			else
			begin
				hash_match				<=	1'b0	;
				match_distance_cnt	<=	match_distance_cnt;
			end
		end
		else
		begin
			hash_match		<=	1'b0	;
			if(info_valid)
				match_distance_cnt	<=	32'b0;
			else
				match_distance_cnt	<=	match_distance_cnt;
		end
	end
end

// match length caculator
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		unmatch_length_cnt	<=	32'b0;
	end
	else
	begin
		if(info_valid)
			unmatch_length_cnt	<=	32'b0;
		else if(unmatch_dvalid)
			unmatch_length_cnt	<=	unmatch_length_cnt + unmatch_length_incr;
		else
			unmatch_length_cnt	<=	unmatch_length_cnt;
	end
end
					
// match length caculator
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		match_length_cnt	<=	32'd4	;
	end
	else
	begin
		if((dict_ovalid)&&(byte4_valid))
		begin
			match_length_cnt	<=	match_length_cnt + match_length_incr;
		end
		else
		begin
			if(info_valid)
				match_length_cnt	<=	32'd4;
			else
				match_length_cnt	<=	match_length_cnt;
		end
	end
end

// digest register
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		xxh32_dword	<=	32'b0;
	end
	else
	begin
		if(digest_valid)
			xxh32_dword	<= digest;
		else
			xxh32_dword	<=	xxh32_dword;
	end
end

// hash hit status register
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		hit_status_reg	<=	3'b0;
	end
	else
	begin
		if(hash_hit)
			hit_status_reg	<=	hit_status;
		else
			hit_status_reg	<=	hit_status_reg;
	end
end

// byte4_data1 register for unmatch data
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		byte4_data1_reg	<=	32'b0;
	end
	else
	begin
		if(byte4_valid)
			byte4_data1_reg	<=	byte4_data1;
		else
			byte4_data1_reg	<=	byte4_data1_reg;
	end
end

// file length latch and header information generation
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		file_len_reg	<=	32'b0;
		blocksize_id	<=	8'b0;
		header_crc		<=	8'b0;
		head_valid		<=	1'b0;
		max_bsize		<=	32'b0;
		block_cut		<=	1'b0;
	end
	else
	begin
		if(file_len_valid)
		begin
			file_len_reg	<=	file_len;
			head_valid		<=	1'b1;
			if(file_len <= 32'h10000)
			begin
				blocksize_id	<=	8'h40;
				header_crc		<=	8'hA7;
				max_bsize		<=	32'h10000;
				block_cut		<=	1'b0;
			end
			else if(file_len <= 32'h40000)
			begin
				blocksize_id	<=	8'h50;
				header_crc		<=	8'h08;
				max_bsize		<=	32'h40000;
				block_cut		<=	1'b0;
			end
			else if(file_len <= 32'h100000)
			begin
				blocksize_id	<=	8'h60;
				header_crc		<=	8'h85;
				max_bsize		<=	32'h100000;
				block_cut		<=	1'b0;
			end
			else if(file_len <= 32'h400000)
			begin
				blocksize_id	<=	8'h70;
				header_crc		<=	8'hB9;
				max_bsize		<=	32'h400000;
				block_cut		<=	1'b0;
			end
			else
			begin
				blocksize_id	<=	8'h70;
				header_crc		<=	8'hB9;
				max_bsize		<=	32'h400000;
				block_cut		<=	1'b1;
			end
		end
		else
		begin
			file_len_reg	<=	file_len_reg;
			blocksize_id	<=	8'b0;
			header_crc		<=	8'b0;
			head_valid		<=	1'b0;
			block_cut		<=	block_cut;
		end
	end
end

// last 5 Bytes and last 2 dword directed signal
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		last_5bytes_temp	<=	1'b0;
		last_5bytes			<=	1'b0;
	end
	else
	begin
		//if(last_seg_en && (file_len_cnt >= (file_len_reg - 32'd5)))
		//	last_5bytes	<=	1'b1;
		//else 
		if(info_valid) // (seg_done)
			last_5bytes	<=	last_5bytes_temp;
		else
			last_5bytes	<=	last_5bytes;
			
		if(compress_done)
			last_5bytes_temp	<=	1'b0;	
		else if(file_len_cnt >= (file_len_reg - 32'd5))
			last_5bytes_temp	<=	1'b1;
		else
			last_5bytes_temp	<=	last_5bytes_temp;
	end
end

// encode frame done and encode enable signal generation
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		encode_frame_undone	<=	1'b0;
		encode_en_reg			<=	1'b0;
		wait_encode_reg		<=	1'b0;
	end
	else
	begin
		if(seg_done || encode_done)
		begin
			encode_frame_undone	<=	1'b0;
			encode_en_reg			<=	1'b0;
		end
		else if(info_valid)
		begin
			encode_frame_undone	<= 1'b1;
			encode_en_reg			<=	1'b1;
		end
		else
		begin
			encode_frame_undone	<=	encode_frame_undone;
			encode_en_reg			<=	encode_en_reg;
		end
		if(!wait_encode)
			wait_encode_reg	<=	1'b0;
		else if(wait_encode && info_valid)
			wait_encode_reg	<=	1'b1;
		else
			wait_encode_reg	<=	wait_encode_reg;
	end
end

//////////////////////////////////////////////
////				Combination Logic 			////
//////////////////////////////////////////////

// Combination Logic for status transfer
always @ (*)
begin
	case(current_state)
	IDLE 			:	begin
							if(start_compress)
							begin
								if((hash_unable)||(fifo_count<15'd4))
									next_state	=	WAIT_UNBUSY	;
								else
									next_state	=	PROC_START	;
							end
							else
								next_state	=	IDLE	;
						end
	WAIT_UNBUSY	:	begin
							if((hash_unable)||(fifo_count<15'd4))
								next_state	=	WAIT_UNBUSY	;
							else
								next_state	=	PROC_START	;
						end
	PROC_START	:	begin	
							if(byte4_busy || hash_unable)
								next_state	=	PROC_START	;
							else
								next_state	=	READ_BYTES	;
						end 		
	READ_BYTES	:	begin	
							next_state	=	WAIT_SVALID	;
						end
	WAIT_SVALID	:	begin
							if(byte4_valid)
							begin
								if(last_5bytes || last_seg_en)
								begin
									if(last_1dword)	
										next_state	=	ENCODE_START;
									else
										next_state	=	READ_BYTES;
								end
								else
								begin
									next_state	=	UPDATE_HASH	;
								end
							end
							else
							begin
								next_state	=	WAIT_SVALID	;
							end
						end
	UPDATE_HASH	:	begin	
							next_state	=	WAIT_HASH	;
						end	
	WAIT_HASH	:	begin
							if(hash_ovalid)
							begin
								if((hit_dist <= 32'hFFFF)
									&& hash_hit && (hash_ovalid)) //(hash_match)	// hash address is match
								begin
									if(hash_oaddr[1:0] == 2'b0)
										next_state	=	MATCH_START	;
									else
										next_state	=	MATCH_STANDBY	;
								end
								else
								begin
									next_state	=	READ_BYTES	;
								end
							end
							else
							begin
								next_state	=	WAIT_HASH	;
							end
						end
	MATCH_STANDBY:	begin
							next_state	=	MATCH_START	;
						end
	MATCH_START	:	begin	
							next_state	=	MATCHING	;
						end		
	MATCHING		:	begin	
							if( (dict_ovalid) && (byte4_valid)
								&& match_goon && (!outofrange) )	//	&& (dict_abs_addr < anchor))
								if(over_band)	//	((fifo_count < 15'h1) || over_band)
									next_state	=	WAIT_FIFO;
								else
									next_state	=	MATCHING;
							else
								next_state	=	MATCH_END;
						end	
	WAIT_FIFO	:	begin
							if(last_seg_en)
							begin
								next_state	=	MATCHING;
							end
							else
							begin
								if(over_band || byte4_busy)	//	(((fifo_count < 15'h1) || over_band)
								begin
									next_state	=	WAIT_FIFO;
								end
								else
								begin
									if(match_addr[1:0] == 2'b00)
										next_state	=	MATCHING	;
									else
										next_state	=	MATCH_RECV;
								end
							end
						end
	MATCH_RECV	:	begin
							next_state	=	MATCHING	;
						end
	MATCH_END	:	begin	
							next_state	=	ENCODE_START;
						end		
	ENCODE_START:	begin	
							if(encode_frame_undone)
								next_state	=	ENCODE_WAIT	;
							else
								if(file_len_cnt < file_len_reg) // one full encode process
									next_state	=	READ_BYTES;
								else
									next_state	=	ENCODE_WAIT;
						end
	ENCODE_WAIT	:	begin	
							if((!encode_frame_undone) && (!info_valid))	//	(seg_done)
							begin
								if(file_len_cnt < file_len_reg) // one full encode process
									next_state	=	READ_BYTES;
								else
									next_state	=	STOP;
							end
							else
							begin
								next_state	=	ENCODE_WAIT;
							end
						end
	STOP			:	begin	
							next_state	=	STOP;
						end
	default		:	begin	
							next_state	=	IDLE;
						end
	endcase
end

// Combination Logic for internal control signal
always @ (*)
begin
	case(current_state)
	IDLE 			:	begin
							incr_bytes		=	3'b0;	
							matching			=	1'b0;
							match_addr_en	=	1'b0;
							match_offset	=	16'b0;
							match_length	=	32'b0;
							unmatch_length	=	32'b0;
							ignore_offset  =	1'b0;
							info_valid		=	1'b0;	
							compress_done	=	1'b0;	
							compress_start	=	1'b0;
							last_seg_en		=	1'b0;
						end
	WAIT_UNBUSY	:	begin
							incr_bytes		=	3'b0;		
							matching			=	1'b0;
							match_addr_en	=	1'b0;
							match_offset	=	16'b0;
							match_length	=	32'b0;
							unmatch_length	=	32'b0;
							ignore_offset  =	1'b0;
							info_valid		=	1'b0;	
							compress_done	=	1'b0;	
							compress_start	=	1'b0;	
							last_seg_en		=	1'b0;
						end
	PROC_START	:	begin	
							incr_bytes		=	3'b0;	
							matching			=	1'b0;
							match_addr_en	=	1'b0;
							match_offset	=	16'b0;
							match_length	=	32'b0;
							unmatch_length	=	32'b0;
							ignore_offset  =	1'b0;
							info_valid		=	1'b0;	
							compress_done	=	1'b0;	
							compress_start	=	1'b1;	
							last_seg_en		=	1'b0;
						end 		
	READ_BYTES	:	begin	
							incr_bytes		=	3'b0;		//	3'h1;	
							matching			=	1'b0;
							match_addr_en	=	1'b0;
							match_offset	=	16'b0;
							match_length	=	32'b0;
							unmatch_length	=	32'b0;
							ignore_offset  =	1'b0;
							info_valid		=	1'b0;	
							compress_done	=	1'b0;	
							compress_start	=	1'b0;	
							if(file_len_cnt >= (file_len_reg - 32'd8))
								last_seg_en	=	1'b1;
							else
								last_seg_en	=	1'b0;
						end
	WAIT_SVALID	:	begin
							if(last_seg_en && byte4_valid)
								incr_bytes	=	3'h4;	
							else
								incr_bytes	=	3'b0;	
							matching			=	1'b0;
							match_addr_en	=	1'b0;
							match_offset	=	16'b0;
							match_length	=	32'b0;
							unmatch_length	=	32'b0;
							ignore_offset  =	1'b0;
							info_valid		=	1'b0;	
							compress_done	=	1'b0;	
							compress_start	=	1'b0;
							if(file_len_cnt >= (file_len_reg - 32'd8))
								last_seg_en	=	1'b1;
							else
								last_seg_en	=	1'b0;
						end
	UPDATE_HASH	:	begin	
							incr_bytes		=	3'h4;		//	3'h1;		
							matching			=	1'b0;
							match_addr_en	=	1'b0;
							match_offset	=	16'b0;
							match_length	=	32'b0;
							unmatch_length	=	32'b0;
							ignore_offset  =	1'b0;
							info_valid		=	1'b0;	
							compress_done	=	1'b0;	
							compress_start	=	1'b0;	
							last_seg_en		=	1'b0;
						end	
	WAIT_HASH	:	begin
							incr_bytes		=	3'b0;	
							matching			=	1'b0;
							match_addr_en	=	1'b0;
							match_offset	=	16'b0;
							match_length	=	32'b0;
							unmatch_length	=	32'b0;
							ignore_offset  =	1'b0;
							info_valid		=	1'b0;	
							compress_done	=	1'b0;	
							compress_start	=	1'b0;
							last_seg_en		=	1'b0;
						end
	MATCH_STANDBY:	begin
							incr_bytes		=	3'b0;	
							matching			=	1'b0;
							match_addr_en	=	1'b1;
							match_offset	=	16'b0;
							match_length	=	32'b0;
							unmatch_length	=	32'b0;
							ignore_offset  =	1'b0;
							info_valid		=	1'b0;	
							compress_done	=	1'b0;	
							compress_start	=	1'b0;	
							last_seg_en		=	1'b0;
						end
	MATCH_START	:	begin	
							incr_bytes		=	hit_status_reg;	// notice
							matching			=	1'b1;
							match_addr_en	=	1'b1;
							match_offset	=	16'b0;
							match_length	=	32'b0;
							unmatch_length	=	32'b0;
							ignore_offset  =	1'b0;
							info_valid		=	1'b0;	
							compress_done	=	1'b0;	
							compress_start	=	1'b0;	
							last_seg_en		=	1'b0;
						end		
	MATCHING		:	begin
							if(match_goon)
								incr_bytes	=	3'h4;
							else
								incr_bytes	=	match_mask;	//	3'b0;
							matching			=	1'b1;
							if(over_band)
								match_addr_en	=	1'b0;
							else
								match_addr_en	=	1'b1;
							match_offset	=	16'b0;
							match_length	=	32'b0;
							unmatch_length	=	32'b0;
							ignore_offset  =	1'b0;
							info_valid		=	1'b0;	
							compress_done	=	1'b0;	
							compress_start	=	1'b0;	
							last_seg_en		=	1'b0;
						end			
	WAIT_FIFO	:	begin	
							incr_bytes		=	3'b0;	
							matching			=	1'b0;
							if((!over_band) && (!byte4_busy) && (match_addr[1:0] == 2'b00))
								match_addr_en	=	1'b1;
							else
								match_addr_en	=	1'b0;
							match_offset	=	16'b0;
							match_length	=	32'b0;
							unmatch_length	=	32'b0;
							ignore_offset  =	1'b0;
							info_valid		=	1'b0;	
							compress_done	=	1'b0;	
							compress_start	=	1'b0;	
							if(file_len_cnt >= (file_len_reg - 32'd8))
								last_seg_en	=	1'b1;
							else
								last_seg_en	=	1'b0;
						end		
	MATCH_RECV	:	begin
							incr_bytes		=	3'b0;	
							matching			=	1'b1;
							match_addr_en	=	1'b1;
							match_offset	=	16'b0;
							match_length	=	32'b0;
							unmatch_length	=	32'b0;
							ignore_offset  =	1'b0;
							info_valid		=	1'b0;	
							compress_done	=	1'b0;	
							compress_start	=	1'b0;	
							last_seg_en		=	1'b0;
						end
	MATCH_END	:	begin	
							incr_bytes		=	3'b0;	
							matching			=	1'b0;
							match_addr_en	=	1'b0;
							match_offset	=	16'b0;
							match_length	=	32'b0;
							unmatch_length	=	32'b0;
							ignore_offset  =	1'b0;
							info_valid		=	1'b0;	
							compress_done	=	1'b0;	
							compress_start	=	1'b0;	
							last_seg_en		=	1'b0;
						end		
	ENCODE_START:	begin	
							incr_bytes		=	3'b0;	
							matching			=	1'b0;
							match_addr_en	=	1'b0;
							if(last_5bytes || last_seg_en)
							begin
								match_offset	=	16'b0;
								match_length	=	32'b0;
								unmatch_length	=	unmatch_length_cnt;
								ignore_offset  =	1'b1;
							end
							else
							begin
								match_offset	=	match_distance_cnt[15:0];
								match_length	=	match_length_cnt;
								unmatch_length	=	unmatch_length_cnt;
								ignore_offset  =	1'b0;
							end
							if(!encode_frame_undone) //  || seg_done)
								info_valid	=	1'b1;	
							else
								info_valid	=	1'b0;
							compress_done	=	1'b0;	
							compress_start	=	1'b0;	
							last_seg_en		=	1'b0;
						end	
	ENCODE_WAIT	:	begin	
							incr_bytes		=	3'b0;	
							matching			=	1'b0;
							match_addr_en	=	1'b0;
							if(last_5bytes||last_seg_en)
							begin
								match_offset	=	16'b0;
								match_length	=	32'b0;
								unmatch_length	=	unmatch_length_cnt;
								ignore_offset  =	1'b1;
							end
							else
							begin
								match_offset	=	match_distance_cnt[15:0];
								match_length	=	match_length_cnt;
								unmatch_length	=	unmatch_length_cnt;
								ignore_offset  =	1'b0;
							end
							if((!encode_frame_undone) && (!wait_encode_reg))
								info_valid	=	1'b1;	
							else
								info_valid	=	1'b0;
							compress_done	=	1'b0;	
							compress_start	=	1'b0;	
							last_seg_en		=	1'b0;
						end
	STOP			:	begin	
							incr_bytes		=	3'b0;	
							matching			=	1'b0;
							match_addr_en	=	1'b0;
							match_offset	=	16'b0;
							match_length	=	32'b0;
							unmatch_length	=	32'b0;
							ignore_offset  =	1'b0;
							info_valid		=	1'b0;	
							compress_done	=	1'b1;	
							compress_start	=	1'b0;	
							last_seg_en		=	1'b0;
						end
	default		:	begin	
							incr_bytes		=	3'b0;	
							matching			=	1'b0;
							match_addr_en	=	1'b0;
							match_offset	=	16'b0;
							match_length	=	32'b0;
							unmatch_length	=	32'b0;
							ignore_offset  =	1'b0;
							info_valid		=	1'b0;	
							compress_done	=	1'b0;	
							compress_start	=	1'b0;	
							last_seg_en		=	1'b0;
						end
	endcase
end

// Combination Logic for external hash_table module control signal
always @ (*)
begin
	case(current_state)
	IDLE 			:	begin
							hash_clean		=	1'b0;	
							hash_wr_only	=	1'b0;
							hash_iaddr1		=	32'b0;	
							hash_idata1		=	32'b0;
							hash_ivalid1	=	1'b0;	
							hash_iaddr2		=	32'b0;	
							hash_idata2		=	32'b0;
							hash_ivalid2	=	1'b0;		
							hash_iaddr3		=	32'b0;	
							hash_idata3		=	32'b0;	
							hash_ivalid3	=	1'b0;	
							hash_iaddr4		=	32'b0;	
							hash_idata4		=	32'b0;
							hash_ivalid4	=	1'b0;	
						end
	WAIT_UNBUSY	:	begin
							hash_clean		=	1'b0;	
							hash_wr_only	=	1'b0;
							hash_iaddr1		=	32'b0;	
							hash_idata1		=	32'b0;
							hash_ivalid1	=	1'b0;		
							hash_iaddr2		=	32'b0;	
							hash_idata2		=	32'b0;
							hash_ivalid2	=	1'b0;		
							hash_iaddr3		=	32'b0;	
							hash_idata3		=	32'b0;
							hash_ivalid3	=	1'b0;		
							hash_iaddr4		=	32'b0;	
							hash_idata4		=	32'b0;
							hash_ivalid4	=	1'b0;	
						end
	PROC_START	:	begin	
							hash_clean		=	1'b0;
							hash_wr_only	=	1'b0;
							hash_iaddr1		=	32'b0;	
							hash_idata1		=	32'b0;
							hash_ivalid1	=	1'b0;		
							hash_iaddr2		=	32'b0;	
							hash_idata2		=	32'b0;
							hash_ivalid2	=	1'b0;		
							hash_iaddr3		=	32'b0;	
							hash_idata3		=	32'b0;
							hash_ivalid3	=	1'b0;		
							hash_iaddr4		=	32'b0;	
							hash_idata4		=	32'b0;	
							hash_ivalid4	=	1'b0;	
						end 		
	READ_BYTES	:	begin	
							hash_clean		=	1'b0;
							hash_wr_only	=	1'b0;
							hash_iaddr1		=	32'b0;	
							hash_idata1		=	32'b0;
							hash_ivalid1	=	1'b0;		
							hash_iaddr2		=	32'b0;	
							hash_idata2		=	32'b0;
							hash_ivalid2	=	1'b0;		
							hash_iaddr3		=	32'b0;	
							hash_idata3		=	32'b0;
							hash_ivalid3	=	1'b0;		
							hash_iaddr4		=	32'b0;	
							hash_idata4		=	32'b0;
							hash_ivalid4	=	1'b0;	
						end
	WAIT_SVALID	:	begin
							hash_clean		=	1'b0;
							hash_wr_only	=	1'b0;
							if(byte4_valid)
							begin
								hash_iaddr1		=	abs_addr1;		
								hash_idata1		=	byte4_data1;
								hash_ivalid1	=	1'b1;    			
								hash_iaddr2		=	abs_addr2;		
								hash_idata2		=	byte4_data2;
								hash_ivalid2	=	1'b1;    			
								hash_iaddr3		=	abs_addr3;		
								hash_idata3		=	byte4_data3;
								hash_ivalid3	=	1'b1;    			
								hash_iaddr4		=	abs_addr4;		
								hash_idata4		=	byte4_data4;
								hash_ivalid4	=	1'b1;    			
							end
							else
							begin	
								hash_iaddr1		=	32'b0; 		
								hash_idata1		=	32'b0;
								hash_ivalid1	=	1'b0;   
								hash_iaddr2		=	32'b0; 		
								hash_idata2		=	32'b0;
								hash_ivalid2	=	1'b0;    	
								hash_iaddr3		=	32'b0; 		
								hash_idata3		=	32'b0;
								hash_ivalid3	=	1'b0;    	
								hash_iaddr4		=	32'b0; 		
								hash_idata4		=	32'b0;
								hash_ivalid4	=	1'b0;		
							end
						end
	UPDATE_HASH	:	begin	
							hash_clean		=	1'b0;
							hash_wr_only	=	1'b0;
							hash_iaddr1		=	32'b0; 		
							hash_idata1		=	32'b0;
							hash_ivalid1	=	1'b0;	
							hash_iaddr2		=	32'b0; 		
							hash_idata2		=	32'b0;
							hash_ivalid2	=	1'b0;	
							hash_iaddr3		=	32'b0; 		
							hash_idata3		=	32'b0;
							hash_ivalid3	=	1'b0;	
							hash_iaddr4		=	32'b0; 		
							hash_idata4		=	32'b0;
							hash_ivalid4	=	1'b0;	
						end	
	WAIT_HASH	:	begin
							hash_clean		=	1'b0;
							hash_wr_only	=	1'b0;
							hash_iaddr1		=	32'b0; 		
							hash_idata1		=	32'b0;
							hash_ivalid1	=	1'b0;    	
							hash_iaddr2		=	32'b0; 		
							hash_idata2		=	32'b0;
							hash_ivalid2	=	1'b0; 
							hash_iaddr3		=	32'b0; 		
							hash_idata3		=	32'b0;
							hash_ivalid3	=	1'b0; 
							hash_iaddr4		=	32'b0; 		
							hash_idata4		=	32'b0;
							hash_ivalid4	=	1'b0;
						end
	MATCH_STANDBY:	begin
							hash_clean		=	1'b0;
							hash_wr_only	=	1'b0;
							hash_iaddr1		=	32'b0; 		
							hash_idata1		=	32'b0;
							hash_ivalid1	=	1'b0;	
							hash_iaddr2		=	32'b0; 		
							hash_idata2		=	32'b0;
							hash_ivalid2	=	1'b0;	
							hash_iaddr3		=	32'b0; 		
							hash_idata3		=	32'b0;
							hash_ivalid3	=	1'b0;	
							hash_iaddr4		=	32'b0; 		
							hash_idata4		=	32'b0;
							hash_ivalid4	=	1'b0;	
						end
	MATCH_START	:	begin	
							hash_clean		=	1'b0;
							hash_wr_only	=	1'b1;
							hash_iaddr1		=	32'b0; 		
							hash_idata1		=	32'b0;
							hash_ivalid1	=	1'b0;	
							hash_iaddr2		=	32'b0; 		
							hash_idata2		=	32'b0;
							hash_ivalid2	=	1'b0;	
							hash_iaddr3		=	32'b0; 		
							hash_idata3		=	32'b0;
							hash_ivalid3	=	1'b0;	
							hash_iaddr4		=	32'b0; 		
							hash_idata4		=	32'b0;
							hash_ivalid4	=	1'b0;	
						end		
	MATCHING		:	begin
							hash_clean		=	1'b0;
							hash_wr_only	=	1'b1;
							if(byte4_valid && match_goon)
							begin
								hash_iaddr1		=	abs_addr1; 		
								hash_idata1		=	byte4_data1;
								hash_ivalid1	=	match_head[0];	
								hash_iaddr2		=	abs_addr2; 		
								hash_idata2		=	byte4_data2;
								hash_ivalid2	=	match_head[1];	
								hash_iaddr3		=	abs_addr3; 		
								hash_idata3		=	byte4_data3;
								hash_ivalid3	=	match_head[2];	
								hash_iaddr4		=	abs_addr4; 		
								hash_idata4		=	byte4_data4;
								hash_ivalid4	=	match_head[3];	
							end
							else
							begin
								hash_iaddr1		=	32'b0; 		
								hash_idata1		=	32'b0;
								hash_ivalid1	=	1'b0;	
								hash_iaddr2		=	32'b0; 		
								hash_idata2		=	32'b0;
								hash_ivalid2	=	1'b0;	
								hash_iaddr3		=	32'b0; 		
								hash_idata3		=	32'b0;
								hash_ivalid3	=	1'b0;	
								hash_iaddr4		=	32'b0; 		
								hash_idata4		=	32'b0;
								hash_ivalid4	=	1'b0;	
							end
						end			
	WAIT_FIFO	:	begin	
							hash_clean		=	1'b0;
							hash_wr_only	=	1'b0;
							hash_iaddr1		=	32'b0; 		
							hash_idata1		=	32'b0;
							hash_ivalid1	=	1'b0;	
							hash_iaddr2		=	32'b0; 		
							hash_idata2		=	32'b0;
							hash_ivalid2	=	1'b0;	
							hash_iaddr3		=	32'b0; 		
							hash_idata3		=	32'b0;
							hash_ivalid3	=	1'b0;	
							hash_iaddr4		=	32'b0; 		
							hash_idata4		=	32'b0;
							hash_ivalid4	=	1'b0;	
						end		
	MATCH_RECV	:	begin
							hash_clean		=	1'b0;
							hash_wr_only	=	1'b0;
							hash_iaddr1		=	32'b0; 		
							hash_idata1		=	32'b0;
							hash_ivalid1	=	1'b0;	
							hash_iaddr2		=	32'b0; 		
							hash_idata2		=	32'b0;
							hash_ivalid2	=	1'b0;	
							hash_iaddr3		=	32'b0; 		
							hash_idata3		=	32'b0;
							hash_ivalid3	=	1'b0;	
							hash_iaddr4		=	32'b0; 		
							hash_idata4		=	32'b0;
							hash_ivalid4	=	1'b0;	
						end
	MATCH_END	:	begin	
							hash_clean		=	1'b0;
							hash_wr_only	=	1'b0;
							hash_iaddr1		=	32'b0; 		
							hash_idata1		=	32'b0;
							hash_ivalid1	=	1'b0;	
							hash_iaddr2		=	32'b0; 		
							hash_idata2		=	32'b0;
							hash_ivalid2	=	1'b0;	
							hash_iaddr3		=	32'b0; 		
							hash_idata3		=	32'b0;
							hash_ivalid3	=	1'b0;	
							hash_iaddr4		=	32'b0; 		
							hash_idata4		=	32'b0;
							hash_ivalid4	=	1'b0;	
						end		
	ENCODE_START:	begin	
							hash_clean		=	1'b0;
							hash_wr_only	=	1'b0;
							hash_iaddr1		=	32'b0; 		
							hash_idata1		=	32'b0;
							hash_ivalid1	=	1'b0;	
							hash_iaddr2		=	32'b0; 		
							hash_idata2		=	32'b0;
							hash_ivalid2	=	1'b0;	
							hash_iaddr3		=	32'b0; 		
							hash_idata3		=	32'b0;
							hash_ivalid3	=	1'b0;	
							hash_iaddr4		=	32'b0; 		
							hash_idata4		=	32'b0;
							hash_ivalid4	=	1'b0;	
						end	
	ENCODE_WAIT	:	begin	
							hash_clean		=	1'b0;
							hash_wr_only	=	1'b0;
							hash_iaddr1		=	32'b0; 		
							hash_idata1		=	32'b0;
							hash_ivalid1	=	1'b0;	
							hash_iaddr2		=	32'b0; 		
							hash_idata2		=	32'b0;
							hash_ivalid2	=	1'b0;	
							hash_iaddr3		=	32'b0; 		
							hash_idata3		=	32'b0;
							hash_ivalid3	=	1'b0;	
							hash_iaddr4		=	32'b0; 		
							hash_idata4		=	32'b0;
							hash_ivalid4	=	1'b0;	
						end
	STOP			:	begin	
							hash_clean		=	1'b1;
							hash_wr_only	=	1'b0;
							hash_iaddr1		=	32'b0; 		
							hash_idata1		=	32'b0;
							hash_ivalid1	=	1'b0;	
							hash_iaddr2		=	32'b0; 		
							hash_idata2		=	32'b0;
							hash_ivalid2	=	1'b0;	
							hash_iaddr3		=	32'b0; 		
							hash_idata3		=	32'b0;
							hash_ivalid3	=	1'b0;	
							hash_iaddr4		=	32'b0; 		
							hash_idata4		=	32'b0;
							hash_ivalid4	=	1'b0;	
						end
	default		:	begin	
							hash_clean		=	1'b0;
							hash_wr_only	=	1'b0;
							hash_iaddr1		=	32'b0; 		
							hash_idata1		=	32'b0;
							hash_ivalid1	=	1'b0;	
							hash_iaddr2		=	32'b0; 		
							hash_idata2		=	32'b0;
							hash_ivalid2	=	1'b0;	
							hash_iaddr3		=	32'b0; 		
							hash_idata3		=	32'b0;
							hash_ivalid3	=	1'b0;	
							hash_iaddr4		=	32'b0; 		
							hash_idata4		=	32'b0;
							hash_ivalid4	=	1'b0;	
						end
	endcase
end

// Combination Logic for external others module control signal
always @ (*)
begin
	case(current_state)
	IDLE 			:	begin
							dict_abs_addr			=	32'b0;
							dict_rd					=	1'b0;	
							move_dist				=	3'b0;
							move_valid				=	1'b0;
							rd_data_en				=	1'b0;
							shift_dist				=	3'b0;
							shift_en					=	1'b0;
							prefetch					=	1'b0;
							byte4_en					=	1'b0;
							unmatch_data			=	32'b0;
							unmatch_dvalid			=	1'b0;
							unmatch_length_incr	=	3'b0;
							encode_en				=	1'b0;
							wait_encode				=	1'b0;
						end
	WAIT_UNBUSY	:	begin
							dict_abs_addr			=	32'b0;
							dict_rd					=	1'b0;	
							move_dist				=	3'b0;
							move_valid				=	1'b0;
							rd_data_en				=	1'b0;
							shift_dist				=	3'b0;
							shift_en					=	1'b0;
							prefetch					=	1'b0;
							byte4_en					=	1'b0;
							unmatch_data			=	32'b0;
							unmatch_dvalid			=	1'b0;
							unmatch_length_incr	=	3'b0;
							encode_en				=	1'b0;
							wait_encode				=	1'b0;
						end
	PROC_START	:	begin	
							dict_abs_addr			=	32'b0;
							dict_rd					=	1'b0;	
							move_dist				=	3'b0;
							move_valid				=	1'b0;
							rd_data_en				=	1'b0;
							shift_dist				=	3'b0;
							shift_en					=	1'b0;
							prefetch					=	1'b0;
							byte4_en					=	1'b1;
							unmatch_data			=	32'b0;
							unmatch_dvalid			=	1'b0;
							unmatch_length_incr	=	3'b0;
							encode_en				=	1'b0;
							wait_encode				=	1'b0;
						end 		
	READ_BYTES	:	begin	
							dict_abs_addr			=	32'b0;
							dict_rd					=	1'b0;
							move_dist				=	3'h4;
							move_valid				=	1'b1;
							rd_data_en				=	1'b1;
							shift_dist				=	3'b0;	
							shift_en					=	1'b0;	
							prefetch					=	1'b0;
							byte4_en					=	1'b1;
							unmatch_data			=	32'b0;
							unmatch_dvalid			=	1'b0;
							unmatch_length_incr	=	3'b0;
							encode_en				=	encode_en_reg;
							wait_encode				=	1'b0;
						end
	WAIT_SVALID	:	begin
							dict_abs_addr	=	32'b0;
							dict_rd			=	1'b0;	
							move_dist		=	3'b0;
							move_valid		=	1'b0;
							rd_data_en		=	1'b0;
							prefetch			=	1'b0;
							encode_en		=	encode_en_reg;
							wait_encode				=	1'b0;
							if(byte4_valid)
							begin
								shift_dist	=	3'h4;	
								shift_en		=	1'b1;	
							end
							else
							begin
								shift_dist	=	3'b0;
								shift_en		=	1'b0;
							end
							byte4_en			=	1'b1;
							if(last_5bytes || last_seg_en)
							begin
								unmatch_data			=	byte4_data1;
								unmatch_dvalid			=	1'b1;
								if(last_incr >= 32'h4)
									unmatch_length_incr	=	3'h4;
								else
									unmatch_length_incr	=	last_incr;
							end
							else
							begin
								unmatch_data			=	32'b0;
								unmatch_dvalid			=	1'b0;
								unmatch_length_incr	=	3'b0;
							end
						end
	UPDATE_HASH	:	begin	
							dict_abs_addr			=	32'b0;
							dict_rd					=	1'b0;	
							move_dist				=	3'b0;
							move_valid				=	1'b0;
							rd_data_en				=	1'b0;
							shift_dist				=	3'b0;
							shift_en					=	1'b0;
							prefetch					=	1'b0;
							byte4_en					=	1'b1;
							unmatch_data			=	32'b0;
							unmatch_dvalid			=	1'b0;
							unmatch_length_incr	=	3'b0;
							encode_en				=	encode_en_reg;
							wait_encode				=	1'b0;
						end	
	WAIT_HASH	:	begin
							dict_abs_addr	=	32'b0;
							dict_rd			=	1'b0;	
							rd_data_en		=	1'b0;
							byte4_en			=	1'b1;
							encode_en		=	encode_en_reg;
							wait_encode				=	1'b0;
							if(hash_ovalid)
							begin
								if(!hash_hit)
								begin
									unmatch_data			=	byte4_data1_reg;
									unmatch_dvalid			=	1'b1;
									move_dist				=	3'b0;
									move_valid				=	1'b0;
									shift_dist				=	3'b0;
									shift_en					=	1'b0;
									prefetch					=	1'b0;
									unmatch_length_incr	=	3'h4;
								end
								else if((hit_dist > 32'hFFFF) && hash_hit)
								begin
									unmatch_data			=	byte4_data1_reg;
									unmatch_dvalid			=	1'b1;
									move_dist				=	3'b0;
									move_valid				=	1'b0;
									shift_dist				=	3'b0;
									shift_en					=	1'b0;
									prefetch					=	1'b0;
									unmatch_length_incr	=	3'h4;
								end
								else
								begin
									if(hit_status == 3'b0)
									begin
										unmatch_data			=	32'b0;
										unmatch_dvalid			=	1'b0;
										unmatch_length_incr	=	3'b0;
									end
									else
									begin
										unmatch_data			=	byte4_data1_reg;
										unmatch_dvalid			=	1'b1;
										unmatch_length_incr	=	hit_status;
									end
									move_dist		=	hit_status;
									move_valid		=	1'b1;
									shift_dist		=	hit_status;
									shift_en			=	1'b1;
									prefetch			=	1'b1;
								end
							end
							else
							begin
								unmatch_data			=	32'b0;
								unmatch_dvalid			=	1'b0;
								move_dist				=	3'b0;
								move_valid				=	1'b0;
								shift_dist				=	3'b0;
								shift_en					=	1'b0;
								prefetch					=	1'b0;
								unmatch_length_incr	=	3'b0;
							end
						end
	MATCH_STANDBY:	begin
							dict_abs_addr			=	match_addr;
							dict_rd					=	1'b1;	
							move_dist				=	3'b0;
							move_valid				=	1'b0;
							rd_data_en				=	1'b0;
							shift_dist				=	3'b0;
							shift_en					=	1'b0;
							prefetch					=	1'b0;
							byte4_en					=	1'b1;
							unmatch_data			=	32'b0;
							unmatch_dvalid			=	1'b0;
							unmatch_length_incr	=	3'b0;
							encode_en				=	encode_en_reg;
							wait_encode				=	1'b0;
						end
	MATCH_START	:	begin	
							dict_abs_addr			=	match_addr;
							dict_rd					=	1'b1;	
							move_dist				=	3'b0;
							shift_dist				=	3'b0;
							move_valid				=	1'b1;
							rd_data_en				=	1'b1;
							shift_en					=	1'b0;
							prefetch					=	1'b0;
							byte4_en					=	1'b1;
							unmatch_data			=	32'b0;
							unmatch_dvalid			=	1'b0;
							unmatch_length_incr	=	3'b0;
							encode_en				=	encode_en_reg;
							wait_encode				=	1'b0;
						end		
	MATCHING		:	begin
							if(match_goon)
							begin
								move_dist	=	3'h4;
								shift_dist	=	3'h4;
							end
							else
							begin
								move_dist	=	match_mask;
								shift_dist	=	match_mask;
							end
							move_valid		=	1'b1;
							shift_en			=	1'b1;
							prefetch			=	1'b0;
							if(file_len_cnt < (file_len_reg - 32'd5))
							begin
								if(match_goon && (!over_band))
								begin
									rd_data_en		=	1'b1;
									dict_rd			=	1'b1;
								end
								else
								begin
									rd_data_en		=	1'b0;
									dict_rd			=	1'b0;
								end
								dict_abs_addr	=	match_addr;
							end
							else
							begin
								rd_data_en		=	1'b0;
								dict_rd			=	1'b0;
								dict_abs_addr	=	32'b0;
							end
							byte4_en					=	1'b1;
							unmatch_data			=	32'b0;
							unmatch_dvalid			=	1'b0;
							unmatch_length_incr	=	3'b0;
							encode_en				=	encode_en_reg;
							wait_encode				=	1'b0;
						end			
	WAIT_FIFO	:	begin	
							if((!over_band) && (!byte4_busy))	//	((fifo_count >= 15'h1) && (!over_band))
							begin
								dict_abs_addr	=	match_addr;
								dict_rd			=	1'b1;	
								if(match_addr[1:0] == 2'b0)
								begin
									rd_data_en	=	1'b1;
									prefetch		=	1'b1;
								end
								else
								begin
									rd_data_en	=	1'b0;
									prefetch		=	1'b0;
								end
							end
							else
							begin
								dict_abs_addr	=	32'b0;
								dict_rd			=	1'b0;	
								rd_data_en		=	1'b0;
								prefetch			=	1'b0;
							end
							move_dist				=	3'b0;
							move_valid				=	1'b0;
							shift_dist				=	3'b0;
							shift_en					=	1'b0;
							byte4_en					=	1'b1;
							unmatch_data			=	32'b0;
							unmatch_dvalid			=	1'b0;
							unmatch_length_incr	=	3'b0;
							encode_en				=	encode_en_reg;
							wait_encode				=	1'b0;
						end		
	MATCH_RECV	:	begin
							dict_abs_addr			=	match_addr;
							dict_rd					=	1'b1;	
							move_dist				=	3'b0;
							move_valid				=	1'b0;
							rd_data_en				=	1'b1;
							shift_dist				=	3'b0;
							shift_en					=	1'b0;
							prefetch					=	1'b0;
							byte4_en					=	1'b1;
							unmatch_data			=	32'b0;
							unmatch_dvalid			=	1'b0;
							unmatch_length_incr	=	3'b0;
							encode_en				=	encode_en_reg;
							wait_encode				=	1'b0;
						end
	MATCH_END	:	begin	
							dict_abs_addr			=	32'b0;
							dict_rd					=	1'b0;
							move_dist				=	3'b0;
							move_valid				=	1'b0;
							rd_data_en				=	1'b0;
							shift_dist				=	3'b0;
							shift_en					=	1'b0;
							prefetch					=	1'b0;
							byte4_en					=	1'b1;
							unmatch_data			=	32'b0;
							unmatch_dvalid			=	1'b0;
							unmatch_length_incr	=	3'b0;
							encode_en				=	encode_en_reg;
							wait_encode				=	1'b0;
						end		
	ENCODE_START:	begin	
							dict_abs_addr			=	32'b0;
							dict_rd					=	1'b0;		
							move_dist				=	3'b0;
							move_valid				=	1'b0;
							rd_data_en				=	1'b0;
							shift_dist				=	3'b0;
							shift_en					=	1'b0;
							prefetch					=	1'b0;
							byte4_en					=	1'b1;
							unmatch_data			=	32'b0;
							unmatch_dvalid			=	1'b0;
							unmatch_length_incr	=	3'b0;
							encode_en				=	1'b1;
							if(file_len_cnt >= file_len_reg)
								wait_encode			=	1'b1;
							else
								wait_encode			=	1'b0;
						end	
	ENCODE_WAIT	:	begin	
							dict_abs_addr			=	32'b0;
							dict_rd					=	1'b0;	
							move_dist				=	3'b0;
							move_valid				=	1'b0;
							rd_data_en				=	1'b0;
							shift_dist				=	3'b0;
							shift_en					=	1'b0;
							prefetch					=	1'b0;
							byte4_en					=	1'b1;
							unmatch_data			=	32'b0;
							unmatch_dvalid			=	1'b0;
							unmatch_length_incr	=	3'b0;
							encode_en				=	1'b1;
							wait_encode				=	1'b1;
						end
	STOP			:	begin	
							dict_abs_addr			=	32'b0;
							dict_rd					=	1'b0;	
							move_dist				=	3'b0;
							move_valid				=	1'b0;
							rd_data_en				=	1'b0;
							shift_dist				=	3'b0;
							shift_en					=	1'b0;
							prefetch					=	1'b0;
							byte4_en					=	1'b0;
							unmatch_data			=	32'b0;
							unmatch_dvalid			=	1'b0;
							unmatch_length_incr	=	3'b0;
							encode_en				=	1'b0;
							wait_encode				=	1'b0;
						end
	default		:	begin	
							dict_abs_addr			=	32'b0;
							dict_rd					=	1'b0;	
							move_dist				=	3'b0;
							move_valid				=	1'b0;
							rd_data_en				=	1'b0;
							shift_dist				=	3'b0;
							shift_en					=	1'b0;
							prefetch					=	1'b0;
							byte4_en					=	1'b0;
							unmatch_data			=	32'b0;
							unmatch_dvalid			=	1'b0;
							unmatch_length_incr	=	3'b0;
							encode_en				=	1'b0;
							wait_encode				=	1'b0;
						end
	endcase
end


endmodule
