`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:50:12 02/25/2016 
// Design Name: 
// Module Name:    byte_addressing_v2 
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
module byte_addressing_v2(
// clk and rst
input wire				clk,
input wire				rstN,
input wire 				last_5bytes,
input wire				hit_valid,
// fifo 32bit data input
input wire	[31:0]	fifo_data, 
input wire				fifo_valid,
input wire				fifo_empty,
output reg				rd_fifo_en,
// data output
input wire				byte4_en,
input wire				rd_shift_en,
input wire				rd_dword_en,
input wire	[2:0]		match_mask,
output reg				byte4_busy,
output reg	[31:0]	byte4_shift,
//output reg	[31:0]	abs_addr,
output reg				byte4_svalid,
output reg	[31:0]	byte4_dword,
output reg				byte4_dvalid
);

//////////////// FSM status ////////////////
parameter		IDLE			=	4'h0	;
parameter		WAIT_INIT	=	4'h1	;
parameter		INIT			=	4'h2	;
parameter		LOAD_SHIFT	=	4'h3	;
parameter		SHIFT_ONLY	=	4'h4	;
parameter		WAIT_SHIFT	=	4'h5	;
parameter		LOAD_ONLY	=	4'h6	;
parameter		LOAD_DWORD	=	4'h7	;
parameter		DONE			=	4'h8	;
////////////////////////////////////////////
// FSM status
reg	[3:0]		current_state,next_state;
// shifter inout signal
reg	[31:0]	in_data;
reg	[2:0]		in_shift;	
reg				shift_valid,data_valid;
wire	[31:0]	out_data;
wire	[2:0]		out_mask;	
wire				in_req,in_stb;
// initial counter
reg	[1:0]		init_cnt;
reg				init_cnt_en,init_done;
//	load done signal
reg				load_done,load_cnt_en;
reg	[1:0]		load_cnt;
wire	[3:0]		shift_remind;
// fifo data latch
reg	[31:0]	fifo_data_reg;
wire	[31:0]	in_data_sel;

/////////////////////////////////////////////////
////			Dividual Combination Logic 		////
/////////////////////////////////////////////////
// data select
assign		in_data_sel	=	fifo_valid ? fifo_data : fifo_data_reg;

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

// load done signal generate
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		load_done	<=	1'b0;
		load_cnt		<=	2'b0;
	end
	else
	begin
		if(!byte4_en)
		begin
			load_done	<=	1'b0;
			load_cnt		<=	2'b0;
		end
		else if(byte4_busy)
		begin
			load_done	<=	1'b1;
			load_cnt		<=	2'b0;
		end
		else if(rd_fifo_en)
			if(!data_valid)
			begin
				load_done	<=	1'b0;
				load_cnt		<=	load_cnt + 1'b1;
			end
			else
			begin
				load_done	<=	load_done;
				load_cnt		<=	load_cnt;
			end
		else
			if(data_valid)
			begin
				load_done	<=	1'b1;
				load_cnt		<=	load_cnt - 1'b1;
			end
			else
			begin
				load_done	<=	load_done;
				load_cnt		<=	load_cnt;
			end
	end
end

// data latch
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		fifo_data_reg	<=	32'b0;
	end
	else
	begin
		if(fifo_valid)
			fifo_data_reg	<=	fifo_data;
		else
			fifo_data_reg	<=	fifo_data_reg;
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
									if(rd_shift_en)
										next_state	=	SHIFT_ONLY;
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
								if(rd_dword_en)
									next_state	=	LOAD_DWORD;
								else if(rd_shift_en)
									if(in_req && ((!fifo_empty) || (load_cnt!=2'b0)))
										next_state	=	LOAD_SHIFT;
									else
										next_state	=	SHIFT_ONLY;
								else
									next_state	=	WAIT_SHIFT;
							end
							else
							begin
								next_state	=	DONE;
							end
						end
	SHIFT_ONLY	:	begin
							if(byte4_en)
							begin
								if(rd_dword_en)
									next_state	=	LOAD_DWORD;
								else if(rd_shift_en)
									if(in_req && ((!fifo_empty) || (load_cnt!=2'b0)))
										next_state	=	LOAD_SHIFT;
									else
										next_state	=	SHIFT_ONLY;
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
								if(rd_dword_en)
									next_state	=	LOAD_DWORD;
								else if(rd_shift_en)
									if(in_req && ((!fifo_empty) || (load_cnt!=2'b0)))
										next_state	=	LOAD_SHIFT;
									else
										next_state	=	SHIFT_ONLY;
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
								if(rd_dword_en)
									next_state	=	LOAD_DWORD;
								else if(rd_shift_en)
									if(in_req && ((!fifo_empty) || (load_cnt!=2'b0)))
										next_state	=	LOAD_SHIFT;
									else
										next_state	=	SHIFT_ONLY;
								else
									next_state	=	WAIT_SHIFT;
							end
							else
							begin
								next_state	=	DONE;
							end
						end
	LOAD_DWORD	:	begin
							if(byte4_en)
							begin
								if(rd_dword_en)
									next_state	=	LOAD_DWORD;
								else if(rd_shift_en)
									if(in_req && ((!fifo_empty) || (load_cnt!=2'b0)))
										next_state	=	LOAD_SHIFT;
									else
										next_state	=	SHIFT_ONLY;
								else
									next_state	=	WAIT_SHIFT;
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
							byte4_shift		=	32'b0;
							byte4_svalid	=	1'b0;
							byte4_dword		=	32'b0;
							byte4_dvalid	=	1'b0;
							rd_fifo_en		=	1'b0;
							in_data			=	32'b0;
							in_shift			=	3'b0;
							shift_valid		=	1'b0;
							data_valid		=	1'b0;
						end
	WAIT_INIT	:	begin
							init_cnt_en		=	1'b0;
							byte4_busy		=	1'b1;
							byte4_shift		=	32'b0;
							byte4_svalid	=	1'b0;
							byte4_dword		=	32'b0;
							byte4_dvalid	=	1'b0;
							if((!fifo_empty)&& byte4_en)
								rd_fifo_en	=	1'b1;
							else
								rd_fifo_en	=	1'b0;
							in_data			=	32'b0;
							in_shift			=	3'b0;
							shift_valid		=	1'b0;
							data_valid		=	1'b0;
						end
	INIT			:	begin
							init_cnt_en		=	1'b1;
							byte4_busy		=	1'b1;
							byte4_shift		=	32'b0;
							byte4_svalid	=	1'b0;
							byte4_dword		=	32'b0;
							byte4_dvalid	=	1'b0;
							if((!fifo_empty)&& (init_cnt<=2'h2) && byte4_en)
								rd_fifo_en	=	1'b1;
							else
								rd_fifo_en	=	1'b0;
							if(fifo_valid && byte4_en)
							begin
								in_data		=	in_data_sel;
								in_shift		=	3'h0;
								shift_valid	=	1'b0;
								data_valid	=	1'b1;
							end
							else
							begin
								in_data		=	32'b0;
								in_shift		=	3'b0;
								shift_valid	=	1'b0;
								data_valid	=	1'b0;
							end
						end
	LOAD_SHIFT	:	begin
							init_cnt_en		=	1'b0;
							byte4_busy		=	1'b0;
							byte4_shift		=	out_data;
							byte4_svalid	=	1'b1;
							byte4_dword		=	32'b0;
							byte4_dvalid	=	1'b0;
							if((!fifo_empty) && in_stb)
								rd_fifo_en	=	1'b1;
							else
								rd_fifo_en	=	1'b0;
							if((!load_done) && byte4_en)
							begin
								in_data		=	in_data_sel;
								in_shift		=	3'h1;
								shift_valid	=	1'b1;
								data_valid	=	1'b1;
							end
							else
							begin
								in_data		=	32'b0;
								in_shift		=	3'b0;
								shift_valid	=	1'b0;
								data_valid	=	1'b0;
							end
						end
	SHIFT_ONLY	:	begin
							init_cnt_en		=	1'b0;
							byte4_busy		=	1'b0;
							byte4_shift		=	out_data;
							byte4_svalid	=	1'b1;
							byte4_dword		=	32'b0;
							byte4_dvalid	=	1'b0;
							if((!fifo_empty) && in_stb)
								rd_fifo_en	=	1'b1;
							else
								rd_fifo_en	=	1'b0;
							in_data			=	32'b0;
							in_shift			=	3'h1;
							shift_valid		=	1'b1;
							data_valid		=	1'b0;
						end
	WAIT_SHIFT	:	begin
							init_cnt_en		=	1'b0;
							byte4_busy		=	1'b0;
							byte4_shift		=	32'b0;
							byte4_svalid	=	1'b0;
							byte4_dword		=	32'b0;
							byte4_dvalid	=	1'b0;
							if((!fifo_empty) && rd_dword_en && in_stb)
								rd_fifo_en	=	1'b1;
							else
								rd_fifo_en	=	1'b0;
								
							if(rd_dword_en)
							begin
								if(in_req)
								begin
									in_data		=	in_data_sel;
									data_valid	=	1'b1;
								end
								else 
								begin
									in_data		=	32'b0;
									data_valid	=	1'b0;
								end
							end
							else
							begin
								in_data		=	32'b0;
								data_valid	=	1'b0;
							end
							if(hit_valid)
							begin
								in_shift		=	3'h3;
								shift_valid	=	1'b1;
							end
							else
							begin
								in_shift		=	3'b0;
								shift_valid	=	1'b0;
							end
						end
	LOAD_ONLY	:	begin
							init_cnt_en		=	1'b0;
							byte4_busy		=	1'b0;
							byte4_shift		=	32'b0;
							byte4_svalid	=	1'b0;
							byte4_dword		=	32'b0;
							byte4_dvalid	=	1'b0;
							rd_fifo_en		=	1'b0;
							if((!load_done) && byte4_en)
							begin
								in_data		=	in_data_sel;
								in_shift		=	3'h0;
								shift_valid	=	1'b0;
								data_valid	=	1'b1;
							end
							else
							begin
								in_data		=	32'b0;
								in_shift		=	3'b0;
								shift_valid	=	1'b0;
								data_valid	=	1'b0;
							end
						end
	LOAD_DWORD	:	begin
							init_cnt_en		=	1'b0;
							byte4_busy		=	1'b0;
							byte4_shift		=	32'b0;
							byte4_svalid	=	1'b0;
							byte4_dword		=	out_data;
							byte4_dvalid	=	1'b1;
							if((!fifo_empty) && 
								(in_stb || ((match_mask==3'b100)&&(!last_5bytes))))
								rd_fifo_en	=	1'b1;
							else
								rd_fifo_en	=	1'b0;
								
							if(	(!load_done) && byte4_en 
								&& ((shift_remind - {1'b0,match_mask})<=4'h8))
							begin
								in_data		=	in_data_sel;
								data_valid	=	1'b1;
							end
							else
							begin
								in_data		=	32'b0;
								data_valid	=	1'b0;
							end
							if(byte4_en)
							begin
								in_shift		=	match_mask; // 3'h4;
								shift_valid	=	1'b1;
							end
							else
							begin
								in_shift		=	3'b0;
								shift_valid	=	1'b0;
							end
						end
	DONE			:	begin
							init_cnt_en		=	1'b0;
							byte4_busy		=	1'b0;
							byte4_shift		=	32'b0;
							byte4_svalid	=	1'b0;
							byte4_dword		=	32'b0;
							byte4_dvalid	=	1'b0;
							rd_fifo_en		=	1'b0;
							in_data			=	32'b0;
							in_shift			=	3'b0;
							shift_valid		=	1'b0;
							data_valid		=	1'b0;
						end
	default		:	begin
							init_cnt_en		=	1'b0;
							byte4_busy		=	1'b0;
							byte4_shift		=	32'b0;
							byte4_svalid	=	1'b0;
							byte4_dword		=	32'b0;
							byte4_dvalid	=	1'b0;
							rd_fifo_en		=	1'b0;
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
shifter_96bit	U_shifter_96bit
(
	// clock and reset
	.clk				(clk),
	.rstN				(rstN),
	// 32bit data input
	.in_data			(in_data),
	.in_shift		(in_shift),  
	.shift_valid	(shift_valid),
	.data_valid		(data_valid),
	.load_done		(load_done),
	.in_req			(in_req),
	.in_stb			(in_stb),
	.shift_remind	(shift_remind),
	// 32bit data output	
	.out_data		(out_data),  
	.out_mask		(out_mask),
	.out_empty		(out_empty)
);

//////////////////////////////////////////////
////			  IP CORES  Module 			   ////
//////////////////////////////////////////////
// None

endmodule

