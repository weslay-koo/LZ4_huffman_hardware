`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:39:06 08/09/2016 
// Design Name: 
// Module Name:    bit_len_gen 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: Trace huffman tree to calculate and optimous 
//								VLC Bit Length (Method from RFC1951)
//
//////////////////////////////////////////////////////////////////////////////////
module bit_len_gen(
// global clock and reset
input wire				clk,
input wire				rstN,
// control and status signal
input wire				trace_start,
output reg				gen_done,
// tree RAM Interface
input wire	[9:0]		tree_even_douta,
input wire	[9:0]		tree_even_doutb,
input wire	[9:0]		tree_odd_douta,
input wire	[9:0]		tree_odd_doutb,
output reg	[7:0]		tree_even_addra,
output reg	[7:0]		tree_even_addrb,
output reg	[7:0]		tree_odd_addra,
output reg	[7:0]		tree_odd_addrb,
// Bit Length Counter RAM read interface
input wire	[3:0]		bl_cnt_addra,
output wire	[8:0]		bl_cnt_douta,
input wire	[3:0]		bl_cnt_addrb,
output wire	[8:0]		bl_cnt_doutb
);

//////////////// FSM status ////////////////
parameter		IDLE				=	4'h0;
parameter		READ_LEAF		=	4'h1;
parameter		MID_NODE			=	4'h2;
parameter		ROOT_NODE		=	4'h3;
parameter		TRACE_DONE		=	4'h4;
parameter		WAIT_ARRAY		=	4'h5;
parameter		GET_OVERFLOW	=	4'h6;
parameter		SCAN_BLCNT		=	4'h7;
parameter		OPT_BLEN			=	4'h8;
parameter		OPT_STORE		=	4'h9;
parameter		OPT_DONE			=	4'hA;
////////////////////////////////////////////

// FSM signal
reg	[3:0]		current_state,next_state;
// encode start signal delay
reg				trace_start_d1;
// parallel 2 huffman tree trace
reg	[4:0]		code_len_1,code_len_2;
reg				code_sen_1,code_sen_2;	//	code register shift enable
reg				even_oddN_1,even_oddN_2;
reg				seg_clr_1,seg_clr_2;
// node address
reg	[8:0]		node_addr_1,node_addr_2,
					node_addr_1_d1,node_addr_2_d1;
reg	[8:0]		leaf_addr_cnt;
reg				leaf_addr_en;
reg				tram_sel_en;
// Single VLC trace done signal
reg				trace_done_1,trace_done_2;
// vlc bit length store array
reg	[3:0]		array1_addra,array1_addrb,
					array2_addra,array2_addrb;
wire				array1_busy,array2_busy; // Indicate reg_array aux port disable status
reg				incr_en_1,incr_en_2;
reg				decr_en_1,decr_en_2;
wire	[8:0]		bl_count1a,bl_count1b,bl_count2a,bl_count2b;
// search end signal generation
wire				search_end_1,search_end_2;
wire				none_zero_1,none_zero_2;
// bl_count signal 
wire	[8:0]		bl_counta,bl_countb;
// tree optimous process
reg	[3:0]		scan_cnt;
reg				scan_cnt_en;
reg				bl_scan_done;
reg				scan_cnt_rst;
// overflow register
reg	[8:0]		overflow;
reg				overflow_load,overflow_decr;
// store bl_count to single dual port ram
reg	[4:0]		bl_store_cnt,bl_store_cnt_d1;
reg				bl_store_en;
reg				opt_bl_wea,opt_bl_web;
reg	[3:0]		opt_bl_addra,opt_bl_addrb;
reg	[8:0]		opt_bl_dina,opt_bl_dinb;
wire	[8:0]		opt_bl_douta,opt_bl_doutb;

/////////////////////////////////////////////////
////			Dividual Combination Logic 		////
/////////////////////////////////////////////////
//	search end signal generation
assign		search_end_1	=	(	(node_addr_1 == node_addr_1_d1) 
										|| (node_addr_1 < 9'h100)) ? 1'b1 : 1'b0;
assign		search_end_2	=	(	(node_addr_2 == node_addr_2_d1) 
										|| (node_addr_2 < 9'h100)) ? 1'b1 : 1'b0;
assign		none_zero_1		=	(node_addr_1 != 9'b0) ? 1'b1 : 1'b0;
assign		none_zero_2		=	(node_addr_2 != 9'b0) ? 1'b1 : 1'b0;

// Merge BL_COUNT value in two reg arrays
assign		bl_counta		=	bl_count1a + bl_count2a;
assign		bl_countb		=	bl_count1b + bl_count2b;

// output opt_bl_count
assign		bl_cnt_douta	=	opt_bl_douta;
assign		bl_cnt_doutb	=	opt_bl_doutb;

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

// trace_start delay
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		trace_start_d1	<=	1'b0;
	end
	else
	begin
		trace_start_d1	<=	trace_start;
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
		if({trace_start_d1,trace_start}==2'b01)
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
		code_len_1	<=	5'b0;
		code_len_2	<=	5'b0;
	end
	else
	begin
		if({trace_start_d1,trace_start}==2'b01)	// Code trace 1
		begin
			code_len_1	<=	5'b0;
		end
		else if(code_sen_1)
		begin
			if(code_len_1 < 5'h10)
				code_len_1	<=	code_len_1 + 1'b1;
			else
				code_len_1	<=	5'h10;
		end
		else
		begin
			if(seg_clr_1)
				code_len_1	<=	5'b0;
			else
				code_len_1	<=	code_len_1;
		end
			
		if({trace_start_d1,trace_start}==2'b01)	// Code trace 2
		begin
			code_len_2	<=	5'b0;
		end
		else if(code_sen_2)
		begin
			if(code_len_2 < 5'h10)
				code_len_2	<=	code_len_2 + 1'b1;
			else
				code_len_2	<=	5'h10;
		end
		else
		begin
			if(seg_clr_2)
				code_len_2	<=	5'b0;
			else
				code_len_2	<=	code_len_2;
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

// Tree trace done signal
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		trace_done_1	<=	1'b0;
		trace_done_2	<=	1'b0;
	end
	else
	begin
		if(leaf_addr_en)
			trace_done_1	<=	1'b0;
		else if(search_end_1 && incr_en_1)
			trace_done_1	<=	1'b1;
		else
			trace_done_1	<=	trace_done_1;
			
		if(leaf_addr_en)
			trace_done_2	<=	1'b0;
		else if(search_end_2 && incr_en_2)
			trace_done_2	<=	1'b1;
		else
			trace_done_2	<=	trace_done_2;
	end
end

// node_addr_1 and node_addr_2 delay
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

// optimous process counter
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		scan_cnt	<=	4'b0;
	end
	else
	begin
		if(scan_cnt_rst)				// every Code bl_len (0~255) will reset counter 
			scan_cnt	<=	4'hE;			// Scan start from bl_count[14]
		else if(scan_cnt_en)
			scan_cnt	<=	scan_cnt - 2'h2;
		else
			scan_cnt	<=	scan_cnt;
	end
end

// Overflow register for Tree optimous
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		overflow	<=	9'b0;
	end
	else
	begin
		if(overflow_load)
			overflow	<=	bl_counta;	// deflaut reg_array port A will output the number of bl>15 element in address 0
		else if(overflow_decr)
			overflow	<=	overflow - 1'b1;
		else
			overflow	<=	overflow;
	end
end

// store bl_count to single dual port ram
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		bl_store_cnt		<=	5'b0;
		bl_store_cnt_d1	<=	5'b0;
	end
	else
	begin
		bl_store_cnt_d1	<=	bl_store_cnt;
		if({trace_start_d1,trace_start}==2'b01)
			bl_store_cnt	<=	5'b0;						// jump bl_count[0]
		else if(bl_store_en)
			bl_store_cnt	<=	bl_store_cnt + 2'h2;
		else
			bl_store_cnt	<=	bl_store_cnt;
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
							if({trace_start_d1,trace_start}==2'b01)
								next_state	=	READ_LEAF;
							else
								next_state	=	IDLE;
						end
	READ_LEAF	:	begin
							next_state	=	MID_NODE;
						end
	MID_NODE		:	begin
							if(none_zero_1 & none_zero_2)
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
							if(leaf_addr_cnt >= 9'hFE)
								next_state	=	TRACE_DONE;
							else
								next_state	=	READ_LEAF;
						end
	TRACE_DONE	:	begin
							next_state	=	WAIT_ARRAY;
						end
	WAIT_ARRAY	:	begin
							next_state	=	GET_OVERFLOW;
						end
	GET_OVERFLOW:	begin
							if(bl_counta != 9'b0)
								next_state	=	SCAN_BLCNT;
							else
								next_state	=	OPT_STORE;
						end						
	SCAN_BLCNT	:	begin
							if(!bl_scan_done)
								next_state	=	SCAN_BLCNT;
							else
								next_state	=	OPT_BLEN;
						end
	OPT_BLEN		:	begin
							if((~array1_busy) & (~array2_busy))
							begin
								if(overflow > 9'h1)
									next_state	=	SCAN_BLCNT;
								else
									next_state	=	OPT_STORE;
							end
							else
							begin
								next_state	=	OPT_BLEN;
							end
						end
	OPT_STORE	:	begin
							if(bl_store_cnt < 5'h10)
								next_state	=	OPT_STORE;
							else
								next_state	=	OPT_DONE;
						end
	OPT_DONE		:	begin
							if({trace_start_d1,trace_start}==2'b01)
								next_state	=	READ_LEAF;
							else
								next_state	=	OPT_DONE;
						end	
	default		:	begin
							next_state	=	IDLE;
						end
	endcase
end

// FSM control signal generation (Trace in Tree)
always @ (*)
begin
	case(current_state)
	IDLE			:	begin
							node_addr_1		=	9'b0;
							node_addr_2		=	9'b0;
							tram_sel_en		=	1'b0;
							leaf_addr_en	=	1'b0;
							code_sen_1		=	1'b0;
							code_sen_2		=	1'b0;
							gen_done			=	1'b0;
						end
	READ_LEAF	:	begin
							node_addr_1		=	leaf_addr_cnt;
							node_addr_2		=	leaf_addr_cnt + 2'h1;
							tram_sel_en		=	1'b1;
							leaf_addr_en	=	1'b0;
							code_sen_1		=	1'b0;
							code_sen_2		=	1'b0;
							gen_done			=	1'b0;
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
								
							if(even_oddN_2)
								node_addr_2	=	tree_even_doutb[8:0];
							else
								node_addr_2	=	tree_odd_doutb[8:0];
							if((!search_end_2) && none_zero_2)
								code_sen_2	=	1'b1;
							else
								code_sen_2	=	1'b0;
							tram_sel_en		=	1'b1;
							leaf_addr_en	=	1'b0;
							gen_done			=	1'b0;
						end
	ROOT_NODE	:	begin
							node_addr_1		=	9'b0;
							node_addr_2		=	9'b0;
							tram_sel_en		=	1'b0;
							leaf_addr_en	=	1'b1;
							code_sen_1		=	1'b0;
							code_sen_2		=	1'b0;
							gen_done			=	1'b0;
						end
	TRACE_DONE,
	WAIT_ARRAY	:	begin
							node_addr_1		=	9'b0;
							node_addr_2		=	9'b0;
							tram_sel_en		=	1'b0;
							leaf_addr_en	=	1'b0;
							code_sen_1		=	1'b0;
							code_sen_2		=	1'b0;
							gen_done			=	1'b0;
						end
	GET_OVERFLOW,						
	SCAN_BLCNT	,						
	OPT_BLEN		,
	OPT_STORE	:	begin
							node_addr_1		=	9'b0;
							node_addr_2		=	9'b0;
							tram_sel_en		=	1'b0;
							leaf_addr_en	=	1'b0;
							code_sen_1		=	1'b0;
							code_sen_2		=	1'b0;
							gen_done			=	1'b0;
						end
	OPT_DONE		:	begin
							node_addr_1		=	9'b0;
							node_addr_2		=	9'b0;
							tram_sel_en		=	1'b0;
							leaf_addr_en	=	1'b0;
							code_sen_1		=	1'b0;
							code_sen_2		=	1'b0;
							gen_done			=	1'b1;
						end	
	default		:	begin
							node_addr_1		=	9'b0;
							node_addr_2		=	9'b0;
							tram_sel_en		=	1'b0;
							leaf_addr_en	=	1'b0;
							code_sen_1		=	1'b0;
							code_sen_2		=	1'b0;
							gen_done			=	1'b0;
						end
	endcase
end

// FSM Tree RAM signal (Tree RAM addr generation)
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
	TRACE_DONE	,
	WAIT_ARRAY	,
	GET_OVERFLOW,
	SCAN_BLCNT	,
	OPT_BLEN		,
	OPT_STORE	,
	OPT_DONE		:	begin
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

// FSM BL_RAM and BL_reg_array signal
always @ (*)
begin
	case(current_state)
	IDLE			,
	READ_LEAF	,
	MID_NODE		:	begin
							scan_cnt_en		=	1'b0;
							scan_cnt_rst	=	1'b0;
							bl_store_en		=	1'b0;
							array1_addra	=	code_len_1[3:0];
							array1_addrb	=	4'b0;
							array2_addra	=	code_len_2[3:0];
							array2_addrb	=	4'b0;
							overflow_load	=	1'b0;
							overflow_decr	=	1'b0;
							bl_scan_done	=	1'b0;
						end
	ROOT_NODE	:	begin
							scan_cnt_en		=	1'b0;
							scan_cnt_rst	=	1'b0;
							bl_store_en		=	1'b0;
							array1_addra	=	code_len_1[3:0];
							array1_addrb	=	4'b0;
							array2_addra	=	code_len_2[3:0];
							array2_addrb	=	4'b0;
							overflow_load	=	1'b0;
							overflow_decr	=	1'b0;
							bl_scan_done	=	1'b0;
						end
	TRACE_DONE,
	WAIT_ARRAY	:	begin
							scan_cnt_en		=	1'b0;
							scan_cnt_rst	=	1'b1;
							bl_store_en		=	1'b0;
							array1_addra	=	4'b0;	// default reg_array port A will output the number of bl>15 element in address 0
							array1_addrb	=	4'b0;
							array2_addra	=	4'b0;	// default reg_array port A will output the number of bl>15 element in address 0
							array2_addrb	=	4'b0;
							overflow_load	=	1'b0;
							overflow_decr	=	1'b0;
							bl_scan_done	=	1'b0;
						end
	GET_OVERFLOW:	begin
							if(bl_counta != 9'b0)
								scan_cnt_en	=	1'b1;
							else
								scan_cnt_en	=	1'b0;
							scan_cnt_rst	=	1'b0;
							bl_store_en		=	1'b0;
							array1_addra	=	scan_cnt;
							array1_addrb	=	scan_cnt - 1'b1;
							array2_addra	=	scan_cnt;
							array2_addrb	=	scan_cnt - 1'b1;
							overflow_load	=	1'b1;
							overflow_decr	=	1'b0;
							bl_scan_done	=	1'b0;
						end
	SCAN_BLCNT	:	begin
							overflow_load	=	1'b0;
							overflow_decr	=	1'b0;
							bl_store_en		=	1'b0;
							if((bl_counta==9'b0) && (bl_countb==9'b0))
							begin
								scan_cnt_en		=	1'b1;
								array1_addra	=	scan_cnt;
								array1_addrb	=	scan_cnt - 1'b1;
								array2_addra	=	scan_cnt;
								array2_addrb	=	scan_cnt - 1'b1;
								bl_scan_done	=	1'b0;
								scan_cnt_rst	=	1'b0;
							end
							else if(bl_counta!=9'b0)
							begin
								scan_cnt_en		=	1'b0;
								bl_scan_done	=	1'b1;
								scan_cnt_rst	=	1'b1;
								if(bl_count1a != 9'b0)
								begin
									array1_addra	=	scan_cnt + 2'h2;	// bl_count[prev_scan_cnt] decrease 1
									array2_addra	=	scan_cnt + 2'h3;	// bl_count[prev_scan_cnt+1] increase 2
								end
								else
								begin
									array1_addra	=	scan_cnt	+ 2'h3;	// bl_count[prev_scan_cnt+1] increase 2
									array2_addra	=	scan_cnt + 2'h2;	// bl_count[prev_scan_cnt] decrease 1
								end
								array1_addrb	=	4'b0;
								array2_addrb	=	4'b0;
							end
							else
							begin
								scan_cnt_en		=	1'b0;
								bl_scan_done	=	1'b1;
								scan_cnt_rst	=	1'b1;
								if(bl_count1b != 9'b0)
								begin
									array1_addra	=	scan_cnt	+ 2'h1;	// bl_count[prev_scan_cnt] decrease 1
									array2_addra	=	scan_cnt + 2'h2;	// bl_count[prev_scan_cnt+1] increase 2
								end
								else
								begin
									array1_addra	=	scan_cnt	+ 2'h2;	// bl_count[prev_scan_cnt+1] increase 2
									array2_addra	=	scan_cnt + 2'h1;	// bl_count[prev_scan_cnt] decrease 1
								end
								array1_addrb	=	4'b0;
								array2_addrb	=	4'b0;
							end
						end		
	OPT_BLEN		:	begin
							if((~array1_busy) & (~array2_busy))
							begin
								scan_cnt_en		=	1'b1;
								overflow_decr	=	1'b1;
							end
							else
							begin
								scan_cnt_en		=	1'b0;
								overflow_decr	=	1'b0;
							end
							scan_cnt_rst	=	1'b0;
							bl_store_en		=	1'b0;
							array1_addra	=	scan_cnt;
							array1_addrb	=	scan_cnt - 1'b1;
							array2_addra	=	scan_cnt;
							array2_addrb	=	scan_cnt - 1'b1;
							overflow_load	=	1'b0;
							bl_scan_done	=	1'b0;
						end
	OPT_STORE	:	begin
							scan_cnt_en		=	1'b0;
							scan_cnt_rst	=	1'b0;
							bl_store_en		=	1'b1;
							array1_addra	=	bl_store_cnt[3:0];
							array1_addrb	=	bl_store_cnt[3:0] + 1'b1;
							array2_addra	=	bl_store_cnt[3:0];
							array2_addrb	=	bl_store_cnt[3:0] + 1'b1;
							overflow_load	=	1'b0;
							overflow_decr	=	1'b0;
							bl_scan_done	=	1'b0;
						end
	OPT_DONE		:	begin
							scan_cnt_en		=	1'b0;
							scan_cnt_rst	=	1'b0;
							bl_store_en		=	1'b0;
							array1_addra	=	4'b0;
							array1_addrb	=	4'b0;
							array2_addra	=	4'b0;
							array2_addrb	=	4'b0;
							overflow_load	=	1'b0;
							overflow_decr	=	1'b0;
							bl_scan_done	=	1'b0;
						end				
	default		:	begin
							scan_cnt_en		=	1'b0;
							scan_cnt_rst	=	1'b0;
							bl_store_en		=	1'b0;
							array1_addra	=	4'b0;
							array1_addrb	=	4'b0;
							array2_addra	=	4'b0;
							array2_addrb	=	4'b0;
							overflow_load	=	1'b0;
							overflow_decr	=	1'b0;
							bl_scan_done	=	1'b0;
						end
	endcase
end

// FSM BL count RAM signal
always @ (*)
begin
	case(current_state)
	IDLE			,
	READ_LEAF	:	begin
							incr_en_1	=	1'b0;
							incr_en_2	=	1'b0;
							decr_en_1	=	1'b0;
							decr_en_2	=	1'b0;
							seg_clr_1	=	1'b0;
							seg_clr_2	=	1'b0;
						end
	MID_NODE		:	begin
							seg_clr_1	=	1'b0;
							seg_clr_2	=	1'b0;
							decr_en_1	=	1'b0;
							decr_en_2	=	1'b0;
							if((code_len_1 >= 5'h10) && (!trace_done_1))
							begin
								incr_en_1	=	1'b0;
							end
							else
							begin
								if(search_end_1 & (!trace_done_1))
									incr_en_1	=	1'b1;
								else
									incr_en_1	=	1'b0;
							end
							
							if((code_len_2 >= 5'h10) && (!trace_done_2))
							begin
								incr_en_2	=	1'b0;
							end
							else
							begin
								if(search_end_2 & (!trace_done_2))
									incr_en_2	=	1'b1;
								else
									incr_en_2	=	1'b0;
							end
						end
	ROOT_NODE	:	begin
							if(leaf_addr_cnt <= 9'hFE)
							begin
								if(!trace_done_1)
								incr_en_1	=	1'b1;
								else
									incr_en_1	=	1'b0;
								if(!trace_done_2)
									incr_en_2	=	1'b1;
								else
									incr_en_2	=	1'b0;
							end
							else
							begin
								incr_en_1	=	1'b0;
								incr_en_2	=	1'b0;
							end
							decr_en_1	=	1'b0;
							decr_en_2	=	1'b0;
							seg_clr_1	=	1'b1;
							seg_clr_2	=	1'b1;
						end
	TRACE_DONE	,
	WAIT_ARRAY	:	begin
							incr_en_1	=	1'b0;
							incr_en_2	=	1'b0;
							decr_en_1	=	1'b0;
							decr_en_2	=	1'b0;
							seg_clr_1	=	1'b1;
							seg_clr_2	=	1'b1;
						end
	GET_OVERFLOW:	begin
							incr_en_1	=	1'b0;
							incr_en_2	=	1'b0;
							decr_en_1	=	1'b0;
							decr_en_2	=	1'b0;
							seg_clr_1	=	1'b0;
							seg_clr_2	=	1'b0;
						end					
	SCAN_BLCNT	:	begin
							if((bl_counta==9'b0) && (bl_countb==9'b0))
							begin
								incr_en_1	=	1'b0;
								incr_en_2	=	1'b0;
								decr_en_1	=	1'b0;
								decr_en_2	=	1'b0;
							end
							else if(bl_counta!=9'b0)
							begin
								if(bl_count1a != 9'b0)
								begin
									incr_en_1	=	1'b0;
									decr_en_1	=	1'b1;
									incr_en_2	=	1'b1;
									decr_en_2	=	1'b1;
								end
								else
								begin
									incr_en_1	=	1'b1;
									decr_en_1	=	1'b1;
									incr_en_2	=	1'b0;
									decr_en_2	=	1'b1;
								end
							end
							else
							begin
								if(bl_count1b != 9'b0)
								begin
									incr_en_1	=	1'b0;
									decr_en_1	=	1'b1;
									incr_en_2	=	1'b1;
									decr_en_2	=	1'b1;
								end
								else
								begin
									incr_en_1	=	1'b1;
									decr_en_1	=	1'b1;
									incr_en_2	=	1'b0;
									decr_en_2	=	1'b1;
								end
							end
							seg_clr_1	=	1'b0;
							seg_clr_2	=	1'b0;
						end					
	OPT_BLEN		:	begin
							incr_en_1	=	1'b0;
							incr_en_2	=	1'b0;
							decr_en_1	=	1'b0;
							decr_en_2	=	1'b0;
							seg_clr_1	=	1'b0;
							seg_clr_2	=	1'b0;
						end
	OPT_STORE	,
	OPT_DONE		:	begin
							incr_en_1	=	1'b0;
							incr_en_2	=	1'b0;
							decr_en_1	=	1'b0;
							decr_en_2	=	1'b0;
							seg_clr_1	=	1'b0;
							seg_clr_2	=	1'b0;
						end		
	default		:	begin
							incr_en_1	=	1'b0;
							incr_en_2	=	1'b0;
							decr_en_1	=	1'b0;
							decr_en_2	=	1'b0;
							seg_clr_1	=	1'b0;
							seg_clr_2	=	1'b0;
						end
	endcase
end

// FSM OPT BL count RAM signal
always @ (*)
begin
	case(current_state)
	IDLE			,
	READ_LEAF	,
	MID_NODE		,
	ROOT_NODE	,
	TRACE_DONE	,
	WAIT_ARRAY	,
	GET_OVERFLOW,					
	SCAN_BLCNT	,					
	OPT_BLEN		:	begin
							opt_bl_wea		=	1'b0;
							opt_bl_dina		=	9'b0;
							opt_bl_addra	=	4'b0;
							opt_bl_web		=	1'b0;
							opt_bl_dinb		=	9'b0;
							opt_bl_addrb	=	4'b0;
						end
	OPT_STORE	:	begin
							if(bl_store_cnt >= 5'h01)
							begin
								if(bl_store_cnt_d1[3:0] != 4'b0)		// jump bl_count[0] for overflow
									opt_bl_wea	=	1'b1;
								else
									opt_bl_wea	=	1'b0;
								opt_bl_web	=	1'b1;
							end
							else
							begin
								opt_bl_wea	=	1'b0;
								opt_bl_web	=	1'b0;
							end
							opt_bl_dina		=	bl_counta;
							opt_bl_addra	=	bl_store_cnt_d1[3:0];
							opt_bl_dinb		=	bl_countb;
							opt_bl_addrb	=	bl_store_cnt_d1[3:0] + 1'b1;
						end
	OPT_DONE		:	begin
							opt_bl_wea		=	1'b0;
							opt_bl_dina		=	9'b0;
							opt_bl_addra	=	bl_cnt_addra;
							opt_bl_web		=	1'b0;
							opt_bl_dinb		=	9'b0;
							opt_bl_addrb	=	bl_cnt_addrb;
						end		
	default		:	begin
							opt_bl_wea		=	1'b0;
							opt_bl_dina		=	9'b0;
							opt_bl_addra	=	4'b0;
							opt_bl_web		=	1'b0;
							opt_bl_dinb		=	9'b0;
							opt_bl_addrb	=	4'b0;
						end
	endcase
end



/////////////////////////////////////////////////
////					Sub Modules						////
/////////////////////////////////////////////////
// Bit length counter array 1 for BL_COUNT[i]
reg_array_16x9bit	U_blcount_1
(
	// global clock and reset
	.clk				(clk),
	.rstN				(rstN),
	// access signal
	.addr				(array1_addra),	
	.addr_aux		(array1_addrb),
	.incr_en			(incr_en_1),
	.decr_en			(decr_en_1),
	.bl_count		(bl_count1a),
	.bl_count_aux	(bl_count1b),
	.busy				(array1_busy)
);

// Bit length counter array 2 for BL_COUNT[i]
reg_array_16x9bit	U_blcount_2
(
	// global clock and reset
	.clk				(clk),
	.rstN				(rstN),
	// access signal
	.addr				(array2_addra),	
	.addr_aux		(array2_addrb),
	.incr_en			(incr_en_2),
	.decr_en			(decr_en_2),
	.bl_count		(bl_count2a),
	.bl_count_aux	(bl_count2b),
	.busy				(array2_busy)
);

// Optimous Bit length counter  ram for BL_COUNT[i]
ram_16x9bit	U_opt_blcount
(
  .clka		(clk),
  .wea		(opt_bl_wea),	
  .addra		(opt_bl_addra),
  .dina		(opt_bl_dina),	
  .clkb		(clk),
  .web		(opt_bl_web),	
  .addrb		(opt_bl_addrb),
  .dinb		(opt_bl_dinb),
  
  .douta		(opt_bl_douta),
  .doutb		(opt_bl_doutb)
);


endmodule
