`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:27:06 08/09/2016 
// Design Name: 
// Module Name:    vlc_table_v3 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: Use huffman tree to implement VLC encode (Method of Gzip Tree.c)
//
//        20bit Frame in VLC Table RAM is
// (MSB)Code_segment_length  				Overflow_ERROR_Bit		VLC_code (LSB)
// 				4bit 									1bit			 			 15bit        
//  		4'h0 : Illegal value					1'b0 : Normal
//			4'h1~4'hF: Valid code length		1'b1 : Overflowed		
//													
//  	NOTICE_1	:	bl_count[i] convert to VLC start Code table next_code[i] Algorithm:
//    					for (bits = 1; bits <= MAX_BITS; bits++) {
//    					    next_code[bits] = code = (code + bl_count[bits-1]) << 1;
//    					}
// 
// 	NOTICE_2	:	Use next_code[i] to generate VLC Algorithm:
//    					for (n = 0; n <= max_code; n++) {
//								len = tree[n].Len;
//								if (len != 0) {
//									tree[n].Code = next_code[len];
//									next_code[len]++;
//								}
//							}
//
//////////////////////////////////////////////////////////////////////////////////
module vlc_table_v3(
// global clock and reset
input wire				clk,
input wire				rstN,
// control and status signal
input wire				vlc_start,
output reg				vlc_done,
// BL COUNT RAM Interface
input wire	[8:0]		bl_cnt_douta,
input wire	[8:0]		bl_cnt_doutb,
output reg	[3:0]		bl_cnt_addra,
output reg	[3:0]		bl_cnt_addrb,
// Read Heap by FIFO interface
input wire	[7:0]		heap_even_dout,
input wire				heap_even_valid,
input wire	[7:0]		heap_odd_dout,
input wire				heap_odd_valid,
output reg				heap_even_rd,
output reg				heap_odd_rd,
// Encode VLC Table interface
input wire	[7:0]		vlc_addra_in,
input wire	[7:0]		vlc_addrb_in,
input wire	[7:0]		vlc_addrc_in,
input wire	[7:0]		vlc_addrd_in,
output wire	[19:0]	vlc_douta,
output wire	[19:0]	vlc_doutb,
output wire	[19:0]	vlc_doutc,
output wire	[19:0]	vlc_doutd,
// bl table ram write RAM interface
output reg	[6:0]		blt_even_waddr,
output reg				blt_even_wr,
output reg	[3:0]		blt_even_wdata,
output reg	[6:0]		blt_odd_waddr,
output reg				blt_odd_wr,
output reg	[3:0]		blt_odd_wdata
);

//////////////// FSM status ////////////////
parameter		IDLE				=	4'h0;
parameter		NEXT_CODE_INIT	=	4'h1;
parameter		BLCNT_SEEK		=	4'h2;
parameter		NC_HEAP_READ	=	4'h3;	// next_code and external heap read
parameter		VLC_GEN			=	4'h4;
parameter		DONE				=	4'h5;
////////////////////////////////////////////

// FSM signal
reg	[3:0]		current_state,next_state;
// encode start signal delay
reg				vlc_start_d1;
// bl_count accumulate counter for next_code
reg				init_cnt_en,bl_acc_en;
reg	[4:0]		init_cnt,init_cnt_d1;
reg	[15:0]	bl_acc;
// leaf node counter
reg				leaf_cnt_en;
reg	[9:0]		leaf_cnt;
// next_code ram signal
reg				ncode_wea,ncode_web;
reg	[3:0]		ncode_addra,ncode_addrb;
reg	[15:0]	ncode_dina,ncode_dinb;
wire	[15:0]	ncode_douta,ncode_doutb;
// vlc table ram signal
reg				vlc_wea,vlc_web;
reg	[7:0]		vlc_addra,vlc_addrb,vlc_addrc,vlc_addrd;
reg	[19:0]	vlc_dina,vlc_dinb;
// next_code and bl_count scan counter 
reg	[4:0]		scan_cnt,scan_cnt_prev;
reg				scan_cnt_en;
reg				scan_cnt_incr;
// Sub counter in every bl_count[i] started by next_code[i]
reg	[15:0]	vlc_cnt;
reg	[8:0]		sub_cnt;
reg				vlc_load,vlc_cnt_en;
// Seek first BL_count[i] != 0 
wire				seek_done;

/////////////////////////////////////////////////
////			Dividual Combination Logic 		////
/////////////////////////////////////////////////

// Select 4bit count value in 16bit bl_dout_even/bl_dout_odd
function	[3:0]	SEL4B;
	input	[15:0]	data;
	input	[1:0]		sel;
	begin
		case(sel)
		2'b00	:	SEL4B	=	data[15:12];
		2'b01	:	SEL4B	=	data[11:8];
		2'b10	:	SEL4B	=	data[7:4];
		2'b11	:	SEL4B	=	data[3:0];
		default:	SEL4B	=	4'b0;
		endcase
	end
endfunction

// Seek first BL_count[i] != 0 
assign		seek_done	=	(bl_cnt_douta != 9'b0) ? 1'b1 : 1'b0;

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

// bl_count accumulate counter for next_code
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		init_cnt		<=	5'b0;	
		init_cnt_d1	<=	5'b0;	
	end
	else
	begin
		init_cnt_d1	<=	init_cnt;
		if({vlc_start_d1,vlc_start}==2'b01)	
			init_cnt	<=	5'b0;	
		else if(init_cnt_en)
			init_cnt	<=	init_cnt + 2'h2;
		else
			init_cnt	<=	init_cnt;
	end
end

// leaf node counter
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		leaf_cnt	<=	9'b0;
	end
	else
	begin
		if({vlc_start_d1,vlc_start}==2'b01)
			leaf_cnt	<=	9'b0;
		else if(leaf_cnt_en)
			leaf_cnt	<=	leaf_cnt + 1'b1;
		else
			leaf_cnt	<=	leaf_cnt;
	end
end

// bl_acc use bl_count accumulate to next_code
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		bl_acc	<=	16'b0;
	end
	else
	begin
		if({vlc_start_d1,vlc_start}==2'b01)
			bl_acc	<=	16'b0;
		else if(bl_acc_en)
			bl_acc	<=	ncode_dinb;
		else
			bl_acc	<=	bl_acc;
	end
end

// next_code and bl_count scan counter 
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		scan_cnt			<=	5'b0;
		scan_cnt_prev	<=	5'b0;
	end
	else
	begin
		if(scan_cnt_incr)								// when scan_cnt_incr==1, previous status is no need to be store
			scan_cnt_prev	<=	scan_cnt + 1'b1;	// So scan_cnt_prev change with scan_cnt in the same time
		else												
			scan_cnt_prev	<=	scan_cnt;
		if({vlc_start_d1,vlc_start}==2'b01)
			scan_cnt	<=	5'h1;
		else if(scan_cnt_en)
		begin
			if((bl_cnt_douta == 9'b0) || scan_cnt_incr)
				scan_cnt	<=	scan_cnt + 1'b1;
			else
				scan_cnt	<=	scan_cnt_prev;
		end
		else
			scan_cnt	<=	scan_cnt;
	end
end

// Sub counter in every bl_count[i] started by next_code[i]
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		vlc_cnt	<=	16'b0;
		sub_cnt	<=	9'b0;
	end
	else
	begin
		if({vlc_start_d1,vlc_start}==2'b01)
		begin
			vlc_cnt	<=	16'b0;
			sub_cnt	<=	9'b0;
		end
		else if(vlc_load)
		begin
			vlc_cnt	<=	ncode_douta + {7'b0,(bl_cnt_douta - 1'b1)};	
			sub_cnt	<=	bl_cnt_douta;	
		end
		else if(vlc_cnt_en)
		begin
			vlc_cnt	<=	vlc_cnt - 1'b1;
			sub_cnt	<=	sub_cnt - 1'b1;
		end
		else
		begin
			vlc_cnt	<=	vlc_cnt;
			sub_cnt	<=	sub_cnt;
		end
	end
end


/////////////////////////////////////////////////
////				Combination Logic 				////
/////////////////////////////////////////////////
// FSM state transfer
always @ (*)
begin
	case(current_state)
	IDLE				:	begin
								if({vlc_start_d1,vlc_start}==2'b01)	
									next_state	=	NEXT_CODE_INIT;       
								else                                   
									next_state	=	IDLE;                
							end                                       	
	NEXT_CODE_INIT	:	begin
								if(init_cnt >= 5'h10)
									next_state	=	BLCNT_SEEK;
								else
									next_state	=	NEXT_CODE_INIT;
							end
	BLCNT_SEEK		:	begin
								if(seek_done)
									next_state	=	NC_HEAP_READ;
								else
									next_state	=	BLCNT_SEEK;
							end
   NC_HEAP_READ	:	begin
								next_state	=	VLC_GEN;
							end
   VLC_GEN			:	begin
								if(leaf_cnt > 9'hFF)
									next_state	=	DONE;
								else if(sub_cnt > 9'h1)
									next_state	=	NC_HEAP_READ;
								else
									next_state	=	BLCNT_SEEK;
							end
   DONE				:	begin
								if({vlc_start_d1,vlc_start}==2'b01)	
									next_state	=	NEXT_CODE_INIT;      
								else
									next_state	=	DONE;
							end
	default			:	begin
								next_state	=	IDLE;
							end
	endcase
end


// FSM BL_COUNT and NEXT_CODE and HEAP control signal
always @ (*)
begin
	case(current_state)
	IDLE				:	begin
								bl_cnt_addra	=	4'b0;
                        bl_cnt_addrb	=	4'b0;
								init_cnt_en		=	1'b0;
								ncode_wea		=	1'b0;
								ncode_addra		=	4'b0;
								ncode_dina		=	16'b0;
								ncode_web		=	1'b0;
								ncode_addrb		=	4'b0;
								ncode_dinb		=	16'b0;
								scan_cnt_en		=	1'b0;
								scan_cnt_incr	=	1'b0;
								bl_acc_en		=	1'b0;
								heap_even_rd	=	1'b0;
								heap_odd_rd		=	1'b0;
								vlc_done			=	1'b0;
							end                                       	
	NEXT_CODE_INIT	:	begin
								bl_cnt_addra	=	init_cnt[3:0];
                        bl_cnt_addrb	=	init_cnt[3:0] + 1'b1;
								init_cnt_en		=	1'b1;
								if(init_cnt >= 5'h01)
								begin
									ncode_wea	=	1'b1;
									ncode_web	=	1'b1;
									bl_acc_en	=	1'b1;
								end
								else
								begin
									ncode_wea	=	1'b0;
									ncode_web	=	1'b0;
									bl_acc_en	=	1'b0;
								end
								ncode_addra		=	init_cnt[3:0] - 1'b1;
								ncode_dina		=	((bl_acc + bl_cnt_douta) << 1);
								ncode_addrb		=	init_cnt[3:0];
								ncode_dinb		=	((ncode_dina + bl_cnt_doutb) << 1);	//	Notice: Last element be stored in address 0 must be 0
								scan_cnt_en		=	1'b0;											// because of the algorithm
								scan_cnt_incr	=	1'b0;
								heap_even_rd	=	1'b0;
								heap_odd_rd		=	1'b0;
								vlc_done			=	1'b0;
							end
	BLCNT_SEEK		:	begin
								bl_cnt_addra	=	scan_cnt[3:0];				// Previous status last init_cnt is 5'h10 
                        bl_cnt_addrb	=	4'b0;							// scan_cnt initial value should be 5'h01
								init_cnt_en		=	1'b0;							// process only 1 VLC per FSM cycle to guaruntee seek 
								ncode_wea		=	1'b0;                   // nonezero bl_count[i] be count correctly
								ncode_addra		=	scan_cnt[3:0];
								ncode_dina		=	16'b0;
								ncode_web		=	1'b0;
								ncode_addrb		=	4'b0;
								ncode_dinb		=	16'b0;
								bl_acc_en		=	1'b0;
								scan_cnt_en		=	1'b1;
								scan_cnt_incr	=	1'b0;
								heap_even_rd	=	1'b0;
								heap_odd_rd		=	1'b0;
								vlc_done			=	1'b0;
							end
   NC_HEAP_READ	:	begin
								bl_cnt_addra	=	scan_cnt[3:0];
                        bl_cnt_addrb	=	4'b0;
								init_cnt_en		=	1'b0;
								ncode_wea		=	1'b0;
								ncode_addra		=	scan_cnt[3:0];
								ncode_dina		=	16'b0;
								ncode_web		=	1'b0;
								ncode_addrb		=	4'b0;
								ncode_dinb		=	16'b0;
								bl_acc_en		=	1'b0;
								scan_cnt_en		=	1'b0;
								scan_cnt_incr	=	1'b0;
								vlc_done			=	1'b0;
								if(leaf_cnt[0])
								begin
									heap_even_rd	=	1'b1;
									heap_odd_rd		=	1'b0;
								end
								else
								begin
									heap_even_rd	=	1'b0;
									heap_odd_rd		=	1'b1;
								end
							end
   VLC_GEN			:	begin
								if(sub_cnt > 9'h1)		// pre-read next bl_count[i]
								begin
									bl_cnt_addra	=	scan_cnt[3:0];
									ncode_addra		=	scan_cnt[3:0];
									scan_cnt_en		=	1'b0;
									scan_cnt_incr	=	1'b0;
								end
								else
								begin
									bl_cnt_addra	=	scan_cnt[3:0] + 1'b1;
									ncode_addra		=	scan_cnt[3:0] + 1'b1;
									scan_cnt_en		=	1'b1;
									scan_cnt_incr	=	1'b1;
								end
                        bl_cnt_addrb	=	4'b0;
								init_cnt_en		=	1'b0;
								ncode_wea		=	1'b0;
								ncode_dina		=	16'b0;
								ncode_web		=	1'b0;
								ncode_addrb		=	4'b0;
								ncode_dinb		=	16'b0;
								bl_acc_en		=	1'b0;
								heap_even_rd	=	1'b0;
								heap_odd_rd		=	1'b0;
								vlc_done			=	1'b0;
							end
   DONE				:	begin
								bl_cnt_addra	=	4'b0;
                        bl_cnt_addrb	=	4'b0;
								init_cnt_en		=	1'b0;
								ncode_wea		=	1'b0;
								ncode_addra		=	4'b0;
								ncode_dina		=	16'b0;
								ncode_web		=	1'b0;
								ncode_addrb		=	4'b0;
								ncode_dinb		=	16'b0;
								scan_cnt_en		=	1'b0;
								scan_cnt_incr	=	1'b0;
								bl_acc_en		=	1'b0;
								heap_even_rd	=	1'b0;
								heap_odd_rd		=	1'b0;
								vlc_done			=	1'b1;
							end
	default			:	begin
								bl_cnt_addra	=	4'b0;
                        bl_cnt_addrb	=	4'b0;
								init_cnt_en		=	1'b0;
								ncode_wea		=	1'b0;
								ncode_addra		=	4'b0;
								ncode_dina		=	16'b0;
								ncode_web		=	1'b0;
								ncode_addrb		=	4'b0;
								ncode_dinb		=	16'b0;
								scan_cnt_en		=	1'b0;
								scan_cnt_incr	=	1'b0;
								bl_acc_en		=	1'b0;
								heap_even_rd	=	1'b0;
								heap_odd_rd		=	1'b0;
								vlc_done			=	1'b0;
							end
	endcase
end

// VLC table signal
always @ (*)
begin
	case(current_state)
	IDLE				:	begin
								vlc_load			=	1'b0;
								vlc_cnt_en		=	1'b0;
								leaf_cnt_en		=	1'b0;
								vlc_wea			=	1'b0;
								vlc_dina			=	20'b0;
								vlc_addra		=	8'b0;
								vlc_web			=	1'b0;
								vlc_dinb			=	20'b0;
								vlc_addrb		=	8'b0;
								vlc_addrc		=	8'b0;
								vlc_addrd		=	8'b0;
							end                                       	
	NEXT_CODE_INIT	:	begin
								vlc_load			=	1'b0;
								vlc_cnt_en		=	1'b0;
								leaf_cnt_en		=	1'b0;
								vlc_wea			=	1'b0;
								vlc_dina			=	20'b0;
								vlc_addra		=	8'b0;
								vlc_web			=	1'b0;
								vlc_dinb			=	20'b0;
								vlc_addrb		=	8'b0;
								vlc_addrc		=	8'b0;
								vlc_addrd		=	8'b0;
							end
	BLCNT_SEEK		:	begin
								if(seek_done)
									vlc_load		=	1'b1;
								else
									vlc_load		=	1'b0;
								vlc_cnt_en		=	1'b0;
								leaf_cnt_en		=	1'b0;
								vlc_wea			=	1'b0;
								vlc_dina			=	20'b0;
								vlc_addra		=	8'b0;
								vlc_web			=	1'b0;
								vlc_dinb			=	20'b0;
								vlc_addrb		=	8'b0;
								vlc_addrc		=	8'b0;
								vlc_addrd		=	8'b0;
							end						
   NC_HEAP_READ	:	begin
								vlc_load			=	1'b0;
								vlc_cnt_en		=	1'b0;
								leaf_cnt_en		=	1'b1;
								vlc_wea			=	1'b0;
								vlc_dina			=	20'b0;
								vlc_addra		=	8'b0;
								vlc_web			=	1'b0;
								vlc_dinb			=	20'b0;
								vlc_addrb		=	8'b0;
								vlc_addrc		=	8'b0;
								vlc_addrd		=	8'b0;
							end
   VLC_GEN			:	begin
								vlc_load			=	1'b0;
								vlc_cnt_en		=	1'b1;
								leaf_cnt_en		=	1'b0;
								if(leaf_cnt[0])
								begin
									vlc_wea	=	1'b0;		// port A for EVEN
									vlc_web	=	1'b1;		// port B for ODD
								end
								else
								begin
									vlc_wea	=	1'b1;
									vlc_web	=	1'b0;	
								end
								vlc_dina			=	{scan_cnt[3:0],vlc_cnt};
								vlc_addra		=	heap_even_dout;
								vlc_dinb			=	{scan_cnt[3:0],vlc_cnt};
								vlc_addrb		=	heap_odd_dout;
								vlc_addrc		=	heap_even_dout;
								vlc_addrd		=	heap_odd_dout;
							end
   DONE				:	begin
								vlc_load			=	1'b0;
								vlc_cnt_en		=	1'b0;
								leaf_cnt_en		=	1'b0;
								vlc_wea			=	1'b0;		
								vlc_dina			=	20'b0;   
								vlc_addra		=	vlc_addra_in;
								vlc_web			=	1'b0;    
								vlc_dinb			=	20'b0;
								vlc_addrb		=	vlc_addrb_in;
								vlc_addrc		=	vlc_addrc_in;
								vlc_addrd		=	vlc_addrd_in;
							end
	default			:	begin
								vlc_load			=	1'b0;
								vlc_cnt_en		=	1'b0;
								leaf_cnt_en		=	1'b0;
								vlc_wea			=	1'b0;
								vlc_dina			=	20'b0;
								vlc_addra		=	8'b0;
								vlc_web			=	1'b0;
								vlc_dinb			=	20'b0;
								vlc_addrb		=	8'b0;
								vlc_addrc		=	8'b0;
								vlc_addrd		=	8'b0;
							end
	endcase
end

// BL table output
always @ (*)
begin
	case(current_state)
	IDLE				,                                       	
	NEXT_CODE_INIT	,
	BLCNT_SEEK		,
   NC_HEAP_READ	:	begin
								blt_even_waddr	=	7'b0;
								blt_even_wr		=	1'b0;
                        blt_even_wdata	=	4'b0;
                        blt_odd_waddr	=	7'b0;
                        blt_odd_wr		=	1'b0;
								blt_odd_wdata	=	4'b0;
							end
   VLC_GEN			:	begin
								if(leaf_cnt[0])
								begin
									if(heap_odd_dout[0])
									begin
										blt_even_wr	=	1'b0;
										blt_odd_wr	=	1'b1;
									end
									else
									begin
										blt_even_wr	=	1'b1;
										blt_odd_wr	=	1'b0;
									end
									blt_even_waddr	=	heap_odd_dout[7:1];
									blt_odd_waddr	=	heap_odd_dout[7:1];
								end
								else
								begin
									if(heap_even_dout[0])
									begin
										blt_even_wr	=	1'b0;
										blt_odd_wr	=	1'b1;
									end
									else
									begin
										blt_even_wr	=	1'b1;
										blt_odd_wr	=	1'b0;
									end
									blt_even_waddr	=	heap_even_dout[7:1];
									blt_odd_waddr	=	heap_even_dout[7:1];
								end
                        blt_even_wdata	=	scan_cnt[3:0];
								blt_odd_wdata	=	scan_cnt[3:0];
							end
   DONE				:	begin
								blt_even_waddr	=	7'b0;
								blt_even_wr		=	1'b0;
                        blt_even_wdata	=	4'b0;
                        blt_odd_waddr	=	7'b0;
                        blt_odd_wr		=	1'b0;
								blt_odd_wdata	=	4'b0;
							end
	default			:	begin
								blt_even_waddr	=	7'b0;
								blt_even_wr		=	1'b0;
                        blt_even_wdata	=	4'b0;
                        blt_odd_waddr	=	7'b0;
                        blt_odd_wr		=	1'b0;
								blt_odd_wdata	=	4'b0;
							end
	endcase
end


/////////////////////////////////////////////////
////					Sub Modules						////
/////////////////////////////////////////////////
// ram for NEXT_CODE[i]
bram_16x16bit	U_next_code
(
  .clka			(clk),
  .wea			(ncode_wea),	
  .addra			(ncode_addra),	
  .dina			(ncode_dina),	
  .clkb			(clk),			
  .web			(ncode_web),	
  .addrb			(ncode_addrb),
  .dinb			(ncode_dinb),
	
  .douta			(ncode_douta),
  .doutb			(ncode_doutb)
);

// RAM 256x20bit for VLC encode table for PORT A B
ram_256x20bit	U_vlc_table_1
(
  .clka			(clk),
  .wea			(vlc_wea),		// port A for EVEN
  .addra			(vlc_addra),  
  .dina			(vlc_dina),	
  .clkb			(clk),		
  .web			(vlc_web), 		// port B for ODD
  .addrb			(vlc_addrb),
  .dinb			(vlc_dinb),
  
  .douta			(vlc_douta),
  .doutb			(vlc_doutb)
);

// RAM 4096x17bit for VLC encode table for PORT C D
ram_256x20bit	U_vlc_table_2
(
  .clka			(clk),
  .wea			(vlc_wea),		// port A for EVEN
  .addra			(vlc_addrc),   
  .dina			(vlc_dina),    
  .clkb			(clk),         
  .web			(vlc_web),     // port B for ODD
  .addrb			(vlc_addrd),
  .dinb			(vlc_dinb),
  
  .douta			(vlc_doutc),
  .doutb			(vlc_doutd)
);

endmodule
