`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:46:14 08/15/2016 
// Design Name: 
// Module Name:    code_lookup_v2 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: lookup module use 8bit data as an address to lookup from
//								vlc_table and get code_len/code and store in 16 depth FIFO
//			Distribute RAM or register array FIFO data frame :
// (MSB)Code_segment_length  				Overflow_ERROR_Bit		VLC_code (LSB)
// 				4bit 									1bit			 			 15bit        
//  		4'h0 : Illegal value					1'b0 : Normal
//			4'h1~4'hF: Valid code length		1'b1 : Overflowed		
//				
//////////////////////////////////////////////////////////////////////////////////
module code_lookup_v2(
// global clock and reset
input wire				clk,
input wire				rstN,
// input source data
input wire	[7:0]		src_data,
input wire				src_valid,
// lookup table 16 bit VLC code sequence
input wire	[19:0]	vlc_data,
output reg	[7:0]		vlc_addr,
// module slave interface
output reg				error,
// output fifo interface
input wire				rd_code,
output wire	[3:0]		code_len,	//	last 16bit segment valid data bits number
output wire	[15:0]	code_data,
output wire				code_valid,
output wire				code_empty,
output wire				code_full
);

//////////////// FSM status ////////////////
parameter		IDLE		=	4'h0;
parameter		LOOKUP	=	4'h1;
parameter		DONE		=	4'h2;
////////////////////////////////////////////

// FSM signal
reg	[3:0]		current_state,next_state;
// fifo signal
reg	[19:0]	fifo_in;
reg				fifo_wr;

/////////////////////////////////////////////////
////			Dividual Combination Logic 		////
/////////////////////////////////////////////////

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

// generate code error signal
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		error	<=	1'b0;
	end
	else
	begin
		if(fifo_wr & vlc_data[15])	// vlc_data[15] indicated if the 15bit vlc_code is overflowed
			error	<=	1'b1;
		else
			error	<=	error;					// One error will lead to collapse
	end
end

/////////////////////////////////////////////////
////				Combination Logic 				////
/////////////////////////////////////////////////
// FSM state transfer
always @ (*)
begin
	case(current_state)
	IDLE	:	begin
					if(src_valid)
						next_state	=	LOOKUP;
					else
						next_state	=	IDLE;
				end
	LOOKUP:	begin
					if(!src_valid)
						next_state	=	DONE;
					else
						next_state	=	LOOKUP;
				end
	DONE	:	begin
					if(src_valid)
						next_state	=	LOOKUP;
					else
						next_state	=	DONE;
				end
	default:	begin
					next_state	=	IDLE;
				end
	endcase
end

// FSM control signal
always @ (*)
begin
	case(current_state)
	IDLE	:	begin
					vlc_addr			=	src_data;
					fifo_wr			=	1'b0;
					fifo_in			=	20'b0;
				end
	LOOKUP:	begin
					vlc_addr			=	src_data;
					fifo_wr			=	1'b1;
					fifo_in			=	vlc_data;
				end
	DONE	:	begin
					vlc_addr			=	src_data;
					fifo_wr			=	1'b0;
					fifo_in			=	20'b0;
				end
	default:	begin
					vlc_addr			=	8'b0;
					fifo_wr			=	1'b0;
					fifo_in			=	20'b0;
				end
	endcase
end

/////////////////////////////////////////////////
////					Sub Modules						////
/////////////////////////////////////////////////
// VLC_code and Code_len FIFO
fifo_16x20bit	U_fifo_16x20bit
(
	// global clock and reset
	.clk			(clk),
	.rstN			(rstN),
	// fifo interface
	.din			(fifo_in),
	.wr_en		(fifo_wr),
	.rd_en		(rd_code),
	.dout			({code_len,code_data}),
	.valid		(code_valid),
	.empty		(code_empty),
	.full			(code_full)
);

endmodule
