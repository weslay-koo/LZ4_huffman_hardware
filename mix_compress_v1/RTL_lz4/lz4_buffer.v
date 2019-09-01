`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:33:25 05/27/2015 
// Design Name: 
// Module Name:    lz4_buffer 
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

module lz4_buffer(
// clk and rst
input	wire				clk,
input wire				rstN,
input wire				buf_clean,
output reg				buf_unable,
// external end signal
input wire				compress_end,
// external data input
input wire	[31:0]	buf_idword,
input wire				buf_idvalid,
input wire	[31:0]	buf_ishift,
input wire				buf_isvalid,
input wire	[31:0]	buf_waddr, // Byte addressed write address
output reg				buf_full,
// data output
input wire				buf_rdreq,
input wire	[31:0]	buf_raddr, // Byte addressed read address
output reg	[31:0]	buf_odata,
output reg				buf_ovalid,
output reg				buf_empty,
// dictionary anchor move distance(per code segment)
input wire				move_valid,
input wire	[15:0]	move_distance, // Byte addressed
output reg	[31:0]	head_addr  // absolutely address 64kB block head
);

//////////////// FSM status ////////////////
parameter		IDLE				=	4'h0	;
parameter		CLEAN				=	4'h1	;
parameter		INIT_DICT		=	4'h2	;
parameter		READ_WRITE		=	4'h3	;
parameter		ANCHOR_MOVE		=	4'h4	;
parameter		WAIT				=	4'h5	;
parameter		STOP				=	4'h6	;
////////////////////////////////////////////
// FSM signal
reg	[3:0]		current_state,next_state;
// Bytes' number in dict for initial
reg	[16:0]	dict_data_cnt;
reg				dict_cnt_en;
reg	[2:0]		dict_cnt_inc;
// clean counter
reg	[15:0]	clean_cnt;
reg				clean_cnt_en;
// valid signal
wire				buf_ivalid;
// RAM signal
reg				ram_wea,ram_web;
reg	[14:0]	ram_addra,ram_addrb;
reg	[31:0]	ram_dina,ram_dinb;
// address, glue data and write signal
reg	[31:0]	data_glue;
reg	[63:0]	data_shift;
reg	[2:0]		shift_cnt,shift_cnt_d1;
reg				wr_en;
reg	[14:0]	wr_addr,rd_addr;
// head address counter
reg	[31:0]	abs_head_addr;		//	absolute head address
reg				head_cnt_en;
// address convert
wire	[15:0]	rel_head_addr;		// relative address
wire	[15:0]	rel_wr_addr,rel_rd_addr;  	

/////////////////////////////////////////////////
////			Dividual Combination Logic 		////
/////////////////////////////////////////////////
assign			buf_ivalid	=	buf_idvalid | buf_isvalid;
assign			rel_wr_addr	=	buf_waddr - {16'b0,abs_head_addr} + {16'b0,rel_head_addr};
assign			rel_rd_addr	=	buf_raddr - {16'b0,abs_head_addr} + {16'b0,rel_head_addr};

/////////////////////////////////////////////////
////				 Sequential Logic 				////
/////////////////////////////////////////////////
// FSM status transfer logic
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

// clean counter
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		clean_cnt	<=	16'b0;
	end
	else
	begin
		if(buf_ivalid)
			clean_cnt	<=	16'b0;
		else if(clean_cnt_en)
			clean_cnt	<=	clean_cnt + 1'b1;
		else
			clean_cnt	<=	clean_cnt;
	end
end

// Bytes in dict counter
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		dict_data_cnt	<=	17'b0;
	end
	else
	begin
		if(init_done)
			dict_data_cnt	<=	17'b0;
		else if(clean_cnt_en)
			dict_data_cnt	<=	dict_data_cnt + {14'b0,dict_cnt_inc};
		else
			dict_data_cnt	<=	dict_data_cnt;
	end
end

// head counter
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		abs_head_addr	<=	32'b0;
		rel_head_addr	<=	16'b0;
	end
	else
	begin
		if(head_cnt_en)
			abs_head_addr	<=	abs_head_addr + 1'b1;
		else
			abs_head_addr	<=	abs_head_addr;
			
		if(head_cnt_en)	
			rel_head_addr	<=	rel_head_addr + 1'b1;
		else
			rel_head_addr	<=	rel_head_addr;
	end
end

// data glue logic
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		data_shift	<=	64'b0;
		shift_cnt	<=	3'b0;
		shift_cnt_d1<=	3'b0;
	end
	else
	begin
		shift_cnt_d1	<=	shift_cnt;
		if(buf_isvalid)
		begin
			data_shift	<=	{data_shift[55:0],buf_ishift[7:0]};
			shift_cnt	<=	shift_cnt + 3'b001;
		end
		else if(buf_idvalid)
		begin
			data_shift	<=	{data_shift[31:0],buf_idword};
			shift_cnt	<=	shift_cnt + 3'b100;
		end
		else
		begin
			data_shift	<=	data_shift;
			shift_cnt	<=	shift_cnt;
		end
	end
end

//////////////////////////////////////////////
////				Combination Logic 			////
//////////////////////////////////////////////
// FSM status transfer logic
always @ (*)
begin
	case(current_state)
	IDLE			:	begin
							if((buf_clean)&&(!clean_done))
								next_state	=	CLEAN;
							else if((!init_done)||buf_ivalid)
								next_state	=	INIT_DICT;
							else if(buf_rdreq||buf_ivalid)
								next_state	=	READ_WRITE;
							else if(move_valid)
								next_state	=	ANCHOR_MOVE;
							else
								next_state	=	IDLE;
						end
	CLEAN			:	begin
							if(clean_cnt>=15'h7FFF)
							begin
								if(buf_ivalid)
									next_state	=	INIT_DICT;
								else
									next_state	=	WAIT;
							end
							else
							begin
								next_state	=	CLEAN;
							end
						end
	INIT_DICT	:	begin
							if(dict_data_cnt>=17'h10000)
							begin
								if(buf_rdreq||buf_ivalid)
									next_state	=	READ_WRITE;
								else 
									next_state	=	WAIT;
							end
							else
							begin
								next_state	=	INIT_DICT;
							end
						end
	READ_WRITE	:	begin
							if(buf_rdreq||buf_ivalid)
								next_state	=	READ_WRITE;
							else 
								next_state	=	WAIT;
						end
	ANCHOR_MOVE	:	begin
							if(compress_end)
								next_state	=	STOP;
							else
								next_state	=	WAIT;
						end
	WAIT			:	begin
							if((buf_clean)&&(!clean_done))
								next_state	=	CLEAN;
							else if((!init_done)||buf_ivalid)
								next_state	=	INIT_DICT;
							else if(buf_rdreq||buf_ivalid)
								next_state	=	READ_WRITE;
							else if(move_valid)
								next_state	=	ANCHOR_MOVE;
							else
								next_state	=	WAIT;
						end
	STOP			:	begin
							next_state	=	IDLE;
						end
	default		:	begin
							next_state	=	IDLE;
						end	
	endcase
end

// FSM output and contrel signal logic
always @ (*)
begin
	case(current_state)
	IDLE			:	begin
							clean_cnt_en	=	1'b0;
							dict_cnt_en		=	1'b0;
							dict_cnt_inc	=	3'b0;
							buf_odata		=	32'b0;
							buf_ovalid		=	1'b0;
							buf_empty		=	1'b0;
							buf_full			=	1'b0;
							head_addr		=	32'b0;
							buf_unable		=	1'b0;
							data_glue		=	32'b0;
							wr_en				=	1'b0;
							wr_addr			=	15'b0;
							rd_addr			=	15'b0;
							head_cnt_en		=	1'b0;
						end
	CLEAN			:	begin
							clean_cnt_en	=	1'b1;
							dict_cnt_en		=	1'b0;
							dict_cnt_inc	=	3'b0;
							buf_odata		=	32'b0;
							buf_ovalid		=	1'b0;
							buf_empty		=	1'b0;
							buf_full			=	1'b0;
							head_addr		=	32'b0;
							buf_unable		=	1'b1;
							data_glue		=	32'b0;
							wr_en				=	1'b0;
							wr_addr			=	15'b0;
							rd_addr			=	15'b0;
							head_cnt_en		=	1'b0;
						end
	INIT_DICT	:	begin
							clean_cnt_en	=	1'b0;
							dict_cnt_en		=	1'b1;
							if(buf_isvalid)
								dict_cnt_inc	=	3'h1;
							else if(buf_idvalid)
								dict_cnt_inc	=	3'h4;
							else
								dict_cnt_inc	=	3'h0;
							buf_odata		=	32'b0;
							buf_ovalid		=	1'b0;
							buf_empty		=	1'b0;
							buf_full			=	1'b0;
							head_addr		=	32'b0;
							buf_unable		=	1'b0;
							data_glue		=	32'b0;
							if(shift_cnt_d1[2]^shift_cnt[2])
								wr_en		=	1'b1;
							else
								wr_en		=	1'b0;
							wr_addr			=	rel_wr_addr;
							rd_addr			=	rel_rd_addr;
							head_cnt_en		=	1'b0;
						end
	READ_WRITE	:	begin
							clean_cnt_en	=	1'b0;
							dict_cnt_en		=	1'b0;
							dict_cnt_inc	=	3'b0;
							buf_odata		=	ram_doutb;
							buf_ovalid		=	1'b1;
							buf_empty		=	1'b0;
							buf_full			=	1'b0;
							head_addr		=	32'b0;
							buf_unable		=	1'b0;
							data_glue		=	32'b0;
							if(shift_cnt_d1[2]^shift_cnt[2])
								wr_en		=	1'b1;
							else
								wr_en		=	1'b0;
							wr_addr			=	rel_wr_addr;	//	15'b0;
							rd_addr			=	rel_rd_addr;	//	15'b0;
							head_cnt_en		=	1'b1;
						end
	ANCHOR_MOVE	:	begin
							clean_cnt_en	=	1'b0;
							dict_cnt_en		=	1'b0;
							dict_cnt_inc	=	3'b0;
							buf_odata		=	32'b0;
							buf_ovalid		=	1'b0;
							buf_empty		=	1'b0;
							buf_full			=	1'b0;
							head_addr		=	32'b0;
							buf_unable		=	1'b0;
							data_glue		=	32'b0;
							wr_en				=	1'b0;
							wr_addr			=	15'b0;
							rd_addr			=	15'b0;
							head_cnt_en		=	1'b0;
						end
	WAIT			:	begin
							clean_cnt_en	=	1'b0;
							dict_cnt_en		=	1'b0;
							dict_cnt_inc	=	3'b0;
							buf_odata		=	32'b0;
							buf_ovalid		=	1'b0;
							buf_empty		=	1'b0;
							buf_full			=	1'b0;
							head_addr		=	32'b0;
							buf_unable		=	1'b0;
							data_glue		=	32'b0;
							wr_en				=	1'b0;
							wr_addr			=	15'b0;
							rd_addr			=	15'b0;
							head_cnt_en		=	1'b0;
						end
	STOP			:	begin
							clean_cnt_en	=	1'b0;
							dict_cnt_en		=	1'b0;
							dict_cnt_inc	=	3'b0;
							buf_odata		=	32'b0;
							buf_ovalid		=	1'b0;
							buf_empty		=	1'b0;
							buf_full			=	1'b0;
							head_addr		=	32'b0;
							buf_unable		=	1'b1;
							data_glue		=	32'b0;
							wr_en				=	1'b0;
							wr_addr			=	15'b0;
							rd_addr			=	15'b0;
							head_cnt_en		=	1'b0;
						end
	default		:	begin
							clean_cnt_en	=	1'b0;
							dict_cnt_en		=	1'b0;
							dict_cnt_inc	=	3'b0;
							buf_odata		=	32'b0;
							buf_ovalid		=	1'b0;
							buf_empty		=	1'b0;
							buf_full			=	1'b0;
							head_addr		=	32'b0;
							buf_unable		=	1'b0;
							data_glue		=	32'b0;
							wr_en				=	1'b0;
							wr_addr			=	15'b0;
							rd_addr			=	15'b0;
							head_cnt_en		=	1'b0;
						end	
	endcase
end

// FSM RAM control signal
always @ (*)
begin
	case(current_state)
	IDLE			:	begin
							ram_wea		=	1'b0;
							ram_addra	=	15'b0;
							ram_dina		=	32'b0;
							ram_web		=	1'b0;
							ram_addrb	=	15'b0;
							ram_dinb		=	32'b0;
						end
	CLEAN			:	begin
							ram_wea		=	1'b1;
							ram_addra	=	clean_cnt[14:0];
							ram_dina		=	32'b0;
							ram_web		=	1'b0;
							ram_addrb	=	15'b0;
							ram_dinb		=	32'b0;
						end
	INIT_DICT	:	begin
							ram_wea		=	wr_en;
							ram_addra	=	wr_addr;
							ram_dina		=	data_glue;
							ram_web		=	1'b0;
							ram_addrb	=	rd_addr;
							ram_dinb		=	32'b0;
						end
	READ_WRITE	:	begin
							ram_wea		=	wr_en;
							ram_addra	=	wr_addr;
							ram_dina		=	data_glue;
							ram_web		=	1'b0;
							ram_addrb	=	rd_addr;
							ram_dinb		=	32'b0;
						end
	ANCHOR_MOVE	:	begin
							ram_wea		=	1'b0;
							ram_addra	=	15'b0;
							ram_dina		=	32'b0;
							ram_web		=	1'b0;
							ram_addrb	=	15'b0;
							ram_dinb		=	32'b0;
						end
	WAIT			:	begin
							ram_wea		=	1'b0;
							ram_addra	=	15'b0;
							ram_dina		=	32'b0;
							ram_web		=	1'b0;
							ram_addrb	=	15'b0;
							ram_dinb		=	32'b0;
						end
	STOP			:	begin
							ram_wea		=	1'b0;
							ram_addra	=	15'b0;
							ram_dina		=	32'b0;
							ram_web		=	1'b0;
							ram_addrb	=	15'b0;
							ram_dinb		=	32'b0;
						end
	default		:	begin
							ram_wea		=	1'b0;
							ram_addra	=	15'b0;
							ram_dina		=	32'b0;
							ram_web		=	1'b0;
							ram_addrb	=	15'b0;
							ram_dinb		=	32'b0;
						end	
	endcase
end

//////////////////////////////////////////////
////			  IP CORES  Module 			   ////
//////////////////////////////////////////////

buffer_ram32Kx32bit	U_buffer_ram
(
  .clka			(clk),
  .wea			(ram_wea),
  .addra			(ram_addra),
  .dina			(ram_dina),
  .clkb			(clk),
  .web			(ram_web),
  .addrb			(ram_addrb),
  .dinb			(ram_dinb),
                    
  .douta			(ram_douta),
  .doutb			(ram_doutb)
);

endmodule
