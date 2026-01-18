`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:43:53 05/29/2016 
// Design Name: 
// Module Name:    tree_build 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
//	Revision 2.00 - Add tree odd and even ram debug port		
//	Revision 3.00 - Add Round Robin function to balance EVEN and ODD tree ram address values
//							When noa[0] and noc[0] is all 0, 2 ports of EVEN ram is using, so new node will be write to ODD
//							When noa[0] and noc[0] is all 1, 2 ports of ODD ram is using, so new node will be write to EVEN
//							When noa[0] is 0(1) and noc[0] is 1(0), 1 ports of EVEN and ODD ram is using,so new node will be 
//								write to EVEN or ODD will be decided by Round Robin value, to prevent address overflow in EVEN 
//								or ODD ram
//
// Additional Comments: 
// 		36bit Frame in Sorted RAM is
// (MSB)	Node_number		Stat_freq	(LSB)
//				9bit		  	 	27bit
//
//        10bit Frame in Tree RAM is
// (MSB)	Node_attribution  Superior_node_address (LSB)
// 			1bit 							9bit        
//  	0:Left_Node 1:Right_Node
//
//////////////////////////////////////////////////////////////////////////////////
// `include "../include.v"
module tree_build_v3(
// global clock and reset
input wire				clk,
input wire				rstN,
// control and status signal
input wire				build_tree_start,
output reg				build_tree_done,
// sorted RAM Interface
output reg				sorted_wea,
output reg	[6:0]		sorted_addra,
output reg	[35:0]	sorted_dina,
input wire	[35:0]	sorted_douta,
output reg				sorted_web,
output reg	[6:0]		sorted_addrb,
output reg	[35:0]	sorted_dinb,
input wire	[35:0]	sorted_doutb,
output reg				sorted_wec,
output reg	[6:0]		sorted_addrc,
output reg	[35:0]	sorted_dinc,
input wire	[35:0]	sorted_doutc,
output reg				sorted_wed,
output reg	[6:0]		sorted_addrd,
output reg	[35:0]	sorted_dind,
input wire	[35:0]	sorted_doutd,
`ifdef DEBUG_TREE
// Debug port of huffman tree ram data
input wire				debug_en,
input wire				debug_rd,
input wire	[7:0]		debug_odd_addr,
input wire	[7:0]		debug_even_addr,
output wire	[9:0]		debug_odd_data,
output wire	[9:0]		debug_even_data,
`endif
// tree RAM Interface
input wire	[7:0]		tree_even_addra,
input wire	[7:0]		tree_even_addrb,
input wire	[7:0]		tree_odd_addra,
input wire	[7:0]		tree_odd_addrb,
output wire	[9:0]		tree_even_douta,
output wire	[9:0]		tree_even_doutb,
output wire	[9:0]		tree_odd_douta,
output wire	[9:0]		tree_odd_doutb
);

////////////// Constant Define //////////////
parameter	LEFT_NODE	= 1'b0;
parameter	RIGHT_NODE 	= 1'b1;
////////////////////////////////////////////

//////////////// FSM status ////////////////
parameter		IDLE				=	4'h0;
parameter		NODE_READ		=	4'h1;
parameter		NODE_MERGE		=	4'h2;
parameter		NODE_SKIP		=	4'h3;
parameter		NODE_SEEK		=	4'h4;
parameter		NODE_INSERT		=	4'h5;	// use insert sort to insert node
parameter		TREE_DONE		=	4'h6;
////////////////////////////////////////////

// FSM signal
reg	[3:0]		current_state,next_state;
// Tree RAM signal
reg				odd_wea,odd_web;
reg	[9:0]		odd_dina,odd_dinb;
reg	[7:0]		even_addra,even_addrb;
reg	[7:0]		odd_addra,odd_addrb;
reg				even_wea,even_web;
reg	[9:0]		even_dina,even_dinb;
// build_tree_start delay
reg				build_tree_start_d1;
// leaf node counter
reg	[8:0]		leaf_count;
reg				leaf_count_en;
// scan counter for Read date from Heap_RAM
reg	[7:0]		scan_cnt;
reg				scan_cnt_en;
// heap seek pos counter
reg	[6:0]		seek_pos1,seek_pos2,
					seek_pos1_d1,seek_pos2_d1,
					seek_pos1_d2,seek_pos2_d2;
reg				seek_pos_en,seek_pos_load;
reg				seek_done;
reg				left_rightN;
// node merge data
reg	[26:0]	merge_data;
reg				merge_en;
// root counter
reg	[8:0]		mid_addr;
reg				mid_addr_load;
// Sorted number/Node number and node statistic freq
wire	[8:0]		node_noa,node_nob,node_noc,node_nod;
wire	[26:0]	node_freqa,node_freqb,node_freqc,node_freqd;
// merge address of even and odd ram
reg	[7:0]		merge_addr_even,merge_addr_odd;
wire	[7:0]		merge_addr;
reg				merge_odd_evenN;	// wire
reg				merge_round_robin;
reg				merge_addr_incr;
// compare merge_data and data from sorted ram
wire				gt_freqa,gt_freqc;  // merge_data greater than freqx
wire				lt_freqa,lt_freqc;  // merge_data little than freqx
// Freq None zero node judgement
wire				none_zero_a,none_zero_c;

/////////////////////////////////////////////////
////			Dividual Combination Logic 		////
/////////////////////////////////////////////////
// Node number from sorted ram
assign			node_noa		=	sorted_douta[35:27];
assign			node_nob		=	sorted_doutb[35:27];
assign			node_noc		=	sorted_doutc[35:27];
assign			node_nod		=	sorted_doutd[35:27];
// Node freq value from sorted ram
assign			node_freqa	=	sorted_douta[26:0];
assign			node_freqb	=	sorted_doutb[26:0];
assign			node_freqc	=	sorted_doutc[26:0];
assign			node_freqd	=	sorted_doutd[26:0];
// ODD or EVEN merge address select signal
//assign			merge_odd_evenN	=	~node_noc[0];	// old version merge_odd_evenN signal generator
assign			merge_addr			=	merge_odd_evenN ? merge_addr_odd : merge_addr_even;
// compare merge_data and data from sorted ram
assign			gt_freqa		=	(merge_data > node_freqa) ? 1'b1 : 1'b0;
assign			gt_freqc		=	(merge_data > node_freqc) ? 1'b1 : 1'b0;
assign			lt_freqa		=	(merge_data < node_freqa) ? 1'b1 : 1'b0;
assign			lt_freqc		=	(merge_data < node_freqc) ? 1'b1 : 1'b0;
// Freq None zero node judgement
assign			none_zero_a	=	(node_freqa > 27'b0) ? 1'b1 : 1'b0;
assign			none_zero_c	=	(node_freqc > 27'b0) ? 1'b1 : 1'b0;

// merge_odd_evenN signal generator
always @ (*)
begin
	if(node_noa[0] ^ node_noc[0])
	begin
		merge_odd_evenN	=	merge_round_robin;
	end
	else
	begin
		merge_odd_evenN	=	~node_noc[0];
	end
end

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

// merge address counter for both EVEN and ODD ram
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		merge_addr_even	<=	8'b0;
		merge_addr_odd		<=	8'b0;
	end
	else
	begin
		if({build_tree_start_d1,build_tree_start}==2'b01)
			merge_addr_even	<=	8'h80;
		else if(merge_addr_incr & (~merge_odd_evenN))
			merge_addr_even	<=	merge_addr_even + 1'b1;
		else
			merge_addr_even	<=	merge_addr_even;
			
		if({build_tree_start_d1,build_tree_start}==2'b01)
			merge_addr_odd		<=	8'h80;
		else if(merge_addr_incr & merge_odd_evenN)
			merge_addr_odd		<=	merge_addr_odd + 1'b1;
		else
			merge_addr_odd		<=	merge_addr_odd;
	end
end

// merge_round_robin signal generation for balance EVEN and ODD tree ram address values
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		merge_round_robin	<=	1'b0;
	end
	else
	begin
		if(merge_addr_incr & (node_noa[0] ^ node_noc[0]))
			merge_round_robin	<=	~merge_odd_evenN;
		else
			merge_round_robin	<=	merge_round_robin;
	end
end

// build_tree_start delay
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		build_tree_start_d1	<=	1'b0;
	end
	else
	begin
		build_tree_start_d1	<=	build_tree_start;
	end
end

// leaf node counter
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		leaf_count	<=	9'b0;
	end
	else
	begin
		if({build_tree_start_d1,build_tree_start}==2'b01)
			leaf_count	<=	9'h100;
		else if(leaf_count_en)
			leaf_count	<=	leaf_count - 1'b1;
		else
			leaf_count	<=	leaf_count;
	end
end

// scan counter
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		scan_cnt	<=	8'b0;
	end
	else
	begin
		if({build_tree_start_d1,build_tree_start}==2'b01)
			scan_cnt	<=	8'h1;
		else if(scan_cnt_en)
			scan_cnt	<=	scan_cnt	+ 1'b1;
		else
			scan_cnt	<=	scan_cnt;
	end
end

// Heap seek position counter
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		seek_pos1_d2	<=	7'b0;
		seek_pos2_d2	<=	7'b0;
		seek_pos1_d1	<=	7'b0;
		seek_pos2_d1	<=	7'b0;
		seek_pos1		<=	7'b0;
		seek_pos2		<=	7'b0;
	end
	else
	begin
		if(seek_pos_load)
		begin
			seek_pos1_d2	<=	scan_cnt[7:1] - 1'b1;
			seek_pos1_d1	<=	scan_cnt[7:1];
			seek_pos1		<=	scan_cnt[7:1] + 1'b1;
			if(!scan_cnt[0])
			begin
				seek_pos1_d2	<=	scan_cnt[7:1] - 2'h2;
				seek_pos2_d1	<=	scan_cnt[7:1] - 2'h1;
				seek_pos2		<=	scan_cnt[7:1];
			end
			else
			begin
				seek_pos1_d2	<=	scan_cnt[7:1] - 1'b1;
				seek_pos2_d1	<=	scan_cnt[7:1];
				seek_pos2		<=	scan_cnt[7:1] + 1'b1;
			end
		end
		else if(seek_pos_en)
		begin
			seek_pos1_d2	<=	seek_pos1_d1;
			seek_pos2_d2	<=	seek_pos2_d1;
			seek_pos1_d1	<=	seek_pos1;
			seek_pos2_d1	<=	seek_pos2;
			seek_pos1		<= seek_pos1 + 1'b1;	
			seek_pos2		<=	seek_pos2 + 1'b1;	
		end
		else
		begin
			seek_pos1_d2	<=	seek_pos1_d2;
			seek_pos2_d2	<=	seek_pos2_d2;
			seek_pos1_d1	<=	seek_pos1_d1;
			seek_pos2_d1	<=	seek_pos2_d1;
			seek_pos1		<=	seek_pos1;
			seek_pos2		<=	seek_pos2;
		end
	end
end

// node frequency merge data
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		merge_data	<=	27'b0;
	end
	else
	begin
		if(merge_en)
			merge_data	<=	node_freqa + node_freqc;
		else
			merge_data	<=	merge_data;
	end
end

// root note counter
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		mid_addr	<=	9'b0;
	end
	else
	begin
		if({build_tree_start_d1,build_tree_start}==2'b01)
			mid_addr	<=	9'b0;
		else if(mid_addr_load)
			mid_addr	<=	{merge_addr,merge_odd_evenN};
		else
			mid_addr	<=	mid_addr;
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
							if({build_tree_start_d1,build_tree_start}==2'b01)
								next_state	=	NODE_READ;
							else
								next_state	=	IDLE;
						end
	NODE_READ	:	begin
							next_state	=	NODE_MERGE;
						end
	NODE_MERGE	:	begin
							if(none_zero_a & none_zero_c)
								next_state	=	NODE_SEEK;
							else if((!none_zero_a) & (!none_zero_c))
								next_state	=	NODE_SKIP;
							else
								next_state	=	NODE_READ;
						end
	NODE_SKIP	:	begin
							next_state	=	NODE_READ;
						end
	NODE_SEEK	:	begin
							if(seek_done)
								next_state	=	NODE_INSERT;
							else
								next_state	=	NODE_SEEK;
						end
	NODE_INSERT	:	begin
							if(leaf_count <= 9'h2)
								next_state	=	TREE_DONE;
							else
								next_state	=	NODE_READ;
						end
	TREE_DONE	:	begin
							if({build_tree_start_d1,build_tree_start}==2'b01)
								next_state	=	NODE_READ;
							else
								next_state	=	TREE_DONE;
						end
	default		:	begin
							next_state	=	IDLE;
						end
	endcase
end


// FSM control Signal
always @ (*)
begin
	case(current_state)
	IDLE			:	begin
							leaf_count_en	=	1'b0;
							scan_cnt_en		=	1'b0;
							seek_pos_load	=	1'b0;
							seek_pos_en		=	1'b0;
							merge_en			=	1'b0;
							seek_done		=	1'b0;
							left_rightN		=	1'b0;
							build_tree_done=	1'b0;
						end
	NODE_READ	:	begin
							leaf_count_en	=	1'b0;
							scan_cnt_en		=	1'b0;
							seek_pos_load	=	1'b1;
							seek_pos_en		=	1'b0;
							merge_en			=	1'b0;
							seek_done		=	1'b0;
							left_rightN		=	1'b0;
							build_tree_done=	1'b0;
						end
	NODE_MERGE	:	begin
							if(none_zero_a & none_zero_c)
							begin
								leaf_count_en	=	1'b0;
								scan_cnt_en		=	1'b0;
							end
							else
							begin
								leaf_count_en	=	1'b1;
								scan_cnt_en		=	1'b1;
							end
							if(none_zero_a & none_zero_c)
							begin
								seek_pos_en		=	1'b1;
								merge_en			=	1'b1;
							end
							else
							begin
								seek_pos_en		=	1'b0;
								merge_en			=	1'b0;
							end
							seek_pos_load	=	1'b0;
							seek_done		=	1'b0;
							left_rightN		=	1'b0;
							build_tree_done=	1'b0;
						end
	NODE_SKIP	:	begin
							leaf_count_en	=	1'b1;
							scan_cnt_en		=	1'b1;
							seek_pos_en		=	1'b0;
							seek_pos_load	=	1'b0;
							merge_en			=	1'b0;
							seek_done		=	1'b0;
							left_rightN		=	1'b0;
							build_tree_done=	1'b0;
						end
	NODE_SEEK	:	begin
							leaf_count_en	=	1'b0;
							scan_cnt_en		=	1'b0;
							seek_pos_load	=	1'b0;
							build_tree_done=	1'b0;
							merge_en			=	1'b0;
							if(	((!gt_freqa) && (!scan_cnt[0]))
								|| ((!gt_freqc) && scan_cnt[0])
								||	((seek_pos1_d2 >= 7'h7F) || (seek_pos2_d2 >= 7'h7F))	)
							begin
								seek_done	=	1'b1;
								seek_pos_en	=	1'b0;
							end
							else
							begin
								seek_done	=	1'b0;
								seek_pos_en	=	1'b1;
							end
							
							if(	((!lt_freqa) & lt_freqc & scan_cnt[0]) 
								||	((!lt_freqc) & lt_freqa & (!scan_cnt[0])) )
								left_rightN		=	1'b1;
							else
								left_rightN		=	1'b0;
						end
	NODE_INSERT	:	begin
							leaf_count_en	=	1'b1;
							scan_cnt_en		=	1'b1;
							seek_pos_en		=	1'b0;
							seek_pos_load	=	1'b0;
							merge_en			=	1'b0;
							seek_done		=	1'b0;
							left_rightN		=	1'b0;
							build_tree_done=	1'b0;
						end
	TREE_DONE	:	begin
							leaf_count_en	=	1'b0;
							scan_cnt_en		=	1'b0;
							seek_pos_en		=	1'b0;
							seek_pos_load	=	1'b0;
							merge_en			=	1'b0;
							seek_done		=	1'b0;
							left_rightN		=	1'b0;
							build_tree_done=	1'b1;
						end
	default		:	begin
							leaf_count_en	=	1'b0;
							scan_cnt_en		=	1'b0;
							seek_pos_en		=	1'b0;
							seek_pos_load	=	1'b0;
							merge_en			=	1'b0;
							seek_done		=	1'b0;
							left_rightN		=	1'b0;
							build_tree_done=	1'b0;
						end
	endcase
end

// FSM External Sorted RAM Signal
always @ (*)
begin
	case(current_state)
	IDLE			:	begin
							sorted_wea		=	1'b0;
							sorted_addra	=	7'b0;
							sorted_dina		=	36'b0;
							sorted_web		=	1'b0;
							sorted_addrb	=	7'b0;
							sorted_dinb		=	36'b0;
							sorted_wec		=	1'b0;
							sorted_addrc	=	7'b0;
							sorted_dinc		=	36'b0;
							sorted_wed		=	1'b0;
							sorted_addrd	=	7'b0;
							sorted_dind		=	36'b0;
						end
	NODE_READ	:	begin
							sorted_wea		=	1'b0;
							sorted_addra	=	scan_cnt[7:1];
							sorted_dina		=	36'b0;
							sorted_web		=	1'b0;
							sorted_addrb	=	7'b0;
							sorted_dinb		=	36'b0;
							sorted_wec		=	1'b0;
							if(!scan_cnt[0])  // scan_cnt indicated the element location which merge data will be stored
								sorted_addrc	=	scan_cnt[7:1] - 1'b1;
							else
								sorted_addrc	=	scan_cnt[7:1];
							sorted_dinc		=	36'b0;
							sorted_wed		=	1'b0;
							sorted_addrd	=	7'b0;
							sorted_dind		=	36'b0;
						end
	NODE_MERGE	:	begin
							sorted_wea		=	1'b0;
							if(none_zero_a & none_zero_c)
								sorted_addra	=	seek_pos1;
							else
								sorted_addra	=	7'b0;
							sorted_dina		=	36'b0;
							sorted_web		=	1'b0;
							sorted_addrb	=	7'b0;
							sorted_dinb		=	36'b0;
							sorted_wec		=	1'b0;
							if(none_zero_a & none_zero_c)
								sorted_addrc	=	seek_pos2;
							else
								sorted_addrc	=	7'b0;
							sorted_dinc		=	36'b0;
							sorted_wed		=	1'b0;
							sorted_addrd	=	7'b0;
							sorted_dind		=	36'b0;
						end
	NODE_SKIP	:	begin
							sorted_wea		=	1'b0;
							sorted_addra	=	7'b0;
							sorted_dina		=	36'b0;
							sorted_web		=	1'b0;
							sorted_addrb	=	7'b0;
							sorted_dinb		=	36'b0;
							sorted_wec		=	1'b0;
							sorted_addrc	=	7'b0;
							sorted_dinc		=	36'b0;
							sorted_wed		=	1'b0;
							sorted_addrd	=	7'b0;
							sorted_dind		=	36'b0;
						end
	NODE_SEEK	:	begin
							sorted_wea		=	1'b0;
							sorted_addra	=	seek_pos1;
							sorted_dina		=	36'b0;
							sorted_wec		=	1'b0;
							sorted_addrc	=	seek_pos2;
							sorted_dinc		=	36'b0;
							if(!scan_cnt[0]) 
							begin
								if(gt_freqc & gt_freqa)
								begin
									sorted_web		=	1'b1;
									sorted_addrb	=	seek_pos1_d2;
									sorted_dinb		=	sorted_doutc;
									sorted_wed		=	1'b1;
									sorted_addrd	=	seek_pos2_d1;
									if(seek_pos1_d2 < 7'h7F)
										sorted_dind	=	sorted_douta;
									else
										sorted_dind	=	{mid_addr,merge_data};
								end
								else if(gt_freqc & (!gt_freqa))
								begin
									sorted_web		=	1'b1;
									sorted_addrb	=	seek_pos1_d2;
									sorted_dinb		=	sorted_doutc;
									sorted_wed		=	1'b1;
									sorted_addrd	=	seek_pos2_d1;
									sorted_dind		=	{mid_addr,merge_data};
								end
								else
								begin
									sorted_web		=	1'b1;
									sorted_addrb	=	seek_pos1_d2;
									sorted_dinb		=	{mid_addr,merge_data};
									sorted_wed		=	1'b0;
									sorted_addrd	=	7'b0;
									sorted_dind		=	36'b0;
								end
							end
							else
							begin
								if(gt_freqa & gt_freqc)
								begin
									sorted_addrb	=	seek_pos1_d1;
									sorted_dinb		=	sorted_doutc;
									sorted_wed		=	1'b1;
									sorted_addrd	=	seek_pos2_d2;
									if(seek_pos2_d2 < 7'h7F)
									begin
										sorted_web	=	1'b1;
										sorted_dind	=	sorted_douta;
									end
									else
									begin
										sorted_web	=	1'b0;
										sorted_dind	=	{mid_addr,merge_data};
									end
								end
								else if(gt_freqa & (!gt_freqc))
								begin
									sorted_web		=	1'b1;
									sorted_addrb	=	seek_pos1_d1;
									sorted_dinb		=	{mid_addr,merge_data};
									sorted_wed		=	1'b1;
									sorted_addrd	=	seek_pos2_d2;
									sorted_dind		=	sorted_douta;
								end
								else
								begin
									sorted_web		=	1'b0;
									sorted_addrb	=	7'b0;
									sorted_dinb		=	36'b0;
									sorted_wed		=	1'b1;
									sorted_addrd	=	seek_pos2_d2;
									sorted_dind		=	{mid_addr,merge_data};
								end
							end
						end
	NODE_INSERT	:	begin
							sorted_wea		=	1'b0;
							sorted_addra	=	7'b0;
							sorted_dina		=	36'b0;
							sorted_web		=	1'b0;
							sorted_addrb	=	7'b0;
							sorted_dinb		=	36'b0;
							sorted_wec		=	1'b0;
							sorted_addrc	=	7'b0;
							sorted_dinc		=	36'b0;
							sorted_wed		=	1'b0;
							sorted_addrd	=	7'b0;
							sorted_dind		=	36'b0;
						end
	TREE_DONE	:	begin
							sorted_wea		=	1'b0;
							sorted_addra	=	7'b0;
							sorted_dina		=	36'b0;
							sorted_web		=	1'b0;
							sorted_addrb	=	7'b0;
							sorted_dinb		=	36'b0;
							sorted_wec		=	1'b0;
							sorted_addrc	=	7'b0;
							sorted_dinc		=	36'b0;
							sorted_wed		=	1'b0;
							sorted_addrd	=	7'b0;
							sorted_dind		=	36'b0;
						end
	default		:	begin
							sorted_wea		=	1'b0;
							sorted_addra	=	7'b0;
							sorted_dina		=	36'b0;
							sorted_web		=	1'b0;
							sorted_addrb	=	7'b0;
							sorted_dinb		=	36'b0;
							sorted_wec		=	1'b0;
							sorted_addrc	=	7'b0;
							sorted_dinc		=	36'b0;
							sorted_wed		=	1'b0;
							sorted_addrd	=	7'b0;
							sorted_dind		=	36'b0;
						end
	endcase
end

// FSM Tree RAM Signal
always @ (*)
begin
	case(current_state)
	IDLE			,
	NODE_READ	:	begin
							even_wea				=	1'b0;
							even_addra			=	8'b0;
							even_dina			=	10'b0;
							even_web				=	1'b0;
							even_addrb			=	8'b0;
							even_dinb			=	10'b0;
							odd_wea				=	1'b0;
							odd_addra			=	8'b0;
							odd_dina				=	10'b0;
							odd_web				=	1'b0;
							odd_addrb			=	8'b0;
							odd_dinb				=	10'b0;
							merge_addr_incr	=	1'b0;
							mid_addr_load		=	1'b0;
						end
	NODE_MERGE	:	begin
							merge_addr_incr	=	1'b1;
							mid_addr_load		=	1'b1;
							if((~node_noa[0]) & none_zero_a & none_zero_c)				// consider as a leaf node
							begin
								even_wea		=	1'b1;
								even_addra	=	node_noa[8:1];
								if(!scan_cnt[0])
									even_dina	=	{RIGHT_NODE,merge_addr,merge_odd_evenN};
								else
									even_dina	=	{LEFT_NODE,merge_addr,merge_odd_evenN};
							end
							else if((	(node_noa[0] & node_noc[0] & (~merge_round_robin)) 
										| 	(node_noa[0] & (~node_noc[0]) & (~merge_round_robin)) ) 
										& none_zero_a & none_zero_c)	// consider as a root or mid node
							begin
								even_wea		=	1'b1;
								even_addra	=	merge_addr;
								even_dina	=	{1'b0,merge_addr,1'b0};
							end
							else
							begin
								even_wea		=	1'b0;
								even_addra	=	8'b0;
								even_dina	=	10'b0;
							end
							
							if((~node_noc[0]) & none_zero_a & none_zero_c)				// consider as a leaf node
							begin
								even_web		=	1'b1;
								even_addrb	=	node_noc[8:1];
								if(!scan_cnt[0])
									even_dinb	=	{LEFT_NODE,merge_addr,merge_odd_evenN};
								else
									even_dinb	=	{RIGHT_NODE,merge_addr,merge_odd_evenN};
							end
							else if((	((~node_noa[0]) & node_noc[0] & (~merge_round_robin))
										|	(node_noa[0] & node_noc[0] & merge_round_robin)) 
										& none_zero_a & none_zero_c) // consider as a root or mid node
							begin
								even_web		=	1'b1;
								even_addrb	=	merge_addr;
								even_dinb	=	{1'b0,merge_addr,1'b0};
							end
							else
							begin
								even_web		=	1'b0;
								even_addrb	=	8'b0;
								even_dinb	=	10'b0;
							end
							
							if(node_noa[0] & none_zero_a & none_zero_c)				// consider as a leaf node
							begin
								odd_wea		=	1'b1;
								odd_addra	=	node_noa[8:1];
								if(!scan_cnt[0])
									odd_dina	=	{RIGHT_NODE,merge_addr,merge_odd_evenN};
								else
									odd_dina	=	{LEFT_NODE,merge_addr,merge_odd_evenN};
							end
							else if((	((~node_noa[0]) & (~node_noc[0]) & merge_round_robin)
										|	((~node_noa[0]) & node_noc[0] & merge_round_robin))
										& none_zero_a & none_zero_c) // consider as a root or mid node
							begin
								odd_wea		=	1'b1;
								odd_addra	=	merge_addr;
								odd_dina		=	{1'b0,merge_addr,1'b1};
							end
							else
							begin
								odd_wea		=	1'b0;
								odd_addra	=	8'b0;
								odd_dina		=	10'b0;
							end
							
							if(node_noc[0] & none_zero_a & none_zero_c)				// consider as a leaf node
							begin
								odd_web		=	1'b1;
								odd_addrb	=	node_noc[8:1];
								if(!scan_cnt[0])
									odd_dinb	=	{LEFT_NODE,merge_addr,merge_odd_evenN};
								else
									odd_dinb	=	{RIGHT_NODE,merge_addr,merge_odd_evenN};
							end
							else if((	(node_noa[0] & (~node_noc[0]) & merge_round_robin)
										|	((~node_noa[0]) & (~node_noc[0]) & (~merge_round_robin)))
										& none_zero_a & none_zero_c)	// consider as a root or mid node
							begin
								odd_web		=	1'b1;
								odd_addrb	=	merge_addr;
								odd_dinb		=	{1'b0,merge_addr,1'b1};
							end
							else
							begin
								odd_web		=	1'b0;
								odd_addrb	=	8'b0;
								odd_dinb		=	10'b0;
							end
						end
	NODE_SKIP	,
	NODE_SEEK	,
	NODE_INSERT	:	begin
							even_wea				=	1'b0;
							even_addra			=	8'b0;
							even_dina			=	10'b0;
							even_web				=	1'b0;
							even_addrb			=	8'b0;
							even_dinb			=	10'b0;
							odd_wea				=	1'b0;
							odd_addra			=	8'b0;
							odd_dina				=	10'b0;
							odd_web				=	1'b0;
							odd_addrb			=	8'b0;
							odd_dinb				=	10'b0;
							merge_addr_incr	=	1'b0;
							mid_addr_load		=	1'b0;
						end
	TREE_DONE	:	begin
							even_wea				=	1'b0;
							even_addra			=	tree_even_addra;
							even_dina			=	10'b0;
							even_web				=	1'b0;
							even_addrb			=	tree_even_addrb;
							even_dinb			=	10'b0;
							odd_wea				=	1'b0;
							odd_addra			=	tree_odd_addra;
							odd_dina				=	10'b0;
							odd_web				=	1'b0;
							odd_addrb			=	tree_odd_addrb;
							odd_dinb				=	10'b0;
							merge_addr_incr	=	1'b0;
							mid_addr_load		=	1'b0;
						end
	default		:	begin
							even_wea				=	1'b0;
							even_addra			=	8'b0;
							even_dina			=	10'b0;
							even_web				=	1'b0;
							even_addrb			=	8'b0;
							even_dinb			=	10'b0;
							odd_wea				=	1'b0;
							odd_addra			=	8'b0;
							odd_dina				=	10'b0;
							odd_web				=	1'b0;
							odd_addrb			=	8'b0;
							odd_dinb				=	10'b0;
							merge_addr_incr	=	1'b0;
							mid_addr_load		=	1'b0;
						end
	endcase
end


/////////////////////////////////////////////////
////					Sub Modules						////
/////////////////////////////////////////////////
// Tree EVEN ram 256*10bit
ram_256x10bit U_tree_even_ram
(
  .clka		(clk),
  .wea		(even_wea),
  .addra		(even_addra),
  .dina		(even_dina),
  .clkb		(clk),
  .web		(even_web),
  .addrb		(even_addrb),
  .dinb		(even_dinb),
  
  .douta		(tree_even_douta),
  .doutb		(tree_even_doutb)
);

// Tree ODD ram 256*10bit
ram_256x10bit U_tree_odd_ram
(
  .clka		(clk),
  .wea		(odd_wea),
  .addra		(odd_addra),
  .dina		(odd_dina),
  .clkb		(clk),
  .web		(odd_web),
  .addrb		(odd_addrb),
  .dinb		(odd_dinb),
  
  .douta		(tree_odd_douta),
  .doutb		(tree_odd_doutb)
);

`ifdef DEBUG_TREE
// Tree EVEN mirror ram for Debug
ram_256x10bit U_mirror_even_ram
(
  .clka		(clk),
  .wea		(debug_en ? debug_rd : even_wea),
  .addra		(debug_en ? debug_even_addr : even_addra),
  .dina		(even_dina),
  .clkb		(clk),
  .web		(even_web),
  .addrb		(even_addrb),
  .dinb		(even_dinb),
  
  .douta		(debug_even_data),
  .doutb		()
);

// Tree ODD mirror ram for Debug
ram_256x10bit U_mirror_odd_ram
(
  .clka		(clk),
  .wea		(debug_en ? debug_rd : odd_wea),
  .addra		(debug_en ? debug_odd_addr : odd_addra),
  .dina		(odd_dina),
  .clkb		(clk),
  .web		(odd_web),
  .addrb		(odd_addrb),
  .dinb		(odd_dinb),
  
  .douta		(debug_odd_data),
  .doutb		()
);
`endif

endmodule
