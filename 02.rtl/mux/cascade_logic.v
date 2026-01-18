`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:33:52 03/30/2017 
// Design Name: 
// Module Name:    cascade_logic 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: Cascade LZ4 and huffman encoder with variable statistic 
//								length function
//
//////////////////////////////////////////////////////////////////////////////////
module cascade_logic(
// Global clock and reset
input wire				clk,
input wire				rstN,
// control signal for variable statistic length
input wire	[16:0]	max_stat_len,	// max statistic length is 65536
input wire				max_stat_valid,// this signal will trigger new statistic process
input wire				start_compress,
// data from LZ4 output fifo
input wire	[33:0]	lz4_data,
input wire				lz4_valid,
input wire				lz4_empty,
input wire				lz4_full,
input wire				lz4_hfull,	// half full
input wire				lz4_done,	// LZ4 encoder done, all data has been stored in output fifo
output reg				lz4_oen,
// data to huffman input fifo
input wire				huff_full,
input wire				huff_empty,	// indicate all data in statistic fifo has been encoded, wait for new data to encode
output reg	[31:0]	huff_data,
output reg				huff_valid,
output reg				huff_last,
output reg	[2:0]		huff_lmask,
output reg				huff_in_end,
output reg				huff_stat_end
);

// wait for LZ4 encoder time delay
parameter	WAIT_TIME	=	4'hA;

// data read and counter for Statistic Length control
reg	[16:0]	stat_cnt,max_stat_len_reg;
// register full signal for data latch
reg				latch_full;
reg	[33:0]	latch;
// wait counter when lz4_done signal valid
reg	[3:0]		wait_count;
reg				time_delayed;

/////////////////////////////////////////////////
////			Dividual Combination Logic 		////
/////////////////////////////////////////////////
// None

/////////////////////////////////////////////////
////				Combination Logic 				////
/////////////////////////////////////////////////
//	None

/////////////////////////////////////////////////
////				 Sequential Logic 				////
/////////////////////////////////////////////////
// max_stat_len register
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		max_stat_len_reg	<=	17'h1_FFFF;
	end
	else
	begin
		if(start_compress)
			max_stat_len_reg	<=	17'h1_FFFF;
		else if(max_stat_valid)
			max_stat_len_reg	<=	max_stat_len;
		else
			max_stat_len_reg	<=	max_stat_len_reg;
	end
end

// oen signal generation for data from LZ4 encoder
// wait counter run when lz4_done signal valid, and lz4_oen must invalid before counter reach WAIT_TIME value
// when wait counter reach WAIT_TIME value, time_delayed signal will be set to high level
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		lz4_oen			<=	1'b0;
		wait_count		<=	4'b0;
		time_delayed	<=	1'b0;
	end
	else
	begin
		if(max_stat_valid)
		begin
			lz4_oen	<=	1'b0;
		end
		else if(~lz4_done)
		begin
			if((huff_full != 1'b1) && (lz4_empty != 1'b1) && (stat_cnt < max_stat_len_reg))
			begin
				lz4_oen	<=	1'b1;
			end
			else
			begin
				if(huff_empty & (~lz4_empty))
					lz4_oen	<=	1'b1;
				else
					lz4_oen	<=	1'b0;
			end
		end
		else
		begin
			if((huff_full != 1'b1) && (lz4_empty != 1'b1) && (stat_cnt < max_stat_len_reg) && (time_delayed == 1'b1))
			begin
				lz4_oen	<=	1'b1;
			end
			else
			begin
				if(huff_empty & (~lz4_empty) & time_delayed)
					lz4_oen	<=	1'b1;
				else
					lz4_oen	<=	1'b0;
			end
		end
		
		if(start_compress)
		begin
			wait_count		<=	4'b0;
			time_delayed	<=	1'b0;
		end
		else if(lz4_done && (wait_count < WAIT_TIME))
		begin
			wait_count		<=	wait_count + 1'b1;
			time_delayed	<=	1'b0;
		end
		else if(lz4_done && (wait_count >= WAIT_TIME))
		begin
			wait_count		<=	WAIT_TIME;
			time_delayed	<=	1'b1;
		end
		else
		begin
			wait_count		<=	wait_count;
			time_delayed	<=	time_delayed;
		end
	end
end

// statistic counter and huffman stat_end signal generation
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		stat_cnt			<=	17'b0;
		huff_stat_end	<=	1'b0;
	end
	else
	begin
		if(max_stat_valid)
		begin
			stat_cnt	<=	17'b0;
		end
		else if(lz4_valid & (~huff_stat_end))
		begin
			stat_cnt	<=	stat_cnt + 3'h4;	// statistic length radix is 4
		end
		else
		begin
			stat_cnt	<=	stat_cnt;
		end
		
		if(start_compress)
		begin
			huff_stat_end	<=	1'b0;
		end
		else if(lz4_done & lz4_empty)
		begin
			huff_stat_end	<=	1'b1;
		end
		else if(stat_cnt >= max_stat_len_reg)
		begin
			huff_stat_end	<=	1'b1;
		end
		else
		begin
			huff_stat_end	<=	huff_stat_end;
		end
	end
end

// data tranfer to Huffman encoder
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		huff_data	<=	32'b0;
	   huff_valid	<=	1'b0;
		huff_last	<=	1'b0;
	   huff_lmask	<=	3'b0;
		latch_full	<=	1'b0;
		latch			<=	34'b0;
	end
	else
	begin
		if(!huff_full)
		begin
			if(lz4_valid | latch_full)
			begin
				huff_valid	<=	1'b1;
				if(latch_full & lz4_valid)
				begin
					huff_data	<=	latch[31:0];
					huff_last	<=	1'b0;
					huff_lmask	<=	{(~(latch[33]|latch[32])),latch[33:32]};
					latch	<=	lz4_data;
					latch_full	<=	1'b1;
				end
				else if(lz4_valid & (~latch_full))
				begin
					huff_data	<=	lz4_data[31:0];
					if(lz4_data[33:32] != 2'b0)
						huff_last	<=	1'b1;
					else
						huff_last	<=	1'b0;
					huff_lmask	<=	{(~(lz4_data[33]|lz4_data[32])),lz4_data[33:32]};
					latch			<=	34'b0;
					latch_full	<=	1'b0;
				end
				else
				begin
					huff_data	<=	latch[31:0];
					if(latch[33:32] != 2'b0)
						huff_last	<=	1'b1;
					else
						huff_last	<=	1'b0;
					huff_lmask	<=	{(~(latch[33]|latch[32])),latch[33:32]};
					latch			<=	34'b0;
					latch_full	<=	1'b0;
				end
			end
			else
			begin
				huff_data	<=	32'b0;
				huff_valid	<=	1'b0;
				huff_last	<=	1'b0;
				huff_lmask	<=	3'b0;
				latch			<=	34'b0;
				latch_full	<=	latch_full;
			end
		end
		else
		begin
			huff_data	<=	32'b0;
			huff_valid	<=	1'b0;
			huff_last	<=	1'b0;
			huff_lmask	<=	3'b0;
			if(lz4_valid)
			begin
				latch			<=	lz4_data;
				latch_full	<=	1'b1;
			end
			else
			begin
				latch			<=	latch;
				latch_full	<=	latch_full;
			end
		end
	end
end

// Last mask and huffman in end signal generation
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
	   huff_in_end		<=	1'b0;
	end
	else
	begin
		if(start_compress)
		begin
			huff_in_end		<=	1'b0;
		end
		else if(lz4_done & lz4_empty & time_delayed)
		begin
			huff_in_end		<=	1'b1;
		end	
		else
		begin
			huff_in_end		<=	huff_in_end;
		end
	end
end


/////////////////////////////////////////////////
////					Sub Modules						////
/////////////////////////////////////////////////
// None

endmodule
