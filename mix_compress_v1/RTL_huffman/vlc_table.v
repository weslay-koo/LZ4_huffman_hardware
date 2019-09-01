`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:36:14 07/15/2016 
// Design Name: 
// Module Name:    vlc_table 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: Use huffman tree to implement VLC encode
//
//        22bit Frame in Tree RAM is
// (MSB)	Extend_to_next_segment  Code_segment_length  VLC_code_16bit_segment (LSB)
// 				1bit							5bit 							16bit        
//  	0:Not extend to next 16bit		5'h0 || >5'h100: Illegal value
//		1:Extend to next 16bit			5'h1~5'h10: Segment code length
//													
//////////////////////////////////////////////////////////////////////////////////
module vlc_table(
// global clock and reset
input wire				clk,
input wire				rstN,
// control and status signal
input wire				vlc_start,
output reg				vlc_done,
// tree RAM Interface
input wire	[9:0]		tree_even_douta,
input wire	[9:0]		tree_even_doutb,
input wire	[9:0]		tree_odd_douta,
input wire	[9:0]		tree_odd_doutb,
output reg	[7:0]		tree_even_addra,
output reg	[7:0]		tree_even_addrb,
output reg	[7:0]		tree_odd_addra,
output reg	[7:0]		tree_odd_addrb,
// Encode VLC Table interface
input wire	[11:0]	vlc_addra_in,
input wire	[11:0]	vlc_addrb_in,
input wire	[11:0]	vlc_addrc_in,
input wire	[11:0]	vlc_addrd_in,
output wire	[21:0]	vlc_douta,
output wire	[21:0]	vlc_doutb,
output wire	[21:0]	vlc_doutc,
output wire	[21:0]	vlc_doutd
);

//////////////// FSM status ////////////////
parameter		IDLE			=	4'h0;
parameter		READ_LEAF	=	4'h1;
parameter		MID_NODE		=	4'h2;
parameter		ROOT_NODE	=	4'h3;
parameter		DONE			=	4'h4;
////////////////////////////////////////////

// FSM signal
reg	[3:0]		current_state,next_state;
// encode start signal delay
reg				vlc_start_d1;
// 4 register for parallel 4 huffman tree trace
reg	[15:0]	code_1,code_2;
reg	[4:0]		code_len_1,code_len_2;
reg				code_sin_1,code_sin_2;	//	code register shift in data
reg				code_sen_1,code_sen_2;	//	code register shift enable
reg				even_oddN_1,even_oddN_2;
// node address
reg	[8:0]		node_addr_1,node_addr_2,
					node_addr_1_d1,node_addr_2_d1;
reg	[8:0]		leaf_addr_cnt;
reg				leaf_addr_en;
reg				tram_sel_en;
// VLC table RAM signal
reg				vlc_wea,vlc_web;
reg	[11:0]	vlc_addra,vlc_addrb,vlc_addrc,vlc_addrd;
reg	[21:0]	vlc_dina,vlc_dinb;
reg	[3:0]		seg_cnt_1,seg_cnt_2;
reg				seg_clr_1,seg_clr_2;
// Single VLC trace done signal
reg				vlc_done_1,vlc_done_2;
// vlc bit length store array
wire	[4:0]		bit_len_1,bit_len_2;
reg				incr_en_1,incr_en_2;
wire	[8:0]		bl_count_1,bl_count_2;
// search end signal generation
wire				search_end_1,search_end_2;
wire				none_zero_1,none_zero_2;

/////////////////////////////////////////////////
////			Dividual Combination Logic 		////
/////////////////////////////////////////////////
// vlc bit length store array
assign			bit_len_1		=	code_len_1;
assign			bit_len_2		=	code_len_2;
//	search end signal generation
assign			search_end_1	=	(node_addr_1 == node_addr_1_d1) ? 1'b1 : 1'b0;
assign			search_end_2	=	(node_addr_2 == node_addr_2_d1) ? 1'b1 : 1'b0;
assign			none_zero_1		=	(node_addr_1 != 9'b0) ? 1'b1 : 1'b0;
assign			none_zero_2		=	(node_addr_2 != 9'b0) ? 1'b1 : 1'b0;

/////////////////////////////////////////////////
////				 Sequential Logic 				////
/////////////////////////////////////////////////
// FSM main process
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

// vlc_start delay
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		vlc_start_d1	<=	1'b0;
	end
	else
	begin
		vlc_start_d1	<=	vlc_start;
	end
end

// initial leaf address counter
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		leaf_addr_cnt	<=	9'b0;
	end
	else
	begin
		if({vlc_start_d1,vlc_start}==2'b01)
			leaf_addr_cnt	<=	9'b0;
		else if(leaf_addr_en)
			leaf_addr_cnt	<=	leaf_addr_cnt + 2'h2;
		else
			leaf_addr_cnt	<=	leaf_addr_cnt;
	end
end

// encode shifter
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		code_1		<=	16'b0;
		code_2		<=	16'b0;
		code_len_1	<=	5'b0;
		code_len_2	<=	5'b0;
		seg_cnt_1	<=	4'b0;
		seg_cnt_2	<=	4'b0;
	end
	else
	begin
		if({vlc_start_d1,vlc_start}==2'b01)	// Code trace 1
		begin
			code_1		<=	16'b0;
			code_len_1	<=	5'b0;
			seg_cnt_1	<=	4'b0;
		end
		else if(code_sen_1)
		begin
			if(code_len_1 < 5'h10)
			begin
				code_1		<=	{code_1[14:0],code_sin_1};
				code_len_1	<=	code_len_1 + 1'b1;
				seg_cnt_1	<=	seg_cnt_1;
			end
			else
			begin
				code_1		<=	{15'b0,code_sin_1};
				code_len_1	<=	5'h1;
				seg_cnt_1	<=	seg_cnt_1 + 1'b1;
			end
		end
		else
		begin
			code_1	<=	code_1;
			if(seg_clr_1)
			begin
				seg_cnt_1	<=	4'b0;
				code_len_1	<=	5'b0;
			end
			else
			begin
				seg_cnt_1	<=	seg_cnt_1;
				code_len_1	<=	code_len_1;
			end
		end
			
		if({vlc_start_d1,vlc_start}==2'b01)	// Code trace 2
		begin
			code_2		<=	16'b0;
			code_len_2	<=	5'b0;
			seg_cnt_2	<=	4'b0;
		end
		else if(code_sen_2)
		begin
			if(code_len_2 < 5'h10)
			begin
				code_2		<=	{code_2[14:0],code_sin_2};
				code_len_2	<=	code_len_2 + 1'b1;
				seg_cnt_2	<=	seg_cnt_2;
			end
			else
			begin
				code_2		<=	{15'b0,code_sin_2};
				code_len_2	<=	5'h1;
				seg_cnt_2	<=	seg_cnt_2 + 1'b1;
			end
		end
		else
		begin
			code_2	<=	code_2;
			if(seg_clr_2)
			begin
				seg_cnt_2	<=	4'b0;
				code_len_2	<=	5'b0;
			end
			else
			begin
				seg_cnt_2	<=	seg_cnt_2;
				code_len_2	<=	code_len_2;
			end
		end
	end
end

// odd/even tree ram selection
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		even_oddN_1	<=	1'b0;
		even_oddN_2	<=	1'b0;
	end
	else
	begin
		if(tram_sel_en)
		begin
			if(node_addr_1[0])
				even_oddN_1	<=	1'b0;
			else
				even_oddN_1	<=	1'b1;
		end
		else
		begin
			even_oddN_1	<=	even_oddN_1;
		end
		
		if(tram_sel_en)
		begin
			if(node_addr_2[0])
				even_oddN_2	<=	1'b0;
			else
				even_oddN_2	<=	1'b1;
		end
		else
		begin
			even_oddN_2	<=	even_oddN_2;
		end
	end
end

// Single VLC trace done signal
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		vlc_done_1	<=	1'b0;
		vlc_done_2	<=	1'b0;
	end
	else
	begin
		if(leaf_addr_en)
			vlc_done_1	<=	1'b0;
		else if(search_end_1 && vlc_wea)
			vlc_done_1	<=	1'b1;
		else
			vlc_done_1	<=	vlc_done_1;
			
		if(leaf_addr_en)
			vlc_done_2	<=	1'b0;
		else if(search_end_2 && vlc_web)
			vlc_done_2	<=	1'b1;
		else
			vlc_done_2	<=	vlc_done_2;
	end
end

// node_addr_1 and node_addr_2_d1 delay
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		node_addr_1_d1	<=	9'b0;
		node_addr_2_d1	<=	9'b0;
	end
	else
	begin
		node_addr_1_d1	<=	node_addr_1;
		node_addr_2_d1	<=	node_addr_2;
	end
end

/////////////////////////////////////////////////
////				Combination Logic 				////
/////////////////////////////////////////////////
// FSM state transfer
always @ (*)
begin
	case(current_state)
	IDLE			:	begin
							if({vlc_start_d1,vlc_start}==2'b01)
								next_state	=	READ_LEAF;
							else
								next_state	=	IDLE;
						end
	READ_LEAF	:	begin
							next_state	=	MID_NODE;
						end
	MID_NODE		:	begin
							if(none_zero_1 & none_zero_1)
							begin
								if(search_end_1 & search_end_2)
									next_state	=	ROOT_NODE;
								else
									next_state	=	MID_NODE;
							end
							else if((~none_zero_1) && none_zero_2)
							begin
								if(search_end_2)
									next_state	=	ROOT_NODE;
								else
									next_state	=	MID_NODE;
							end
							else if(none_zero_1 && (~none_zero_2))
							begin
								if(search_end_1)
									next_state	=	ROOT_NODE;
								else
									next_state	=	MID_NODE;
							end
							else
							begin
								next_state	=	ROOT_NODE;
							end
						end
	ROOT_NODE	:	begin
							if(leaf_addr_cnt >= 9'hFF)
								next_state	=	DONE;
							else
								next_state	=	READ_LEAF;
						end
	DONE			:	begin
							if({vlc_start_d1,vlc_start}==2'b01)
								next_state	=	READ_LEAF;
							else
								next_state	=	DONE;
						end
	default		:	begin
							next_state	=	IDLE;
						end
	endcase
end

// FSM control signal generation
always @ (*)
begin
	case(current_state)
	IDLE			:	begin
							node_addr_1		=	9'b0;
							node_addr_2		=	9'b0;
							tram_sel_en		=	1'b0;
							leaf_addr_en	=	1'b0;
							code_sen_1		=	1'b0;
							code_sin_1		=	1'b0;
							code_sen_2		=	1'b0;
							code_sin_2		=	1'b0;
							vlc_done			=	1'b0;
						end
	READ_LEAF	:	begin
							node_addr_1		=	leaf_addr_cnt;
							node_addr_2		=	leaf_addr_cnt + 2'h1;
							tram_sel_en		=	1'b1;
							leaf_addr_en	=	1'b0;
							code_sen_1		=	1'b0;
							code_sin_1		=	1'b0;
							code_sen_2		=	1'b0;
							code_sin_2		=	1'b0;
							vlc_done			=	1'b0;
						end
	MID_NODE		:	begin
							if(even_oddN_1)
								node_addr_1	=	tree_even_douta[8:0];
							else
								node_addr_1	=	tree_odd_douta[8:0];
							if((!search_end_1) & none_zero_1)
								code_sen_1	=	1'b1;
							else
								code_sen_1	=	1'b0;
							if(even_oddN_1)
								code_sin_1	=	tree_even_douta[9];
							else
								code_sin_1	=	tree_odd_douta[9];
								
							if(even_oddN_2)
								node_addr_2	=	tree_even_doutb[8:0];
							else
								node_addr_2	=	tree_odd_doutb[8:0];
							if((!search_end_2) && none_zero_2)
								code_sen_2	=	1'b1;
							else
								code_sen_2	=	1'b0;
							if(even_oddN_2)
								code_sin_2	=	tree_even_doutb[9];
							else
								code_sin_2	=	tree_odd_doutb[9];
							tram_sel_en		=	1'b1;
							leaf_addr_en	=	1'b0;
							vlc_done			=	1'b0;
						end
	ROOT_NODE	:	begin
							node_addr_1		=	9'b0;
							node_addr_2		=	9'b0;
							tram_sel_en		=	1'b0;
							leaf_addr_en	=	1'b1;
							code_sen_1		=	1'b0;
							code_sin_1		=	1'b0;
							code_sen_2		=	1'b0;
							code_sin_2		=	1'b0;
							vlc_done			=	1'b0;
						end
	DONE			:	begin
							node_addr_1		=	9'b0;
							node_addr_2		=	9'b0;
							tram_sel_en		=	1'b0;
							leaf_addr_en	=	1'b0;
							code_sen_1		=	1'b0;
							code_sin_1		=	1'b0;
							code_sen_2		=	1'b0;
							code_sin_2		=	1'b0;
							vlc_done			=	1'b1;
						end
	default		:	begin
							node_addr_1		=	9'b0;
							node_addr_2		=	9'b0;
							tram_sel_en		=	1'b0;
							leaf_addr_en	=	1'b0;
							code_sen_1		=	1'b0;
							code_sin_1		=	1'b0;
							code_sen_2		=	1'b0;
							code_sin_2		=	1'b0;
							vlc_done			=	1'b0;
						end
	endcase
end

// FSM Tree RAM signal
always @ (*)
begin
	case(current_state)
	IDLE			:	begin
							tree_even_addra	=	8'b0;
							tree_even_addrb	=	8'b0;
							tree_odd_addra		=	8'b0;
							tree_odd_addrb		=	8'b0;
						end
	READ_LEAF	,
	MID_NODE		:	begin
							tree_even_addra	=	node_addr_1[8:1];
							tree_even_addrb	=	node_addr_2[8:1];
							tree_odd_addra		=	node_addr_1[8:1];
							tree_odd_addrb		=	node_addr_2[8:1];
						end
	ROOT_NODE	,
	DONE			:	begin
							tree_even_addra	=	8'b0;
							tree_even_addrb	=	8'b0;
							tree_odd_addra		=	8'b0;
							tree_odd_addrb		=	8'b0;
						end
	default		:	begin
							tree_even_addra	=	8'b0;
							tree_even_addrb	=	8'b0;
							tree_odd_addra		=	8'b0;
							tree_odd_addrb		=	8'b0;
						end
	endcase
end

// FSM VLC table RAM signal
always @ (*)
begin
	case(current_state)
	IDLE			,
	READ_LEAF	:	begin
							incr_en_1	=	1'b0;
							incr_en_2	=	1'b0;
							vlc_wea		=	1'b0;
							vlc_addra	=	12'b0;
							vlc_dina		=	22'b0;
							vlc_web		=	1'b0;
							vlc_addrb	=	12'b0;
							vlc_dinb		=	22'b0;
							vlc_addrc	=	12'b0;
							vlc_addrd	=	12'b0;
							seg_clr_1	=	1'b0;
							seg_clr_2	=	1'b0;
						end
	MID_NODE		:	begin
							seg_clr_1	=	1'b0;
							seg_clr_2	=	1'b0;
							vlc_addrc	=	vlc_addra;
							vlc_addrd	=	vlc_addrb;
							vlc_addra	=	{leaf_addr_cnt[7:0],seg_cnt_1};
							vlc_addrb	=	{leaf_addr_cnt[7:0] + 1'b1,seg_cnt_2};
							if((code_len_1 >= 5'h10) && (!vlc_done_1))
							begin
								incr_en_1	=	1'b0;
								vlc_wea		=	1'b1;
								if(search_end_1)
									vlc_dina		=	{1'b0,5'h100,code_1};
								else
									vlc_dina		=	{1'b1,5'h100,code_1};
							end
							else
							begin
								if(search_end_1 & (!vlc_done_1))
								begin
									vlc_wea		=	1'b1;
									vlc_dina		=	{1'b0,code_len_1,code_1};
									incr_en_1	=	1'b1;
								end
								else
								begin
									vlc_wea		=	1'b0;
									vlc_dina		=	22'b0;
									incr_en_1	=	1'b0;
								end
							end
							
							if((code_len_2 >= 5'h10) && (!vlc_done_2))
							begin
								incr_en_2	=	1'b0;
								vlc_web		=	1'b1;
								if(search_end_2)
									vlc_dinb		=	{1'b0,5'h100,code_2};
								else
									vlc_dinb		=	{1'b1,5'h100,code_2};
							end
							else
							begin
								if(search_end_2 & (!vlc_done_2))
								begin
									vlc_web		=	1'b1;
									vlc_dinb		=	{1'b0,code_len_2,code_2};
									incr_en_2	=	1'b1;
								end
								else
								begin
									vlc_web		=	1'b0;
									vlc_dinb		=	22'b0;
									incr_en_2	=	1'b0;
								end
							end
						end
	ROOT_NODE	:	begin
							if(!vlc_done_1)
							begin
								incr_en_1	=	1'b1;
								vlc_wea		=	1'b1;
							end
							else
							begin
								incr_en_1	=	1'b0;
								vlc_wea		=	1'b0;
							end
							vlc_addra	=	{leaf_addr_cnt[7:0],seg_cnt_1};
							vlc_dina		=	{1'b0,code_len_1,code_1};
							if(!vlc_done_2)
							begin
								incr_en_2	=	1'b1;
								vlc_web		=	1'b1;
							end
							else
							begin
								incr_en_2	=	1'b0;
								vlc_web		=	1'b0;	
							end
							vlc_addrb	=	{leaf_addr_cnt[7:0] + 1'b1,seg_cnt_2};
							vlc_dinb		=	{1'b0,code_len_2,code_2};
							vlc_addrc	=	vlc_addra;
							vlc_addrd	=	vlc_addrb;
							seg_clr_1	=	1'b1;
							seg_clr_2	=	1'b1;
						end
	DONE			:	begin
							incr_en_1	=	1'b0;
							incr_en_2	=	1'b0;
							vlc_wea		=	1'b0;
							vlc_addra	=	vlc_addra_in;
							vlc_dina		=	22'b0;
							vlc_web		=	1'b0;
							vlc_addrb	=	vlc_addrb_in;
							vlc_dinb		=	22'b0;
							vlc_addrc	=	vlc_addrc_in;
							vlc_addrd	=	vlc_addrd_in;
							seg_clr_1	=	1'b1;
							seg_clr_2	=	1'b1;
						end
	default		:	begin
							incr_en_1	=	1'b0;
							incr_en_2	=	1'b0;
							vlc_wea		=	1'b0;
							vlc_addra	=	12'b0;
							vlc_dina		=	22'b0;
							vlc_web		=	1'b0;
							vlc_addrb	=	12'b0;
							vlc_dinb		=	22'b0;
							vlc_addrc	=	12'b0;
							vlc_addrd	=	12'b0;
							seg_clr_1	=	1'b0;
							seg_clr_2	=	1'b0;
						end
	endcase
end

/////////////////////////////////////////////////
////					Sub Modules						////
/////////////////////////////////////////////////
// RAM 4096x17bit for VLC encode table for PORT A B
ram_4kx22bit	U_vlc_table_1
(
  .clka			(clk),
  .wea			(vlc_wea),
  .addra			(vlc_addra),
  .dina			(vlc_dina),
  .clkb			(clk),
  .web			(vlc_web),
  .addrb			(vlc_addrb),
  .dinb			(vlc_dinb),
  
  .douta			(vlc_douta),
  .doutb			(vlc_doutb)
);

// RAM 4096x17bit for VLC encode table for PORT C D
ram_4kx22bit	U_vlc_table_2
(
  .clka			(clk),
  .wea			(vlc_wea),
  .addra			(vlc_addrc),
  .dina			(vlc_dina),
  .clkb			(clk),
  .web			(vlc_web),
  .addrb			(vlc_addrd),
  .dinb			(vlc_dinb),
  
  .douta			(vlc_doutc),
  .doutb			(vlc_doutd)
);

// Bit length counter array
reg_array_16x9bit	U_reg_array_1
(
	// global clock and reset
	.clk				(clk),
	.rstN				(rstN),
	// access signal
	.addr				(bit_len_1[3:0]),	
	.incr_en			(incr_en_1),
	.bl_count		(bl_count_1)	
);

reg_array_16x9bit	U_reg_array_2
(
	// global clock and reset
	.clk				(clk),
	.rstN				(rstN),
	// access signal
	.addr				(bit_len_2[3:0]),	
	.incr_en			(incr_en_2),
	.bl_count		(bl_count_2)	
);

endmodule
