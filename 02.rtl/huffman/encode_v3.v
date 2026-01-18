`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:35:50 08/15/2016 
// Design Name: 
// Module Name:    encode_v3 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: Encode Header in Semi-huffman mode is VLC_TABLE 256 x 16bit == 512Byte
//
//					16bit header element[i] frame:
// (MSB)		 Reserve  		VLC_code[i] (LSB)
//					1bit				15bit
//				0:	Semi-huffman mode(every element has 15bit VLC_code)				 
//				1:	Full-dynamic-huffman mode(if this bit is 0, code didn't appeal, 15bit VLC_code is ignored)
//
//	Revision 3.00 - Delete src_len signal 
//							and reserve the source file length dword position; Data fifo set to 8K depth;
//							Add src_end and src_len signal input
//							
//////////////////////////////////////////////////////////////////////////////////
module encode_v3(
// global clock and reset
input wire				clk,
input wire				rstN,
// control and status signal
input wire				encode_start,
input wire	[2:0]		last_mask,
output reg				encode_done,
// bl table ram read FIFO interface
output reg				blt_rd,
input wire	[31:0]	blt_dout,
input wire				blt_valid,
input wire				blt_empty,
// Read Heap from min element by FIFO interface
output reg				heap_rd,
input wire	[31:0]	heap_dout,
input wire				heap_valid,
input	wire				heap_empty,
// input source data
input wire	[31:0]	src_data,
input wire				src_valid,
input wire				src_empty,
input wire				src_end,	// indicate the source data input has finished
input	wire	[31:0]	src_len,	// length of source data length from LZ4 encoder(variable in compression processing)
output reg				rd_src,
// Encode VLC Table interface
input wire	[19:0]	vlc_douta,
input wire	[19:0]	vlc_doutb,
input wire	[19:0]	vlc_doutc,
input wire	[19:0]	vlc_doutd,
output wire	[7:0]		vlc_addra,
output wire	[7:0]		vlc_addrb,
output wire	[7:0]		vlc_addrc,
output wire	[7:0]		vlc_addrd,
// encoded data out FIFO interface
input wire				rd_encode,
output wire	[31:0]	encode_data,
output wire				encode_valid,
output wire				encode_empty,
output wire				encode_full,
output wire				encode_hfull
);

//////////////// FSM status ////////////////
parameter		IDLE				=	4'h0;
parameter		START				=	4'h1;
parameter		MAGIC_NUMBER	=	4'h2;
parameter		SRC_LENGTH		=	4'h3;
parameter		LR_HEAP			=	4'h4;
parameter		BL_TABLE			=	4'h5;
parameter		LOOKUP			=	4'h6;
parameter		DONE				=	4'h7;
////////////////////////////////////////////
// Parameters for MAGIC Number
parameter		MAGIC_NUM	=	32'hD4_C3_B2_A1; // little endian
// FSM signal
reg	[3:0]		current_state,next_state;
// lookup_table module fifo full signal
wire				lookup_full;
// 4 parallal vlc lookup_table
wire				vlc_empty_1,vlc_empty_2,vlc_empty_3,vlc_empty_4;
wire				vlc_full_1,vlc_full_2,vlc_full_3,vlc_full_4;
wire	[3:0]		vlc_len_1,vlc_len_2,vlc_len_3,vlc_len_4;		
wire	[15:0]	vlc_code_1,vlc_code_2,vlc_code_3,vlc_code_4;		
wire				vlc_valid_1,vlc_valid_2,vlc_valid_3,vlc_valid_4;	
wire				vlc_rd_1,vlc_rd_2,vlc_rd_3,vlc_rd_4;
reg	[3:0]		lookup_en;
// vlc data glue signal
wire	[31:0]	vlc_glue_data;
wire				vlc_glue_valid;
wire				vlc_glue_done;
reg				vlc_glue_start;
// encoded count in FIFO
wire	[12:0]	encode_count;
// encode_start signal delay
reg				encode_start_d1;
// out data to encoded FIFO
reg	[31:0]	out_data;
reg				out_valid;
// processed file length counter
reg	[31:0]	proc_len_cnt;
// indicate data read from source fifo has been ended
reg				data_end;

/////////////////////////////////////////////////
////			Dividual Combination Logic 		////
/////////////////////////////////////////////////
// half full signal generation
assign		encode_hfull	=	(encode_count >= 13'h1000) ? 1'b1 : 1'b0;
// look up full
assign		lookup_full		=	vlc_full_1 | vlc_full_2 | vlc_full_3 | vlc_full_4;

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

// encode start delay signal
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		encode_start_d1	<=	1'b0;
	end
	else
	begin
		encode_start_d1	<=	encode_start;
	end
end

// processed file length counter
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		proc_len_cnt	<=	32'b0;
	end
	else
	begin
		if({encode_start_d1,encode_start}==2'b01)
			proc_len_cnt	<=	32'b0;
		else if(rd_src)
			proc_len_cnt	<=	proc_len_cnt + 3'h4;
		else
			proc_len_cnt	<=	proc_len_cnt;
	end
end

// encode data end signal generation
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		data_end		<=	1'b0;
	end
	else
	begin
		if({encode_start_d1,encode_start}==2'b01)
		begin
			data_end		<=	1'b0;
		end
		else if(proc_len_cnt >= src_len)
		begin
			data_end		<=	1'b1;
		end
		else
		begin
			data_end		<=	data_end;
		end
	end
end

// look up module data enable signal generation
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		lookup_en	<=	4'b0;
	end
	else
	begin
		if(proc_len_cnt >= src_len)
		begin
			case(last_mask)
			3'b001	:	lookup_en <= 4'b0001;
			3'b010	:	lookup_en <= 4'b0011;
			3'b011	:	lookup_en <= 4'b0111;
			3'b100	:	lookup_en <= 4'b1111;
			default	:	lookup_en <= 4'b0;
			endcase
		end
		else
		begin
			lookup_en	<=	4'b1111;
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
								if({encode_start_d1,encode_start}==2'b01)
									next_state	=	START;
								else
									next_state	=	IDLE;
							end
	START				:	begin
								next_state	=	MAGIC_NUMBER;
							end
	MAGIC_NUMBER	:	begin
								next_state	=	SRC_LENGTH;
							end
	SRC_LENGTH		:	begin
								next_state	=	LR_HEAP;
							end
	LR_HEAP			:	begin
								if(heap_empty)
									next_state	=	BL_TABLE;
								else
									next_state	=	LR_HEAP;
							end
	BL_TABLE			:	begin
								if(blt_empty)
									next_state	=	LOOKUP;
								else
									next_state	=	BL_TABLE;
							end
	LOOKUP			:	begin
								if(vlc_glue_done & data_end)
									next_state	=	DONE;
								else
									next_state	=	LOOKUP;
							end
	DONE				:	begin
								if({encode_start_d1,encode_start}==2'b01)
									next_state	=	IDLE;
								else
									next_state	=	DONE;
							end
	default			:	begin
								next_state	=	IDLE;
							end
	endcase
end

// FSM control signal generation
always @ (*)
begin
	case(current_state)
	IDLE				:	begin
								heap_rd			=	1'b0;
								blt_rd			=	1'b0;
								rd_src			=	1'b0;
								out_data			=	32'b0;
								out_valid		=	1'b0;
								vlc_glue_start	=	1'b0;
								encode_done		=	1'b0;
							end
	START				:	begin
								heap_rd			=	1'b0;
								blt_rd			=	1'b0;
								rd_src			=	1'b0;
								out_data			=	32'b0;
								out_valid		=	1'b0;
								vlc_glue_start	=	1'b1;
								encode_done		=	1'b0;
							end
	MAGIC_NUMBER	:	begin
								heap_rd			=	1'b0;
								blt_rd			=	1'b0;
								rd_src			=	1'b0;
								out_data			=	MAGIC_NUM;
								out_valid		=	1'b1;
								vlc_glue_start	=	1'b0;
								encode_done		=	1'b0;
							end
	SRC_LENGTH		:	begin
								heap_rd			=	1'b1;
								blt_rd			=	1'b0;
								rd_src			=	1'b0;
								out_data			=	32'b0; //	{src_len_reg[7:0],src_len_reg[15:8],src_len_reg[23:16],src_len_reg[31:24]};
								out_valid		=	1'b1;
								vlc_glue_start	=	1'b0;
								encode_done		=	1'b0;
							end
	LR_HEAP			:	begin
								if(heap_empty)
								begin
									heap_rd	=	1'b0;
									blt_rd	=	1'b1;
								end
								else
								begin
									heap_rd	=	1'b1;
									blt_rd	=	1'b0;
								end
								rd_src			=	1'b0;
								if(heap_valid)
								begin
									out_data		=	heap_dout;
									out_valid	=	1'b1;
								end
								else
								begin
									out_data		=	32'b0;
									out_valid	=	1'b0;
								end
								vlc_glue_start	=	1'b0;
								encode_done		=	1'b0;
							end
	BL_TABLE			:	begin
								heap_rd			=	1'b0;
								blt_rd			=	1'b1;
								rd_src			=	1'b0;
								out_data			=	blt_dout;
								out_valid		=	blt_valid;
								vlc_glue_start	=	1'b0;
								encode_done		=	1'b0;
							end
	LOOKUP			:	begin
								heap_rd			=	1'b0;
								blt_rd			=	1'b0;
								if(lookup_full | src_empty)
									rd_src	=	1'b0;
								else
									rd_src	=	1'b1;
								if(blt_valid)
								begin
									out_data		=	blt_dout;
									out_valid	=	blt_valid;
								end
								else
								begin
									out_data		=	vlc_glue_data;
									out_valid	=	vlc_glue_valid;
								end
								vlc_glue_start	=	1'b0;
								encode_done		=	1'b0;
							end
	DONE				:	begin
								heap_rd			=	1'b0;
								blt_rd			=	1'b0;
								rd_src			=	1'b0;
								out_data			=	32'b0;
								out_valid		=	1'b0;
								vlc_glue_start	=	1'b0;
								encode_done		=	1'b1;
							end
	default			:	begin
								heap_rd			=	1'b0;
								blt_rd			=	1'b0;
								rd_src			=	1'b0;
								out_data			=	32'b0;
								out_valid		=	1'b0;
								vlc_glue_start	=	1'b0;
								encode_done		=	1'b0;
							end
	endcase
end


/////////////////////////////////////////////////
////					Sub Modules						////
/////////////////////////////////////////////////
// look up from table PORT A
code_lookup_v2		U_code_lookup_1
(
	// global clock and reset
	.clk				(clk),
	.rstN				(rstN),
	// input source data
	.src_data		(src_data[31:24]),
	.src_valid		(src_valid & lookup_en[0]),
	// lookup table 16 bit VLC code sequence
	.vlc_data		(vlc_douta),
	.vlc_addr		(vlc_addra),
	// module slave interface
	.error			(),
	// output fifo interface
	.rd_code			(vlc_rd_1	),
	.code_len		(vlc_len_1	),	//	last 16bit segment valid data bits number
	.code_data		(vlc_code_1	),
	.code_valid		(vlc_valid_1),
	.code_empty		(vlc_empty_1),
	.code_full		(vlc_full_1)
);

// look up from table PORT B
code_lookup_v2		U_code_lookup_2
(
	// global clock and reset
	.clk				(clk),
	.rstN				(rstN),
	// input source data
	.src_data		(src_data[23:16]),
	.src_valid		(src_valid & lookup_en[1]),
	// lookup table 16 bit VLC code sequence
	.vlc_data		(vlc_doutb),
	.vlc_addr		(vlc_addrb),
	// module slave interface
	.error			(),
	// output fifo interface
	.rd_code			(vlc_rd_2	),
	.code_len		(vlc_len_2	),	//	last 16bit segment valid data bits number
	.code_data		(vlc_code_2	),
	.code_valid		(vlc_valid_2),
	.code_empty		(vlc_empty_2),
	.code_full		(vlc_full_2)
);

// look up from table PORT C
code_lookup_v2		U_code_lookup_3
(
	// global clock and reset
	.clk				(clk),
	.rstN				(rstN),
	// input source data
	.src_data		(src_data[15:8]),
	.src_valid		(src_valid & lookup_en[2]),
	// lookup table 16 bit VLC code sequence
	.vlc_data		(vlc_doutc),
	.vlc_addr		(vlc_addrc),
	// module slave interface
	.error			(),
	// output fifo interface
	.rd_code			(vlc_rd_3	),
	.code_len		(vlc_len_3	),	//	last 16bit segment valid data bits number
	.code_data		(vlc_code_3	),
	.code_valid		(vlc_valid_3),
	.code_empty		(vlc_empty_3),
	.code_full		(vlc_full_3)
);

// look up from table PORT D
code_lookup_v2		U_code_lookup_4
(
	// global clock and reset
	.clk				(clk),
	.rstN				(rstN),
	// input source data
	.src_data		(src_data[7:0]),
	.src_valid		(src_valid & lookup_en[3]),
	// lookup table 16 bit VLC code sequence
	.vlc_data		(vlc_doutd),
	.vlc_addr		(vlc_addrd),
	// module slave interface
	.error			(),
	// output fifo interface
	.rd_code			(vlc_rd_4	),
	.code_len		(vlc_len_4	),	//	last 16bit segment valid data bits number
	.code_data		(vlc_code_4	),
	.code_valid		(vlc_valid_4),
	.code_empty		(vlc_empty_4),
	.code_full		(vlc_full_4)
);

// vlc glue logic
vlc_glue_v4		U_vlc_glue
(
	// global clock and reset
	.clk				(clk),
	.rstN				(rstN),
	.vlc_glue_start(vlc_glue_start),
	.vlc_glue_done	(vlc_glue_done	),
	.src_empty		(src_empty		),
	.src_end			(src_end			),
	//	input 16 bit VLC code sequence
	.vlc_empty_1	(vlc_empty_1	),
	.vlc_len_1		(vlc_len_1		),
	.vlc_code_1		(vlc_code_1		),
	.vlc_valid_1	(vlc_valid_1	),
	.vlc_rd_1		(vlc_rd_1		),
	.vlc_empty_2	(vlc_empty_2	),
	.vlc_len_2		(vlc_len_2		),
	.vlc_code_2		(vlc_code_2		),
	.vlc_valid_2	(vlc_valid_2	),
	.vlc_rd_2		(vlc_rd_2		),
	.vlc_empty_3	(vlc_empty_3	),
	.vlc_len_3		(vlc_len_3		),
	.vlc_code_3		(vlc_code_3		),
	.vlc_valid_3	(vlc_valid_3	),
	.vlc_rd_3		(vlc_rd_3		),
	.vlc_empty_4	(vlc_empty_4	),
	.vlc_len_4		(vlc_len_4		),
	.vlc_code_4		(vlc_code_4		),
	.vlc_valid_4	(vlc_valid_4	),
	.vlc_rd_4		(vlc_rd_4		),
	// output 32bit Glued data
	.vlc_glue_data	(vlc_glue_data	),
	.vlc_glue_valid(vlc_glue_valid)
);

// FIFO 4Kx32bit for encoded data
fifo_8kx32bit	U_fifo_8kx32bit
(
  .clk			(clk),
  .rst			(~rstN),
  .din			(out_data),		//	initN ? vlc_glue_data	:	blt_dout
  .wr_en			(out_valid),	//	initN ? vlc_glue_valid	:	blt_valid
  .rd_en			(rd_encode),
  
  .full			(encode_full),
  .empty			(encode_empty),
  .dout			(encode_data),
  .valid			(encode_valid),
  .data_count	(encode_count)
);


endmodule
