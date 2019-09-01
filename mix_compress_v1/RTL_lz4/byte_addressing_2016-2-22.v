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
input wire 				last_5bytes,
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
output reg	[31:0]	abs_addr,
output reg				byte4_svalid,
output reg	[31:0]	byte4_dword,
output reg				byte4_dvalid
);

//////////////// FSM status ////////////////
parameter		IDLE			=	4'h0	;
parameter		WAIT_INIT	=	4'h1	;
parameter		INIT			=	4'h2	;
parameter		INIT_DONE	=	4'h3	;
parameter		WAIT_FIFO	=	4'h4	;
parameter		LOAD_SHIFT	=	4'h5	;
parameter		SHIFT_ONLY	=	4'h6	;
parameter		WAIT_SHIFT	=	4'h7	;
parameter		LOAD_DWORD	=	4'h8	;
parameter		DONE			=	4'h9	;
////////////////////////////////////////////
// FSM status
reg	[3:0]		current_state,next_state;
//	shift reg and counter
reg	[2:0]		shift_cnt,shift_cnt_reg;
reg				shift_en,shift_done;
reg	[95:0]	shift_96bit;
reg				load_dword,load_dword_d1,dword_en,dword_done;
reg	[2:0]		dword_cnt;
reg	[1:0]		pre_rd_status,pre_rd_status_d1;		//	00,11:illegal 01:rd_shift 10:rd_dword
// initial done signal
reg				init_done,init_cnt_en;
reg				init_done_d1,init_done_d2;
reg	[1:0]		init_cnt;
// fifo read signal mask
reg				rd_fifo_mask;
// abs_addr signal
reg	[31:0]	abs_cnt;
reg				abs_cnt_en;
// fifo data register
reg	[31:0]	fifo_data_reg;
// load enable and done
reg				load_en,load_en_d1;
reg				load_done;
// shifter data remain counter
reg	[3:0]		shifter_remain;

/////////////////////////////////////////////////
////			Dividual Combination Logic 		////
/////////////////////////////////////////////////

//assign		byte4_shift	=	shift_64bit[63:32];

// data glue initial logic
function	[95:0]	GLUE;
	input	[63:0]	src;
	input [31:0]	update;
	input	[2:0]		shift_cnt;
	case(shift_cnt)
	3'h0	:	GLUE = {src,update};
	3'h1	:	GLUE = {src[63:8],update,8'b0};
	3'h2	:	GLUE = {src[63:16],update,16'b0};
	3'h3	:	GLUE = {src[63:24],update,24'b0};
	default:	GLUE = 96'b0;
	endcase
endfunction


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
		init_cnt	<=	2'b0;
	end
	else
	begin
		if(init_done)
			init_cnt	<=	2'b0;
		else if(init_cnt_en)
			init_cnt	<=	init_cnt + 1'b1;
		else
			init_cnt	<=	init_cnt;
	end
end

// shift counter
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		shift_cnt		<=	3'b0;
		shift_cnt_reg	<=	3'b0;
	end
	else
	begin
		if(load_en && (!byte4_dvalid))	//	(fifo_valid)
			shift_cnt	<=	3'b0;
		else if((pre_rd_status_d1==2'b01) && (pre_rd_status==2'b10))
			shift_cnt	<=	{1'b0,shift_cnt[1:0] + 2'h3};
		else if(dword_en)
			shift_cnt	<=	{1'b0,shift_cnt[1:0] + match_mask[1:0]};
		else if(shift_en)
			shift_cnt	<=	shift_cnt + 1'b1;
		else
			shift_cnt	<=	shift_cnt;
		
		if(shift_en)
			shift_cnt_reg	<=	shift_cnt;
		else
			shift_cnt_reg	<=	shift_cnt_reg;
	end
end

// shift reg operation 
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		shift_96bit		<=	96'b0;
		shifter_remain	<=	4'b0;
	end
	else
	begin
		if(shift_done)
		begin
			shift_96bit		<=	96'b0;
			shifter_remain	<=	4'b0;
		end
		else if(rd_dword_en&&(pre_rd_status==2'b01))
		begin
			if(shifter_remain <= 4'h9)  //  (shift_cnt_reg!=3'h3)
			begin
				shifter_remain	<=	shifter_remain + 4'h1;
				shift_96bit		<=	{shift_96bit[71:24],fifo_data_reg,16'b0};
			end
			else
			begin
				shifter_remain	<=	shifter_remain - 4'h3;
				shift_96bit		<=	{shift_96bit[71:0],shift_96bit[95:72]};
			end
		end
		else if(load_en)
		begin
			if(dword_en)
			begin
				if(!init_done_d1)
					shifter_remain	<=	shifter_remain + 4'h4;
				else
					shifter_remain	<=	shifter_remain;
//				case(match_mask)
//				3'b001	:	begin
//									if(fifo_valid)
//										shift_96bit	<=	GLUE(shift_96bit[87:24],fifo_data,shift_cnt_reg);
//									else
//										shift_96bit	<=	GLUE(shift_96bit[87:24],fifo_data_reg,shift_cnt_reg);
//								end
//				3'b010	:	begin
//									if(fifo_valid)
//										shift_96bit	<=	GLUE(shift_96bit[79:16],fifo_data,shift_cnt_reg);
//									else
//										shift_96bit	<=	GLUE(shift_96bit[79:16],fifo_data_reg,shift_cnt_reg);
//								end
//				3'b011	:	begin
//									if(fifo_valid)
//										shift_96bit	<=	GLUE(shift_96bit[71:8],fifo_data,shift_cnt_reg);
//									else
//										shift_96bit	<=	GLUE(shift_96bit[71:8],fifo_data_reg,shift_cnt_reg);
//								end
//				3'b100	:	begin
									if(fifo_valid)
										shift_96bit	<=	GLUE(shift_96bit[63:0],fifo_data,shift_cnt_reg);
									else
										shift_96bit	<=	GLUE(shift_96bit[63:0],fifo_data_reg,shift_cnt_reg);
//								end
//				default	:	begin
//									shift_96bit	<=	shift_96bit;
//								end
//				endcase				
			end
			else if(shift_en)
			begin
				shifter_remain	<=	shifter_remain + 4'h3;
				if(fifo_valid)
					shift_96bit	<=	{shift_96bit[87:24],fifo_data};
				else
					shift_96bit	<=	{shift_96bit[87:24],fifo_data_reg};
			end
			else
			begin
				shifter_remain	<=	shifter_remain + 4'h4;
				if(fifo_valid)
					shift_96bit	<=	GLUE(shift_96bit[95:32],fifo_data,shift_cnt);
				else
					shift_96bit	<=	GLUE(shift_96bit[95:32],fifo_data_reg,shift_cnt_reg);
			end
		end
		else
		begin
			if(dword_en)
			begin
				case(match_mask)
				3'b001	:	begin
									shifter_remain	<=	shifter_remain - 4'h1;
									shift_96bit		<=	{shift_96bit[87:0],shift_96bit[95:88]};
								end
				3'b010	:	begin
									shifter_remain	<=	shifter_remain - 4'h2;
									shift_96bit		<=	{shift_96bit[79:0],shift_96bit[95:80]};
								end
				3'b011	:	begin
									shifter_remain	<=	shifter_remain - 4'h3;
									shift_96bit		<=	{shift_96bit[71:0],shift_96bit[95:72]};
								end
				3'b100	:	begin
									shifter_remain	<=	shifter_remain - 4'h4;
									shift_96bit		<=	{shift_96bit[63:0],shift_96bit[95:64]};
								end
				default	:	begin
									shifter_remain	<=	shifter_remain;
									shift_96bit		<=	shift_96bit;
								end
				endcase
			end
			else if(shift_en)
			begin
				shifter_remain	<=	shifter_remain - 4'h1;
				shift_96bit		<=	{shift_96bit[87:0],shift_96bit[95:88]};
			end
			else
			begin
				shifter_remain	<=	shifter_remain;
				shift_96bit		<=	shift_96bit;
			end
		end
	end
end

// initial done signal delay
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		init_done_d2	<=	1'b0;
		init_done_d1	<=	1'b0;
	end
	else
	begin
		init_done_d2	<=	init_done_d1;
		init_done_d1	<=	init_done;
	end
end

// abs_addr signal generation
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		abs_cnt	<=	32'b0;
	end
	else
	begin
		if(dword_en)
		begin
			if(abs_cnt_en)
				abs_cnt	<=	abs_cnt + 3'h4;
			else 
				abs_cnt	<=	abs_cnt;
		end
		else if(byte4_en)
		begin
			if(abs_cnt_en)
				abs_cnt	<=	abs_cnt + 1'b1;
			else 
				abs_cnt	<=	abs_cnt;
		end
		else
		begin
			abs_cnt	<=	32'b0;
		end
	end
end

// fifo data register
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

// load signal delay
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		load_en_d1		<=	1'b0;
		load_dword_d1	<=	1'b0;
	end
	else
	begin
		load_en_d1		<=	load_en;
		load_dword_d1	<=	load_dword;
	end
end

// pre read status statistics
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		pre_rd_status		<=	2'b00;
		pre_rd_status_d1	<=	2'b00;
	end
	else
	begin
		pre_rd_status_d1	<=	pre_rd_status;
		if(rd_dword_en)
			pre_rd_status	<=	2'b10;
		else if(rd_shift_en)
			pre_rd_status	<=	2'b01;
		else
			pre_rd_status	<=	pre_rd_status;
	end
end

// load done signal
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		load_done	<=	1'b0;
	end
	else
	begin
		if(rd_fifo_en)
			load_done	<=	1'b0;
		else if(load_en)
			load_done	<=	1'b1;
		else
			load_done	<=	load_done;
	end
end

/////////////////////////////////////////////
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
								if(fifo_empty)
									next_state	=	WAIT_INIT;
								else
								begin
									if(init_cnt>=2'h2)
										next_state	=	INIT_DONE;
									else
										next_state	=	INIT;
								end
							end
							else
							begin
								next_state	=	DONE;
							end
						end
	INIT_DONE	:	begin
							if(byte4_en)
							begin
								if(rd_shift_en)
									next_state	=	SHIFT_ONLY;
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
								if(fifo_empty)
									next_state	=	WAIT_FIFO;
								else
									next_state	=	LOAD_SHIFT;
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
								begin
									if((shift_cnt>=3'h3)&&(!last_5bytes)) // when in continuous mode, it should be (shift_cnt>=3'h2)
									begin
										if(fifo_empty)
											next_state	=	WAIT_FIFO;
										else
											next_state	=	LOAD_SHIFT;
									end
									else
									begin
										next_state	=	SHIFT_ONLY;
									end
								end
								else
								begin
									next_state	=	WAIT_SHIFT;
								end
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
									if((shift_cnt>=3'h3)&&(!last_5bytes))	 // when in continuous mode, it should be (shift_cnt>=3'h2)
									begin
										if(fifo_empty)
											next_state	=	WAIT_FIFO;
										else
											next_state	=	LOAD_SHIFT;
									end
									else
									begin
										next_state	=	SHIFT_ONLY;
									end
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
							next_state	=	IDLE;
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
							init_done	=	1'b0;
							init_cnt_en	=	1'b0;
							shift_en		=	1'b0;	
							shift_done	=	1'b0;
							abs_cnt_en	=	1'b0;
							load_en		=	1'b0;
							dword_en		=	1'b0;
							if(init_done)
								byte4_busy	=	1'b0;
							else
								byte4_busy	=	1'b1;
							byte4_shift	=	32'b0;
							abs_addr		=	32'b0;
							byte4_svalid=	1'b0;
							byte4_dword	=	32'b0;
							byte4_dvalid=	1'b0;
							rd_fifo_en	=	1'b0;
						end
	WAIT_INIT	:	begin
							init_done	=	1'b0;
							init_cnt_en	=	1'b0;
							shift_en		=	1'b0;	
							shift_done	=	1'b0;
							abs_cnt_en	=	1'b0;
							dword_en		=	1'b0;
							load_en		=	1'b0;
							byte4_busy	=	1'b1;
							byte4_shift	=	32'b0;
							abs_addr		=	32'b0;
							byte4_svalid=	1'b0;
							byte4_dword	=	32'b0;
							byte4_dvalid=	1'b0;
							if((!fifo_empty) && byte4_en)
								rd_fifo_en	=	1'b1;
							else
								rd_fifo_en	=	1'b0;
						end
	INIT			:	begin
							init_done	=	1'b0;
							init_cnt_en	=	1'b1;
							shift_en		=	1'b0;	
							shift_done	=	1'b0;
							abs_cnt_en	=	1'b0;
							dword_en		=	1'b1;
							if(fifo_valid)
								load_en		=	1'b1;
							else
								load_en		=	1'b0;
							byte4_busy	=	1'b1;
							byte4_shift	=	32'b0;
							abs_addr		=	32'b0;
							byte4_svalid=	1'b0;
							byte4_dword	=	32'b0;
							byte4_dvalid=	1'b0;
							if((!fifo_empty) && byte4_en)
								rd_fifo_en	=	1'b1;
							else
								rd_fifo_en	=	1'b0;
						end
	INIT_DONE	:	begin
							init_done	=	1'b1;
							init_cnt_en	=	1'b0;
							shift_en		=	1'b0;	
							shift_done	=	1'b0;
							abs_cnt_en	=	1'b0;
							dword_en		=	1'b1;
							load_en		=	1'b1;
							byte4_busy	=	1'b1;
							byte4_shift	=	32'b0;
							abs_addr		=	32'b0;
							byte4_svalid=	1'b0;
							byte4_dword	=	32'b0;
							byte4_dvalid=	1'b0;
							rd_fifo_en	=	1'b0;
						end
	WAIT_FIFO	:	begin
							init_done	=	1'b1;
							init_cnt_en	=	1'b0;
							shift_en		=	1'b0;	
							shift_done	=	1'b0;
							abs_cnt_en	=	1'b0;
							dword_en		=	1'b0;
							load_en		=	1'b0;
							byte4_busy	=	1'b1;
							byte4_shift	=	32'b0;
							abs_addr		=	32'b0;
							byte4_svalid=	1'b0;
							byte4_dword	=	32'b0;
							byte4_dvalid=	1'b0;
							if((!fifo_empty) && byte4_en)
								rd_fifo_en	=	1'b1;
							else
								rd_fifo_en	=	1'b0;
						end
	LOAD_SHIFT	:	begin
							init_done	=	1'b1;
							init_cnt_en	=	1'b0;
							shift_en		=	1'b1;	
							shift_done	=	1'b0;
							abs_cnt_en	=	1'b1;
							dword_en		=	1'b0;
							load_en		=	1'b1;
							byte4_busy	=	1'b0;
							byte4_shift	=	shift_96bit[95:64];
							abs_addr		=	abs_cnt;
							byte4_svalid=	1'b1;
							byte4_dword	=	32'b0;
							byte4_dvalid=	1'b0;
							rd_fifo_en	=	1'b0;
						end
	SHIFT_ONLY	:	begin
							init_done	=	1'b1;
							init_cnt_en	=	1'b0;
							shift_en		=	1'b1;	
							shift_done	=	1'b0;
							abs_cnt_en	=	1'b1;
							dword_en		=	1'b0;
							load_en		=	1'b0;
							byte4_busy	=	1'b0;
							byte4_shift	=	shift_96bit[95:64];
							abs_addr		=	abs_cnt;
							byte4_svalid=	1'b1;
							byte4_dword	=	32'b0;
							byte4_dvalid=	1'b0;
							if((!fifo_empty) && byte4_en && (shift_cnt==3'h2) && load_done)
								rd_fifo_en	=	1'b1;
							else
								rd_fifo_en	=	1'b0;
						end
	WAIT_SHIFT	:	begin
							init_done	=	1'b1;
							init_cnt_en	=	1'b0;
							shift_en		=	1'b0;	
							shift_done	=	1'b0;
							abs_cnt_en	=	1'b0;
							dword_en		=	1'b0;
							load_en		=	1'b0;
							byte4_busy	=	1'b0;
							byte4_shift	=	32'b0;
							abs_addr		=	32'b0;
							byte4_svalid=	1'b0;
							byte4_dword	=	32'b0;
							byte4_dvalid=	1'b0;
							if((!fifo_empty) && byte4_en && rd_dword_en) // && (shift_cnt_reg!=3'h3))
								rd_fifo_en	=	1'b1;
							else
								rd_fifo_en	=	1'b0;
						end
	LOAD_DWORD	:	begin
							init_done	=	1'b1;
							init_cnt_en	=	1'b0;
							shift_en		=	1'b0;	
							shift_done	=	1'b0;
							rd_fifo_mask=	1'b0;
							abs_cnt_en	=	1'b0;
							dword_en		=	1'b1;
							if(match_mask == 3'b100)
							begin
								if((shifter_remain>4'h9)&&(shift_cnt_reg==3'h3))
									load_en		=	1'b0;
								else
									load_en		=	1'b1;
								if(!fifo_empty)
									rd_fifo_en	=	1'b1;
								else
									rd_fifo_en	=	1'b0;
							end
							else
							begin
								if((shifter_remain - {1'b0,match_mask}) > 4'h8) // (shifter_remain>=4'h8) // 
									load_en		=	1'b0;
								else
									load_en		=	1'b1;
								rd_fifo_en	=	1'b0;
							end
							byte4_busy	=	1'b0;
							byte4_shift	=	32'b0;
							abs_addr		=	32'b0;
							byte4_svalid=	1'b0;
							byte4_dword	=	shift_96bit[95:64];	// shift_64bit[63:32];
							byte4_dvalid=	1'b1;
						end
	DONE			:	begin
							init_done	=	1'b0;
							init_cnt_en	=	1'b0;
							shift_en		=	1'b0;	
							shift_done	=	1'b1;
							abs_cnt_en	=	1'b0;
							dword_en		=	1'b0;
							load_en		=	1'b0;
							byte4_busy	=	1'b0;
							byte4_shift	=	32'b0;
							abs_addr		=	32'b0;
							byte4_svalid=	1'b0;
							byte4_dword	=	32'b0;
							byte4_dvalid=	1'b0;
							rd_fifo_en	=	1'b0;
						end
	default		:	begin
							init_done	=	1'b0;
							init_cnt_en	=	1'b0;
							shift_en		=	1'b0;	
							shift_done	=	1'b1;
							abs_cnt_en	=	1'b0;
							dword_en		=	1'b0;
							load_en		=	1'b0;
							byte4_busy	=	1'b0;
							byte4_shift	=	32'b0;
							abs_addr		=	32'b0;
							byte4_svalid=	1'b0;
							byte4_dword	=	32'b0;
							byte4_dvalid=	1'b0;
							rd_fifo_en	=	1'b0;
						end
	endcase
end

//////////////////////////////////////////////
////			  IP CORES  Module 			   ////
//////////////////////////////////////////////

// None

endmodule
