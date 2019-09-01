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
// Description: FSM just for load data from FIFO
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
input wire				byte4_en,
input wire				rd_shift_en,
output reg				byte4_busy,
output wire	[31:0]	byte4_shift,
output reg	[31:0]	abs_addr,
output reg				byte4_svalid
);

//	shift reg and counter
reg	[2:0]		shift_cnt;
reg	[63:0]	shift_64bit;
// initial done signal
reg				init_done,init_done_d1;
reg	[1:0]		init_cnt;
// fifo signal delay
reg				rd_fifo_en_d1;

/////////////////////////////////////////////////
////			Dividual Combination Logic 		////
/////////////////////////////////////////////////

assign		byte4_shift	=	shift_64bit[63:32];


/////////////////////////////////////////////////
////				 Sequential Logic 				////
/////////////////////////////////////////////////

// rd_fifo_en delay for data_valid
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		rd_fifo_en_d1	<=	1'b0;
	end
	else
	begin
		rd_fifo_en_d1	<=	rd_fifo_en;
	end
end

// initial done
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		init_done_d1<=	1'b0;
		init_done	<=	1'b0;
		init_cnt		<=	2'b0;
	end
	else
	begin
		if(byte4_en)
		begin
			if(rd_fifo_en&&(!init_done))
			begin
				init_done_d1<=	init_done;
				init_cnt	<=	init_cnt + 1'b1;
				if(init_cnt>=2'h1)
					init_done	<=	1'b1;
				else
					init_done	<=	1'b0;
			end
			else
			begin
				init_done_d1<=	init_done;
				init_done	<=	init_done;
				init_cnt		<=	init_cnt;
			end
		end
		else
		begin
			init_done_d1<=	1'b0;
			init_done	<=	1'b0;
			init_cnt		<=	2'b0;
		end
	end
end

// shift counter and load enable signal generation
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		shift_cnt	<=	3'b0;
		rd_fifo_en	<=	1'b0;
		byte4_busy	<=	1'b1;
	end
	else
	begin
		if(byte4_en)
		begin
			if(rd_shift_en)
			begin
				if(rd_fifo_en)
					shift_cnt	<=	3'b0;
				else if(shift_cnt < 3'h3)
					shift_cnt	<=	shift_cnt + 1'b1;
				else
					shift_cnt	<=	shift_cnt;
			end
			else
			begin
				shift_cnt	<=	shift_cnt;
			end

			if((fifo_empty)&&((shift_cnt >= 3'h2))||(!init_done))
				byte4_busy	<=	1'b1;
			else
				byte4_busy	<=	1'b0;
		end
		else
		begin
			shift_cnt	<=	3'b0;
			rd_fifo_en	<=	1'b0;
			byte4_busy	<=	1'b1;
		end
	end
end

// shift reg operation and absolute address generation
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		shift_64bit	<=	64'b0;
		abs_addr		<=	32'b0;
		byte4_svalid<=	1'b0;
	end
	else
	begin
		if(byte4_en)
		begin
			if(rd_fifo_en_d1)
			begin
				if(rd_shift_en)
				begin
					shift_64bit	<=	{shift_64bit[55:24],fifo_data};
					abs_addr		<=	abs_addr + 1'b1;
					byte4_svalid<=	1'b1;
				end
				else
				begin
					abs_addr		<=	abs_addr;
					byte4_svalid<=	1'b0;
					if(init_done_d1)
						shift_64bit	<=	{shift_64bit[63:32],fifo_data};
					else
						shift_64bit	<=	{shift_64bit[31:0],fifo_data};
				end
			end
			else
			begin
				if(rd_shift_en)
				begin
					shift_64bit	<=	{shift_64bit[55:24],shift_64bit[63:56]};
					abs_addr		<=	abs_addr + 1'b1;
					byte4_svalid<=	1'b1;
				end
				else
				begin
					shift_64bit	<=	shift_64bit;
					abs_addr		<=	abs_addr;
					byte4_svalid<=	1'b0;
				end
			end
		end
		else
		begin
			shift_64bit	<=	64'b0;
			abs_addr		<=	32'b0;
			byte4_svalid<=	1'b0;
		end
	end
end

// rd_fifo_en signal generation
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		rd_fifo_en	<=	1'b0;
	end
	else
	begin
		if(byte4_en)
		begin
			if((!fifo_empty)&&((shift_cnt == 3'h2)||(init_cnt<2'h1)))
				rd_fifo_en	<=	1'b1;
			else
				rd_fifo_en	<=	1'b0;
		end
		else
		begin
			rd_fifo_en	<=	1'b0;
		end
	end
end
//////////////////////////////////////////////
////				Combination Logic 			////
//////////////////////////////////////////////
// None

//////////////////////////////////////////////
////			  IP CORES  Module 			   ////
//////////////////////////////////////////////

// None

endmodule
