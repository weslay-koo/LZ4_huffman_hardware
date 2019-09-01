`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:27:10 08/10/2016 
// Design Name: 
// Module Name:    little_root_heap 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: This little root heap is a STRICT ordered sequence
//								Heap must be full up before start to read data from it
//
//////////////////////////////////////////////////////////////////////////////////
module little_root_heap(
// global clock and reset
input wire				clk,
input wire				rstN,
// sorter module heap output for restuct BL_TABLE in bit_len_gen module interface
input wire				heap_even_wea,
input wire	[6:0]		heap_even_addra,
input wire	[7:0]		heap_even_dina,
input wire				heap_even_web,
input wire	[6:0]		heap_even_addrb,
input wire	[7:0]		heap_even_dinb,
input wire				heap_odd_wea,
input wire	[6:0]		heap_odd_addra,
input wire	[7:0]		heap_odd_dina,
input wire				heap_odd_web,
input wire	[6:0]		heap_odd_addrb,
input wire	[7:0]		heap_odd_dinb,
// Read Heap from max element by FIFO interface
input wire				heap_even_rd,
output wire	[7:0]		heap_even_dout,
output reg				heap_even_valid,
input wire				heap_odd_rd,
output wire	[7:0]		heap_odd_dout,
output reg				heap_odd_valid,
// Read Heap from min element by FIFO interface
input wire				heap_rd,
output wire	[31:0]	heap_dout,
output reg				heap_valid,
output reg				heap_empty
);

wire				even_wea,even_web,odd_wea,odd_web;
wire	[6:0]		even_addra,even_addrb,odd_addra,odd_addrb;
reg	[6:0]		even_rd_cnt,odd_rd_cnt;
reg	[6:0]		heap_cnta,heap_cntb;
wire	[7:0]		heap_even_douta,heap_even_doutb,
					heap_odd_douta,heap_odd_doutb;
					
/////////////////////////////////////////////////
////			Dividual Combination Logic 		////
/////////////////////////////////////////////////
// heap max to min output wire
assign			heap_even_dout	=	heap_even_douta;
assign			heap_odd_dout	=	heap_odd_douta;
// heap min to max output wire
assign			heap_dout		=	{heap_even_douta,heap_odd_douta,heap_even_doutb,heap_odd_doutb};
// access address switch
assign			even_addra	=	heap_even_wea ? heap_even_addra : (heap_rd ? heap_cnta : even_rd_cnt);
assign			odd_addra	=	heap_odd_wea  ? heap_odd_addra  : (heap_rd ? heap_cnta : odd_rd_cnt);
assign			even_addrb	=	heap_even_web ? heap_even_addrb : heap_cntb;
assign			odd_addrb	=	heap_odd_web  ? heap_odd_addrb  : heap_cntb;

/////////////////////////////////////////////////
////				 Sequential Logic 				////
/////////////////////////////////////////////////
// Read Heap from max element by FIFO interface 
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		even_rd_cnt			<=	7'b0;
		odd_rd_cnt			<=	7'b0;
		heap_even_valid	<=	1'b0;
		heap_odd_valid		<=	1'b0;
	end	
	else
	begin
		if(heap_even_wea)
		begin
			even_rd_cnt			<=	7'h7F;
			heap_even_valid	<=	1'b0;
		end
		else if(heap_even_rd)
		begin
			even_rd_cnt			<=	even_rd_cnt - 1'b1;
			heap_even_valid	<=	1'b1;
		end
		else
		begin
			even_rd_cnt			<=	even_rd_cnt;
			heap_even_valid	<=	1'b0;
		end
		
		if(heap_odd_wea)
		begin
			odd_rd_cnt		<=	7'h7F;
			heap_odd_valid	<=	1'b0;
		end
		else if(heap_even_rd)
		begin
			odd_rd_cnt		<=	odd_rd_cnt - 1'b1;
			heap_odd_valid	<=	1'b1;
		end
		else
		begin
			odd_rd_cnt		<=	odd_rd_cnt;
			heap_odd_valid	<=	1'b0;
		end
	end
end

// Read Heap from min element by FIFO interface
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		heap_valid	<=	1'b0;
		heap_cnta	<=	7'b0;
		heap_cntb	<=	7'b0;
		heap_empty	<=	1'b0;
	end
	else
	begin
		if(heap_even_wea | heap_odd_wea)
		begin
			heap_cnta	<=	7'b0;
			heap_cntb	<=	7'h1;
			heap_valid	<=	1'b0;
			heap_empty	<=	1'b0;
		end
		else if(heap_rd & (~heap_empty))
		begin
			heap_valid	<=	1'b1;
			if((heap_cnta >= 7'h7E) || (heap_cnta >= 7'h7F))
			begin
				heap_empty	<=	1'b1;
				heap_cnta	<=	heap_cnta;
				heap_cntb	<=	heap_cntb;
			end
			else
			begin
				heap_empty	<=	1'b0;
				heap_cnta	<=	heap_cnta + 2'h2;
				heap_cntb	<=	heap_cntb + 2'h2;
			end
		end
		else
		begin
			heap_cnta	<=	heap_cnta;
		   heap_cntb	<=	heap_cntb;
			heap_valid	<=	1'b0;
			heap_empty	<=	heap_empty;
		end
	end
end

/////////////////////////////////////////////////
////					Sub Modules						////
/////////////////////////////////////////////////
// Sorted RAM 128 x 36bit x 2 USE two 36Kb blocks
ram_128x8bit	U_heap_even_ram	//	heap sort even element 128 element
(
  .clka			(clk),
  .wea			(heap_even_wea),
  .addra			(even_addra),
  .dina			(heap_even_dina),
  .clkb			(clk),
  .web			(heap_even_web),
  .addrb			(even_addrb),
  .dinb			(heap_even_dinb),
  
  .douta			(heap_even_douta),
  .doutb			(heap_even_doutb)
);

ram_128x8bit	U_heap_odd_ram	//	heap sort odd element 128 element
(
  .clka			(clk),
  .wea			(heap_odd_wea),
  .addra			(odd_addra),
  .dina			(heap_odd_dina),
  .clkb			(clk),
  .web			(heap_odd_web),
  .addrb			(odd_addrb),
  .dinb			(heap_odd_dinb),
  
  .douta			(heap_odd_douta),
  .doutb			(heap_odd_doutb)
);


endmodule
