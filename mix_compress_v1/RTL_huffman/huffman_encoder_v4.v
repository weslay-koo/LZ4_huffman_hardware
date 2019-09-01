`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:18:04 08/15/2016 
// Design Name: 
// Module Name:    huffman_encoder 
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
//	Release v3.0 included sort network and speed up
//	Release v4.0 add signal "stat_end" signal to let this module know when statistic
//						has been terminated.
//						add "stat_empty" signal to indicate the data in statistic fifo all 
//						has been encoded. Wait for new data from in_data port.
//	Release v5.0 add Debug port of tree rams
//
//////////////////////////////////////////////////////////////////////////////////
module huffman_encoder_v4(
// global clock and reset
input wire				clk,
input wire				rstN,
input wire				start,
input wire				clean,
output reg				done,
// statistic status indicator
output wire				stat_empty,
// data input
input wire	[31:0]	in_data,
input wire				in_valid,
input wire				stat_end,
input wire	[2:0]		last_mask,
input wire				in_end,
output wire				in_full,
// code output
input wire				out_en,
output wire	[31:0]	out_data,
output wire				out_valid,
output wire				out_empty,
output wire				out_full,
output wire				out_hfull
);

//////////////// FSM status ////////////////
parameter		IDLE				=	4'h0;
parameter		STAT_START		=	4'h1;
parameter		STAT_WAIT		=	4'h2;
parameter		SORT_START		=	4'h3;
parameter		SORT_WAIT		=	4'h4;
parameter		TREE_START		=	4'h5;
parameter		TREE_WAIT		=	4'h6;
parameter		BL_START			=	4'h7;
parameter		BL_WAIT			=	4'h8;
parameter		VLC_START		=	4'h9;
parameter		VLC_WAIT			=	4'hA;
parameter		ENCODE_START	=	4'hB;
parameter		ENCODE_WAIT		=	4'hC;
parameter		CLEAN				=	4'hD;
parameter		DONE				=	4'hE;
////////////////////////////////////////////

// FSM signal
reg	[3:0]		current_state,next_state;
// External start signal delay
reg				start_d1,start_d2;
// freqence ram signal
reg	[31:0]	stat_data;
reg	[2:0]		stat_mask;
reg				stat_valid;
wire				freq_busy;
reg				freq_clean;
reg				freq_stat;
wire	[17:0]	freq_value1a,freq_value1b,
					freq_value2a,freq_value2b,
					freq_value3a,freq_value3b,
					freq_value4a,freq_value4b;
wire				freq_valid;
wire	[7:0]		freq_addr1a,freq_addr1b,
					freq_addr2a,freq_addr2b,
					freq_addr3a,freq_addr3b,
					freq_addr4a,freq_addr4b;
wire				freq_oe;	
// heap sort signal
reg				heap_sort_start;
wire				heap_sort_done;	
wire				sorted_wea;
wire	[6:0]		sorted_addra;
wire	[35:0]	sorted_dina;
wire	[35:0]	sorted_douta;
wire				sorted_web;
wire	[6:0]		sorted_addrb;
wire	[35:0]	sorted_dinb;
wire	[35:0]	sorted_doutb;
wire				sorted_wec;
wire	[6:0]		sorted_addrc;
wire	[35:0]	sorted_dinc;
wire	[35:0]	sorted_doutc;
wire				sorted_wed;
wire	[6:0]		sorted_addrd;
wire	[35:0]	sorted_dind;
wire	[35:0]	sorted_doutd;
// tree generation logic signal
reg				build_tree_start;
wire				build_tree_done;
wire	[9:0]		tree_even_douta;
wire	[9:0]		tree_even_doutb;
wire	[9:0]		tree_odd_douta;
wire	[9:0]		tree_odd_doutb;
wire	[7:0]		tree_even_addra;
wire	[7:0]		tree_even_addrb;
wire	[7:0]		tree_odd_addra;
wire	[7:0]		tree_odd_addrb;
// Tree trace and bl_gen signal
reg				trace_start;
wire				gen_done;
wire	[8:0]		bl_cnt_douta,bl_cnt_doutb;	
wire	[3:0]		bl_cnt_addra,bl_cnt_addrb;
// vlc table signal
reg				vlc_start;
wire				vlc_done;
wire	[7:0]		vlc_addra_in,vlc_addrb_in,vlc_addrc_in,vlc_addrd_in;
wire	[19:0]	vlc_douta,vlc_doutb,vlc_doutc,vlc_doutd;
// encoder signal
reg				encode_start;
wire				encode_done;
reg	[31:0]	src_len;
// Heap RAM for bit length optimous
wire				heap_even_wea,heap_even_web,heap_odd_wea,heap_odd_web;
wire	[6:0]		heap_even_addra,heap_even_addrb,heap_odd_addra,heap_odd_addrb;
wire	[7:0]		heap_even_dina,heap_even_dinb,heap_odd_dina,heap_odd_dinb;
wire				heap_even_rd,heap_odd_rd;
wire	[7:0]		heap_even_dout,heap_odd_dout;
wire				heap_even_valid,heap_odd_valid;
wire				heap_rd,heap_valid,heap_empty;
wire	[31:0]	heap_dout;
// bl table signal
wire	[6:0]		blt_even_waddr,blt_odd_waddr;
wire				blt_even_wr,blt_odd_wr;
wire	[3:0]		blt_even_wdata,blt_odd_wdata;
wire				blt_rd,blt_valid,blt_empty;
wire	[31:0]	blt_dout;
// input data FIFO signal
wire	[31:0]	src_data;	
wire				src_valid,src_empty,rd_src;
reg	[31:0]	src_len_cnt;
// in_end delay
reg				in_end_d1;
// stat_end delay		
reg				stat_end_d1;
// last data has been counted indicator
reg				last_added;

/////////////////////////////////////////////////
////			Dividual Combination Logic 		////
/////////////////////////////////////////////////
// statistic status signal generation
assign			stat_empty	=	src_empty;

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

// source file length counter
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		src_len_cnt	<=	32'b0;
		start_d2		<=	1'b0;
		start_d1		<=	1'b0;
		last_added	<=	1'b0;
	end
	else
	begin
		start_d2		<=	start_d1;
		start_d1		<=	start;
		if(done)
		begin
			src_len_cnt	<=	32'b0;
			last_added	<=	1'b0;
		end
		else
		begin
			if(in_valid)
			begin
				if(in_end & (~last_added))
				begin
					src_len_cnt	<=	src_len_cnt	+ last_mask;
					last_added	<=	1'b1;
				end
				else
				begin
					src_len_cnt	<=	src_len_cnt	+ 3'h4;
					last_added	<=	1'b0;
				end
			end
			else
			begin
				if(in_end & (~last_added))
				begin
					src_len_cnt	<=	src_len_cnt + last_mask;
					last_added	<=	1'b1;
				end
				else
				begin
					src_len_cnt	<=	src_len_cnt;
					last_added	<=	last_added;
				end
			end
		end
	end
end

// in_end delay
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		in_end_d1	<=	1'b0;
	end
	else
	begin
		in_end_d1	<=	in_end;
	end
end

// stat_end delay
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		stat_end_d1	<=	1'b0;
	end
	else
	begin
		stat_end_d1	<=	stat_end;
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
							if(clean)
								next_state	=	CLEAN;
							else if(start)
								next_state	=	STAT_START;
							else
								next_state	=	IDLE;
						end
	STAT_START	:	begin
							next_state	=	STAT_WAIT;
						end
	STAT_WAIT	:	begin
							if(in_end_d1 | stat_end_d1)
								next_state	=	SORT_START;
							else
								next_state	=	STAT_WAIT;	
						end					
	SORT_START	:	begin
							next_state	=	SORT_WAIT;
						end
	SORT_WAIT	:	begin
							if(heap_sort_done)
								next_state	=	TREE_START;
							else
								next_state	=	SORT_WAIT;
						end					
	TREE_START	:	begin
							next_state	=	TREE_WAIT;
						end
	TREE_WAIT	:	begin
							if(build_tree_done)
								next_state	=	BL_START;
							else
								next_state	=	TREE_WAIT;
						end
	BL_START		:	begin
							next_state	=	BL_WAIT;
						end
	BL_WAIT		:	begin
							if(gen_done)
								next_state	=	VLC_START;
							else
								next_state	=	BL_WAIT;
						end
	VLC_START	:	begin
							next_state	=	VLC_WAIT;
						end
	VLC_WAIT		:	begin
							if(vlc_done)
								next_state	=	ENCODE_START;
							else
								next_state	=	VLC_WAIT;
						end
	ENCODE_START:	begin
							next_state	=	ENCODE_WAIT;
						end
	ENCODE_WAIT	:	begin
							if(encode_done)
								next_state	=	DONE;
							else
								next_state	=	ENCODE_WAIT;
						end
	CLEAN			:	begin
							if(freq_busy)
								next_state	=	CLEAN;
							else
								next_state	=	DONE;
						end
	DONE			:	begin
							next_state	=	DONE;
						end
	default		:	begin
							next_state	=	IDLE;
						end
	endcase
end

// FSM control signal
always @ (*)
begin
	case(current_state)
	IDLE			:	begin
							stat_data			=	32'b0;
							stat_mask			=	3'b0;
							stat_valid			=	1'b0;
							freq_clean			=	1'b0;
							freq_stat			=	1'b0;
							heap_sort_start	=	1'b0;
							build_tree_start	=	1'b0;
							trace_start			=	1'b0;
							vlc_start			=	1'b0;
							encode_start		=	1'b0;
							src_len				=	32'b0;
							done					=	1'b0;
						end
	STAT_START	,
	STAT_WAIT	:	begin
							stat_data			=	in_data;
							stat_mask			=	in_end ? last_mask : 3'b100;
							stat_valid			=	in_valid;
							freq_clean			=	1'b0;
							freq_stat			=	1'b1;
							heap_sort_start	=	1'b0;
							build_tree_start	=	1'b0;
							trace_start			=	1'b0;
							vlc_start			=	1'b0;
							encode_start		=	1'b0;
							src_len				=	32'b0;
							done					=	1'b0;
						end					
	SORT_START	:	begin
							stat_data			=	32'b0;
							stat_mask			=	3'b0;
							stat_valid			=	1'b0;
							freq_clean			=	1'b0;
							freq_stat			=	1'b0;
							heap_sort_start	=	1'b1;
							build_tree_start	=	1'b0;
							trace_start			=	1'b0;
							vlc_start			=	1'b0;
							encode_start		=	1'b0;
							src_len				=	32'b0;
							done					=	1'b0;
						end
	SORT_WAIT	:	begin
							stat_data			=	32'b0;
							stat_mask			=	3'b0;
							stat_valid			=	1'b0;
							freq_clean			=	1'b0;
							freq_stat			=	1'b0;
							heap_sort_start	=	1'b0;
							build_tree_start	=	1'b0;
							trace_start			=	1'b0;
							vlc_start			=	1'b0;
							encode_start		=	1'b0;
							src_len				=	32'b0;
							done					=	1'b0;
						end					
	TREE_START	:	begin
							stat_data			=	32'b0;
							stat_mask			=	3'b0;
							stat_valid			=	1'b0;
							freq_clean			=	1'b0;
							freq_stat			=	1'b0;
							heap_sort_start	=	1'b0;
							build_tree_start	=	1'b1;
							trace_start			=	1'b0;
							vlc_start			=	1'b0;
							encode_start		=	1'b0;
							src_len				=	32'b0;
							done					=	1'b0;
						end
	TREE_WAIT	:	begin
							stat_data			=	32'b0;
							stat_mask			=	3'b0;
							stat_valid			=	1'b0;
							freq_clean			=	1'b0;
							freq_stat			=	1'b0;
							heap_sort_start	=	1'b0;
							build_tree_start	=	1'b0;
							trace_start			=	1'b0;
							vlc_start			=	1'b0;
							encode_start		=	1'b0;
							src_len				=	32'b0;
							done					=	1'b0;
						end
	BL_START		:	begin
							stat_data			=	32'b0;
							stat_mask			=	3'b0;
							stat_valid			=	1'b0;
							freq_clean			=	1'b0;
							freq_stat			=	1'b0;
							heap_sort_start	=	1'b0;
							build_tree_start	=	1'b0;
							trace_start			=	1'b1;
							vlc_start			=	1'b0;
							encode_start		=	1'b0;
							src_len				=	32'b0;
							done					=	1'b0;
						end
	BL_WAIT		:	begin
							stat_data			=	32'b0;
							stat_mask			=	3'b0;
							stat_valid			=	1'b0;
							freq_clean			=	1'b0;
							freq_stat			=	1'b0;
							heap_sort_start	=	1'b0;
							build_tree_start	=	1'b0;
							trace_start			=	1'b0;
							vlc_start			=	1'b0;
							encode_start		=	1'b0;
							src_len				=	32'b0;
							done					=	1'b0;
						end
	VLC_START	:	begin
							stat_data			=	32'b0;
							stat_mask			=	3'b0;
							stat_valid			=	1'b0;
							freq_clean			=	1'b0;
							freq_stat			=	1'b0;
							heap_sort_start	=	1'b0;
							build_tree_start	=	1'b0;
							trace_start			=	1'b0;
							vlc_start			=	1'b1;
							encode_start		=	1'b0;
							src_len				=	32'b0;
							done					=	1'b0;
						end
	VLC_WAIT		:	begin
							stat_data			=	32'b0;
							stat_mask			=	3'b0;
							stat_valid			=	1'b0;
							freq_clean			=	1'b0;
							freq_stat			=	1'b0;
							heap_sort_start	=	1'b0;
							build_tree_start	=	1'b0;
							trace_start			=	1'b0;
							vlc_start			=	1'b0;
							encode_start		=	1'b0;
							src_len				=	32'b0;
							done					=	1'b0;
						end
	ENCODE_START:	begin
							stat_data			=	32'b0;
							stat_mask			=	3'b0;
							stat_valid			=	1'b0;
							freq_clean			=	1'b0;
							freq_stat			=	1'b0;
							heap_sort_start	=	1'b0;
							build_tree_start	=	1'b0;
							trace_start			=	1'b0;
							vlc_start			=	1'b0;
							encode_start		=	1'b1;
							src_len				=	src_len_cnt;
							done					=	1'b0;
						end
	ENCODE_WAIT	:	begin
							stat_data			=	32'b0;
							stat_mask			=	3'b0;
							stat_valid			=	1'b0;
							freq_clean			=	1'b0;
							freq_stat			=	1'b0;
							heap_sort_start	=	1'b0;
							build_tree_start	=	1'b0;
							trace_start			=	1'b0;
							vlc_start			=	1'b0;
							encode_start		=	1'b0;
							src_len				=	32'b0;
							done					=	1'b0;
						end
	CLEAN			:	begin
							stat_data			=	32'b0;
							stat_mask			=	3'b0;
							stat_valid			=	1'b0;
							freq_clean			=	1'b1;
							freq_stat			=	1'b0;
							heap_sort_start	=	1'b0;
							build_tree_start	=	1'b0;
							trace_start			=	1'b0;
							vlc_start			=	1'b0;
							encode_start		=	1'b0;
							src_len				=	32'b0;
							done					=	1'b0;
						end
	DONE			:	begin
							stat_data			=	32'b0;
							stat_mask			=	3'b0;
							stat_valid			=	1'b0;
							freq_clean			=	1'b0;
							freq_stat			=	1'b0;
							heap_sort_start	=	1'b0;
							build_tree_start	=	1'b0;
							trace_start			=	1'b0;
							vlc_start			=	1'b0;
							encode_start		=	1'b0;
							src_len				=	32'b0;
							done					=	1'b1;
						end
	default		:	begin
							stat_data			=	32'b0;
							stat_mask			=	3'b0;
							stat_valid			=	1'b0;
							freq_clean			=	1'b0;
							freq_stat			=	1'b0;
							heap_sort_start	=	1'b0;
							build_tree_start	=	1'b0;
							trace_start			=	1'b0;
							vlc_start			=	1'b0;
							encode_start		=	1'b0;
							src_len				=	32'b0;
							done					=	1'b0;
						end
	endcase
end


/////////////////////////////////////////////////
////					Sub Modules						////
/////////////////////////////////////////////////
// Freq RAM for 32bit data input 
// 8 bit data statistic, data input for statistic up to 64KB
freq_ram_256x18bit	U_freq_ram_256x18bit
(
	// global clock and reset
	.clk					(clk),
	.rstN					(rstN),
	.stat_en				(freq_stat),
	.clean				(freq_clean),
	.busy					(freq_busy),
	// data input
	.in_data				(stat_data),
	.in_mask				(stat_mask),
	.in_valid			(stat_valid),
	// freq output
	.freq_value1a		(freq_value1a	),
	.freq_value1b		(freq_value1b	),
	.freq_value2a		(freq_value2a	),
	.freq_value2b		(freq_value2b	),
	.freq_value3a		(freq_value3a	),
	.freq_value3b		(freq_value3b	),
	.freq_value4a		(freq_value4a	),
	.freq_value4b		(freq_value4b	),
	.freq_valid			(freq_valid		),
	.freq_addr1a		(freq_addr1a	),
	.freq_addr1b		(freq_addr1b	),
	.freq_addr2a		(freq_addr2a	),
	.freq_addr2b		(freq_addr2b	),
	.freq_addr3a		(freq_addr3a	),
	.freq_addr3b		(freq_addr3b	),
	.freq_addr4a		(freq_addr4a	),
	.freq_addr4b		(freq_addr4b	),
	.freq_oe				(freq_oe			)
);

// Heap sorter Logic
heap_sorter_v3		U_heap_sorter
(
	// global clock and reset
	.clk						(clk),
	.rstN						(rstN),
	// control and status signal
	.heap_sort_start		(heap_sort_start),
	.heap_sort_done		(heap_sort_done),
	// sorted RAM Interface
	.sorted_even_wea		(sorted_wea		),
	.sorted_even_addra	(sorted_addra	),
	.sorted_even_dina		(sorted_dina	),
	.sorted_even_douta	(sorted_douta	),
	.sorted_even_web		(sorted_web		),
	.sorted_even_addrb	(sorted_addrb	),
	.sorted_even_dinb		(sorted_dinb	),
	.sorted_even_doutb	(sorted_doutb	),
	.sorted_odd_wea		(sorted_wec		),
	.sorted_odd_addra		(sorted_addrc	),
	.sorted_odd_dina		(sorted_dinc	),
	.sorted_odd_douta		(sorted_doutc	),
	.sorted_odd_web		(sorted_wed		),
	.sorted_odd_addrb		(sorted_addrd	),
	.sorted_odd_dinb		(sorted_dind	),
	.sorted_odd_doutb		(sorted_doutd	),
	// frequency statistic RAM Interface
	.freq_value1a			(freq_value1a	),
	.freq_value1b			(freq_value1b	),
	.freq_value2a			(freq_value2a	),
	.freq_value2b			(freq_value2b	),
	.freq_value3a			(freq_value3a	),
	.freq_value3b			(freq_value3b	),
	.freq_value4a			(freq_value4a	),
	.freq_value4b			(freq_value4b	),
	.freq_valid				(freq_valid		),
	.freq_addr1a			(freq_addr1a	),
	.freq_addr1b			(freq_addr1b	),
	.freq_addr2a			(freq_addr2a	),
	.freq_addr2b			(freq_addr2b	),
	.freq_addr3a			(freq_addr3a	),
	.freq_addr3b			(freq_addr3b	),
	.freq_addr4a			(freq_addr4a	),
	.freq_addr4b			(freq_addr4b	),
	.freq_oe					(freq_oe			),
	// sorter module heap output for restuct BL_TABLE in vlc_table module interface
	.heap_even_wea			(heap_even_wea		),
	.heap_even_addra		(heap_even_addra	),
	.heap_even_dina		(heap_even_dina	),
	.heap_even_web			(heap_even_web		),
	.heap_even_addrb		(heap_even_addrb	),
	.heap_even_dinb		(heap_even_dinb	),
	.heap_odd_wea			(heap_odd_wea		),
	.heap_odd_addra		(heap_odd_addra	),
	.heap_odd_dina			(heap_odd_dina		),
	.heap_odd_web			(heap_odd_web		),
	.heap_odd_addrb		(heap_odd_addrb	),
	.heap_odd_dinb			(heap_odd_dinb		)
);

// Huffman Tree generation Logic
tree_build	U_tree_build
(
	// global clock and reset
	.clk						(clk),
	.rstN						(rstN),
	// control and status signal
	.build_tree_start		(build_tree_start	),
	.build_tree_done		(build_tree_done	),
	// sorted RAM Interface
	.sorted_wea				(sorted_wea			),
	.sorted_addra			(sorted_addra		),
	.sorted_dina			(sorted_dina		),
	.sorted_douta			(sorted_douta		),
	.sorted_web				(sorted_web			),
	.sorted_addrb			(sorted_addrb		),
	.sorted_dinb			(sorted_dinb		),
	.sorted_doutb			(sorted_doutb		),
	.sorted_wec				(sorted_wec			),
	.sorted_addrc			(sorted_addrc		),
	.sorted_dinc			(sorted_dinc		),
	.sorted_doutc			(sorted_doutc		),
	.sorted_wed				(sorted_wed			),
	.sorted_addrd			(sorted_addrd		),
	.sorted_dind			(sorted_dind		),
	.sorted_doutd			(sorted_doutd		),
	// tree RAM Interface
	.tree_even_addra		(tree_even_addra	),
	.tree_even_addrb		(tree_even_addrb	),
	.tree_odd_addra		(tree_odd_addra	),
	.tree_odd_addrb		(tree_odd_addrb	),
	.tree_even_douta		(tree_even_douta	),
	.tree_even_doutb		(tree_even_doutb	),
	.tree_odd_douta		(tree_odd_douta	),
	.tree_odd_doutb		(tree_odd_doutb	)
);


// Heap for Bit Length optimous
little_root_heap	U_little_root_heap
(
	// global clock and reset
	.clk					(clk),
	.rstN					(rstN),
	// sorter module heap output for restuct BL_TABLE in vlc_table module interface
	.heap_even_wea		(heap_even_wea		),
	.heap_even_addra	(heap_even_addra	),
	.heap_even_dina	(heap_even_dina	),
	.heap_even_web		(heap_even_web		),
	.heap_even_addrb	(heap_even_addrb	),
	.heap_even_dinb	(heap_even_dinb	),
	.heap_odd_wea		(heap_odd_wea		),
	.heap_odd_addra	(heap_odd_addra	),
	.heap_odd_dina		(heap_odd_dina		),
	.heap_odd_web		(heap_odd_web		),
	.heap_odd_addrb	(heap_odd_addrb	),
	.heap_odd_dinb		(heap_odd_dinb		),
	// Read Heap by FIFO interface
	.heap_even_rd		(heap_even_rd		),
	.heap_even_dout	(heap_even_dout	),
	.heap_even_valid	(heap_even_valid	),
	.heap_odd_rd		(heap_odd_rd		),
	.heap_odd_dout		(heap_odd_dout		),
	.heap_odd_valid	(heap_odd_valid	),
	// Read Heap from min element by FIFO interface
	.heap_rd				(heap_rd		),
	.heap_dout			(heap_dout	),
	.heap_valid			(heap_valid	),
	.heap_empty			(heap_empty	)
);

// bit length counters
bit_len_gen		U_bit_len_gen
(
	// global clock and reset
	.clk					(clk	),
	.rstN					(rstN	),
	// control and status signal
	.trace_start		(trace_start),
	.gen_done			(gen_done	),
	// tree RAM Interface
	.tree_even_douta	(tree_even_douta	),
	.tree_even_doutb	(tree_even_doutb	),
	.tree_odd_douta	(tree_odd_douta	),
	.tree_odd_doutb	(tree_odd_doutb	),
	.tree_even_addra	(tree_even_addra	),
	.tree_even_addrb	(tree_even_addrb	),
	.tree_odd_addra	(tree_odd_addra	),
	.tree_odd_addrb	(tree_odd_addrb	),
	// Bit Length RAM interface
	.bl_cnt_addra		(bl_cnt_addra	),
	.bl_cnt_douta		(bl_cnt_douta	),
	.bl_cnt_addrb		(bl_cnt_addrb	),
	.bl_cnt_doutb		(bl_cnt_doutb	)
);

// Huffman encoder which use huffman tree
vlc_table_v3	U_vlc_table
(
	// global clock and reset
	.clk					(clk),
	.rstN					(rstN),
	// control and status signal
	.vlc_start			(vlc_start	),
	.vlc_done			(vlc_done	),
	// BL RAM Interface
	.bl_cnt_addra		(bl_cnt_addra	),
	.bl_cnt_douta		(bl_cnt_douta	),
	.bl_cnt_addrb		(bl_cnt_addrb	),
	.bl_cnt_doutb		(bl_cnt_doutb	),
	// Read Heap by FIFO interface
	.heap_even_rd		(heap_even_rd		),
	.heap_even_dout	(heap_even_dout	),
	.heap_even_valid	(heap_even_valid	),
	.heap_odd_rd		(heap_odd_rd		),
	.heap_odd_dout		(heap_odd_dout		),
	.heap_odd_valid	(heap_odd_valid	),
	// Encode VLC Table interface
	.vlc_addra_in		(vlc_addra_in	),
	.vlc_addrb_in		(vlc_addrb_in	),
	.vlc_addrc_in		(vlc_addrc_in	),
	.vlc_addrd_in		(vlc_addrd_in	),
	.vlc_douta			(vlc_douta		),
	.vlc_doutb			(vlc_doutb		),
	.vlc_doutc			(vlc_doutc		),
	.vlc_doutd			(vlc_doutd		),
	// BL Table interface
	.blt_even_waddr	(blt_even_waddr),
	.blt_even_wr		(blt_even_wr	),
	.blt_even_wdata	(blt_even_wdata),
	.blt_odd_waddr		(blt_odd_waddr	),
	.blt_odd_wr			(blt_odd_wr		),
	.blt_odd_wdata		(blt_odd_wdata	)
);

// bl table for code value 0~255
bl_table		U_bl_table
(
	// global clock and reset
	.clk					(clk),
	.rstN					(rstN),
	// bl table ram write RAM interface
	.blt_even_waddr	(blt_even_waddr),
	.blt_even_wr		(blt_even_wr	),
	.blt_even_wdata	(blt_even_wdata),
	.blt_odd_waddr		(blt_odd_waddr	),
	.blt_odd_wr			(blt_odd_wr		),
	.blt_odd_wdata		(blt_odd_wdata	),
	// bl table ram read FIFO interface
	.blt_rd				(blt_rd	),
	.blt_dout			(blt_dout),
	.blt_valid			(blt_valid),
	.blt_empty			(blt_empty)
);

// Source data FIFO
fifo_16kx32bit	U_src_fifo	// fifo_4kx32bit
(
  .clk			(clk),
  .rst			(~rstN),
  .din			(in_data),
  .wr_en			(in_valid),
  .rd_en			(rd_src),	
                  	
  .dout			(src_data),	
  .full			(in_full),		
  .empty			(src_empty),
  .valid			(src_valid),
  .data_count	()
);

// VLC encode and glue logic
encode_v3	U_encode
(
	// global clock and reset
	.clk				(clk),
	.rstN				(rstN),
	// control and status signal
	.encode_start	(encode_start),
	.last_mask		(last_mask	),
	.encode_done	(encode_done),
	// bl table ram read FIFO interface
	.blt_rd			(blt_rd		),	
	.blt_dout		(blt_dout	),
	.blt_valid		(blt_valid	),
	.blt_empty		(blt_empty	),
	// Read Heap from min element by FIFO interface
	.heap_rd			(heap_rd		),
	.heap_dout		(heap_dout	),
	.heap_valid		(heap_valid	),
	.heap_empty		(heap_empty	),
	// Encode VLC Table interface
	.vlc_douta		(vlc_douta	),
	.vlc_doutb		(vlc_doutb	),
	.vlc_doutc		(vlc_doutc	),
	.vlc_doutd		(vlc_doutd	),
	.vlc_addra		(vlc_addra_in),
	.vlc_addrb		(vlc_addrb_in),
	.vlc_addrc		(vlc_addrc_in),
	.vlc_addrd		(vlc_addrd_in),
	// input source data
	.src_data		(src_data	),
	.src_valid		(src_valid	),
	.src_empty		(src_empty	),
	.src_end			(in_end		),
	.src_len			(src_len_cnt),	// indicate the source data count (change in compression processing)
	.rd_src			(rd_src		),
	// encoded data out FIFO interface
	.rd_encode		(out_en		),
	.encode_data	(out_data	),
	.encode_valid	(out_valid	),
	.encode_empty	(out_empty	),
	.encode_full	(out_full	),
	.encode_hfull	(out_hfull	)
);



endmodule
