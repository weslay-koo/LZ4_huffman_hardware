`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:53:22 09/01/2016 
// Design Name: 
// Module Name:    heap_sorter_v3 
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
//	Revision	1.01 - File Created
//	Revision 2.01 - Added Heap out to external RAM and gurantee little node number nodes 
//								will be stored in higher address
//	Revision 3.01 - Use select network to implement seek min node, port has been redefined
//
// Additional Comments: A huffman tree has N Leaf-nodes and N-1 Mid-nodes
// 		36bit Frame in Sorted RAM is
// (MSB)	Node_number		Stat_freq	(LSB)
//				9bit		  	 27bit
//
//////////////////////////////////////////////////////////////////////////////////
module heap_sorter_v3(
// global clock and reset
input wire				clk,
input wire				rstN,
// control and status signal
input wire				heap_sort_start,
output wire				heap_sort_done,
// sorted RAM Interface
input wire				sorted_even_wea,
input wire	[6:0]		sorted_even_addra,
input wire	[35:0]	sorted_even_dina,
output wire	[35:0]	sorted_even_douta,
input wire				sorted_even_web,
input wire	[6:0]		sorted_even_addrb,
input wire	[35:0]	sorted_even_dinb,
output wire	[35:0]	sorted_even_doutb,
input wire				sorted_odd_wea,
input wire	[6:0]		sorted_odd_addra,
input wire	[35:0]	sorted_odd_dina,
output wire	[35:0]	sorted_odd_douta,
input wire				sorted_odd_web,
input wire	[6:0]		sorted_odd_addrb,
input wire	[35:0]	sorted_odd_dinb,
output wire	[35:0]	sorted_odd_doutb,
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
parameter		WAIT_COMP	=	4'h2;
parameter		SORT_DONE	=	4'h3;
////////////////////////////////////////////

// FSM signal
reg	[3:0]		current_state,next_state;
// sort done signal
reg				sort_done;
// initial counter
reg	[8:0]		init_cnt,init_cnt_d1;
reg				init_cnt_en;
// select network signal
wire	[35:0]	net_min;
wire				net_valid;
reg				net_wr;
reg	[35:0]	net_in;
// sorter RAM signal
reg	[6:0]		even_addra,even_addrb;
reg	[35:0]	even_dina,even_dinb;
reg				even_wea,even_web;
wire	[35:0]	even_douta,even_doutb;
reg	[6:0]		odd_addra,odd_addrb;
reg	[35:0]	odd_dina,odd_dinb;
reg				odd_wea,odd_web;
wire	[35:0]	odd_douta,odd_doutb;
// address counter for select network write to EVEN/ODD RAMs
reg	[8:0]		addr_cnt;
reg				addr_cnt_en;
// delay of heap_sort_start
reg				heap_sort_start_d1;
// initial heap
wire	[26:0]	init_acc;

/////////////////////////////////////////////////
////			Dividual Combination Logic 		////
/////////////////////////////////////////////////
//	Sorted RAM Interface
assign		sorted_even_douta	=	even_douta;
assign		sorted_even_doutb	=	even_doutb;
assign		sorted_odd_douta	=	odd_douta;
assign		sorted_odd_doutb	=	odd_doutb;
// sort done signal
assign		heap_sort_done		=	sort_done;
// freq_addr
assign		freq_addr1a	=	init_cnt[7:0];	
assign		freq_addr2a	=	init_cnt[7:0];
assign		freq_addr3a	=	init_cnt[7:0];
assign		freq_addr4a	=	init_cnt[7:0];
assign		freq_addr1b	=	8'b0;	// Port B has not be used in V3.01
assign		freq_addr2b	=	8'b0;
assign		freq_addr3b	=	8'b0;
assign		freq_addr4b	=	8'b0;
// freq_adder
assign		init_acc		=	{9'b0,freq_value1a} + {9'b0,freq_value2a} + {9'b0,freq_value3a} + {9'b0,freq_value4a};

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

// initial counter
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		init_cnt		<=	9'hFF;
		init_cnt_d1	<=	9'hFF;
	end
	else
	begin
		if(sort_done)
		begin
			init_cnt_d1	<=	9'hFF;
			init_cnt		<=	9'hFF;
		end
		else if(init_cnt_en)
		begin
			init_cnt_d1	<=	init_cnt;
			init_cnt		<=	init_cnt - 1'b1;
		end
		else
		begin
			init_cnt_d1	<=	init_cnt;
			init_cnt		<=	init_cnt;
		end
	end
end

// address counter for select network write to EVEN/ODD RAMs
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		addr_cnt	<=	9'b0;
	end
	else
	begin
		if(sort_done)
			addr_cnt	<=	9'b0;
		else if(addr_cnt_en)
			addr_cnt	<=	addr_cnt + 1'b1;
		else
			addr_cnt	<=	addr_cnt;
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

/////////////////////////////////////////////////
////				Combination Logic 				////
/////////////////////////////////////////////////
// FSM state transfer
always @ (*)
begin
	case(current_state)
	IDLE			:	begin
							if({heap_sort_start_d1,heap_sort_start}==2'b01)
								next_state	=	INIT;		
							else                             
								next_state	=	IDLE;          
						end	                              
	INIT			:	begin
							if(init_cnt_d1 > 9'h000)
								next_state	=	INIT;
							else
								next_state	=	WAIT_COMP;
						end
	WAIT_COMP	:	begin
							if(net_valid)
								if(addr_cnt < 9'hFF)
									next_state	=	WAIT_COMP;
								else
									next_state	=	SORT_DONE;
							else
								next_state	=	WAIT_COMP;
						end
	SORT_DONE	:	begin
							if({heap_sort_start_d1,heap_sort_start}==2'b01)
								next_state	=	INIT;
							else
								next_state	=	SORT_DONE;
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
							if({heap_sort_start_d1,heap_sort_start}==2'b01)
								init_cnt_en	=	1'b1;
							else
								init_cnt_en	=	1'b0;
							net_wr		=	1'b0;
							net_in		=	36'b0;
							addr_cnt_en	=	1'b0;
							sort_done	=	1'b0;
						end	                              
	INIT			:	begin
							init_cnt_en	=	1'b1;
							net_wr		=	1'b1;
							net_in		=	{1'b0,init_cnt_d1[7:0],init_acc};
							addr_cnt_en	=	1'b0;
							sort_done	=	1'b0;
						end
	WAIT_COMP	:	begin
							init_cnt_en	=	1'b0;
							net_wr		=	1'b0;
							net_in		=	36'b0;
							if(net_valid)
								addr_cnt_en	=	1'b1;
							else
								addr_cnt_en	=	1'b0;
							sort_done	=	1'b0;
						end
	SORT_DONE	:	begin
							init_cnt_en	=	1'b0;
							net_wr		=	1'b0;
							net_in		=	36'b0;
							addr_cnt_en	=	1'b0;
							sort_done	=	1'b1;
						end
	default		:	begin
							init_cnt_en	=	1'b0;
							net_wr		=	1'b0;
							net_in		=	36'b0;
							addr_cnt_en	=	1'b0;
							sort_done	=	1'b0;
						end
	endcase
end

// FSM read external 4 x Freq_ram
always @ (*)
begin
	case(current_state)
	IDLE			:	begin
							if({heap_sort_start_d1,heap_sort_start}==2'b01)
								freq_oe	=	1'b1;
							else
								freq_oe	=	1'b0;
						end
	INIT			:	begin
							freq_oe	=	1'b1;
						end	
	WAIT_COMP	:	begin
							freq_oe	=	1'b0;
						end
	SORT_DONE	:	begin
							freq_oe	=	1'b0;
						end
	default		:	begin
							freq_oe	=	1'b0;
						end
	endcase
end

// FSM write to 2 x RAM signal
always @ (*)
begin
	case(current_state)
	IDLE			,                              
	INIT			:	begin
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
						end	
	WAIT_COMP	:	begin
							if(net_valid)
							begin
								if(addr_cnt[0])
								begin
									even_wea	=	1'b0;
									odd_wea	=	1'b1;
								end
								else
								begin
									even_wea	=	1'b1;
									odd_wea	=	1'b0;
								end
							end
							else
							begin
								even_wea	=	1'b0;
								odd_wea	=	1'b0;
							end
							even_addra	=	addr_cnt[7:1];
							even_dina	=	net_min;
							even_addrb	=	7'b0;
							even_dinb	=	36'b0;
							even_web		=	1'b0;
							odd_addra	=	addr_cnt[7:1];
							odd_dina		=	net_min;
							odd_addrb	=	7'b0;
							odd_dinb		=	36'b0;
							odd_web		=	1'b0;
						end
	SORT_DONE	:	begin
							even_addra	=	sorted_even_addra;
							even_dina	=	sorted_even_dina;
							even_wea		=	sorted_even_wea;
							even_addrb	=	sorted_even_addrb;
							even_dinb	=	sorted_even_dinb;
							even_web		=	sorted_even_web;
							odd_addra	=	sorted_odd_addra;
							odd_dina		=	sorted_odd_dina;
							odd_wea		=	sorted_odd_wea;
							odd_addrb	=	sorted_odd_addrb;
							odd_dinb		=	sorted_odd_dinb;
							odd_web		=	sorted_odd_web;
						end
	default		:	begin
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
						end
	endcase
end

// heap output for restuct BL_TABLE in bit_len_gen module interface
always @ (*)
begin
	case(current_state)
	IDLE		,
	INIT		:	begin
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
	WAIT_COMP:	begin
						if(net_valid)
						begin
							if(addr_cnt[0])
							begin
								heap_even_wea	=	1'b0;
								heap_odd_wea	=	1'b1;
							end
							else
							begin
								heap_even_wea	=	1'b1;
								heap_odd_wea	=	1'b0;
							end
						end
						else
						begin
							heap_even_wea	=	1'b0;
							heap_odd_wea	=	1'b0;
						end
						heap_even_web  	=	1'b0;
						heap_odd_web   	=	1'b0;
						heap_even_addra   =	addr_cnt[7:1];
						heap_even_dina    =	net_min[34:27];
						heap_even_addrb   =	7'b0;
						heap_even_dinb    =	8'b0;
						heap_odd_addra    =	addr_cnt[7:1];
						heap_odd_dina     =	net_min[34:27];
						heap_odd_addrb    =	7'b0;
						heap_odd_dinb     =	8'b0;
					end					
	SORT_DONE:	begin
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
// select network for min element
select_network		U_select_network
(
	.clk				(clk),
	.rstN				(rstN),
	.net_wr			(net_wr),
	.net_in			(net_in),
	.net_out			(net_min),
	.net_valid		(net_valid)
);

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
