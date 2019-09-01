`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:00:10 06/03/2015 
// Design Name: 
// Module Name:    byte_addressing 
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
module byte_addressing(
// clk and rst
input wire				clk,
input wire				rstN,
// fifo 32bit data input
input wire	[31:0]	fifo_data, 
input wire				fifo_valid,
input wire				fifo_empty,
output reg				rd_fifo_en,
// data output
input wire				rd_shift_en,
input wire				rd_data_en,
output reg				byte4_busy,
output wire	[31:0]	byte4_shift,
output wire	[31:0]	byte4_data,
output wire				byte4_svalid,
output wire				byte4_dvalid
);

//////////// FSM Status ///////////////////
parameter	IDLE			=	3'h0;
parameter	DATA_LOAD	=	3'h1;
parameter	READ_BYTE	=	3'h2;
parameter	READ_DWORD	=	3'h3;
///////////////////////////////////////////

reg	[2:0]		current_state,next_state;
reg				load_en,shift_en,shift_dword;
reg	[3:0]		shift_cnt;
reg	[63:0]	byte4_shift_64bit;
reg				rd_shift_en_d1,rd_data_en_d1;
reg				init_done,init_rdfifo;
reg	[1:0]		init_cnt;
reg	[31:0]	fifo_data_reg;
reg				fifo_valid_d1;

// Sequential Logic
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

always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		shift_cnt	<=	4'h0;
	end
	else
	begin
		if(load_en)    // (rd_fifo_en)
			shift_cnt	<=	4'h0;
		else if(rd_shift_en)
			shift_cnt	<=	shift_cnt + 1'b1;
		else
			shift_cnt	<=	shift_cnt;
	end
end

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

always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		fifo_valid_d1	<=	1'b0;
	end
	else
	begin
		fifo_valid_d1	<=	fifo_valid;
	end
end

always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		byte4_shift_64bit	<=	64'b0	;
	end
	else
	begin
		if(fifo_valid_d1)	// (load_en && fifo_valid)	//
		begin
			if(shift_en)
			begin
				byte4_shift_64bit	<=	{byte4_shift_64bit[55:24],fifo_data_reg}; // fifo_data};
			end
			else
			begin
				byte4_shift_64bit[31:0]	<=	fifo_data_reg; //fifo_data;
				if(shift_dword || (!init_done))
				begin
					byte4_shift_64bit[63:32]	<=	byte4_shift_64bit[31:0];
				end
				else
				begin
					byte4_shift_64bit[63:32]	<=	byte4_shift_64bit[63:32];
				end
			end
		end
		else if(shift_en)
		begin
			byte4_shift_64bit	<=	{byte4_shift_64bit[55:0],byte4_shift_64bit[63:56]};	
		end
		else
		begin
			byte4_shift_64bit	<=	byte4_shift_64bit;
		end
	end
end

always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		rd_shift_en_d1	<=	1'b0;
		rd_data_en_d1	<=	1'b0;
	end
	else
	begin
		rd_shift_en_d1	<=	rd_shift_en;
		rd_data_en_d1	<=	rd_data_en;
	end
end

always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		init_done	<=	1'b0	;
		init_cnt		<=	2'b0	;
		init_rdfifo	<=	1'b0	;
	end
	else
	begin
		if(!fifo_empty)
		begin
			if((rd_fifo_en)&&(init_cnt<2'h2))
				init_cnt	<=	init_cnt + 1'b1;
			else 
				init_cnt	<=	init_cnt;
			
			if(init_cnt<2'h1)
				init_rdfifo	<=	1'b1	;
			else
				init_rdfifo	<=	1'b0	;
				
			if(init_cnt>=2'h1)
				init_done	<=	1'b1	;
			else
				init_done	<=	1'b0	;
		end
		else
		begin
			init_cnt		<=	init_cnt;
			init_rdfifo	<=	1'b0;
			init_done	<=	1'b0;
		end
	end
end

// Combination Logic

assign		byte4_shift	=	byte4_shift_64bit[63:32]	;
assign		byte4_data	=	byte4_shift_64bit[63:32]	;
assign		byte4_svalid=	shift_en;
assign		byte4_dvalid=	(shift_dword || (!init_done));

always @ (*)
begin
	case(current_state)
	IDLE			:	begin
							if(((shift_cnt>=4'h3)||(!init_done))&&(!fifo_empty))
								next_state	=	DATA_LOAD	;
							else if(rd_shift_en)
								next_state	=	READ_BYTE	;
							else if(rd_data_en)
								next_state	=	READ_DWORD	;
							else
								next_state	=	IDLE	;
						end
	DATA_LOAD	:	begin
							if((rd_shift_en)||(rd_shift_en_d1))
								next_state	=	READ_BYTE	;
							else if((rd_data_en)||(rd_data_en_d1))
								next_state	=	READ_DWORD	;
							else if(!init_done)
								next_state	=	DATA_LOAD	;
							else
								next_state	=	IDLE	;
						end
	READ_BYTE	:	begin
							if(rd_shift_en)
								next_state	=	READ_BYTE	;
							else if(rd_data_en)
								next_state	=	READ_DWORD	;
							else
								next_state	=	IDLE	;
						end
	READ_DWORD	:	begin
							if(rd_shift_en)
								next_state	=	READ_BYTE	;
							else if(rd_data_en)
								next_state	=	READ_DWORD	;
							else
								next_state	=	IDLE	;
						end
	default		:	begin
							next_state	=	IDLE	;
						end
	endcase
end

always @ (*)
begin
	case(current_state)
	IDLE			:	begin
							if((!fifo_empty)&&(shift_cnt>=4'h3))
								rd_fifo_en	=	1'b1	;
							else
								rd_fifo_en	=	1'b0	;
							if(!init_done)
								byte4_busy	=	1'b1	;
							else
								byte4_busy	=	1'b0	;
							shift_en		=	1'b0	;
							load_en		=	1'b0	;
						end
	DATA_LOAD	:	begin
							if(init_rdfifo)
								rd_fifo_en	=	1'b1	;
							else
								rd_fifo_en	=	1'b0	;
							shift_en		=	1'b0	;
							load_en		=	1'b1	;
							byte4_busy	=	1'b1	;
						end
	READ_BYTE	:	begin
							if((!fifo_empty)&&(shift_cnt==4'h2))
								rd_fifo_en	=	1'b1	;
							else
								rd_fifo_en	=	1'b0	;
							if(shift_cnt>=4'h3)
								load_en	=	1'b1	;
							else
								load_en	=	1'b0	;
							shift_en		=	1'b1	;
							byte4_busy	=	1'b0	;
						end
	READ_DWORD	:	begin
							rd_fifo_en	=	1'b0	;
							shift_en		=	1'b0	;
							load_en		=	1'b0	;
							byte4_busy	=	1'b0	;
						end
	default		:	begin
							rd_fifo_en	=	1'b0	;
							shift_en		=	1'b0	;
							load_en		=	1'b0	;
							byte4_busy	=	1'b0	;
						end
	endcase
end

endmodule
