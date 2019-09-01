`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:35:50 08/15/2016 
// Design Name: 
// Module Name:    encode_v2 
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
//////////////////////////////////////////////////////////////////////////////////
module encode_v2(
// global clock and reset
input wire				clk,
input wire				rstN,
// control and status signal
input wire				encode_start,
output reg				encode_done,
// input source data
input wire	[31:0]	src_data,
input wire				src_valid,
input wire				src_empty,
output reg				rd_src,
// Encode VLC Table interface
input wire	[21:0]	vlc_douta,
input wire	[21:0]	vlc_doutb,
input wire	[21:0]	vlc_doutc,
input wire	[21:0]	vlc_doutd,
output wire	[11:0]	vlc_addra,
output wire	[11:0]	vlc_addrb,
output wire	[11:0]	vlc_addrc,
output wire	[11:0]	vlc_addrd,
// encoded data out FIFO interface
input wire				rd_encode,
output wire	[31:0]	encode_data,
output wire				encode_valid,
output wire				encode_empty,
output wire				encode_full,
output wire				encode_hfull
);


reg				initN;
wire				all_lookup_done;
wire				lookup_done_1,lookup_done_2,lookup_done_3,lookup_done_4;
wire				vlc_empty_1,vlc_empty_2,vlc_empty_3,vlc_empty_4;
wire	[4:0]		lseg_len_1,lseg_len_2,lseg_len_3,lseg_len_4;		
wire	[15:0]	vlc_code_1,vlc_code_2,vlc_code_3,vlc_code_4;		
wire				vlc_valid_1,vlc_valid_2,vlc_valid_3,vlc_valid_4;	
wire				vlc_rd_1,vlc_rd_2,vlc_rd_3,vlc_rd_4;

wire	[31:0]	vlc_glue_data;
wire				vlc_glue_valid;

wire	[11:0]	encode_count;

/////////////////////////////////////////////////
////			Dividual Combination Logic 		////
/////////////////////////////////////////////////
// encode done signal -- wait 4 Byte all done
assign		all_lookup_done	=	lookup_done_1 && lookup_done_2 && lookup_done_3 && lookup_done_4;
// half full signal generation
assign		encode_hfull		=	(encode_count >= 12'h800) ? 1'b1 : 1'b0;

/////////////////////////////////////////////////
////				 Sequential Logic 				////
/////////////////////////////////////////////////
// read external source file signal
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		rd_src	<=	1'b0;
		initN		<=	1'b0;
	end
	else
	begin
		if(all_lookup_done | initN)
		begin
			rd_src	<=	1'b1;
			initN		<=	1'b1;
		end
		else
		begin
			rd_src	<=	1'b0;
			initN		<=	initN;
		end
	end
end

/////////////////////////////////////////////////
////				Combination Logic 				////
/////////////////////////////////////////////////
// none

/////////////////////////////////////////////////
////					Sub Modules						////
/////////////////////////////////////////////////
// look up from table PORT A
code_lookup		U_code_lookup_1
(
	// global clock and reset
	.clk				(clk),
	.rstN				(rstN),
	// input source data
	.src_data		(src_data[31:24]),
	.src_valid		(src_valid),
	// lookup table 16 bit VLC code sequence
	.vlc_data		(vlc_douta),
	.vlc_addr		(vlc_addra),
	// module slave interface
	.lookup_done	(lookup_done_1),
	.error			(),
	// output fifo interface
	.rd_code			(vlc_rd_1	),
	.lseg_len		(lseg_len_1	),	//	last 16bit segment valid data bits number
	.code_data		(vlc_code_1	),
	.code_valid		(vlc_valid_1),
	.code_empty		(vlc_empty_1)
);

// look up from table PORT B
code_lookup		U_code_lookup_2
(
	// global clock and reset
	.clk				(clk),
	.rstN				(rstN),
	// input source data
	.src_data		(src_data[23:16]),
	.src_valid		(src_valid),
	// lookup table 16 bit VLC code sequence
	.vlc_data		(vlc_doutb),
	.vlc_addr		(vlc_addrb),
	// module slave interface
	.lookup_done	(lookup_done_2),
	.error			(),
	// output fifo interface
	.rd_code			(vlc_rd_2	),
	.lseg_len		(lseg_len_2	),	//	last 16bit segment valid data bits number
	.code_data		(vlc_code_2	),
	.code_valid		(vlc_valid_2),
	.code_empty		(vlc_empty_2)
);

// look up from table PORT C
code_lookup		U_code_lookup_3
(
	// global clock and reset
	.clk				(clk),
	.rstN				(rstN),
	// input source data
	.src_data		(src_data[15:8]),
	.src_valid		(src_valid),
	// lookup table 16 bit VLC code sequence
	.vlc_data		(vlc_doutc),
	.vlc_addr		(vlc_addrc),
	// module slave interface
	.lookup_done	(lookup_done_3),
	.error			(),
	// output fifo interface
	.rd_code			(vlc_rd_3	),
	.lseg_len		(lseg_len_3	),	//	last 16bit segment valid data bits number
	.code_data		(vlc_code_3	),
	.code_valid		(vlc_valid_3),
	.code_empty		(vlc_empty_3)
);

// look up from table PORT D
code_lookup		U_code_lookup_4
(
	// global clock and reset
	.clk				(clk),
	.rstN				(rstN),
	// input source data
	.src_data		(src_data[7:0]),
	.src_valid		(src_valid),
	// lookup table 16 bit VLC code sequence
	.vlc_data		(vlc_doutd),
	.vlc_addr		(vlc_addrd),
	// module slave interface
	.lookup_done	(lookup_done_4),
	.error			(),
	// output fifo interface
	.rd_code			(vlc_rd_4	),
	.lseg_len		(lseg_len_4	),	//	last 16bit segment valid data bits number
	.code_data		(vlc_code_4	),
	.code_valid		(vlc_valid_4),
	.code_empty		(vlc_empty_4)
);

// vlc glue logic
vlc_glue		U_vlc_glue
(
	// global clock and reset
	.clk				(clk),
	.rstN				(rstN),
	.encode_start	(encode_start	),
	.encode_done	(encode_done	),
	//	input 16 bit VLC code sequence
	.vlc_empty_1	(vlc_empty_1	),
	.lseg_len_1		(lseg_len_1		),
	.vlc_code_1		(vlc_code_1		),
	.vlc_valid_1	(vlc_valid_1	),
	.lookup_done_1	(lookup_done_1	),
	.vlc_rd_1		(vlc_rd_1		),
	.vlc_empty_2	(vlc_empty_2	),
	.lseg_len_2		(lseg_len_2		),
	.vlc_code_2		(vlc_code_2		),
	.vlc_valid_2	(vlc_valid_2	),
	.lookup_done_2	(lookup_done_2	),
	.vlc_rd_2		(vlc_rd_2		),
	.vlc_empty_3	(vlc_empty_3	),
	.lseg_len_3		(lseg_len_3		),
	.vlc_code_3		(vlc_code_3		),
	.vlc_valid_3	(vlc_valid_3	),
	.lookup_done_3	(lookup_done_3	),
	.vlc_rd_3		(vlc_rd_3		),
	.vlc_empty_4	(vlc_empty_4	),
	.lseg_len_4		(lseg_len_4		),
	.vlc_code_4		(vlc_code_4		),
	.vlc_valid_4	(vlc_valid_4	),
	.lookup_done_4	(lookup_done_4	),
	.vlc_rd_4		(vlc_rd_4		),
	// output 32bit Glued data
	.vlc_glue_data	(vlc_glue_data	),
	.vlc_glue_valid(vlc_glue_valid)
);

// FIFO 4Kx32bit for encoded data
fifo_4kx32bit	U_fifo_4kx32bit
(
  .clk			(clk),
  .rst			(~rstN),
  .din			(vlc_glue_data	),
  .wr_en			(vlc_glue_valid),
  .rd_en			(rd_encode),
  
  .full			(encode_full),
  .empty			(encode_empty),
  .dout			(encode_data),
  .valid			(encode_valid),
  .data_count	(encode_count)
);


endmodule
