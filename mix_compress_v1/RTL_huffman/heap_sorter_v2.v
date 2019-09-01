`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:49:32 05/29/2016 
// Design Name: 
// Module Name:    heap_sorter_v2 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 1.01 - File Created
//	Revision 2.01 - Added Heap out to external RAM and gurantee little node number nodes 
//								will be stored in higher address
// Additional Comments: A huffman tree has N Leaf-nodes and N-1 Mid-nodes
// 		36bit Frame in Sorted RAM is
// (MSB)	Node_number		Stat_freq	(LSB)
//				9bit		  	 27bit
//
//////////////////////////////////////////////////////////////////////////////////
module heap_sorter_v2(
// global clock and reset
input wire				clk,
input wire				rstN,
// control and status signal
input wire				heap_sort_start,
output reg				heap_sort_done,
// sorted RAM Interface
input wire				sorted_wea,
input wire	[6:0]		sorted_addra,
input wire	[35:0]	sorted_dina,
output wire	[35:0]	sorted_douta,
input wire				sorted_web,
input wire	[6:0]		sorted_addrb,
input wire	[35:0]	sorted_dinb,
output wire	[35:0]	sorted_doutb,
input wire				sorted_wec,
input wire	[6:0]		sorted_addrc,
input wire	[35:0]	sorted_dinc,
output wire	[35:0]	sorted_doutc,
input wire				sorted_wed,
input wire	[6:0]		sorted_addrd,
input wire	[35:0]	sorted_dind,
output wire	[35:0]	sorted_doutd,
// frequencany statistic RAM Interface
input wire	[17:0]	freq_value1a,
input wire	[17:0]	freq_value1b,
input wire	[17:0]	freq_value2a,
input wire	[17:0]	freq_value2b,
input wire	[17:0]	freq_value3a,
input wire	[17:0]	freq_value3b,
input wire	[17:0]	freq_value4a,
input wire	[17:0]	freq_value4b,
input wire				freq_valid,
output wire	[7:0]		freq_addr1a,
output wire	[7:0]		freq_addr1b,
output wire	[7:0]		freq_addr2a,
output wire	[7:0]		freq_addr2b,
output wire	[7:0]		freq_addr3a,
output wire	[7:0]		freq_addr3b,
output wire	[7:0]		freq_addr4a,
output wire	[7:0]		freq_addr4b,
output reg				freq_oe,
// heap output for restuct BL_TABLE in bit_len_gen module interface
output reg				heap_even_wea,
output reg	[6:0]		heap_even_addra,
output reg	[7:0]		heap_even_dina,
output reg				heap_even_web,
output reg	[6:0]		heap_even_addrb,
output reg	[7:0]		heap_even_dinb,
output reg				heap_odd_wea,
output reg	[6:0]		heap_odd_addra,
output reg	[7:0]		heap_odd_dina,
output reg				heap_odd_web,
output reg	[6:0]		heap_odd_addrb,
output reg	[7:0]		heap_odd_dinb
);

//////////////// FSM status ////////////////
parameter		IDLE			=	4'h0;
parameter		INIT			=	4'h1;
parameter		SEG_SORT		=	4'h2;
parameter		SEG_WAIT		=	4'h3;
parameter		SEG_SWAP		=	4'h4;
parameter		SEG_DONE		=	4'h5;
parameter		HEAP_OUT		=	4'h6;
parameter		SORT_DONE	=	4'h7;
////////////////////////////////////////////

// FSM signal
reg	[3:0]		current_state,next_state;
// Little heap sort signal
reg	[8:0]		heap_size,sort_cnt;
reg				heap_seg_done;
reg	[35:0]	max,mid,min;
wire				first_sort,last_sort;
// initial heap
reg	[7:0]		init_cnt,init_cnt_d1;
reg				init_cnt_en;
wire	[26:0]	init_acc_1,init_acc_2;
reg	[35:0]	init_max,init_min;
// sorter RAM signal
reg	[6:0]		even_addra,even_addrb;
reg	[35:0]	even_dina,even_dinb;
reg				even_wea,even_web;
wire	[35:0]	even_douta,even_doutb;
reg	[6:0]		odd_addra,odd_addrb;
reg	[35:0]	odd_dina,odd_dinb;
reg				odd_wea,odd_web;
wire	[35:0]	odd_douta,odd_doutb;
// delay of heap_sort_start
reg				heap_sort_start_d1;
// scan signal
reg				scanning;
// heap size correction for heap shrink
wire	[8:0]		heap_size_corr;
// output to external heap ram counter
reg	[7:0]		heapout_cnt,heapout_cnt_d1;
reg				heapout_en;

/////////////////////////////////////////////////
////			Dividual Combination Logic 		////
/////////////////////////////////////////////////
//	Sorted RAM Interface
assign		sorted_douta	=	even_douta;
assign		sorted_doutb	=	even_doutb;
assign		sorted_doutc	=	odd_douta;
assign		sorted_doutd	=	odd_doutb;

// freq_addr
assign		freq_addr1a	=	{init_cnt[6:0],1'b0};
assign		freq_addr1b	=	{init_cnt[6:0],1'b1};
assign		freq_addr2a	=	{init_cnt[6:0],1'b0};
assign		freq_addr2b	=	{init_cnt[6:0],1'b1};
assign		freq_addr3a	=	{init_cnt[6:0],1'b0};
assign		freq_addr3b	=	{init_cnt[6:0],1'b1};
assign		freq_addr4a	=	{init_cnt[6:0],1'b0};
assign		freq_addr4b	=	{init_cnt[6:0],1'b1};

// freq_adder
assign		init_acc_1	=	{9'b0,freq_value1a} + {9'b0,freq_value2a} + {9'b0,freq_value3a} + {9'b0,freq_value4a};
assign		init_acc_2	=	{9'b0,freq_value1b} + {9'b0,freq_value2b} + {9'b0,freq_value3b} + {9'b0,freq_value4b};

// First sort element
assign		first_sort	=	((!heap_size[0]) && (sort_cnt == {1'b0,heap_size[8:1]})) ? 1'b1 : 1'b0;
assign		last_sort	=	(sort_cnt == 9'b0) ? 1'b1 : 1'b0;

// heap size correction for heap shrink
assign		heap_size_corr	=	heap_size - 1'b1;

// pre-compare two data when initial heap
always @ (*)
begin
	if(init_acc_1 >= init_acc_2)
	begin
		init_max	=	{1'b0,init_cnt_d1[6:0],1'b0,init_acc_1};
		init_min	=	{1'b0,init_cnt_d1[6:0],1'b1,init_acc_2};
	end
	else
	begin
		init_max	=	{1'b0,init_cnt_d1[6:0],1'b1,init_acc_2};
		init_min	=	{1'b0,init_cnt_d1[6:0],1'b0,init_acc_1};
	end
end

// compare three data per clock cycle when heap sorting
always @ (*)
begin
	if(first_sort)
	begin
		mid	=	36'b0;
		if(!sort_cnt[0])
		begin
			if(even_douta[26:0] < even_doutb[26:0])
			begin
				max	=	even_doutb;
				min	=	even_douta;
			end
			else if(even_douta[26:0] > even_doutb[26:0])
			begin
				max	=	even_douta;
				min	=	even_doutb;
			end
			else		// if even_douta[26:0] == even_doutb[26:0], 
			begin		// gurantee max element is the larger sequence number element
				if(even_douta[35:27] > even_doutb[35:27])
				begin
					max	=	even_douta;
					min	=	even_doutb;
				end
				else
				begin
					max	=	even_doutb;
					min	=	even_douta;
				end
			end
		end
		else
		begin
			if(odd_douta[26:0] < even_doutb[26:0])
			begin
				max	=	even_doutb;
				min	=	odd_douta;
			end
			else if(odd_douta[26:0] > even_doutb[26:0])
			begin
				max	=	odd_douta;
				min	=	even_doutb;
			end
			else		// if even_douta[26:0] == even_doutb[26:0], 
			begin		// gurantee max element is the larger sequence number element
				if(odd_douta[35:27] > even_doutb[35:27])
				begin
					max	=	odd_douta;
					min	=	even_doutb;
				end
				else
				begin
					max	=	even_doutb;
					min	=	odd_douta;
				end
			end
		end
	end
	else if(last_sort)
	begin
		max	=	even_douta;
		mid	=	36'b0;
		min	=	36'b0;
	end
	else
	begin
		if(!sort_cnt[0])
		begin
			if(even_douta[26:0] < even_doutb[26:0])
			begin
				max	=	odd_doutb;
				mid	=	even_doutb;
				min	=	even_douta;
			end
			else if(even_douta[26:0] > odd_doutb[26:0])
			begin
				max	=	even_douta;
				mid	=	odd_doutb;
				min	=	even_doutb;
			end
			else if(		(even_douta[26:0] == even_doutb[26:0]) 
						&& (even_douta[35:27] < even_doutb[35:27]))
			begin
				max	=	odd_doutb;		// if even_douta[26:0] == even_doutb[26:0], 
				mid	=	even_doutb;    // gurantee mid element is the larger sequence number element
				min	=	even_douta;
			end
			else if(		(even_douta[26:0] == odd_doutb[26:0])
						&&	(even_douta[35:27] > odd_doutb[35:27]))
			begin
				max	=	even_douta;		// if even_douta[26:0] == odd_doutb[26:0], 
				mid	=	odd_doutb;     // gurantee max element is the larger sequence number element
				min	=	even_doutb;
			end
			else
			begin
				max	=	odd_doutb;
				mid	=	even_douta;
				min	=	even_doutb;
			end
		end
		else
		begin
			if(odd_douta[26:0] < even_doutb[26:0])
			begin
				max	=	odd_doutb;
				mid	=	even_doutb;
				min	=	odd_douta;
			end
			else if(odd_douta[26:0] > odd_doutb[26:0])
			begin
				max	=	odd_douta;
				mid	=	odd_doutb;
				min	=	even_doutb;
			end
			else if(		(odd_douta[26:0] == even_doutb[26:0])					
						&&	(odd_douta[35:27] < even_doutb[35:27]))
			begin
				max	=	odd_doutb;	// if odd_douta[26:0] == even_doutb[26:0], 
				mid	=	even_doutb;  // gurantee mid element is the larger sequence number element
				min	=	odd_douta;
			end
			else if(		(odd_douta[26:0] == odd_doutb[26:0])
						&&	(odd_douta[35:27] > odd_doutb[35:27]))
			begin									 	
				max	=	odd_douta; 	// if odd_douta[26:0] == odd_doutb[26:0],    	
				mid	=	odd_doutb;  // gurantee max element is the larger sequence number element
				min	=	even_doutb;
			end
			else
			begin
				max	=	odd_doutb;
				mid	=	odd_douta;
				min	=	even_doutb;
			end
		end
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

// heap size change
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		heap_size	<=	9'b0;
	end
	else
	begin
		if(init_cnt_en)
			heap_size	<=	9'hFF;	// initial heap size is 255
		else if(heap_seg_done)
			heap_size	<=	heap_size - 1'b1;
		else
			heap_size	<=	heap_size;
	end
end

// heap initial counter
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		init_cnt		<=	8'b0;
		init_cnt_d1	<=	8'b0;
	end
	else
	begin
		init_cnt_d1	<=	init_cnt;
		if(init_cnt_en)
			init_cnt	<=	init_cnt + 1'b1;
		else
			init_cnt	<=	8'b0;	
	end
end

//	heap sort counter
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		sort_cnt	<=	9'b0;
	end
	else
	begin
		if(heap_seg_done)
			sort_cnt	<=	{1'b0,heap_size_corr[8:1]};
		else if(scanning)
			sort_cnt	<=	sort_cnt - 1'b1;
		else
			sort_cnt	<=	sort_cnt;
	end
end

// delay of heap_sort_start
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		heap_sort_start_d1	<=	1'b0;
	end
	else
	begin
		heap_sort_start_d1	<=	heap_sort_start;
	end
end

// output to external heap ram counter
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		heapout_cnt		<=	8'b0;
		heapout_cnt_d1	<=	8'b0;
	end
	else
	begin
		heapout_cnt_d1	<=	heapout_cnt;
		if(heap_sort_done)
			heapout_cnt	<=	8'b0;
		else if(heapout_en)
			heapout_cnt	<=	heapout_cnt + 2'h2;
		else
			heapout_cnt	<=	heapout_cnt;
	end
end

/////////////////////////////////////////////////
////				Combination Logic 				////
/////////////////////////////////////////////////
// FSM state transfer
always @ (*)
begin
	case(current_state)
	IDLE		:	begin
						if({heap_sort_start_d1,heap_sort_start}==2'b01)
							next_state	=	INIT;
						else
							next_state	=	IDLE;
					end
	INIT		:	begin
						if(init_cnt_d1 < 8'h7F)
							next_state	=	INIT;
						else
							next_state	=	SEG_SORT;
					end
	SEG_SORT	:	begin
						next_state	=	SEG_WAIT;
					end
	SEG_WAIT	:	begin
						if(sort_cnt <= 9'h0)
							next_state	=	SEG_SWAP;
						else
							next_state	=	SEG_SORT;
					end
	SEG_SWAP	:	begin
						next_state	=	SEG_DONE;
					end
	SEG_DONE	:	begin
						if(heap_size <= 9'h1)
							next_state	=	HEAP_OUT;
						else
							next_state	=	SEG_SORT;
					end	
	HEAP_OUT	:	begin
						if(heapout_cnt < 8'h80)
							next_state	=	HEAP_OUT;
						else
							next_state	=	SORT_DONE;
					end
	SORT_DONE:	begin
						if({heap_sort_start_d1,heap_sort_start}==2'b01)
							next_state	=	INIT;
						else
							next_state	=	SORT_DONE;
					end
	default	:	begin
						next_state	=	IDLE;
					end
	endcase
end

// FSM state signal
always @ (*)
begin
	case(current_state)
	IDLE		:	begin
						if({heap_sort_start_d1,heap_sort_start}==2'b01)
							init_cnt_en	=	1'b1;
						else
							init_cnt_en	=	1'b0;
						scanning			=	1'b0;
						heap_seg_done	=	1'b0;
						heap_sort_done	=	1'b0;
					end
	INIT		:	begin
						init_cnt_en		=	1'b1;
						scanning			=	1'b0;
						if(init_cnt_d1 < 8'h7F)
							heap_seg_done	=	1'b0;
						else
							heap_seg_done	=	1'b1;
						heap_sort_done	=	1'b0;
					end
	SEG_SORT	:	begin
						init_cnt_en		=	1'b0;
						scanning			=	1'b0;
						heap_seg_done	=	1'b0;
						heap_sort_done	=	1'b0;
					end
	SEG_WAIT	:	begin
						init_cnt_en		=	1'b0;
						scanning			=	1'b1;
						heap_seg_done	=	1'b0;
						heap_sort_done	=	1'b0;
					end
	SEG_SWAP	:	begin
						init_cnt_en		=	1'b0;
						scanning			=	1'b0;
						heap_seg_done	=	1'b0;
						heap_sort_done	=	1'b0;
					end
	SEG_DONE	:	begin
						init_cnt_en		=	1'b0;
						scanning			=	1'b0;
						heap_seg_done	=	1'b1;
						heap_sort_done	=	1'b0;
					end	
	HEAP_OUT	:	begin
						init_cnt_en		=	1'b0;
						scanning			=	1'b0;
						heap_seg_done	=	1'b0;
						heap_sort_done	=	1'b0;
					end
	SORT_DONE:	begin
						init_cnt_en		=	1'b0;
						scanning			=	1'b0;
						heap_seg_done	=	1'b0;
						heap_sort_done	=	1'b1;
					end
	default	:	begin
						init_cnt_en		=	1'b0;
						scanning			=	1'b0;
						heap_seg_done	=	1'b0;
						heap_sort_done	=	1'b0;
					end
	endcase
end

// data process in Sorted RAM
always @ (*)
begin
	case(current_state)
	IDLE		:	begin
						even_addra	=	7'b0;
						even_dina	=	36'b0;
						even_wea		=	1'b0;
						even_addrb	=	7'b0;
						even_dinb	=	36'b0;
						even_web		=	1'b0;
						odd_addra	=	7'b0;
						odd_dina		=	36'b0;
						odd_wea		=	1'b0;
						odd_addrb	=	7'b0;
						odd_dinb		=	36'b0;
						odd_web		=	1'b0;
						if({heap_sort_start_d1,heap_sort_start}==2'b01)
							freq_oe	=	1'b1;
						else
							freq_oe	=	1'b0;
					end
	INIT		:	begin		// pre-sort gurantee ODD data >= EVEN data when address is the same
						if(freq_valid)
						begin
							even_addra	=	init_cnt_d1[6:0];
							even_dina	=	init_min;
							even_wea		=	1'b1;
							odd_addra	=	init_cnt_d1[6:0];
							odd_dina		=	init_max;
							odd_wea		=	1'b1;
						end
						else
						begin
							even_addra	=	7'b0;
							even_dina	=	36'b0;
							even_wea		=	1'b0;
							odd_addra	=	7'b0;
							odd_dina		=	36'b0;
							odd_wea		=	1'b0;
						end
						even_addrb	=	7'b0;
						even_dinb	=	36'b0;
						even_web		=	1'b0;
						odd_addrb	=	7'b0;
						odd_dinb		=	36'b0;
						odd_web		=	1'b0;
						freq_oe		=	1'b1;
					end
	SEG_SORT	:	begin
						even_addra	=	sort_cnt[7:1];	// Added Logic to gurantee EVEN[i] <= ODD[i] when (sort_cnt[0])
						even_dina	=	36'b0;
						even_wea		=	1'b0;
						odd_addra	=	sort_cnt[7:1]; // Added Logic to gurantee EVEN[i] <= ODD[i] when (!sort_cnt[0])
						odd_dina		=	36'b0;
						odd_wea		=	1'b0;
						even_addrb	=	sort_cnt[6:0];
						even_dinb	=	36'b0;
						even_web		=	1'b0;	
						odd_addrb	=	sort_cnt[6:0];
						odd_dinb		=	36'b0;
						odd_web		=	1'b0;
						freq_oe		=	1'b0;
					end
	SEG_WAIT	:	begin
						freq_oe		=	1'b0;
						even_addra	=	sort_cnt[7:1];
						odd_addra	=	sort_cnt[7:1];
						even_addrb	=	sort_cnt[6:0];
						odd_addrb	=	sort_cnt[6:0];
						if(!sort_cnt[0])
						begin
							even_wea		=	1'b1;
							odd_wea		=	1'b1;
							if(max[26:0] < odd_douta[26:0])	// in last_sort state, sort_cnt[0] == 1'b0
							begin										// The MAX element be store in ODD[0]
								even_dina	=	max;
								odd_dina		=	odd_douta;
							end
							else if(max[26:0] == odd_douta[26:0]) // larger number store in high address
							begin
								if(max[35:27] < odd_douta[35:27])
								begin
									even_dina	=	max;
									odd_dina		=	odd_douta;
								end
								else
								begin
									even_dina	=	odd_douta;
									odd_dina		=	max;
								end
							end
							else
							begin
								even_dina	=	odd_douta;
								odd_dina		=	max;
							end
						end
						else
						begin
							even_wea		=	1'b1;
							odd_wea		=	1'b1;
							if(max[26:0] < even_douta[26:0])
							begin
								even_dina	=	max;
								odd_dina		=	even_douta;
							end
							else if(max[26:0] == even_douta[26:0]) // larger number store in high address
							begin
								if(max[35:27] < even_douta[35:27])
								begin
									even_dina	=	max;
									odd_dina		=	even_douta;
								end
								else
								begin
									even_dina	=	even_douta;
									odd_dina		=	max;
								end
							end
							else
							begin
								even_dina	=	even_douta;
								odd_dina		=	max;
							end
						end
						if(last_sort)
						begin
							even_dinb	=	36'b0;
							even_web		=	1'b0;
						end
						else
						begin
							even_dinb	=	min;
							even_web		=	1'b1;	
						end
						if(first_sort | last_sort)
						begin
							odd_dinb		=	36'b0;
							odd_web		=	1'b0;
						end
						else
						begin
							odd_dinb		=	mid;
							odd_web		=	1'b1;
						end
					end
	SEG_SWAP	:	begin
						if(heap_size[0])
						begin
							even_addra	=	7'b0;
							even_dina	=	36'b0;
							even_wea		=	1'b0;
							odd_addra	=	heap_size[7:1];
							odd_dina		=	36'b0;
							odd_wea		=	1'b0;
						end
						else
						begin
							even_addra	=	heap_size[7:1];
							even_dina	=	36'b0;
							even_wea		=	1'b0;
							odd_addra	=	7'b0;
							odd_dina		=	36'b0;
							odd_wea		=	1'b0;
						end
						even_addrb	=	7'b0;
						even_dinb	=	36'b0;
						even_web		=	1'b0;
						odd_addrb	=	7'b0;
						odd_dinb		=	36'b0;
						odd_web		=	1'b0;
						freq_oe		=	1'b0;
					end
	SEG_DONE	:	begin
						if(heap_size[0])
						begin
							even_addra	=	7'b0;
							even_dina	=	36'b0;
							even_wea		=	1'b0;
							odd_addra	=	heap_size[7:1];
							odd_dina		=	odd_doutb;
							odd_wea		=	1'b1;
							if(odd_douta[26:0] > even_doutb[26:0])	// Gurantee ODD[0] > EVEN[0]
							begin
								even_dinb	=	even_doutb;
								odd_dinb		=	odd_douta;
							end
							else if(odd_douta[26:0] == even_doutb[26:0])	// larger number store in high address
							begin
								if(odd_douta[35:27] > even_doutb[35:27])
								begin
									even_dinb	=	even_doutb;
									odd_dinb		=	odd_douta;
								end
								else
								begin
									even_dinb	=	odd_douta;
									odd_dinb		=	even_doutb;
								end
							end
							else
							begin
								even_dinb	=	odd_douta;
								odd_dinb		=	even_doutb;
							end
						end
						else
						begin
							even_addra	=	heap_size[7:1];
							even_dina	=	odd_doutb;  // MAX element in one sort process is store in ODD[0]
							even_wea		=	1'b1;
							odd_addra	=	7'b0;
							odd_dina		=	36'b0;
							odd_wea		=	1'b0;
							if(even_douta[26:0] > even_doutb[26:0])	// Gurantee ODD[0] > EVEN[0]
							begin
								even_dinb	=	even_doutb;
								odd_dinb		=	even_douta;
							end
							else if(even_douta[26:0] == even_doutb[26:0])	// larger number store in high address
							begin
								if(even_douta[35:27] > even_doutb[35:27])
								begin
									even_dinb	=	even_doutb;
									odd_dinb		=	even_douta;
								end
								else
								begin
									even_dinb	=	even_douta;
									odd_dinb		=	even_doutb;
								end
							end
							else
							begin
								even_dinb	=	even_douta;
								odd_dinb		=	even_doutb;
							end
						end
						even_addrb	=	7'b0;
						even_web		=	1'b1;
						odd_addrb	=	7'b0;
						odd_web		=	1'b1;
						freq_oe		=	1'b0;
					end
	HEAP_OUT	:	begin
						even_addra	=	heapout_cnt[6:0];
						even_dina	=	36'b0;
						even_wea		=	1'b0;
						even_addrb	=	heapout_cnt[6:0] + 1'b1;
						even_dinb	=	36'b0;
						even_web		=	1'b0;
						odd_addra	=	heapout_cnt[6:0];
						odd_dina		=	36'b0;
						odd_wea		=	1'b0;
						odd_addrb	=	heapout_cnt[6:0] + 1'b1;
						odd_dinb		=	36'b0;
						odd_web		=	1'b0;
						freq_oe		=	1'b0;
					end
	SORT_DONE:	begin
						even_addra	=	sorted_addra;
						even_dina	=	sorted_dina;
						even_wea		=	sorted_wea;
						even_addrb	=	sorted_addrb;
						even_dinb	=	sorted_dinb;
						even_web		=	sorted_web;
						odd_addra	=	sorted_addrc;
						odd_dina		=	sorted_dinc;
						odd_wea		=	sorted_wec;
						odd_addrb	=	sorted_addrd;
						odd_dinb		=	sorted_dind;
						odd_web		=	sorted_wed;
						freq_oe		=	1'b0;
					end
	default	:	begin
						even_addra	=	7'b0;
						even_dina	=	36'b0;
						even_wea		=	1'b0;
						even_addrb	=	7'b0;
						even_dinb	=	36'b0;
						even_web		=	1'b0;
						odd_addra	=	7'b0;
						odd_dina		=	36'b0;
						odd_wea		=	1'b0;
						odd_addrb	=	7'b0;
						odd_dinb		=	36'b0;
						odd_web		=	1'b0;
						freq_oe		=	1'b0;
					end
	endcase
end

// heap output for restuct BL_TABLE in bit_len_gen module interface
always @ (*)
begin
	case(current_state)
	IDLE		,
	INIT		,
	SEG_SORT	,
	SEG_WAIT	,
	SEG_SWAP ,
	SEG_DONE	:	begin
						heapout_en			=	1'b0;
						heap_even_addra   =	8'b0;
						heap_even_dina    =	8'b0;
						heap_even_wea		=	1'b0;
						heap_even_addrb   =	8'b0;
						heap_even_dinb    =	8'b0;
						heap_even_web     =	1'b0;
						heap_odd_addra    =	8'b0;
						heap_odd_dina     =	8'b0;
						heap_odd_wea		=	1'b0;
						heap_odd_addrb    =	8'b0;
						heap_odd_dinb     =	8'b0;
						heap_odd_web      =	1'b0;
					end				
	HEAP_OUT	:	begin
						if(heapout_cnt < 8'h80)
							heapout_en	=	1'b1;
						else
							heapout_en	=	1'b0;
						if(heapout_cnt >= 8'h01)
						begin
							heap_even_wea	=	1'b1;
							heap_even_web  =	1'b1;
							heap_odd_wea	=	1'b1;
							heap_odd_web   =	1'b1;
						end
						else
						begin
							heap_even_wea	=	1'b0;
							heap_even_web  =	1'b0;
							heap_odd_wea	=	1'b0;
							heap_odd_web   =	1'b0;
						end
						heap_even_addra   =	heapout_cnt_d1[6:0];
						heap_even_dina    =	even_douta[34:27];
						heap_even_addrb   =	heapout_cnt_d1[6:0] + 1'b1;
						heap_even_dinb    =	even_doutb[34:27];
						heap_odd_addra    =	heapout_cnt_d1[6:0];
						heap_odd_dina     =	odd_douta[34:27];
						heap_odd_addrb    =	heapout_cnt_d1[6:0] + 1'b1;
						heap_odd_dinb     =	odd_doutb[34:27];
					end					
	SORT_DONE:	begin
						heapout_en			=	1'b0;
						heap_even_addra   =	8'b0;
						heap_even_dina    =	8'b0;
						heap_even_wea		=	1'b0;
						heap_even_addrb   =	8'b0;
						heap_even_dinb    =	8'b0;
						heap_even_web     =	1'b0;
						heap_odd_addra    =	8'b0;
						heap_odd_dina     =	8'b0;
						heap_odd_wea		=	1'b0;
						heap_odd_addrb    =	8'b0;
						heap_odd_dinb     =	8'b0;
						heap_odd_web      =	1'b0;
					end
	default	:	begin
						heapout_en			=	1'b0;
						heap_even_addra   =	8'b0;
						heap_even_dina    =	8'b0;
						heap_even_wea		=	1'b0;
						heap_even_addrb   =	8'b0;
						heap_even_dinb    =	8'b0;
						heap_even_web     =	1'b0;
						heap_odd_addra    =	8'b0;
						heap_odd_dina     =	8'b0;
						heap_odd_wea		=	1'b0;
						heap_odd_addrb    =	8'b0;
						heap_odd_dinb     =	8'b0;
						heap_odd_web      =	1'b0;
					end
	endcase
end


/////////////////////////////////////////////////
////					Sub Modules						////
/////////////////////////////////////////////////
// Sorted RAM 128 x 36bit x 2 USE two 36Kb blocks
ram_128x36bit	U_sorded_even_ram	//	heap sort even element 128 element
(
  .clka			(clk),
  .wea			(even_wea),
  .addra			(even_addra),
  .dina			(even_dina),
  .clkb			(clk),
  .web			(even_web),
  .addrb			(even_addrb),
  .dinb			(even_dinb),
  
  .douta			(even_douta),
  .doutb			(even_doutb)
);

ram_128x36bit	U_sorded_odd_ram	//	heap sort odd element 128 element
(
  .clka			(clk),
  .wea			(odd_wea),
  .addra			(odd_addra),
  .dina			(odd_dina),
  .clkb			(clk),
  .web			(odd_web),
  .addrb			(odd_addrb),
  .dinb			(odd_dinb),
  
  .douta			(odd_douta),
  .doutb			(odd_doutb)
);


endmodule
