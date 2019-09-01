`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:14:48 05/30/2015 
// Design Name: 
// Module Name:    hash_table 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: read delay 2 cycles,write delay 3 cycles, Read first
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module hash_table(
// clk and rst
input wire				clk,
input wire				rstN,
input wire				hash_clean,
input wire				hash_wr_only,
output reg				hash_unable,
// external unmatched data 4 byte input 
input wire	[31:0]	hash_idata,
input wire	[31:0]	hash_iaddr,  // first char address (64KB range)
input wire				hash_ivalid,  // single pulse signal with valid data input
// external dictionary data 4 byte input 
output reg				hash_hit,
output wire	[31:0]	hash_oaddr,
output reg				hash_ovalid
);

///////// FSM Status defination ////////////
parameter	IDLE			=	3'h0;
parameter	CLEAN_TABLE	=	3'h1;
parameter	HASH_CALC	=	3'h2;
parameter	HASH_UPDATE	=	3'h3;
parameter	WAIT			=	3'h4;
parameter	STOP			=	3'h5;
////////////////////////////////////////////
// FSM signal
reg	[2:0]		current_state,next_state;
// Hash ram control signal
reg	[14:0]	hash_ram_waddr,hash_ram_raddr;
reg				hash_ram_wea;
reg	[63:0]	hash_ram_din;
// Hash table clean signal
reg	[15:0]	clean_cnt;
reg				clean_cnt_en;
// data to hash value
reg	[31:0]	hash_idata_reg,hash_iaddr_reg;	
wire	[14:0]	hash_key;
reg	[14:0]	hash_key_d1;
wire	[63:0]	hash_temp;
// data match judgement
reg				odata_latch;
reg	[31:0]	hash_odata_reg;
wire	[31:0]	hash_odata;

/////////////////////////////////////////////////
////				 Sequential Logic 				////
/////////////////////////////////////////////////

// main FSM transfer Sequential Logic
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

// clean signal generation
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		clean_cnt	<=	16'b0;
	end
	else
	begin
		if(clean_cnt_en)
			clean_cnt	<=	clean_cnt + 1'b1;
		else
			clean_cnt	<=	clean_cnt;
	end
end

// input data and address latch
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		hash_idata_reg	<=	32'b0;
		hash_iaddr_reg	<=	32'b0;
	end
	else
	begin
		if(hash_ivalid)
		begin
			hash_idata_reg	<=	hash_idata;	
			hash_iaddr_reg	<=	hash_iaddr;
		end
		else
		begin
			hash_idata_reg	<=	hash_idata_reg;	
		   hash_iaddr_reg	<=	hash_iaddr_reg;	
		end
	end
end

// hash_key delay
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		hash_key_d1	<=	15'b0;
	end
	else
	begin
		hash_key_d1	<=	hash_key;	
	end
end

// output data latch
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		hash_odata_reg	<=	32'b0;
	end
	else
	begin
		if(odata_latch)
			hash_odata_reg	<=	hash_odata;
		else
			hash_odata_reg	<=	hash_odata_reg;
	end
end

//////////////////////////////////////////////
////				Combination Logic 			////
//////////////////////////////////////////////
always @ (*)
begin
	case(current_state)
	IDLE			:	begin
							if(hash_clean)
								next_state	=	CLEAN_TABLE;
							else if(hash_ivalid)
								next_state	=	HASH_CALC;
							else
								next_state	=	IDLE;
						end
	CLEAN_TABLE	:	begin
							if(clean_cnt >= 16'h7FFF)
								next_state	=	IDLE;
							else
								next_state	=	CLEAN_TABLE;
						end	
	HASH_CALC	:	begin
							next_state	=	HASH_UPDATE;
						end	
	HASH_UPDATE	:	begin
							if(hash_ivalid)
								next_state	=	HASH_CALC;
							else
								next_state	=	WAIT;
						end
	WAIT			:	begin
							if(hash_clean)
								next_state	=	STOP;
							else if(hash_ivalid)
								next_state	=	HASH_CALC;
							else
								next_state	=	WAIT;
						end
	STOP			:	begin
							next_state	=	CLEAN_TABLE;
						end
	default		:	begin
							next_state	=	IDLE;
						end
	endcase
end

always @ (*)
begin
	case(current_state)
	IDLE			:	begin
							hash_unable		=	1'b0;
							hash_ram_waddr	=	15'b0;
							hash_ram_raddr	=	15'b0;
							hash_ram_wea	=	1'b0;
							hash_ram_din	=	64'b0;
							clean_cnt_en	=	1'b0;
							odata_latch		=	1'b0;
							hash_hit			=	1'b0;
							hash_ovalid		=	1'b0;
						end
	CLEAN_TABLE	:	begin
							hash_unable		=	1'b1;
							hash_ram_waddr	=	clean_cnt[14:0];
							hash_ram_raddr	=	15'b0;
							hash_ram_wea	=	1'b1;
							hash_ram_din	=	64'b0;
							clean_cnt_en	=	1'b1;
							odata_latch		=	1'b0;
							hash_hit			=	1'b0;
							hash_ovalid		=	1'b0;
						end	
	HASH_CALC	:	begin
							hash_unable		=	1'b0;
							hash_ram_waddr	=	15'b0;
							hash_ram_raddr	=	hash_key;
							hash_ram_wea	=	1'b0;
							hash_ram_din	=	64'b0;
							clean_cnt_en	=	1'b0;
							odata_latch		=	1'b1;
							hash_ovalid		=	1'b0;
							hash_hit			=	1'b0;
						end	
	HASH_UPDATE	:	begin
							hash_unable		=	1'b0;
							hash_ram_waddr	=	hash_key_d1;
							hash_ram_raddr	=	15'b0;
							hash_ram_wea	=	1'b1;
							hash_ram_din	=	{hash_idata_reg,hash_iaddr_reg};
							clean_cnt_en	=	1'b0;
							odata_latch		=	1'b0;
							hash_ovalid		=	1'b1;
							if(hash_odata == hash_idata_reg)
								hash_hit	=	1'b1;
							else
								hash_hit	=	1'b0;
						end
	WAIT			:	begin
							hash_unable		=	1'b0;
							hash_ram_waddr	=	15'b0;
							hash_ram_raddr	=	15'b0;
							hash_ram_wea	=	1'b0;
							hash_ram_din	=	64'b0;
							clean_cnt_en	=	1'b0;
							odata_latch		=	1'b0;
							hash_hit			=	1'b0;
							hash_ovalid		=	1'b0;
						end
	STOP			:	begin
							hash_unable		=	1'b0;
							hash_ram_waddr	=	15'b0;
							hash_ram_raddr	=	15'b0;
							hash_ram_wea	=	1'b0;
							hash_ram_din	=	64'b0;
							clean_cnt_en	=	1'b0;
							odata_latch		=	1'b0;
							hash_hit			=	1'b0;
							hash_ovalid		=	1'b0;
						end
	default		:	begin
							hash_unable		=	1'b0;
							hash_ram_waddr	=	15'b0;
							hash_ram_raddr	=	15'b0;
							hash_ram_wea	=	1'b0;
							hash_ram_din	=	64'b0;
							clean_cnt_en	=	1'b0;
							odata_latch		=	1'b0;
							hash_hit			=	1'b0;
							hash_ovalid		=	1'b0;
						end
	endcase
end

//////////////////////////////////////////////
////			  IP CORES  Module 			   ////
//////////////////////////////////////////////
// IP core 32bit absolute address and 32bit originate data
hash_ram_32Kx64bit	U_hash_ram
(
  .clka			(clk),
  .wea			(hash_ram_wea),
  .addra			(hash_ram_waddr),
  .dina			(hash_ram_din),
  .clkb			(clk),
  .web			(1'b0),
  .addrb			(hash_ram_raddr),
  .dinb			(64'b0),
  
  .douta			(),
  .doutb			({hash_odata,hash_oaddr})
);

// hash multiplier
hash_mul32x32 U_hash_mul
(
  .clk	(clk), 
  .sclr	(~rstN), 
  .a		(32'h9E37_79B1), // Hash coef
  .b		(hash_idata), 
  
  .p		(hash_temp)
);

/////////////////////////////////////////////////
////			Dividual Combination Logic 		////
/////////////////////////////////////////////////
assign	hash_key = hash_temp[31:17];

endmodule
