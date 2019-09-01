`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:49:24 02/01/2016 
// Design Name: 
// Module Name:    xxh32_calc 
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
module xxh32_calc(
// global clock and reset signal
input	wire				clk,
input wire				rstN,
// data stream and data length information
input wire				compress_start,
input wire				compress_done,
input wire	[31:0]	length,
input wire				length_valid,
input wire	[31:0]	data,
input wire				data_valid,
// output 32bit calc value
output reg	[31:0]	digest,
output reg				digest_valid
);

//////////// Constants of calc /////////////
parameter		PRIME32_1  = 32'd2654435761;
parameter		PRIME32_2  = 32'd2246822519;
parameter		PRIME32_3  = 32'd3266489917;
parameter		PRIME32_4  = 32'd668265263;
parameter		PRIME32_5  = 32'd374761393;
////////////////////////////////////////////

//////////////// FSM status ////////////////
parameter		IDLE					=	4'h0	;
parameter		XXH32_RESET			=	4'h1	;
parameter		XXH32_UPDATE_WAIT	=	4'h2	;
parameter		XXH32_UPDATE		=	4'h3	;
parameter		XXH32_UPDATE_END	=	4'h4	;
parameter		XXH32_DIGEST_WAIT	=	4'h5	;
parameter		XXH32_DIGEST_INIT	=	4'h6	;
parameter		XXH32_DIGEST_DW	=	4'h7	;
parameter		XXH32_DIGEST_BYTE	=	4'h8	;
parameter		XXH32_DIGEST_END1	=	4'h9	;
parameter		XXH32_DIGEST_END2	=	4'hA	;
parameter		XXH32_DONE			=	4'hB	;
////////////////////////////////////////////
// FSM status
reg	[3:0]		current_state,next_state;
// state structure
reg	[31:0]	state_v1,state_v2,state_v3,state_v4;
reg	[31:0]	temp_v1,temp_v2,temp_v3,temp_v4;
reg				v1_valid,v2_valid,v3_valid,v4_valid;
// multiplier signal
wire	[31:0]	mul_vi;
reg	[31:0]	digest_temp;
wire	[63:0]	mul_vi_temp,mul_digest,update_vi_temp;
wire	[31:0]	update_coe1,update_coe2;
wire	[31:0]	digest_coe;
reg	[31:0]	update_temp;
wire	[31:0]	update_vi;
wire	[31:0]	mul_data;
// compress_start signal posedge detect
reg				compress_start_d1;
// 32bit data remain counter
reg	[31:0]	proc_cnt;
// update vi state counter
reg	[1:0]		vi_cnt,vi_cnt_d1;
reg				vi_updating;
// digest value
reg	[31:0]	h32,h32_reg;
reg				h32_valid;
// total length
wire	[31:0]	total_length;
reg	[31:0]	length_reg;
// digest initial signal
reg				digest_init;
reg				digest_init_done;
// digest prime coe select
reg				final4byte;
reg				dword_digest,byte_digest;
// digest remaining bytes shifter
reg	[31:0]	shifter;
reg	[1:0]		shift_cnt;
reg				shift_en;
// input data delay
reg	[31:0]	data_d1;
reg				data_valid_d1;
// end status signal
reg				end1,end2;
// fifo signal
wire				fifo_wr,fifo_valid,fifo_empty;
reg				fifo_rd;
wire	[31:0]	fifo_data;
wire	[3:0]		data_count;
reg				fifo_wait,fifo_wait_d1,fifo_wait_en;
// update end
reg				update_end;
// previous status for digest end stage 1
reg	[1:0]		prev_proc;  // 00,11	:	no dword or byte digest process
									//	01    :	previous status is dword digest process
									// 10		:	previous status is byte digest process
reg				dword_proc,byte_proc;

/////////////////////////////////////////////////
////			Dividual Combination Logic 		////
/////////////////////////////////////////////////
// ROTL32(data,13) logic
function	[31:0] ROTL32_13;
	input	[31:0] data_in;
	ROTL32_13	=	(data_in << 13) | (data_in >> 19);
endfunction

// ROTL32(data,1) logic
function	[31:0] ROTL32_1;
	input	[31:0] data_in;
	ROTL32_1	=	(data_in << 1) | (data_in >> 31);
endfunction

// ROTL32(data,7) logic
function	[31:0] ROTL32_7;
	input	[31:0] data_in;
	ROTL32_7	=	(data_in << 7) | (data_in >> 25);
endfunction

// ROTL32(data,12) logic
function	[31:0] ROTL32_12;
	input	[31:0] data_in;
	ROTL32_12	=	(data_in << 12) | (data_in >> 20);
endfunction

// ROTL32(data,18) logic
function	[31:0] ROTL32_18;
	input	[31:0] data_in;
	ROTL32_18	=	(data_in << 18) | (data_in >> 14);
endfunction

// ROTL32(data,17) logic
function	[31:0] ROTL32_17;
	input	[31:0] data_in;
	ROTL32_17	=	(data_in << 17) | (data_in >> 15);
endfunction

// ROTL32(data,11) logic
function	[31:0] ROTL32_11;
	input	[31:0] data_in;
	ROTL32_11	=	(data_in << 11) | (data_in >> 21);
endfunction

// COMPLEMENT logic
function	[31:0] COMPLEMENT32;
	input	[31:0] data_in;
	COMPLEMENT32	=	(~data_in) + 32'h1;
endfunction

// multiplier coeffection
assign		update_coe1	=	(data_valid&&(!dword_digest)) ? PRIME32_2 : (dword_digest ?  PRIME32_3 : PRIME32_5);
assign		update_coe2	=	vi_updating ? PRIME32_1 : 32'b0;
assign		digest_coe	=	end1 ? PRIME32_2 : (end2 ? PRIME32_3 : (final4byte ? PRIME32_1 : PRIME32_4));

// multiplier data cut
assign		mul_vi	=	mul_vi_temp[31:0];
assign		update_vi=	update_vi_temp[31:0];
//assign		mul_data	=	fifo_valid ? fifo_data : (byte_digest ? {shifter[31:24],24'b0} : data);
assign		mul_data	=	byte_digest ? {shifter[31:24],24'b0} : (fifo_valid ? fifo_data : data);
// total length calculation
assign		total_length	=	length_reg;

// fifo signal
assign		fifo_wr		=	update_end & data_valid_d1;
assign		fifo_empty	=	(data_count>4'b0) ? 1'b0 : 1'b1;

/////////////////////////////////////////////////
////				 Sequential Logic 				////
/////////////////////////////////////////////////
// FSM transfer Logic
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

// state_vi update
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		state_v1	<=	32'b0;
		state_v2	<=	32'b0;
		state_v3	<=	32'b0;
		state_v4	<=	32'b0;
	end
	else
	begin
		if(v1_valid)
			state_v1	<=	temp_v1;
		else
			state_v1	<=	state_v1;
		
		if(v2_valid)
			state_v2	<=	temp_v2;
		else
			state_v2	<=	state_v2;
			
		if(v3_valid)
			state_v3	<=	temp_v3;
		else
			state_v3	<=	state_v3;
			
		if(v4_valid)
			state_v4	<=	temp_v4;
		else
			state_v4	<=	state_v4;
	end
end

// 32bit data input counter
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		proc_cnt		<=	32'b0;
		length_reg	<=	32'b0;
	end
	else
	begin
		if(length_valid)
		begin
			proc_cnt		<=	32'b0;
			length_reg	<=	length;
		end
		else if(vi_updating)	//	(data_valid && vi_updating)	//	
		begin
			proc_cnt		<=	proc_cnt + 32'd4;
			length_reg	<=	length_reg;
		end
		else if(fifo_valid && (proc_cnt<=(length_reg - 4'h4)))
		begin
			proc_cnt		<=	proc_cnt + 32'd4;
			length_reg	<=	length_reg;
		end	
		else if(shift_en)
		begin
			proc_cnt		<=	proc_cnt + 32'd1;
			length_reg	<=	length_reg;
		end
		else
		begin
			proc_cnt		<=	proc_cnt;
			length_reg	<=	length_reg;
		end
	end
end

// update vi state counter
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		vi_cnt	<=	2'b0;
		vi_cnt_d1<=	2'b0;
	end
	else
	begin
		vi_cnt_d1	<=	vi_cnt;
		if(vi_updating)
			vi_cnt	<=	vi_cnt + 1'b1;
		else
			vi_cnt	<=	vi_cnt;
	end
end

// digest h32 register
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		h32_reg	<=	32'b0;
	end
	else
	begin
		if(h32_valid)
			h32_reg	<=	h32;
		else
			h32_reg	<=	h32_reg;
	end
end

// input data delay
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		data_d1			<=	32'b0;
		data_valid_d1	<=	1'b0;
	end
	else
	begin
		data_valid_d1	<=	data_valid;
		if(data_valid)
			data_d1	<=	data;
		else
			data_d1	<=	data_d1;
	end
end

// digest remaining bytes shifter
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		shift_cnt	<=	2'b0;
		shifter		<=	32'b0;
	end
	else
	begin
		if(data_valid_d1)
		begin
			shift_cnt	<=	2'b0;
			shifter		<=	data_d1;
		end
		else if(shift_en)
		begin
			shift_cnt	<=	shift_cnt + 1'b1;
			shifter		<=	{shifter[23:0],shifter[31:24]};
		end
		else
		begin
			shift_cnt	<=	shift_cnt;
			shifter		<=	shifter;
		end
	end
end

// digest initial signal
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		digest_init_done	<=	1'b0;
	end
	else
	begin
		if(digest_init)
			digest_init_done	<=	1'b1;
		else
			digest_init_done	<=	digest_init_done;
	end
end

// previous status for digest end stage 1
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		prev_proc	<=	2'b0;
	end
	else
	begin
		if(dword_proc)
			prev_proc	<=	2'b01;
		else if(byte_proc)
			prev_proc	<=	2'b10;
		else
			prev_proc	<=	prev_proc;
	end
end

// fifo wait signal
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		fifo_wait	<=	1'b0;
		fifo_wait_d1<=	1'b0;
	end
	else
	begin
		fifo_wait_d1	<=	fifo_wait_en;
		if(fifo_wait_d1)
			fifo_wait	<=	1'b1;
		else
			fifo_wait	<=	1'b0;
	end
end

/////////////////////////////////////////////////
////				Combination Logic 			   ////
/////////////////////////////////////////////////
// FSM transfer Logic
always@ (*)
begin
	case(current_state)
	IDLE					:	begin
									if({compress_start_d1,compress_start}==2'b01)
										next_state	=	XXH32_RESET;
									else
										next_state	=	IDLE;
								end
	XXH32_RESET			:	begin
									if(data_valid)
										next_state	=	XXH32_UPDATE;
									else
										next_state	=	XXH32_UPDATE_WAIT;
								end
	XXH32_UPDATE_WAIT	:	begin
									if(data_valid)
										next_state	=	XXH32_UPDATE;
									else
										next_state	=	XXH32_UPDATE_WAIT;
								end
	XXH32_UPDATE		:	begin
									if(data_valid)
									begin
										if((proc_cnt>=(length_reg - 32'd20))&&(vi_cnt==2'b11))
											next_state	=	XXH32_UPDATE_END;
										else
											next_state	=	XXH32_UPDATE;
									end
									else
									begin
										if((proc_cnt>=(length_reg - 32'd20))&&(vi_cnt==2'b11))
											next_state	=	XXH32_UPDATE_END;
										else
											next_state	=	XXH32_UPDATE_WAIT;
									end
								end
	XXH32_UPDATE_END	:	begin
									if(fifo_empty && (proc_cnt<(length_reg - 4'h4)))  // (fifo_empty && (proc_cnt<length_reg))
										next_state	=	XXH32_DIGEST_WAIT;
									else
										next_state	=	XXH32_DIGEST_INIT;
								end
	XXH32_DIGEST_WAIT	:	begin
									if(!fifo_empty) // (data_valid)
									begin
										if(!digest_init_done)
											next_state	=	XXH32_DIGEST_INIT;
										else if(proc_cnt <= (length_reg - 32'd4))
											next_state	=	XXH32_DIGEST_DW;
										else
											next_state	=	XXH32_DIGEST_BYTE;
									end
									else
									begin
										next_state	=	XXH32_DIGEST_WAIT;
									end
								end
	XXH32_DIGEST_INIT	:	begin
									if(!fifo_empty) // (data_valid||data_valid_d1)
									begin
										if(proc_cnt <= (length_reg - 32'd4))
											next_state	=	XXH32_DIGEST_DW;
										else
											next_state	=	XXH32_DIGEST_BYTE;
									end
									else if(proc_cnt > (length_reg - 32'd4))  // length_reg
										next_state	=	XXH32_DIGEST_END1;
									else
										next_state	=	XXH32_DIGEST_WAIT;
								end
	XXH32_DIGEST_DW	:	begin
									if(proc_cnt >= length_reg)
									begin
										next_state	=	XXH32_DIGEST_END1;
									end
									else if(proc_cnt <= (length_reg - 32'd4))
									begin
										if(!fifo_empty)
											next_state	=	XXH32_DIGEST_DW;
										else
											next_state	=	XXH32_DIGEST_WAIT;
									end
									else
									begin
										if(!fifo_empty)
											next_state	=	XXH32_DIGEST_BYTE;
										else
											next_state	=	XXH32_DIGEST_WAIT;
									end
								end
	XXH32_DIGEST_BYTE	:	begin
									if(proc_cnt < length_reg)
										next_state	=	XXH32_DIGEST_BYTE;
									else
										next_state	=	XXH32_DIGEST_END1;
								end
	XXH32_DIGEST_END1	:	begin
									next_state	=	XXH32_DIGEST_END2;
								end
	XXH32_DIGEST_END2	:	begin
									next_state	=	XXH32_DONE;
								end
	XXH32_DONE			:	begin
									next_state	=	IDLE;
								end			
	default				:	begin
									next_state	=	IDLE;
								end
	endcase
end

// FSM output Logic
always@ (*)
begin
	case(current_state)
	IDLE					:	begin
									temp_v1		=	32'b0;
									temp_v2		=	32'b0;
									temp_v3		=	32'b0;
									temp_v4		=	32'b0;
									v1_valid		=	1'b0;
									v2_valid		=	1'b0;
									v3_valid		=	1'b0;
									v4_valid		=	1'b0;
									update_temp	=	32'b0;
									vi_updating	=	1'b0;
									update_end	=	1'b0;
									fifo_rd		=	1'b0;
									h32			=	32'b0;
									h32_valid	=	1'b0;
									final4byte	=	1'b0;
									digest_temp	=	32'b0;
									digest_init	=	1'b0;
									dword_digest=	1'b0;
									byte_digest	=	1'b0;
									shift_en		=	1'b0;
									end1			=	1'b0;
									end2			=	1'b0;
									digest		=	32'b0;
									digest_valid=	1'b0;
									dword_proc	=	1'b0;
									byte_proc	=	1'b0;
									fifo_wait_en=	1'b0;
								end
	XXH32_RESET			:	begin
									temp_v1		=	PRIME32_1 + PRIME32_2;
									temp_v2		=	PRIME32_2;
									temp_v3		=	32'b0;
									temp_v4		=	COMPLEMENT32(PRIME32_1);
									v1_valid		=	1'b1;
									v2_valid		=	1'b1;
									v3_valid		=	1'b1;
									v4_valid		=	1'b1;
									update_temp	=	32'b0;
									vi_updating	=	1'b0;
									update_end	=	1'b0;
									fifo_rd		=	1'b0;
									h32			=	32'b0;
									h32_valid	=	1'b0;
									final4byte	=	1'b0;
									digest_temp	=	32'b0;
									digest_init	=	1'b0;
									dword_digest=	1'b0;
									byte_digest	=	1'b0;
									shift_en		=	1'b0;
									end1			=	1'b0;
									end2			=	1'b0;
									digest		=	32'b0;
									digest_valid=	1'b0;
									dword_proc	=	1'b0;
									byte_proc	=	1'b0;
									fifo_wait_en=	1'b0;
								end
	XXH32_UPDATE_WAIT	:	begin
									temp_v1		=	32'b0;
									temp_v2		=	32'b0;
									temp_v3		=	32'b0;
									temp_v4		=	32'b0;
									v1_valid		=	1'b0;
									v2_valid		=	1'b0;
									v3_valid		=	1'b0;
									v4_valid		=	1'b0;
									update_temp	=	32'b0;
									vi_updating	=	1'b0;
									update_end	=	1'b0;
									fifo_rd		=	1'b0;
									h32			=	32'b0;
									h32_valid	=	1'b0;
									final4byte	=	1'b0;
									digest_temp	=	32'b0;
									digest_init	=	1'b0;
									dword_digest=	1'b0;
									byte_digest	=	1'b0;
									shift_en		=	1'b0;
									end1			=	1'b0;
									end2			=	1'b0;
									digest		=	32'b0;
									digest_valid=	1'b0;
									dword_proc	=	1'b0;
									byte_proc	=	1'b0;
									fifo_wait_en=	1'b0;
								end
	XXH32_UPDATE		:	begin
									case(vi_cnt)
									2'b00		:	begin
														update_temp	=	ROTL32_13(mul_vi + state_v1);
													end
									2'b01		:	begin
														update_temp	=	ROTL32_13(mul_vi + state_v2);
													end
									2'b10		:	begin
														update_temp	=	ROTL32_13(mul_vi + state_v3);
													end
									2'b11		:	begin
														update_temp	=	ROTL32_13(mul_vi + state_v4);
													end
									default	:	begin
														update_temp	=	32'b0;
													end
									endcase
									case(vi_cnt_d1)
									2'b00		:	begin
														temp_v1	=	update_vi;
														temp_v2	=	32'b0;
														temp_v3	=	32'b0;
														temp_v4	=	32'b0;
														v1_valid	=	1'b1;
														v2_valid	=	1'b0;
														v3_valid	=	1'b0;
														v4_valid	=	1'b0;
													end
									2'b01		:	begin
														temp_v2	=	update_vi;
														temp_v1	=	32'b0;
														temp_v3	=	32'b0;
														temp_v4	=	32'b0;
														v1_valid	=	1'b0;
														v2_valid	=	1'b1;
														v3_valid	=	1'b0;
														v4_valid	=	1'b0;
													end
									2'b10		:	begin
														temp_v3	=	update_vi;
														temp_v1	=	32'b0;
														temp_v2	=	32'b0;
														temp_v4	=	32'b0;
														v1_valid	=	1'b0;
														v2_valid	=	1'b0;
														v3_valid	=	1'b1;
														v4_valid	=	1'b0;
													end
									2'b11		:	begin
														temp_v4	=	update_vi;
														temp_v1	=	32'b0;
														temp_v2	=	32'b0;
														temp_v3	=	32'b0;
														v1_valid	=	1'b0;
														v2_valid	=	1'b0;
														v3_valid	=	1'b0;
														v4_valid	=	1'b1;
													end
									default	:	begin
														temp_v1	=	32'b0;
														temp_v2	=	32'b0;
														temp_v3	=	32'b0;
														temp_v4	=	32'b0;
														v1_valid	=	1'b0;
														v2_valid	=	1'b0;
														v3_valid	=	1'b0;
														v4_valid	=	1'b0;
													end
									endcase
									vi_updating	=	1'b1;
									update_end	=	1'b0;
									fifo_rd		=	1'b0;
									h32			=	32'b0;
									h32_valid	=	1'b0;
									final4byte	=	1'b0;
									digest_temp	=	32'b0;
									digest_init	=	1'b0;
									dword_digest=	1'b0;
									byte_digest	=	1'b0;
									shift_en		=	1'b0;
									end1			=	1'b0;
									end2			=	1'b0;
									digest		=	32'b0;
									digest_valid=	1'b0;
									dword_proc	=	1'b0;
									byte_proc	=	1'b0;
									fifo_wait_en=	1'b0;
								end
	XXH32_UPDATE_END	:	begin
									case(vi_cnt)
									2'b00		:	begin
														update_temp	=	ROTL32_13(mul_vi + state_v1);
													end
									2'b01		:	begin
														update_temp	=	ROTL32_13(mul_vi + state_v2);
													end
									2'b10		:	begin
														update_temp	=	ROTL32_13(mul_vi + state_v3);
													end
									2'b11		:	begin
														update_temp	=	ROTL32_13(mul_vi + state_v4);
													end
									default	:	begin
														update_temp	=	32'b0;
													end
									endcase
									case(vi_cnt_d1)
									2'b00		:	begin
														temp_v1	=	update_vi;
														temp_v2	=	32'b0;
														temp_v3	=	32'b0;
														temp_v4	=	32'b0;
														v1_valid	=	1'b1;
														v2_valid	=	1'b0;
														v3_valid	=	1'b0;
														v4_valid	=	1'b0;
													end
									2'b01		:	begin
														temp_v2	=	update_vi;
														temp_v1	=	32'b0;
														temp_v3	=	32'b0;
														temp_v4	=	32'b0;
														v1_valid	=	1'b0;
														v2_valid	=	1'b1;
														v3_valid	=	1'b0;
														v4_valid	=	1'b0;
													end
									2'b10		:	begin
														temp_v3	=	update_vi;
														temp_v1	=	32'b0;
														temp_v2	=	32'b0;
														temp_v4	=	32'b0;
														v1_valid	=	1'b0;
														v2_valid	=	1'b0;
														v3_valid	=	1'b1;
														v4_valid	=	1'b0;
													end
									2'b11		:	begin
														temp_v4	=	update_vi;
														temp_v1	=	32'b0;
														temp_v2	=	32'b0;
														temp_v3	=	32'b0;
														v1_valid	=	1'b0;
														v2_valid	=	1'b0;
														v3_valid	=	1'b0;
														v4_valid	=	1'b1;
													end
									default	:	begin
														temp_v1	=	32'b0;
														temp_v2	=	32'b0;
														temp_v3	=	32'b0;
														temp_v4	=	32'b0;
														v1_valid	=	1'b0;
														v2_valid	=	1'b0;
														v3_valid	=	1'b0;
														v4_valid	=	1'b0;
													end
									endcase
									vi_updating	=	1'b0;
									update_end	=	1'b1;
									dword_digest=	1'b1;
									if(!fifo_empty)
										fifo_rd		=	1'b1;
									else
										fifo_rd		=	1'b0;
									h32			=	32'b0;
									h32_valid	=	1'b0;
									final4byte	=	1'b0;
									digest_temp	=	32'b0;
									digest_init	=	1'b0;
									byte_digest	=	1'b0;
									shift_en		=	1'b0;
									end1			=	1'b0;
									end2			=	1'b0;
									digest		=	32'b0;
									digest_valid=	1'b0;
									dword_proc	=	1'b0;
									byte_proc	=	1'b0;
									fifo_wait_en=	1'b0;
								end
	XXH32_DIGEST_WAIT	:	begin
									temp_v1		=	32'b0;
									temp_v2		=	32'b0;
									temp_v3		=	32'b0;
									temp_v4		=	32'b0;
									v1_valid		=	1'b0;
									v2_valid		=	1'b0;
									v3_valid		=	1'b0;
									v4_valid		=	1'b0;
									update_temp	=	32'b0;
									vi_updating	=	1'b0;
									update_end	=	1'b1;
									if(!fifo_empty)
										fifo_rd	=	1'b1;
									else
										fifo_rd	=	1'b0;
									h32			=	32'b0;
									h32_valid	=	1'b0;
									final4byte	=	1'b0;
									digest_temp	=	32'b0;
									digest_init	=	1'b0;
									if(proc_cnt < (length_reg - 32'd4))
										dword_digest=	1'b1;
									else
										dword_digest=	1'b0;
									byte_digest	=	1'b0;
									shift_en		=	1'b0;
									end1			=	1'b0;
									end2			=	1'b0;
									digest		=	32'b0;
									digest_valid=	1'b0;
									dword_proc	=	1'b0;
									byte_proc	=	1'b0;
									fifo_wait_en=	1'b1;
								end
	XXH32_DIGEST_INIT	:	begin
									temp_v1		=	32'b0;
									temp_v2		=	32'b0;
									temp_v3		=	32'b0;
									temp_v4		=	32'b0;
									v1_valid		=	1'b0;
									v2_valid		=	1'b0;
									v3_valid		=	1'b0;
									v4_valid		=	1'b0;
									update_temp	=	32'b0;
									vi_updating	=	1'b0;
									update_end	=	1'b1;
									fifo_rd		=	1'b1;
									h32			=	ROTL32_1(state_v1) + ROTL32_7(state_v2) 
													 + ROTL32_12(state_v3) + ROTL32_18(state_v4) 
													 + total_length;
									h32_valid	=	1'b1;
									final4byte	=	1'b0;
									digest_temp	=	ROTL32_17(h32 + mul_vi);
									digest_init	=	1'b1;
									if((proc_cnt<=(length_reg-4'h4)))
									begin
										dword_digest=	1'b1;
										byte_digest	=	1'b0;
										shift_en		=	1'b0;
									end
									else
									begin
										dword_digest=	1'b0;
										byte_digest	=	1'b1;
										shift_en		=	1'b1;
									end
									end1			=	1'b0;
									end2			=	1'b0;
									digest		=	32'b0;
									digest_valid=	1'b0;
									dword_proc	=	1'b0;
									byte_proc	=	1'b0;
									fifo_wait_en=	1'b0;
								end
	XXH32_DIGEST_DW	:	begin
									temp_v1		=	32'b0;
									temp_v2		=	32'b0;
									temp_v3		=	32'b0;
									temp_v4		=	32'b0;
									v1_valid		=	1'b0;
									v2_valid		=	1'b0;
									v3_valid		=	1'b0;
									v4_valid		=	1'b0;
									update_temp	=	32'b0;
									vi_updating	=	1'b0;
									update_end	=	1'b1;
									if(data_count <= 4'h1)
										fifo_rd	=	1'b0;
									else
										fifo_rd	=	1'b1;
									if(fifo_wait)
										h32		=	h32_reg + mul_vi;
									else
										h32		=	mul_digest[31:0] + mul_vi;
									h32_valid	=	1'b1;
									final4byte	=	1'b0;
									if((proc_cnt<length_reg)&&(proc_cnt>=(length_reg-32'd4)))
									begin
										shift_en		=	1'b1;
										dword_digest=	1'b0;
										byte_digest	=	1'b1;
									end
									else
									begin
										shift_en		=	1'b0;
										dword_digest=	1'b1;
										byte_digest	=	1'b0;
									end
									digest_temp	=	ROTL32_17(h32);
									digest_init	=	1'b0;
									end1			=	1'b0;
									end2			=	1'b0;
									digest		=	32'b0;
									digest_valid=	1'b0;
									dword_proc	=	1'b1;
									byte_proc	=	1'b0;
									fifo_wait_en=	1'b0;
								end
	XXH32_DIGEST_BYTE	:	begin
									temp_v1		=	32'b0;
									temp_v2		=	32'b0;
									temp_v3		=	32'b0;
									temp_v4		=	32'b0;
									v1_valid		=	1'b0;
									v2_valid		=	1'b0;
									v3_valid		=	1'b0;
									v4_valid		=	1'b0;
									update_temp	=	32'b0;
									vi_updating	=	1'b0;
									update_end	=	1'b1;
									fifo_rd		=	1'b0;
									if((prev_proc == 2'b01)||(prev_proc == 2'b10))
										h32		=	mul_digest[31:0] + mul_vi;
									else
										h32		=	h32_reg + mul_vi;
									h32_valid	=	1'b1;
									final4byte	=	1'b1;
									digest_temp	=	ROTL32_11(h32);
									digest_init	=	1'b0;
									dword_digest=	1'b0;
									byte_digest	=	1'b1;
									shift_en		=	1'b1;
									end1			=	1'b0;
									end2			=	1'b0;
									digest		=	32'b0;
									digest_valid=	1'b0;
									dword_proc	=	1'b0;
									byte_proc	=	1'b1;
									fifo_wait_en=	1'b0;
								end
	XXH32_DIGEST_END1	:	begin
									temp_v1		=	32'b0;
									temp_v2		=	32'b0;
									temp_v3		=	32'b0;
									temp_v4		=	32'b0;
									v1_valid		=	1'b0;
									v2_valid		=	1'b0;
									v3_valid		=	1'b0;
									v4_valid		=	1'b0;
									update_temp	=	32'b0;
									vi_updating	=	1'b0;
									update_end	=	1'b1;
									fifo_rd		=	1'b0;
									if((prev_proc == 2'b01)||(prev_proc == 2'b10))
										h32		=	mul_digest[31:0] ^ (mul_digest[31:0]>>15);
									else
										h32		=	h32_reg ^ (h32_reg>>15);
									h32_valid	=	1'b1;
									final4byte	=	1'b0;
									digest_temp	=	h32;
									digest_init	=	1'b0;
									dword_digest=	1'b0;
									byte_digest	=	1'b0;
									shift_en		=	1'b0;
									end1			=	1'b1;
									end2			=	1'b0;
									digest		=	32'b0;
									digest_valid=	1'b0;
									dword_proc	=	1'b0;
									byte_proc	=	1'b0;
									fifo_wait_en=	1'b0;
								end
	XXH32_DIGEST_END2	:	begin
									temp_v1		=	32'b0;
									temp_v2		=	32'b0;
									temp_v3		=	32'b0;
									temp_v4		=	32'b0;
									v1_valid		=	1'b0;
									v2_valid		=	1'b0;
									v3_valid		=	1'b0;
									v4_valid		=	1'b0;
									update_temp	=	32'b0;
									vi_updating	=	1'b0;
									update_end	=	1'b1;
									fifo_rd		=	1'b0;
									h32			=	mul_digest[31:0] ^ (mul_digest[31:0]>>13);
									h32_valid	=	1'b1;
									final4byte	=	1'b1;
									digest_temp	=	h32;
									digest_init	=	1'b0;
									dword_digest=	1'b0;
									byte_digest	=	1'b1;
									shift_en		=	1'b0;
									end1			=	1'b0;
									end2			=	1'b1;
									digest		=	32'b0;
									digest_valid=	1'b0;
									dword_proc	=	1'b0;
									byte_proc	=	1'b0;
									fifo_wait_en=	1'b0;
								end
	XXH32_DONE			:	begin
									temp_v1		=	32'b0;
									temp_v2		=	32'b0;
									temp_v3		=	32'b0;
									temp_v4		=	32'b0;
									v1_valid		=	1'b0;
									v2_valid		=	1'b0;
									v3_valid		=	1'b0;
									v4_valid		=	1'b0;
									update_temp	=	32'b0;
									vi_updating	=	1'b0;
									update_end	=	1'b1;
									fifo_rd		=	1'b0;
									h32			=	32'b0;
									h32_valid	=	1'b0;
									final4byte	=	1'b0;
									digest_temp	=	32'b0;
									digest_init	=	1'b0;
									dword_digest=	1'b0;
									byte_digest	=	1'b0;
									shift_en		=	1'b0;
									end1			=	1'b0;
									end2			=	1'b0;
									digest		=	mul_digest[31:0] ^ (mul_digest[31:0]>>16);
									digest_valid=	1'b1;
									dword_proc	=	1'b0;
									byte_proc	=	1'b0;
									fifo_wait_en=	1'b0;
								end
	default				:	begin
									temp_v1		=	32'b0;
									temp_v2		=	32'b0;
									temp_v3		=	32'b0;
									temp_v4		=	32'b0;
									v1_valid		=	1'b0;
									v2_valid		=	1'b0;
									v3_valid		=	1'b0;
									v4_valid		=	1'b0;
									update_temp	=	32'b0;
									vi_updating	=	1'b0;
									update_end	=	1'b0;
									fifo_rd		=	1'b0;
									h32			=	32'b0;
									h32_valid	=	1'b0;
									final4byte	=	1'b0;
									digest_temp	=	32'b0;
									digest_init	=	1'b0;
									dword_digest=	1'b0;
									byte_digest	=	1'b0;
									shift_en		=	1'b0;
									end1			=	1'b0;
									end2			=	1'b0;
									digest		=	32'b0;
									digest_valid=	1'b0;
									dword_proc	=	1'b0;
									byte_proc	=	1'b0;
									fifo_wait_en=	1'b0;
								end
	endcase
end

/////////////////////////////////////////////////
////			 	 IP CORES  Module 			   ////
/////////////////////////////////////////////////
// 2 multiplier for xxh32_update
xxh32_mul vi_mul1
(
  .clk		(clk), 
  .sclr		(~rstN), 
  .a			(update_coe1), 
  .b			({mul_data[7:0],mul_data[15:8],mul_data[23:16],mul_data[31:24]}),
  
  .p			(mul_vi_temp)
);

xxh32_mul vi_mul2
(
  .clk		(clk), 
  .sclr		(~rstN), 
  .a			(update_coe2), 
  .b			(update_temp),
  
  .p			(update_vi_temp)
);

// multiplier for xxh32_digest
xxh32_mul digest_mul
(
  .clk		(clk), 
  .sclr		(~rstN), 
  .a			(digest_coe), 
  .b			(digest_temp),
  
  .p			(mul_digest)
);

// fifo for digest procedure(first word fall through)
fifo_16x32b	U_digest_fifo
(
  .clk			(clk),
  .rst			(~rstN),
  .din			(data_d1),
  .wr_en			(fifo_wr),
  .rd_en			(fifo_rd),
	
  .dout			(fifo_data),
  .full			(),
  .empty			(),	//	(fifo_empty),	//
  .valid			(fifo_valid),
  .data_count	(data_count)
);

endmodule
