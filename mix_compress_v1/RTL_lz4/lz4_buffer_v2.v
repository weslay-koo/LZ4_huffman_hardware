`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:00:24 01/10/2016 
// Design Name: 
// Module Name:    lz4_buffer_v2 
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
module lz4_buffer_v2(
// global clock and reset signal
input wire				clk,
input wire				rstN,
// control signal
input wire				compress_start,
input wire				compress_done,
input wire				match_start,
input	wire				matching,
input wire				seg_done,
input wire	[2:0]		move_dist,	
input wire				move_valid,
// data input 
input wire				wr_req,
input wire	[31:0]	idata,
// fifo output interface
input wire				fifo_rd,
output reg	[31:0]	fifo_odata,	
output reg				fifo_ovalid,	
// RAM address and data interface -- for dict search
input wire	[31:0]	ram_abs_addr,
input wire				ram_rd,
output reg	[31:0]	ram_odata,
output reg	[2:0]		ram_omask,
output reg				ram_ovalid,
// status signal
output reg				outofrange,
output wire	[31:0]	anchor,
output wire				over_band,	//	gurantee read position do not over first conflict address
output reg				buf_full,
output reg				fifo_empty,
output wire	[14:0]	fifo_count,
output wire	[31:0]	head_addr
);
// NOTICE: The FSM just for read data from 
//////////////// FSM status ////////////////
parameter		IDLE				=	4'h0	;
parameter		INIT				=	4'h1	; // when dict less than 64K
parameter		INIT_ALL_READ	=	4'h2	;
parameter		INIT_FIFO_READ	=	4'h3	;
parameter		INIT_DICT_READ	=	4'h4	;
parameter		INIT_WAIT		=	4'h5	;
parameter		OPR_ALL_READ	=	4'h6	;
parameter		OPR_FIFO_READ	=	4'h7	;
parameter		OPR_DICT_READ	=	4'h8	;
parameter		OPR_WAIT			=	4'h9	;
parameter		STOP				=	4'hA	;
////////////////////////////////////////////
// FSM signal
reg	[3:0]		current_state,next_state;
// dict initial signal
reg				init_cnt_en,init_start,init_done;
reg	[16:0]	init_cnt;
// RAM signal
wire				ram_wea,ram_web;
wire	[14:0]	ram_addra,ram_addrb;
wire	[31:0]	ram_dina,ram_dinb;
wire	[31:0]	ram_douta,ram_doutb;
reg	[31:0]	ram_doutb_d1;
// RAM Read and write conflict process
wire				wr_cfifo,rd_cfifo;
wire				wea_conflict,web_conflict;
wire	[14:0]	conflict_addr;
reg	[14:0]	prev_caddr;
wire	[31:0]	conflict_data;
wire	[9:0]		cfifo_count;
wire				cfifo_rdrdy;
wire				cfifo_full,cfifo_empty;
wire				conflict_valid;
reg	[31:0]	conflict_head;
reg				wr_cfifo_d1;
reg				conflict_recode;
// for update counter
wire	[14:0]	update_remain;
// address convert signal
reg	[31:0]	head_Baddr,tail_Baddr;
reg	[31:0]	anchor_Baddr;
wire	[31:0]	relate_Baddr;
wire	[14:0]	queue_head;
reg	[14:0]	queue_tail;
reg	[14:0]	update_pointer;
reg	[14:0]	queue_head_d1,queue_tail_d1;
reg	[14:0]	update_pointer_d1;
wire	[14:0]	ram_rd_addr;
// data mask logic
reg	[2:0]		data_mask;
// delay input signal
reg				wr_req_d1,fifo_rd_d1;
// delay when write command conflict with read 
reg				wr_delay;
// data glue logic
reg	[31:0]	data_glue;
reg				matching_d1;
wire				ram_duo_read;
// conflict data loopback to fifo
wire	[46:0]	cfifo_din;
wire				cfifo_loop;
reg				cvalid_delay;
// ram access address delay
reg	[31:0]	ram_abs_addr_d1;

/////////////////////////////////////////////////
////			Dividual Combination Logic 		////
/////////////////////////////////////////////////

assign			head_addr		=	head_Baddr;
assign			relate_Baddr	=	ram_abs_addr - head_Baddr;	

assign			ram_rd_addr		=	ram_abs_addr[16:2];
assign			ram_wea			=	((!fifo_rd) & wr_req) | wea_conflict; // logic for avoid read and write conflict
assign			ram_dina			=	wea_conflict ? conflict_data : idata;
assign			ram_addra		=	wea_conflict ? conflict_addr : (fifo_rd ? queue_tail : update_pointer);
assign			ram_web			=	(fifo_rd & (!ram_rd) & wr_req) | web_conflict;	// logic for avoid read and write conflict
assign			ram_dinb			=	web_conflict ? conflict_data : idata;
assign			ram_addrb		=	web_conflict ? conflict_addr : (ram_rd ? ram_rd_addr : update_pointer);

assign			wr_cfifo			=		(fifo_rd & ram_rd & (wr_req | conflict_valid)) 
											| 	((fifo_rd | ram_rd) & wr_req & conflict_valid);											
assign			rd_cfifo			=	cfifo_empty ? 1'b0 : cfifo_rdrdy;
assign			wea_conflict	=	(!fifo_rd) & ram_rd & (!wr_req) & conflict_valid;
assign			web_conflict	=	(!(fifo_rd & wr_req)) & (!ram_rd) & conflict_valid;
assign			cfifo_rdrdy		=	!( (wr_req | ram_rd) & (wr_req | fifo_rd) & (fifo_rd | ram_rd) );
	
assign			cfifo_loop		=	conflict_valid & (!(wea_conflict | web_conflict));
assign			cfifo_din		=	cfifo_loop	? 	{conflict_addr,conflict_data}	:	{update_pointer,idata};
	
assign			anchor			=	anchor_Baddr;
	
assign			fifo_count		=	update_pointer - queue_tail;
	
assign			ram_duo_read	=	(({matching_d1,matching}==2'b01)&&(ram_abs_addr[1:0]!=2'b00)) ? 1'b1 : 1'b0;
	
assign			queue_head		=	head_Baddr[16:2];

assign			update_remain	=	queue_head - update_pointer - 1'b1;

// prevent queuee tail go over first conflict address which didn't write in buffer
assign			over_band = (((tail_Baddr + 5'h10) >= conflict_head) && (!cfifo_empty)) ? 1'b1 : 1'b0;

function	[31:0]	GLUE;
	input	[31:0]	data_pre;
	input	[31:0]	data_post;
	input	[2:0]		data_mask;
	begin
		case(data_mask)
		3'b100	:	GLUE	=	data_post;
		3'b001	:	GLUE	=	{data_pre[23:0],data_post[31:24]};
		3'b010	:	GLUE	=	{data_pre[15:0],data_post[31:16]};
		3'b011	:	GLUE	=	{data_pre[7:0],data_post[31:8]};
		default	:	GLUE	=	data_pre;
		endcase
	end
endfunction

	
/////////////////////////////////////////////////
////				 Sequential Logic 				////
/////////////////////////////////////////////////

// FSM main transfer logic
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

//// write signal delay when it conflict with read command
//always @ (posedge clk or negedge rstN)
//begin
//	if(!rstN)
//	begin
//		wr_delay	<=	1'b0;
//	end
//	else
//	begin
//		if(fifo_rd & ram_rd & (wr_req | wr_delay))
//			wr_delay	<=	1'b1;
//		else
//			wr_delay	<=	1'b0;
//	end
//end

//// fifo conflict data loop back signal delay
//always @ (posedge clk or negedge rstN)
//begin
//	if(!rstN)
//	begin
//		cvalid_delay 	<=	1'b0;
//	end
//	else
//	begin
//		if(fifo_rd & ram_rd & (wr_req | wr_delay) & conflict_valid)
//			cvalid_delay 	<=	1'b1;
//		else
//			cvalid_delay 	<=	1'b0;
//	end
//end

// pointer register delay
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		queue_head_d1		<=	15'b0;
		queue_tail_d1		<=	15'b0;
		update_pointer_d1	<=	15'b0;
	end
	else
	begin
		queue_head_d1		<=	queue_head;		
		queue_tail_d1		<=	queue_tail;		
		update_pointer_d1	<=	update_pointer;
	end
end

// input signal delay
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		wr_req_d1	<=	1'b0;
		fifo_rd_d1	<=	1'b0;
	end
	else
	begin
		wr_req_d1	<=	wr_req;
	   fifo_rd_d1	<=	fifo_rd;
	end
end

// dict init counter
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		init_cnt	<=	17'b0;
	end
	else
	begin
		if(init_done)
		begin
			init_cnt	<=	17'b0;
		end
		else if(init_cnt_en)
		begin
			init_cnt	<=	init_cnt	+ 3'h4;
		end
		else
		begin
			init_cnt	<=	init_cnt;
		end
	end
end

// data mask logic
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		data_mask	<=	3'b0;
	end
	else
	begin
		case(ram_abs_addr[1:0])	//	(relate_Baddr[1:0])
		2'b00	:	data_mask	<=	3'b100;
		2'b01	:	data_mask	<=	3'b001;
		2'b10	:	data_mask	<=	3'b010;
		2'b11	:	data_mask	<=	3'b011;
		default:	data_mask	<=	3'b000;
		endcase
	end
end

// status signal out
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		buf_full		<=	1'b0;
		fifo_empty	<=	1'b0;
	end
	else
	begin
		if(	((update_remain <= 15'h1) && wr_req) 
			|| cfifo_full || (cfifo_count >= 10'd253) )
			buf_full		<=	1'b1;
		else if(update_remain >= 15'h1)
			buf_full		<=	1'b0;
		else
			buf_full		<=	buf_full;
			
		if(	((fifo_count <= 15'h1) && fifo_rd && (!wr_req))
			||	(over_band && conflict_recode)	)
			fifo_empty	<=	1'b1;
		else if(	(wr_req && fifo_empty && (!fifo_rd))
				||	((!wr_req) && (!over_band))	)
			fifo_empty	<=	1'b0;
		else
			fifo_empty	<=	fifo_empty;
	end
end

// circle queue pointer
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		head_Baddr		<=	32'b0;
		tail_Baddr		<=	32'b0;
		anchor_Baddr	<=	32'b0;
		update_pointer	<=	15'b0;
		queue_tail		<=	15'b0;
		conflict_head	<=	32'b0;
		prev_caddr		<=	15'b0;
		wr_cfifo_d1		<=	1'b0;
		conflict_recode<=	1'b0;
	end
	else
	begin
		wr_cfifo_d1	<=	wr_cfifo;
		if(fifo_rd)
		begin
			queue_tail	<=	queue_tail + 1'b1;
		end
		else
		begin
			queue_tail	<=	queue_tail;
		end
		
		if(rd_cfifo)
		begin
			conflict_head	<=	conflict_head + {15'b0,(conflict_addr - prev_caddr),2'b0};
			prev_caddr		<=	conflict_addr;
			conflict_recode<=	conflict_recode;
		end
		else if(({wr_cfifo_d1,wr_cfifo}==2'b01) && (!conflict_recode))
		begin
			conflict_head	<=	conflict_head + {15'b0,(update_pointer - prev_caddr),2'b0};
			prev_caddr		<=	update_pointer;
			conflict_recode<=	1'b1;
		end
		else
		begin
			conflict_head	<=	conflict_head;
			prev_caddr		<=	prev_caddr;
			conflict_recode<=	conflict_recode;
		end
			
		if(move_valid)
		begin
			tail_Baddr	<=	tail_Baddr + move_dist;
			if((head_Baddr == 32'b0) && (tail_Baddr - head_Baddr + move_dist >=32'hFFFF))
				head_Baddr	<=	tail_Baddr + move_dist - 32'hFFFF;	// 32'h10000;
			else if(tail_Baddr - head_Baddr + move_dist >=32'hFFFF)
				head_Baddr	<=	head_Baddr + move_dist;
			else
				head_Baddr	<=	head_Baddr;
		end
		else
		begin
			tail_Baddr	<=	tail_Baddr;
			head_Baddr	<=	head_Baddr;
		end
		
		if(!init_done)
			anchor_Baddr	<=	tail_Baddr;
		else if(match_start)
			anchor_Baddr	<=	tail_Baddr;
		else
			anchor_Baddr	<=	anchor_Baddr;	
			
		if(wr_req)
			update_pointer	<=	update_pointer + 1'b1;
		else
			update_pointer	<=	update_pointer;
	end
end

// delay matching signal for read ram port B twice when start match
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		matching_d1		<=	1'b0;
	end
	else
	begin
		matching_d1		<=	matching;
	end
end

//// double read RAM when dict address low 2 bit is not 0
//always @ (posedge clk or negedge rstN)
//begin
//	if(!rstN)
//	begin
//		ram_duo_read	<=	1'b0;
//	end
//	else
//	begin
//		if(({matching_d1,matching}==2'b01)&&(ram_abs_addr[1:0]!=2'b00))
//			ram_duo_read	<=	1'b1;
//		else
//			ram_duo_read	<=	1'b0;
//	end
//end

// RAM data delay
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		ram_doutb_d1	<=	32'b0;
	end
	else
	begin
		if(ram_ovalid || ram_duo_read)
			ram_doutb_d1	<=	ram_doutb;
		else
			ram_doutb_d1	<=	ram_doutb_d1;
	end
end

// out of range signal generation
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		outofrange			<=	1'b0;
		ram_abs_addr_d1	<=	32'b0;
	end
	else
	begin
		if(ram_rd)
			ram_abs_addr_d1	<=	ram_abs_addr;
		else
			ram_abs_addr_d1	<=	ram_abs_addr_d1;
			
		if(matching && (tail_Baddr > ram_abs_addr_d1) && ((tail_Baddr - ram_abs_addr_d1) >= 32'h10000))
			outofrange	<=	1'b1;
		else
			outofrange	<=	1'b0;
	end
end

/////////////////////////////////////////////////
////				 Combination Logic 				////
/////////////////////////////////////////////////

// FSM transfer status
always @ (*)
begin
	case(current_state)
	IDLE				:	begin
								if(compress_done)
									next_state	=	STOP;
								else if(compress_start)
									next_state	=	INIT;
								else
									next_state	=	IDLE;
							end
	INIT,
	INIT_ALL_READ,
	INIT_FIFO_READ,
	INIT_DICT_READ,
	INIT_WAIT		:	begin
								if(init_cnt >= 17'hFFFF)
								begin
									if(fifo_rd&&ram_rd)	//	(matching)
										next_state	=	OPR_ALL_READ;
									else if(fifo_rd)
										next_state	=	OPR_FIFO_READ;
									else if(ram_rd)
										next_state	=	OPR_DICT_READ;
									else
										next_state	=	OPR_WAIT;
								end
								else
								begin
									if(fifo_rd&&ram_rd)	//	(matching)
										next_state	=	INIT_ALL_READ;
									else if(fifo_rd)
										next_state	=	INIT_FIFO_READ;
									else if(ram_rd)
										next_state	=	INIT_DICT_READ;
									else
										next_state	=	INIT_WAIT;
								end
							end
	OPR_ALL_READ,							
	OPR_FIFO_READ,
	OPR_DICT_READ,
	OPR_WAIT			:	begin
								if(compress_done)
								begin
									next_state	=	STOP;
								end
								else
								begin
									if(fifo_rd&&ram_rd)	//	(matching)
										next_state	=	OPR_ALL_READ;
									else if(fifo_rd)
										next_state	=	OPR_FIFO_READ;
									else if(ram_rd)
										next_state	=	OPR_DICT_READ;
									else
										next_state	=	OPR_WAIT;
								end
							end
	STOP				:	begin
								next_state	=	IDLE;
							end
	default			:	begin
								next_state	=	IDLE;
							end
	endcase
end

// FSM signal and output
always @ (*)
begin
	case(current_state)
	IDLE				:	begin
								fifo_odata	=	32'b0;
								fifo_ovalid	=	1'b0;
								ram_odata	=	32'b0;
								ram_omask	=	3'b0;
								ram_ovalid	=	1'b0;
								init_cnt_en	=	1'b0;
								init_start	=	1'b1;
								init_done	=	1'b0;
							end
	INIT				:	begin
								fifo_odata	=	32'b0;
								fifo_ovalid	=	1'b0;
								ram_odata	=	32'b0;
								ram_omask	=	3'b0;
								ram_ovalid	=	1'b0;
								init_cnt_en	=	1'b1;
								init_start	=	1'b1;
								init_done	=	1'b0;
							end
	INIT_ALL_READ	:	begin
								fifo_odata	=	ram_douta;
								fifo_ovalid	=	1'b1;
								ram_odata	=	GLUE(ram_doutb_d1,ram_doutb,data_mask);
								ram_omask	=	data_mask;
								if(ram_duo_read)
									ram_ovalid	=	1'b0;
								else
									ram_ovalid	=	1'b1;
								init_cnt_en	=	1'b1;
								init_start	=	1'b0;
								init_done	=	1'b0;
							end		
	INIT_FIFO_READ	:	begin
								fifo_odata	=	ram_douta;
								fifo_ovalid	=	1'b1;
								ram_odata	=	32'b0;
								ram_omask	=	3'b0;
								ram_ovalid	=	1'b0;
								init_cnt_en	=	1'b1;
								init_start	=	1'b0;
								init_done	=	1'b0;
							end					
	INIT_DICT_READ	:	begin
								fifo_odata	=	32'b0;
								fifo_ovalid	=	1'b0;
								ram_odata	=	GLUE(ram_doutb_d1,ram_doutb,data_mask);
								ram_omask	=	data_mask;
								if(ram_duo_read)
									ram_ovalid	=	1'b0;
								else
									ram_ovalid	=	1'b1;
								init_cnt_en	=	1'b0;
								init_start	=	1'b0;
								init_done	=	1'b0;
							end
	INIT_WAIT		:	begin
								fifo_odata	=	32'b0;
								fifo_ovalid	=	1'b0;
								ram_odata	=	32'b0;
								ram_omask	=	3'b0;
								ram_ovalid	=	1'b0;
								init_cnt_en	=	1'b0;
								init_start	=	1'b0;
								init_done	=	1'b0;
							end
	OPR_ALL_READ	:	begin
								fifo_odata	=	ram_douta;
								fifo_ovalid	=	1'b1;
								ram_odata	=	GLUE(ram_doutb_d1,ram_doutb,data_mask);
								ram_omask	=	data_mask;
								if(ram_duo_read)
									ram_ovalid	=	1'b0;
								else
									ram_ovalid	=	1'b1;
								init_cnt_en	=	1'b0;
								init_start	=	1'b0;
								init_done	=	1'b1;
							end		
	OPR_FIFO_READ	:	begin
								fifo_odata	=	ram_douta;
								fifo_ovalid	=	1'b1;
								ram_odata	=	32'b0;
								ram_omask	=	3'b0;
								ram_ovalid	=	1'b0;
								init_cnt_en	=	1'b0;
								init_start	=	1'b0;
								init_done	=	1'b1;
							end					
	OPR_DICT_READ	:	begin
								fifo_odata	=	32'b0;
								fifo_ovalid	=	1'b0;
								ram_odata	=	GLUE(ram_doutb_d1,ram_doutb,data_mask);
								ram_omask	=	data_mask;
								if(ram_duo_read)
									ram_ovalid	=	1'b0;
								else
									ram_ovalid	=	1'b1;
								init_cnt_en	=	1'b0;
								init_start	=	1'b0;
								init_done	=	1'b1;
							end
	OPR_WAIT			:	begin
								fifo_odata	=	32'b0;
								fifo_ovalid	=	1'b0;
								ram_odata	=	32'b0;
								ram_omask	=	3'b0;
								ram_ovalid	=	1'b0;
								init_cnt_en	=	1'b0;
								init_start	=	1'b0;
								init_done	=	1'b1;
							end
	STOP				:	begin
								fifo_odata	=	32'b0;
								fifo_ovalid	=	1'b0;
								ram_odata	=	32'b0;
								ram_omask	=	3'b0;
								ram_ovalid	=	1'b0;
								init_cnt_en	=	1'b0;
								init_start	=	1'b0;
								init_done	=	1'b1;
							end
	default			:	begin
								fifo_odata	=	32'b0;
								fifo_ovalid	=	1'b0;
								ram_odata	=	32'b0;
								ram_omask	=	3'b0;
								ram_ovalid	=	1'b0;
								init_cnt_en	=	1'b0;
								init_start	=	1'b0;
								init_done	=	1'b0;
							end
	endcase
end


/////////////////////////////////////////////////
////			 	 IP CORES  Module 			   ////
/////////////////////////////////////////////////
// main circul queue ram
buffer_ram32Kx32bit	U_buffer_ram // 64KBx2 Buffer
(
  .clka			(clk),		// port A for FIFO read
  .wea			(ram_wea),
  .addra			(ram_addra),	//	two port all can be write and 
  .dina			(ram_dina),  	//	guarantee not conflict with read operate
  .clkb			(clk),		// port B for RAM read
  .web			(ram_web),
  .addrb			(ram_addrb),
  .dinb			(ram_dinb),
                    
  .douta			(ram_douta),
  .doutb			(ram_doutb)
);

// conflict process little fifo (first byte fall through)
fifo_512x47bit	U_conflict_fifo	// high 15bit is ram addr, low 32bit is data
(
	.clk				(clk),
	.rstN				(rstN),
	.din				(cfifo_din),
	.wr_en			(wr_cfifo),
	.rd_en			(rd_cfifo),
	                
	.dout				({conflict_addr,conflict_data}),
	.valid			(conflict_valid),
	.empty			(cfifo_empty),
	.full				(cfifo_full),
	.data_count		(cfifo_count)
);

endmodule
