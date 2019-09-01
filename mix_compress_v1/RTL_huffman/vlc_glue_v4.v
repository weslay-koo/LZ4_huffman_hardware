`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:13:47 08/15/2016 
// Design Name: 
// Module Name:    vlc_glue_v3 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 2.01 - File Created
//	Revision 3.00 - all_done signal add to input	
//	Revision 4.00 - add REMIND status to write last 16bit data to vlc_glue_data
// Additional Comments: Glue 4 VLC code and guaruntee not overflow
//								Input max 16bit vlc code and code length
//								output 32bit VLC glued data
//
//////////////////////////////////////////////////////////////////////////////////
module vlc_glue_v4(
// global clock and reset
input wire				clk,
input wire				rstN,
// control and status signal
input wire				vlc_glue_start,
output reg				vlc_glue_done,
input wire				src_empty,
input wire				src_end,
//	input 16 bit VLC code sequence
input wire				vlc_empty_1,
input wire	[3:0]		vlc_len_1,
input wire	[15:0]	vlc_code_1,
input wire				vlc_valid_1,
output reg				vlc_rd_1,
input wire				vlc_empty_2,
input wire	[3:0]		vlc_len_2,
input wire	[15:0]	vlc_code_2,
input wire				vlc_valid_2,
output reg				vlc_rd_2,
input wire				vlc_empty_3,
input wire	[3:0]		vlc_len_3,
input wire	[15:0]	vlc_code_3,
input wire				vlc_valid_3,
output reg				vlc_rd_3,
input wire				vlc_empty_4,
input wire	[3:0]		vlc_len_4,
input wire	[15:0]	vlc_code_4,
input wire				vlc_valid_4,
output reg				vlc_rd_4,
// output 32bit Glued data to external FIFO
output reg	[31:0]	vlc_glue_data,
output reg				vlc_glue_valid	
);

//////////////// FSM status ////////////////
parameter		IDLE			=	4'h0;
parameter		INIT			=	4'h1;
parameter		INIT_DONE	=	4'h2;
parameter		WAIT_2		=	4'h3;
parameter		GLUE_12		=	4'h4;
parameter		WAIT_3		=	4'h5;
parameter		GLUE_23		=	4'h6;
parameter		WAIT_4		=	4'h7;
parameter		GLUE_34		=	4'h8;
parameter		WAIT_1		=	4'h9;
parameter		GLUE_41		=	4'hA;
parameter		GLUE_LAST	=	4'hB;
parameter		WRITE			=	4'hC;
parameter		REMIND		=	4'hD;
parameter		DONE			=	4'hE;
////////////////////////////////////////////

// FSM signal
reg	[3:0]		current_state,next_state;
// all done signal generation
wire				all_done;
// data glue length accumulator
reg	[4:0]		len_acc,len_incr;
reg				acc_inc;
// output 32bit data control
reg				glue_en;
reg	[15:0]	vlc_code;
reg	[15:0]	glue_data,prev_data;
reg				glue_valid;
reg				data_sel;
// VLC data glue
reg	[31:0]	glue_shift;
reg				glue_full;
reg				last_data;

/////////////////////////////////////////////////
////			Dividual Combination Logic 		////
/////////////////////////////////////////////////
// all done signal generation
assign			all_done	=		src_end & src_empty 
									& 	vlc_empty_1 & vlc_empty_2 
									& 	vlc_empty_3 & vlc_empty_4;

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

// data glue length accumulator
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		len_acc	<=	5'b0;
	end
	else
	begin
		if(acc_inc)
			len_acc	<=	{1'b0,len_acc[3:0]} + len_incr;
		else
			len_acc	<=	len_acc;
	end
end

// output 32bit data control
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		data_sel			<=	1'b0;
		prev_data		<=	16'b0;
		vlc_glue_data	<=	32'b0;
		vlc_glue_valid	<=	1'b0;
	end
	else
	begin
		if(glue_valid)
		begin
			prev_data	<=	glue_data;
			data_sel		<=	~data_sel;
		end
		else
		begin
			prev_data	<=	prev_data;
			data_sel		<=	data_sel;
		end
		
		if(data_sel & glue_valid)
		begin
			vlc_glue_data	<=	{prev_data,glue_data};
			vlc_glue_valid	<=	1'b1;
		end
		else if(data_sel & last_data & (~glue_full))
		begin
			vlc_glue_data	<=	{prev_data,16'b0};
			vlc_glue_valid	<=	1'b1;
		end
		else
		begin
			vlc_glue_data	<=	vlc_glue_data;
			vlc_glue_valid	<=	1'b0;
		end
	end
end

// glue VLC data
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		glue_shift	<=	32'b0;
		glue_full	<=	1'b0;
	end
	else
	begin
		if(glue_en)
		begin
			if(({1'b0,len_acc[3:0]} + len_incr) >= 5'h10)
				glue_full	<=	1'b1;
			else
				glue_full	<=	1'b0;
			case(len_incr[3:0])
			4'h0	:	glue_shift	<=	glue_shift;
			4'h1	:	glue_shift	<=	{glue_shift[30:00],vlc_code[0]};
			4'h2	:	glue_shift	<=	{glue_shift[29:00],vlc_code[01:00]};
			4'h3	:	glue_shift	<=	{glue_shift[28:00],vlc_code[02:00]};
			4'h4	:	glue_shift	<=	{glue_shift[27:00],vlc_code[03:00]};
			4'h5	:	glue_shift	<=	{glue_shift[26:00],vlc_code[04:00]};
			4'h6	:	glue_shift	<=	{glue_shift[25:00],vlc_code[05:00]};
			4'h7	:	glue_shift	<=	{glue_shift[24:00],vlc_code[06:00]};
			4'h8	:	glue_shift	<=	{glue_shift[23:00],vlc_code[07:00]};
			4'h9	:	glue_shift	<=	{glue_shift[22:00],vlc_code[08:00]};
			4'hA	:	glue_shift	<=	{glue_shift[21:00],vlc_code[09:00]};
			4'hB	:	glue_shift	<=	{glue_shift[20:00],vlc_code[10:00]};
			4'hC	:	glue_shift	<=	{glue_shift[19:00],vlc_code[11:00]};
			4'hD	:	glue_shift	<=	{glue_shift[18:00],vlc_code[12:00]};
			4'hE	:	glue_shift	<=	{glue_shift[17:00],vlc_code[13:00]};
			4'hF	:	glue_shift	<=	{glue_shift[16:00],vlc_code[14:00]};
			default:	glue_shift	<=	glue_shift;
			endcase
		end
		else
		begin
			glue_shift	<=	glue_shift;
			glue_full	<=	1'b0;
		end
	end
end

// Select 16bit parallal data output in 32bit shifter
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		glue_valid	<=	1'b0;
		glue_data	<=	16'b0;
	end
	else
	begin
		if(glue_full)
		begin
			glue_valid	<=	1'b1;
			case(len_acc[3:0])
			4'h0		:	glue_data	<=	glue_shift[15:00];
			4'h1		:	glue_data	<=	glue_shift[16:01];
			4'h2		:	glue_data	<=	glue_shift[17:02];
			4'h3		:	glue_data	<=	glue_shift[18:03];
			4'h4		:	glue_data	<=	glue_shift[19:04];
			4'h5		:	glue_data	<=	glue_shift[20:05];
			4'h6		:	glue_data	<=	glue_shift[21:06];
			4'h7		:	glue_data	<=	glue_shift[22:07];
			4'h8		:	glue_data	<=	glue_shift[23:08];
			4'h9		:	glue_data	<=	glue_shift[24:09];
			4'hA		:	glue_data	<=	glue_shift[25:10];
			4'hB		:	glue_data	<=	glue_shift[26:11];
			4'hC		:	glue_data	<=	glue_shift[27:12];
			4'hD		:	glue_data	<=	glue_shift[28:13];
			4'hE		:	glue_data	<=	glue_shift[29:14];
			4'hF		:	glue_data	<=	glue_shift[30:15];
			default	:	glue_data	<=	glue_data;
			endcase
		end
		else
		begin
			glue_valid	<=	1'b0;
			glue_data	<=	16'b0;
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
	IDLE		:	begin
						if(vlc_glue_start)
							next_state	=	INIT;
						else
							next_state	=	IDLE;
					end
	INIT		:	begin
						if(!vlc_empty_1)
							next_state	=	INIT_DONE;
						else
							next_state	=	INIT;
					end
	INIT_DONE:	begin
						if(all_done)
							next_state	=	GLUE_LAST;
						else if(!vlc_empty_2)
							next_state	=	GLUE_12;
						else
							next_state	=	WAIT_2;
					end
	WAIT_2	:	begin
						if(!vlc_empty_2)
							next_state	=	GLUE_12;
						else
							next_state	=	WAIT_2;
					end
	GLUE_12	:	begin
						if(all_done)
							next_state	=	GLUE_LAST;  
						else if(!vlc_empty_3)
							next_state	=	GLUE_23;
						else
							next_state	=	WAIT_3;
					end
	WAIT_3	:	begin
						if(!vlc_empty_3)
							next_state	=	GLUE_23;
						else
							next_state	=	WAIT_3;
					end
	GLUE_23	:	begin
						if(all_done)
							next_state	=	GLUE_LAST;                                                
						else if(!vlc_empty_4)
							next_state	=	GLUE_34;
						else
							next_state	=	WAIT_4;   
					end
	WAIT_4	:	begin
						if(!vlc_empty_4)
							next_state	=	GLUE_34;
						else
							next_state	=	WAIT_4;
					end
	GLUE_34	:	begin
						if(all_done)
							next_state	=	GLUE_LAST;                                                
						else if(!vlc_empty_1)
							next_state	=	GLUE_41;
						else
							next_state	=	WAIT_1;   
					end
	WAIT_1	:	begin
						if(!vlc_empty_1)
							next_state	=	GLUE_41;
						else
							next_state	=	WAIT_1;
					end
	GLUE_41	:	begin
						if(all_done)
							next_state	=	GLUE_LAST;                                                
						else if(!vlc_empty_2)
							next_state	=	GLUE_12; 
						else
							next_state	=	WAIT_2;   
					end
	GLUE_LAST:	begin
						next_state	=	WRITE;
					end
	WRITE		:	begin
						if(vlc_glue_valid && (len_acc < 5'h10))
						begin
							if((~data_sel) & glue_valid)
								next_state	=	REMIND;
							else
								next_state	=	DONE;
						end
						else
						begin
							next_state	=	WRITE;
						end
					end
	REMIND	:	begin
						if(vlc_glue_valid)
							next_state	=	DONE;
						else
							next_state	=	REMIND;
					end
	DONE		:	begin
						if(vlc_glue_start)
							next_state	=	INIT;
						else
							next_state	=	DONE;
					end
	default	:	begin
						next_state	=	IDLE;
					end
	endcase
end

// FSM control signal
always @ (*)
begin
	case(current_state)
	IDLE		:	begin
						acc_inc		=	1'b0;
						len_incr		=	5'b0;
						vlc_code		=	16'b0;
						glue_en		=	1'b0;
						last_data	=	1'b0;
						vlc_rd_1		=	1'b0;
						vlc_rd_2		=	1'b0;
						vlc_rd_3		=	1'b0;
						vlc_rd_4		=	1'b0;
						vlc_glue_done	=	1'b0;
					end
	INIT		:	begin
						acc_inc		=	1'b0;
						len_incr		=	5'b0;
						vlc_code		=	16'b0;
						glue_en		=	1'b0;
						last_data	=	1'b0;
						if(!vlc_empty_1)
							vlc_rd_1	=	1'b1;
						else
							vlc_rd_1	=	1'b0;
						vlc_rd_2		=	1'b0;
						vlc_rd_3		=	1'b0;
						vlc_rd_4		=	1'b0;
						vlc_glue_done	=	1'b0;
					end
	INIT_DONE:	begin
						acc_inc		=	1'b1;
						len_incr		=	{1'b0,vlc_len_1};
						vlc_code		=	vlc_code_1;
						glue_en		=	1'b1;
						last_data	=	1'b0;
						vlc_rd_1		=	1'b0;
						if(!vlc_empty_2)
							vlc_rd_2	=	1'b1;
						else
							vlc_rd_2	=	1'b0;
						vlc_rd_3		=	1'b0;
						vlc_rd_4		=	1'b0;
						vlc_glue_done	=	1'b0;
					end
	WAIT_2	:	begin
						acc_inc		=	1'b0;
						len_incr		=	5'b0;
						vlc_code		=	16'b0;
						glue_en		=	1'b0;
						last_data	=	1'b0;
						vlc_rd_1		=	1'b0;
						if(!vlc_empty_2)
							vlc_rd_2	=	1'b1;
						else
							vlc_rd_2	=	1'b0;
						vlc_rd_3		=	1'b0;
						vlc_rd_4		=	1'b0;
						vlc_glue_done	=	1'b0;
					end
	GLUE_12	:	begin
						acc_inc		=	1'b1;
						len_incr		=	{1'b0,vlc_len_2};
						vlc_code		=	vlc_code_2;
						glue_en		=	1'b1;
						last_data	=	1'b0;
						vlc_rd_1		=	1'b0;
						vlc_rd_2		=	1'b0;
						if(!vlc_empty_3)
							vlc_rd_3	=	1'b1;
						else
							vlc_rd_3	=	1'b0;
						vlc_rd_4		=	1'b0;
						vlc_glue_done	=	1'b0;
					end
	WAIT_3	:	begin
						acc_inc		=	1'b0;
						len_incr		=	5'b0;
						vlc_code		=	16'b0;
						glue_en		=	1'b0;
						last_data	=	1'b0;
						vlc_rd_1		=	1'b0;
						vlc_rd_2		=	1'b0;
						if(!vlc_empty_3)
							vlc_rd_3	=	1'b1;
						else
							vlc_rd_3	=	1'b0;
						vlc_rd_4		=	1'b0;
						vlc_glue_done	=	1'b0;
					end
	GLUE_23	:	begin
						acc_inc		=	1'b1;
						len_incr		=	{1'b0,vlc_len_3};
						vlc_code		=	vlc_code_3;
						glue_en		=	1'b1;
						last_data	=	1'b0;
						vlc_rd_1		=	1'b0;
						vlc_rd_2		=	1'b0;
						vlc_rd_3		=	1'b0;
						if(!vlc_empty_4)
							vlc_rd_4	=	1'b1;
						else
							vlc_rd_4	=	1'b0;
						vlc_glue_done	=	1'b0;
					end
	WAIT_4	:	begin
						acc_inc		=	1'b0;
						len_incr		=	5'b0;
						vlc_code		=	16'b0;
						glue_en		=	1'b0;
						last_data	=	1'b0;
						vlc_rd_1		=	1'b0;
						vlc_rd_2		=	1'b0;
						vlc_rd_3		=	1'b0;
						if(!vlc_empty_4)
							vlc_rd_4	=	1'b1;
						else
							vlc_rd_4	=	1'b0;
						vlc_glue_done	=	1'b0;
					end
	GLUE_34	:	begin
						acc_inc		=	1'b1;
						len_incr		=	{1'b0,vlc_len_4};
						vlc_code		=	vlc_code_4;
						glue_en		=	1'b1;
						last_data	=	1'b0;
						if(!vlc_empty_1)
							vlc_rd_1	=	1'b1;
						else
							vlc_rd_1	=	1'b0;
						vlc_rd_2		=	1'b0;
						vlc_rd_3		=	1'b0;
						vlc_rd_4		=	1'b0;
						vlc_glue_done	=	1'b0;
					end
	WAIT_1	:	begin
						acc_inc		=	1'b0;
						len_incr		=	5'b0;
						vlc_code		=	16'b0;
						glue_en		=	1'b0;
						last_data	=	1'b0;
						if(!vlc_empty_4)
							vlc_rd_1	=	1'b1;
						else
							vlc_rd_1	=	1'b0;
						vlc_rd_2		=	1'b0;
						vlc_rd_3		=	1'b0;
						vlc_rd_4		=	1'b0;
						vlc_glue_done	=	1'b0;
					end
	GLUE_41	:	begin
						acc_inc		=	1'b1;
						len_incr		=	{1'b0,vlc_len_1};
						vlc_code		=	vlc_code_1;
						glue_en		=	1'b1;
						last_data	=	1'b0;
						vlc_rd_1		=	1'b0;
						if(!vlc_empty_2)
							vlc_rd_2	=	1'b1;
						else
							vlc_rd_2	=	1'b0;
						vlc_rd_3		=	1'b0;
						vlc_rd_4		=	1'b0;
						vlc_glue_done	=	1'b0;
					end
	GLUE_LAST:	begin
						acc_inc		=	1'b1;
						len_incr		=	5'hF;
						vlc_code		=	16'b0;
						glue_en		=	1'b1;
						last_data	=	1'b0;
						vlc_rd_1		=	1'b0;
						vlc_rd_2		=	1'b0;
						vlc_rd_3		=	1'b0;
						vlc_rd_4		=	1'b0;
						vlc_glue_done	=	1'b0;
					end
	WRITE		:	begin
						acc_inc		=	1'b1;
						len_incr		=	5'b0;
						vlc_code		=	16'b0;
						glue_en		=	1'b0;
						if(vlc_glue_valid && (len_acc < 5'h10))
							last_data	=	1'b0;
						else
							last_data	=	1'b1;
						vlc_rd_1		=	1'b0;
						vlc_rd_2		=	1'b0;
						vlc_rd_3		=	1'b0;
						vlc_rd_4		=	1'b0;
						vlc_glue_done	=	1'b0;
					end
	REMIND	:	begin
						acc_inc		=	1'b0;
						len_incr		=	5'b0;
						vlc_code		=	16'b0;
						glue_en		=	1'b0;
						if(vlc_glue_valid)
							last_data	=	1'b0;
						else
							last_data	=	1'b1;
						vlc_rd_1		=	1'b0;
						vlc_rd_2		=	1'b0;
						vlc_rd_3		=	1'b0;
						vlc_rd_4		=	1'b0;
						vlc_glue_done	=	1'b0;
					end
	DONE		:	begin
						acc_inc		=	1'b0;
						len_incr		=	5'b0;
						vlc_code		=	16'b0;
						glue_en		=	1'b0;
						last_data	=	1'b0;
						vlc_rd_1		=	1'b0;
						vlc_rd_2		=	1'b0;
						vlc_rd_3		=	1'b0;
						vlc_rd_4		=	1'b0;
						vlc_glue_done	=	1'b1;
					end
	default	:	begin
						acc_inc		=	1'b0;
						len_incr		=	5'b0;
						vlc_code		=	16'b0;
						glue_en		=	1'b0;
						last_data	=	1'b0;
						vlc_rd_1		=	1'b0;
						vlc_rd_2		=	1'b0;
						vlc_rd_3		=	1'b0;
						vlc_rd_4		=	1'b0;
						vlc_glue_done	=	1'b0;
					end
	endcase
end

/////////////////////////////////////////////////
////					Sub Modules						////
/////////////////////////////////////////////////

endmodule
