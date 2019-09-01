`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:39:04 07/18/2016 
// Design Name: 
// Module Name:    vlc_glue 
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
module vlc_glue(
// global clock and reset
input wire				clk,
input wire				rstN,
input wire				encode_start,
input wire				encode_done,
//	input 16 bit VLC code sequence
input wire				vlc_empty_1,
input wire	[4:0]		lseg_len_1,
input wire	[15:0]	vlc_code_1,
input wire				vlc_valid_1,
input wire				lookup_done_1,
output reg				vlc_rd_1,
input wire				vlc_empty_2,
input wire	[4:0]		lseg_len_2,
input wire	[15:0]	vlc_code_2,
input wire				vlc_valid_2,
input wire				lookup_done_2,
output reg				vlc_rd_2,
input wire				vlc_empty_3,
input wire	[4:0]		lseg_len_3,
input wire	[15:0]	vlc_code_3,
input wire				vlc_valid_3,
input wire				lookup_done_3,
output reg				vlc_rd_3,
input wire				vlc_empty_4,
input wire	[4:0]		lseg_len_4,
input wire	[15:0]	vlc_code_4,
input wire				vlc_valid_4,
input wire				lookup_done_4,
output reg				vlc_rd_4,
// output 32bit Glued data
output reg	[31:0]	vlc_glue_data,
output reg				vlc_glue_valid	
);

//////////////// FSM status ////////////////
parameter		IDLE		=	4'h0;
parameter		WAIT_1	=	4'h1;
parameter		GLUE_12	=	4'h2;
parameter		WAIT_2	=	4'h3;
parameter		GLUE_23	=	4'h4;
parameter		WAIT_3	=	4'h5;
parameter		GLUE_34	=	4'h6;
parameter		WAIT_4	=	4'h7;
parameter		GLUE_41	=	4'h8;
parameter		DONE		=	4'h9;
////////////////////////////////////////////

// FSM signal
reg	[3:0]		current_state,next_state;
// all done signal generation
wire				all_done;
// data glue length accumulator
reg	[4:0]		len_acc;
reg	[4:0]		len_incr;
reg				acc_en;
// output 32bit data control
reg				glue_en;
reg	[15:0]	vlc_code;
reg	[15:0]	glue_data,prev_data;
reg				glue_valid;
reg				data_sel;

/////////////////////////////////////////////////
////			Dividual Combination Logic 		////
/////////////////////////////////////////////////
// all done signal generation
assign			all_done	=	encode_done & vlc_empty_1 & vlc_empty_2 & vlc_empty_3 & vlc_empty_4;

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
		if(acc_en)
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
		else
		begin
			vlc_glue_data	<=	vlc_glue_data;
			vlc_glue_valid	<=	1'b0;
		end
	end
end

// glue data generation
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		glue_data	<=	16'b0;
		glue_valid	<=	1'b0;
	end
	else
	begin
		if(glue_en)
		begin
			if(len_acc[4])
				glue_valid	<=	1'b1;  // how to switch when more than 3 vlc_code_x length_sum < 16 ?
			else
				glue_valid	<=	1'b0;
			case(len_acc[3:0])
			4'h0		:	glue_data	<=	vlc_code;
			4'h1		:	glue_data	<=	{glue_data[14:00],vlc_code[15]};
			4'h2		:	glue_data	<=	{glue_data[13:00],vlc_code[15:14]};
			4'h3		:	glue_data	<=	{glue_data[12:00],vlc_code[15:13]};
			4'h4		:	glue_data	<=	{glue_data[11:00],vlc_code[15:12]};
			4'h5		:	glue_data	<=	{glue_data[10:00],vlc_code[15:11]};
			4'h6		:	glue_data	<=	{glue_data[09:00],vlc_code[15:10]};
			4'h7		:	glue_data	<=	{glue_data[08:00],vlc_code[15:09]};
			4'h8		:	glue_data	<=	{glue_data[07:00],vlc_code[15:08]};
			4'h9		:	glue_data	<=	{glue_data[06:00],vlc_code[15:07]};
			4'hA		:	glue_data	<=	{glue_data[05:00],vlc_code[15:06]};
			4'hB		:	glue_data	<=	{glue_data[04:00],vlc_code[15:05]};
			4'hC		:	glue_data	<=	{glue_data[03:00],vlc_code[15:04]};
			4'hD		:	glue_data	<=	{glue_data[02:00],vlc_code[15:03]};
			4'hE		:	glue_data	<=	{glue_data[01:00],vlc_code[15:02]};
			4'hF		:	glue_data	<=	{glue_data[0],vlc_code[15:01]};
			default	:	glue_data	<=	glue_data;
			endcase
		end
		else
		begin
			glue_data	<=	glue_data;
			glue_valid	<=	1'b0;
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
						if(encode_start)
							next_state	=	WAIT_1;
						else
							next_state	=	IDLE;
					end
	WAIT_1	:	begin
						if(!vlc_empty_1)
							next_state	=	GLUE_12;
						else
							next_state	=	WAIT_1;
					end				
	GLUE_12	:	begin
						if(all_done)
							next_state	=	DONE;                                                
						else if(vlc_empty_1)  
							if(vlc_empty_2)
								next_state	=	WAIT_2;
							else
								next_state	=	GLUE_23;   
						else
							next_state	=	GLUE_12;   
					end
	WAIT_2	:	begin
						if(!vlc_empty_2)
							next_state	=	GLUE_23;
						else
							next_state	=	WAIT_2;
					end
	GLUE_23	:	begin
						if(all_done)
							next_state	=	DONE;                                                
						else if(vlc_empty_2)  
							if(vlc_empty_3)
								next_state	=	WAIT_3;
							else
								next_state	=	GLUE_34;   
						else
							next_state	=	GLUE_23;   
					end
	WAIT_3	:	begin
						if(!vlc_empty_3)
							next_state	=	GLUE_34;
						else
							next_state	=	WAIT_3;
					end
	GLUE_34	:	begin
						if(all_done)
							next_state	=	DONE;                                                
						else if(vlc_empty_3)  
							if(vlc_empty_4)
								next_state	=	WAIT_4;
							else
								next_state	=	GLUE_41;   
						else
							next_state	=	GLUE_34;   
					end
	WAIT_4	:	begin
						if(!vlc_empty_4)
							next_state	=	GLUE_41;
						else
							next_state	=	WAIT_4;
					end
	GLUE_41	:	begin
						if(all_done)
							next_state	=	DONE;                                                
						else if(vlc_empty_4)  
							if(vlc_empty_1)
								next_state	=	WAIT_1;
							else
								next_state	=	GLUE_12;  
						else
							next_state	=	GLUE_41;   
					end
	DONE		:	begin
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
						acc_en	=	1'b0;
						len_incr	=	5'b0;
						vlc_rd_1	=	1'b0;
						vlc_rd_2	=	1'b0;
						vlc_rd_3	=	1'b0;
						vlc_rd_4	=	1'b0;
						glue_en	=	1'b0;
						vlc_code	=	16'b0;
					end
	WAIT_1	:	begin
						acc_en	=	1'b0;
						len_incr	=	5'b0;
						if(!vlc_empty_1)
							vlc_rd_1	=	1'b1;
						else
							vlc_rd_1	=	1'b0;
						vlc_rd_2	=	1'b0;
						vlc_rd_3	=	1'b0;
						vlc_rd_4	=	1'b0;
						glue_en	=	1'b0;
						vlc_code	=	16'b0;
					end
	GLUE_12	:	begin
						if(lookup_done_1 & vlc_empty_1)
						begin
							acc_en	=	1'b1;
							len_incr	=	lseg_len_1;
						end
						else
						begin
							acc_en	=	1'b0;
							len_incr	=	5'b0;
						end
						if(!vlc_empty_1)
						begin
							vlc_rd_1	=	1'b1;
							glue_en	=	1'b1;
							vlc_code	=	vlc_code_1;
							vlc_rd_2	=	1'b0;
						end
						else
						begin
							vlc_rd_1	=	1'b0;
							glue_en	=	1'b0;
							vlc_code	=	16'b0;
							if(!vlc_empty_2)
								vlc_rd_2	=	1'b1;
							else
								vlc_rd_2	=	1'b0;
						end
						vlc_rd_3	=	1'b0;
						vlc_rd_4	=	1'b0;
					end
	WAIT_2	:	begin
						acc_en	=	1'b0;
						len_incr	=	5'b0;
						vlc_rd_1	=	1'b0;
						if(!vlc_empty_2)
							vlc_rd_2	=	1'b1;
						else
							vlc_rd_2	=	1'b0;
						vlc_rd_3	=	1'b0;
						vlc_rd_4	=	1'b0;
						glue_en	=	1'b0;
						vlc_code	=	16'b0;
					end
	GLUE_23	:	begin
						if(lookup_done_2 & vlc_empty_2)
						begin
							acc_en	=	1'b1;
							len_incr	=	lseg_len_2;
						end
						else
						begin
							acc_en	=	1'b0;
							len_incr	=	5'b0;
						end
						if(!vlc_empty_2)
						begin
							vlc_rd_2	=	1'b1;
							glue_en	=	1'b1;
							vlc_code	=	vlc_code_2;
							vlc_rd_3	=	1'b0;
						end
						else
						begin
							vlc_rd_2	=	1'b0;
							glue_en	=	1'b0;
							vlc_code	=	16'b0;
							if(!vlc_empty_3)
								vlc_rd_3	=	1'b1;
							else
								vlc_rd_3	=	1'b0;
						end
						vlc_rd_1	=	1'b0;
						vlc_rd_4	=	1'b0;
					end
	WAIT_3	:	begin
						acc_en	=	1'b0;
						len_incr	=	5'b0;
						vlc_rd_1	=	1'b0;
						vlc_rd_2	=	1'b0;
						if(!vlc_empty_3)
							vlc_rd_3	=	1'b1;
						else
							vlc_rd_3	=	1'b0;
						vlc_rd_4	=	1'b0;
						glue_en	=	1'b0;
						vlc_code	=	16'b0;
					end
	GLUE_34	:	begin
						if(lookup_done_3 & vlc_empty_3)
						begin
							acc_en	=	1'b1;
							len_incr	=	lseg_len_3;
						end
						else
						begin
							acc_en	=	1'b0;
							len_incr	=	5'b0;
						end
						if(!vlc_empty_3)
						begin
							vlc_rd_3	=	1'b1;
							glue_en	=	1'b1;
							vlc_code	=	vlc_code_3;
							vlc_rd_4	=	1'b0;
						end
						else
						begin
							vlc_rd_3	=	1'b0;
							glue_en	=	1'b0;
							vlc_code	=	16'b0;
							if(!vlc_empty_4)
								vlc_rd_4	=	1'b1;
							else
								vlc_rd_4	=	1'b0;
						end
						vlc_rd_1	=	1'b0;
						vlc_rd_2	=	1'b0;
					end
	WAIT_4	:	begin
						acc_en	=	1'b0;
						len_incr	=	5'b0;
						vlc_rd_1	=	1'b0;
						vlc_rd_2	=	1'b0;
						vlc_rd_3	=	1'b0;
						if(!vlc_empty_4)
							vlc_rd_4	=	1'b1;
						else
							vlc_rd_4	=	1'b0;
						glue_en	=	1'b0;
						vlc_code	=	16'b0;
					end
	GLUE_41	:	begin
						if(lookup_done_4 & vlc_empty_4)
						begin
							acc_en	=	1'b1;
							len_incr	=	lseg_len_4;
						end
						else
						begin
							acc_en	=	1'b0;
							len_incr	=	5'b0;
						end
						vlc_rd_2	=	1'b0;
						vlc_rd_3	=	1'b0;
						if(!vlc_empty_4)
						begin
							vlc_rd_4	=	1'b1;
							glue_en	=	1'b1;
							vlc_code	=	vlc_code_4;
							vlc_rd_1	=	1'b0;
						end
						else
						begin
							vlc_rd_4	=	1'b0;
							glue_en	=	1'b0;
							vlc_code	=	16'b0;
							if(!vlc_empty_1)
								vlc_rd_1	=	1'b1;
							else
								vlc_rd_1	=	1'b0;
						end
					end
	DONE		:	begin
						acc_en	=	1'b0;
						len_incr	=	5'b0;
						vlc_rd_1	=	1'b0;
						vlc_rd_2	=	1'b0;
						vlc_rd_3	=	1'b0;
						vlc_rd_4	=	1'b0;
					end
	default	:	begin
						acc_en	=	1'b0;
						len_incr	=	5'b0;
						vlc_rd_1	=	1'b0;
						vlc_rd_2	=	1'b0;
						vlc_rd_3	=	1'b0;
						vlc_rd_4	=	1'b0;
					end
	endcase
end

/////////////////////////////////////////////////
////					Sub Modules						////
/////////////////////////////////////////////////

endmodule
