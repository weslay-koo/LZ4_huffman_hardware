`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:31:57 04/20/2016 
// Design Name: 
// Module Name:    byte_addressing_v3 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 3.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module byte_addressing_v3(
// clk and rst
input wire				clk,
input wire				rstN,
input wire				prefetch,	// prefetch data before matching start
input wire				last_3dwords,
// fifo 32bit data input
input wire	[31:0]	fifo_data, 
input wire				fifo_valid,
input wire				fifo_empty,
output reg				rd_fifo_en,
// data output
input wire				byte4_en,
input wire				rd_data_en,
input wire	[2:0]		shift_dist,		// delay 1 cycle after rd_data_en
input wire				shift_en,		// delay 1 cycle after rd_data_en
output reg				byte4_busy,
output reg	[31:0]	byte4_data1,	// shifter out [55:24]
output reg	[31:0]	byte4_data2,	// shifter out [47:16]
output reg	[31:0]	byte4_data3,	// shifter out [39:8]
output reg	[31:0]	byte4_data4,	// shifter out [31:0]
output reg				byte4_valid
);

//////////////// FSM status ////////////////
parameter		IDLE			=	4'h0	;
parameter		WAIT_INIT	=	4'h1	;
parameter		INIT			=	4'h2	;
parameter		LOAD_SHIFT	=	4'h3	;
parameter		WAIT_SHIFT	=	4'h4	;
parameter		LOAD_ONLY	=	4'h5	;
parameter		WAIT_FIFO	=	4'h6	;
parameter		DONE			=	4'h7	;
////////////////////////////////////////////
// FSM status
reg	[3:0]		current_state,next_state;
// initial counter
reg	[1:0]		init_cnt;
reg				init_cnt_en,init_done;
// shifter 96bit signal
reg	[31:0]	in_data;
reg 	[2:0]		in_shift;
reg				shift_valid,data_valid;
wire	[55:0]	out_data;
wire	[3:0]		shift_remind;
// shifter request data signal
wire				in_req;
// prefetch logic
reg				prefetch_done;
reg	[31:0]	prefetch_data;
// data register for over read
reg				data_reg_valid;
reg	[31:0]	data_reg,data_reg_in;
reg				data_reg_clr;
reg				data_reg_load;
/////////////////////////////////////////////////
////			Dividual Combination Logic 		////
/////////////////////////////////////////////////

assign			in_req		=	((shift_remind <= 4'h8) || (rd_data_en && (shift_dist!=3'b0) 
																			&& (shift_remind - shift_dist)<=4'h8)) ? 1'b1 : 1'b0;

/////////////////////////////////////////////////
////				 Sequential Logic 				////
/////////////////////////////////////////////////

// FSM status transfer Logic
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
		init_cnt		<=	2'b0;
		init_done	<=	1'b0;
	end
	else
	begin
		if(!byte4_en)
		begin
			init_cnt 	<= 2'b0;
			init_done	<=	1'b0;
		end
		else if(init_cnt < 2'b11)
		begin
			init_done	<=	1'b0;
			if(init_cnt_en)
				init_cnt	<=	init_cnt	+ 1'b1;
			else
				init_cnt	<=	init_cnt;
		end
		else
		begin
			init_cnt		<=	init_cnt;
			init_done	<=	1'b1;
		end
	end
end

// fifo data prefetch
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		prefetch_data	<=	32'b0;
		prefetch_done	<=	1'b0;
	end
	else
	begin
		if(prefetch)
			prefetch_done	<=	1'b1;
		else if(data_valid)
			prefetch_done	<=	1'b0;
		else
			prefetch_done	<=	prefetch_done;
		
		if(fifo_valid)
			prefetch_data	<=	fifo_data;
		else
			prefetch_data	<=	prefetch_data;
	end
end

// data register for over read
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		data_reg_valid	<=	1'b0;
		data_reg			<=	32'b0;
	end
	else
	begin
		if(data_reg_clr)
		begin
			data_reg_valid	<=	1'b0;
			data_reg			<=	32'b0;
		end
		else if(data_reg_load)
		begin
			data_reg_valid	<=	1'b1;
			data_reg			<=	data_reg_in;
		end
		else
		begin
			data_reg_valid	<=	data_reg_valid;
			data_reg			<=	data_reg;
		end
	end
end

//////////////////////////////////////////////
////				Combination Logic 			////
//////////////////////////////////////////////
// FSM state transfer
always @ (*)
begin
	case(current_state)
	IDLE			:	begin
							if(byte4_en)
							begin
								if(fifo_empty)
									next_state	=	WAIT_INIT;
								else
									next_state	=	INIT;
							end
							else
							begin
								next_state	=	IDLE;
							end
						end
	WAIT_INIT	:	begin
							if(byte4_en)
							begin
								if(fifo_empty)
									next_state	=	WAIT_INIT;
								else
									next_state	=	INIT;
							end
							else
							begin
								next_state	=	DONE;
							end	
						end
	INIT			:	begin
							if(byte4_en)
							begin
								if(init_cnt>=2'h3)
								begin
									if(rd_data_en)
										next_state	=	LOAD_SHIFT;
									else
										next_state	=	WAIT_SHIFT;
								end
								else
								begin
									if(fifo_empty)
										next_state	=	WAIT_INIT;
									else
										next_state	=	INIT;
								end
							end
							else
							begin
								next_state	=	DONE;
							end
						end
	LOAD_SHIFT	:	begin
							if(byte4_en)
							begin
								if(rd_data_en)
									if((!fifo_empty) || last_3dwords || data_reg_valid)
										next_state	=	LOAD_SHIFT;
									else
										next_state	=	WAIT_FIFO;
								else if(in_req)
									if((!fifo_empty) || last_3dwords || data_reg_valid)
										next_state	=	LOAD_ONLY;
									else
										next_state	=	WAIT_FIFO;
								else
									next_state	=	WAIT_SHIFT;								
							end
							else
							begin
								next_state	=	DONE;
							end
						end
	WAIT_SHIFT	:	begin
							if(byte4_en)
							begin
								if(rd_data_en)
									next_state	=	LOAD_SHIFT;
								else if(in_req)
									next_state	=	LOAD_ONLY;
								else
									next_state	=	WAIT_SHIFT;
							end
							else
							begin
								next_state	=	DONE;
							end	
						end
	LOAD_ONLY	:	begin
							if(byte4_en)
							begin
								if(rd_data_en)
									next_state	=	LOAD_SHIFT;
								else
									next_state	=	WAIT_SHIFT;
							end
							else
							begin
								next_state	=	DONE;
							end
						end
	WAIT_FIFO	:	begin
							if(byte4_en)
							begin
								if((!fifo_empty) || last_3dwords)
								begin
									if(rd_data_en)
										next_state	=	LOAD_SHIFT;
									else
										next_state	=	LOAD_ONLY;
								end
								else
								begin
									next_state	=	WAIT_FIFO;
								end
							end
							else
							begin
								next_state	=	DONE;
							end
						end
	DONE			:	begin
							if(!byte4_en)
								next_state	=	IDLE;	
							else
								next_state	=	DONE;	
						end
	default		:	begin
							next_state	=	IDLE;		
						end
	endcase
end

// FSM signal generation
always @ (*)
begin
	case(current_state)
	IDLE			:	begin
							init_cnt_en		=	1'b0;
							if(init_done)
								byte4_busy	=	1'b0;
							else
								byte4_busy	=	1'b1;
							byte4_data1		=	32'b0;
							byte4_data2		=	32'b0;
							byte4_data3		=	32'b0;
							byte4_data4		=	32'b0;
							byte4_valid		=	1'b0;
							rd_fifo_en		=	1'b0;
							data_reg_load	=	1'b0;
							data_reg_clr	=	1'b0;
							data_reg_in		=	32'b0;
							in_data			=	32'b0;
							in_shift			=	3'b0;
							shift_valid		=	1'b0;
							data_valid		=	1'b0;
						end
	WAIT_INIT	:	begin
							init_cnt_en		=	1'b0;
							byte4_busy		=	1'b1;
							byte4_data1		=	32'b0;
							byte4_data2		=	32'b0;
							byte4_data3		=	32'b0;
							byte4_data4		=	32'b0;
							byte4_valid		=	1'b0;
							if((!fifo_empty)&& byte4_en)
								rd_fifo_en	=	1'b1;
							else
								rd_fifo_en	=	1'b0;
							data_reg_load	=	1'b0;
							data_reg_clr	=	1'b0;
							data_reg_in		=	32'b0;
							in_data			=	32'b0;
							in_shift			=	3'b0;
							shift_valid		=	1'b0;
							data_valid		=	1'b0;
						end
	INIT			:	begin
							init_cnt_en		=	1'b1;
							byte4_busy		=	1'b1;
							byte4_data1		=	32'b0;
							byte4_data2		=	32'b0;
							byte4_data3		=	32'b0;
							byte4_data4		=	32'b0;
							byte4_valid		=	1'b0;
							if((!fifo_empty)&& (init_cnt<=2'h2) && byte4_en)
								rd_fifo_en	=	1'b1;
							else
								rd_fifo_en	=	1'b0;
							data_reg_load	=	1'b0;
							data_reg_clr	=	1'b0;
							data_reg_in		=	32'b0;
							if(fifo_valid && byte4_en)
							begin
								in_data		=	fifo_data;
								data_valid	=	1'b1;
								in_shift		=	3'h0;
								shift_valid	=	1'b0;
							end
							else
							begin
								in_data		=	32'b0;
								data_valid	=	1'b0;
								in_shift		=	3'b0;
								shift_valid	=	1'b0;
							end
						end
	LOAD_SHIFT	:	begin
							init_cnt_en		=	1'b0;
							if(fifo_empty)
								byte4_busy	=	1'b1;
							else
								byte4_busy	=	1'b0;
							byte4_data1		=	out_data[55:24];
							byte4_data2		=	out_data[47:16];
							byte4_data3		=	out_data[39:8];
							byte4_data4		=	out_data[31:0];
							byte4_valid		=	1'b1;
							in_shift			=	shift_dist;
							shift_valid		=	shift_en;
							if((!fifo_empty) && (in_req || prefetch) && (!data_reg_valid))
								rd_fifo_en	=	1'b1;
							else
								rd_fifo_en	=	1'b0;
							if(prefetch_done && (!fifo_valid))
							begin
								data_reg_clr	=	1'b0;
								if((shift_dist!=3'b0) && ((shift_dist + shift_remind)<=4'hC))
								begin
									in_data			=	prefetch_data;
									data_valid		=	1'b1;
									data_reg_load	=	1'b0;
									data_reg_in		=	32'b0;
								end
								else
								begin
									in_data			=	prefetch_data;
									data_valid		=	1'b0;
									data_reg_load	=	1'b1;
									data_reg_in		=	prefetch_data;
								end
							end
							else if(data_reg_valid)
							begin
								if((shift_dist!=3'b0) && ((shift_dist + shift_remind)<=4'hC))
								begin
									in_data			=	data_reg;
									data_valid		=	1'b1;
									data_reg_load	=	1'b0;
									data_reg_clr	=	1'b1;
									data_reg_in		=	32'b0;
								end
								else
								begin
									in_data			=	32'b0;
									data_valid		=	1'b0;
									data_reg_load	=	1'b0;
									data_reg_clr	=	1'b0;
									data_reg_in		=	32'b0;
								end
							end
							else if(fifo_valid)
							begin
								data_reg_clr=	1'b0;
								if((shift_dist!=3'b0) && ((shift_dist + shift_remind)<=4'hC))
								begin
									in_data			=	fifo_data;
									data_valid		=	1'b1;
									data_reg_load	=	1'b0;
									data_reg_in		=	32'b0;
								end
								else
								begin
									in_data			=	32'b0;
									data_valid		=	1'b0;
									data_reg_load	=	1'b1;
									data_reg_in		=	fifo_data;
								end
							end
							else
							begin
								in_data			=	32'b0;
								data_valid		=	1'b0;
								data_reg_load	=	1'b0;
								data_reg_clr	=	1'b0;
							end
						end
	WAIT_SHIFT	:	begin
							init_cnt_en		=	1'b0;
							if(fifo_empty)
								byte4_busy	=	1'b1;
							else
								byte4_busy	=	1'b0;
							byte4_data1		=	32'b0;
							byte4_data2		=	32'b0;
							byte4_data3		=	32'b0;
							byte4_data4		=	32'b0;
							byte4_valid		=	1'b0;
							data_reg_load	=	1'b0;
							data_reg_clr	=	1'b0;
							data_reg_in		=	32'b0;
							if((!fifo_empty) && (in_req || prefetch) && (!data_reg_valid))
								rd_fifo_en	=	1'b1;
							else
								rd_fifo_en	=	1'b0;
							in_data		=	32'b0;
							data_valid	=	1'b0;
							in_shift		=	3'b0;
							shift_valid	=	1'b0;
						end
	LOAD_ONLY	:	begin
							init_cnt_en		=	1'b0;
							if(fifo_empty)
								byte4_busy	=	1'b1;
							else
								byte4_busy	=	1'b0;
							byte4_data1		=	32'b0;
							byte4_data2		=	32'b0;
							byte4_data3		=	32'b0;
							byte4_data4		=	32'b0;
							byte4_valid		=	1'b0;
							if((!fifo_empty) && prefetch && (!data_reg_valid))
								rd_fifo_en	=	1'b1;
							else
								rd_fifo_en	=	1'b0;
							if(prefetch_done && (!data_reg_valid))
							begin
								if(!fifo_valid)
								begin
									in_data			=	prefetch_data;
									data_valid		=	1'b1;
									data_reg_load	=	1'b0;
									data_reg_clr	=	1'b0;
									data_reg_in		=	32'b0;
								end
								else
								begin
									in_data			=	prefetch_data;
									data_valid		=	1'b1;
									data_reg_load	=	1'b1;
									data_reg_clr	=	1'b0;
									data_reg_in		=	fifo_data;
								end
							end
							else if(data_reg_valid)
							begin
								in_data			=	data_reg;
								data_valid		=	1'b1;
								data_reg_load	=	1'b0;
								data_reg_clr	=	1'b1;
								data_reg_in		=	32'b0;
							end
							else if(fifo_valid)
							begin
								in_data			=	fifo_data;
								data_valid		=	1'b1;
								data_reg_load	=	1'b0;
								data_reg_clr	=	1'b0;
								data_reg_in		=	32'b0;
							end
							else
							begin
								in_data			=	32'b0;
								data_valid		=	1'b0;
								data_reg_load	=	1'b0;
								data_reg_clr	=	1'b0;
								data_reg_in		=	32'b0;
							end
							in_shift			=	shift_dist;
							shift_valid		=	shift_en;
						end
	WAIT_FIFO	:	begin
							init_cnt_en		=	1'b0;
							byte4_busy		=	1'b1;
							byte4_data1		=	32'b0;
							byte4_data2		=	32'b0;
							byte4_data3		=	32'b0;
							byte4_data4		=	32'b0;
							byte4_valid		=	1'b0;
							if((!fifo_empty)&&(!data_reg_valid))
								rd_fifo_en	=	1'b1;
							else
								rd_fifo_en	=	1'b0;
							data_reg_load	=	1'b0;
							data_reg_clr	=	1'b0;
							data_reg_in		=	32'b0;
							in_data			=	32'b0;
							in_shift			=	3'b0;
							shift_valid		=	1'b0;
							data_valid		=	1'b0;
						end
	DONE			:	begin
							init_cnt_en		=	1'b0;
							byte4_busy		=	1'b0;
							byte4_data1		=	32'b0;
							byte4_data2		=	32'b0;
							byte4_data3		=	32'b0;
							byte4_data4		=	32'b0;
							byte4_valid		=	1'b0;
							rd_fifo_en		=	1'b0;
							data_reg_load	=	1'b0;
							data_reg_clr	=	1'b0;
							data_reg_in		=	32'b0;
							in_data			=	32'b0;
							in_shift			=	3'b0;
							shift_valid		=	1'b0;
							data_valid		=	1'b0;
						end
	default		:	begin
							init_cnt_en		=	1'b0;
							byte4_busy		=	1'b0;
							byte4_data1		=	32'b0;
							byte4_data2		=	32'b0;
							byte4_data3		=	32'b0;
							byte4_data4		=	32'b0;
							byte4_valid		=	1'b0;
							rd_fifo_en		=	1'b0;
							data_reg_load	=	1'b0;
							data_reg_clr	=	1'b0;
							data_reg_in		=	32'b0;
							in_data			=	32'b0;
							in_shift			=	3'b0;
							shift_valid		=	1'b0;
							data_valid		=	1'b0;
						end
	endcase
end

//////////////////////////////////////////////
////			  Subordinate  Module 		   ////
//////////////////////////////////////////////
// shifter
shifter_96bit_v3	U_shifter_96bit
(
	// clock and reset
	.clk				(clk),
	.rstN				(rstN),
	// 32bit data input
	.in_data			(in_data),
	.in_shift		(in_shift),  
	.shift_valid	(shift_valid),
	.data_valid		(data_valid),
	.shift_remind	(shift_remind),
	// 32bit data output	
	.out_data		(out_data),
	.out_empty		(out_empty)
);

//////////////////////////////////////////////
////			  IP CORES  Module 			   ////
//////////////////////////////////////////////
// None

endmodule
