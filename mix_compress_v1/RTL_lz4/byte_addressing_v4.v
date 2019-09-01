`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:20:57 04/25/2016 
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
// Revision 4.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module byte_addressing_v4(
// clk and rst
input wire				clk,
input wire				rstN,
input wire				prefetch,	// prefetch data before matching start
input wire				last_3dwords,
// fifo 32bit data input
input wire	[31:0]	fifo_data, 
input wire				fifo_valid,
input wire				fifo_empty,
output wire				rd_fifo_en,
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
output reg				byte4_valid,
// debug port
output reg				shifter_overflow,
output reg				shifter_underflow
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
reg				pref_rd;			
wire	[31:0]	pref_data;	
wire				pref_valid;	
// shift_dist delay
reg	[2:0]		shift_dist_reg;
reg				shift_en_d1;

/////////////////////////////////////////////////
////			Dividual Combination Logic 		////
/////////////////////////////////////////////////

assign			in_req	=	(	((shift_remind - in_shift <= 4'h4) && data_valid) // && (!data_valid))
									|| ((shift_remind - in_shift <= 4'h8) && (!data_valid))
									|| (rd_data_en && (shift_dist!=3'b0) && (shift_remind - shift_dist)<=4'h8)) ? 1'b1 : 1'b0;

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

always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		shift_dist_reg	<=	3'b0;
		shift_en_d1		<=	1'b0;
	end
	else
	begin
		if(shift_en && (!rd_data_en))
			shift_en_d1		<=	1'b1;
		else
			shift_en_d1		<=	1'b0;
		if(shift_en)
			shift_dist_reg	<=	shift_dist;
		else
			shift_dist_reg	<=	shift_dist_reg;
	end
end

always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		shifter_overflow	<=	1'b0;
		shifter_underflow	<= 1'b0;
	end
	else
	begin
		if(shift_remind > 4'hC)
			shifter_overflow	<=	1'b1;
		else
			shifter_overflow	<=	1'b0;
			
		if(shift_remind < 4'h7)
			shifter_underflow	<=	1'b1;
		else
			shifter_underflow	<=	1'b0;
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
									if((!fifo_empty) || last_3dwords)
										next_state	=	LOAD_SHIFT;
									else
										next_state	=	WAIT_FIFO;
								else if(in_req)
									if((!fifo_empty) || last_3dwords)
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
								if(rd_data_en || shift_en)
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
								if(rd_data_en || shift_en)
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
									if(rd_data_en || shift_en)
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
							pref_rd			=	1'b0;	
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
							if((!fifo_empty) && byte4_en)
								pref_rd	=	1'b1;
							else
								pref_rd	=	1'b0;
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
							if((!fifo_empty) && (init_cnt<=2'h2) && byte4_en)
								pref_rd	=	1'b1;
							else
								pref_rd	=	1'b0;
							if(pref_valid && byte4_en)
							begin
								in_data		=	pref_data;
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
							shift_valid		=	1'b1;	//	shift_en;
							if(shift_en)
							begin
								in_shift		=	shift_dist;
								if((shift_remind - shift_dist)<=4'h8)
								begin
									in_data		=	pref_data;
									data_valid	=	pref_valid;
									pref_rd		=	1'b1;
								end
								else
								begin
									in_data		=	32'b0;
									data_valid	=	1'b0;
									pref_rd		=	1'b0;
								end
							end
							else if(shift_en_d1)
							begin
								in_shift		=	shift_dist_reg;
								if((shift_remind - shift_dist_reg)<=4'h8)
								begin
									in_data		=	pref_data;
									data_valid	=	pref_valid;
									pref_rd		=	1'b1;
								end
								else
								begin
									in_data		=	32'b0;
									data_valid	=	1'b0;
									pref_rd		=	1'b0;
								end
							end
							else
							begin
								in_shift		=	3'b0;
								in_data		=	32'b0;
								data_valid	=	1'b0;
								pref_rd		=	1'b0;
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
							pref_rd			=	1'b0;
							in_shift			=	3'b0;
							shift_valid		=	1'b0;
							in_data			=	32'b0;
							data_valid		=	1'b0;
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
							pref_rd			=	1'b1;
							in_shift			=	3'b0;
							shift_valid		=	1'b0;
							in_data			=	pref_data;
							data_valid		=	pref_valid;
						end
	WAIT_FIFO	:	begin
							init_cnt_en		=	1'b0;
							byte4_busy		=	1'b1;
							byte4_data1		=	32'b0;
							byte4_data2		=	32'b0;
							byte4_data3		=	32'b0;
							byte4_data4		=	32'b0;
							byte4_valid		=	1'b0;
							pref_rd			=	1'b0;
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
							pref_rd			=	1'b0;
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
							pref_rd			=	1'b0;
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

shifter_prefetch	U_shifter_prefetch
(
	// global clock and reset signal
	.clk				(clk),
	.rstN				(rstN),
	.last_3dwords	(last_3dwords),
	// input status signal
	.pref_rd			(pref_rd),
	// input fifo data
	.fifo_data		(fifo_data),
	.fifo_valid		(fifo_valid),
	.fifo_empty		(fifo_empty),
	// output read fifo signal
	.fifo_rd			(rd_fifo_en),
	// output prefetch data and valid signal
	.pref_data		(pref_data),
	.pref_valid		(pref_valid)
);

//////////////////////////////////////////////
////			  IP CORES  Module 			   ////
//////////////////////////////////////////////
// None

endmodule
