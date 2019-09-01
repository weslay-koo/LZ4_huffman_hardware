`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:12:10 04/19/2016 
// Design Name: 
// Module Name:    hash_table_v3 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: v1 traditional gold cut hash
//								v2 all byte hash in matching process
//								v3 find match dword by 4 parralle hash calculation 4 port hash table
//
//////////////////////////////////////////////////////////////////////////////////
module hash_table_v3(
// clk and rst
input wire				clk,
input wire				clk_2x,
input wire				rstN,
input wire				hash_clean,
input wire				hash_wr_only,
output reg				hash_unable,
// external unmatched data 4 byte input 
input wire	[31:0]	hash_idata1,		//	shift by 4Bytes per clk cycles when find match
input wire	[31:0]	hash_iaddr1,  		// first char address (64KB range)	[55:24]
input wire				hash_ivalid1, 		// port data and address input valid signal
input wire	[31:0]	hash_idata2,		//	shift by 4Bytes per clk cycles when find match
input wire	[31:0]	hash_iaddr2,  		// first char address (64KB range)	[47:16]
input wire				hash_ivalid2, 		// port data and address input valid signal
input wire	[31:0]	hash_idata3,		//	shift by 4Bytes per clk cycles when find match
input wire	[31:0]	hash_iaddr3,  		// first char address (64KB range)	[39:8]
input wire				hash_ivalid3, 		// port data and address input valid signal
input wire	[31:0]	hash_idata4,		//	shift by 4Bytes per clk cycles when find match
input wire	[31:0]	hash_iaddr4,  		// first char address (64KB range)	[31:0]
input wire				hash_ivalid4, 		// port data and address input valid signal
// external dictionary data 4 byte input 
output reg				hash_hit,
output reg	[2:0]		hit_status,
output reg	[31:0]	hit_dist,		//	match string head 32bit offset value
output reg	[31:0]	hash_oaddr,
output reg				hash_ovalid
);

///////// FSM Status defination ////////////
parameter	IDLE			=	3'h0;
parameter	CLEAN_TABLE	=	3'h1;
parameter	HASH_CALC	=	3'h2;
parameter	HASH_UPDATE	=	3'h3;
parameter	HASH_WRITE	=	3'h4;
parameter	WAIT			=	3'h5;
parameter	STOP			=	3'h6;
////////////////////////////////////////////
// FSM signal
reg	[2:0]		current_state,next_state;
// Hash ram control signal
reg	[14:0]	ram_addra,ram_addrb,ram_addrc,ram_addrd;
reg				ram_wea,ram_web,ram_wec,ram_wed;
reg	[64:0]	ram_dina,ram_dinb,ram_dinc,ram_dind;
wire	[64:0]	ram_douta,ram_doutb,ram_doutc,ram_doutd;
// Hash table clean signal
reg	[15:0]	clean_cnt;
reg				clean_cnt_en;
// data to hash value
reg	[31:0]	hash_idata1_d1,hash_idata1_d2,hash_iaddr1_d1,hash_iaddr1_d2;
reg				hash_ivalid1_d1,hash_ivalid1_d2;
reg	[31:0]	hash_idata2_d1,hash_idata2_d2,hash_iaddr2_d1,hash_iaddr2_d2;
reg				hash_ivalid2_d1,hash_ivalid2_d2;
reg	[31:0]	hash_idata3_d1,hash_idata3_d2,hash_iaddr3_d1,hash_iaddr3_d2;
reg				hash_ivalid3_d1,hash_ivalid3_d2;
reg	[31:0]	hash_idata4_d1,hash_idata4_d2,hash_iaddr4_d1,hash_iaddr4_d2;
reg				hash_ivalid4_d1,hash_ivalid4_d2;
wire	[14:0]	hash_key1,hash_key2,hash_key3,hash_key4;
reg	[14:0]	hash_key1_d1,hash_key2_d1,hash_key3_d1,hash_key4_d1;
wire	[63:0]	hash_temp1,hash_temp2,hash_temp3,hash_temp4;
// data match judgement
wire	[31:0]	hash_odata1,hash_odata2,hash_odata3,hash_odata4;
wire	[31:0]	hash_oaddr1,hash_oaddr2,hash_oaddr3,hash_oaddr4;
wire				hash_flag1,hash_flag2,hash_flag3,hash_flag4;
// hash in valid signal req
wire				hash_ivalid;
// hash match arbiter module signal
wire				arb_hash_hit;	
wire	[2:0]		arb_hit_status;
wire	[31:0]	arb_hash_oaddr;
wire	[31:0]	arb_hit_dist;
// shift internal match module signal (for 4 Bytes paralla process)
wire				shf_hash_hit;	
wire	[2:0]		shf_hit_status;
wire	[31:0]	shf_hash_oaddr;
wire	[31:0]	shf_hit_dist;
	
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

// input port 1 data and address latch
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		hash_idata1_d2		<=	32'b0;
		hash_idata1_d1		<=	32'b0;
		hash_iaddr1_d2		<=	32'b0;
		hash_iaddr1_d1		<=	32'b0;
		hash_ivalid1_d2	<=	1'b0;
		hash_ivalid1_d1	<=	1'b0;
	end
	else
	begin
		hash_ivalid1_d2	<=	hash_ivalid1_d1;
		hash_ivalid1_d1	<=	hash_ivalid1;
		if(hash_ivalid1)
		begin
			hash_idata1_d2		<=	hash_idata1_d1;
			hash_idata1_d1		<=	hash_idata1;	
			hash_iaddr1_d2		<=	hash_iaddr1_d1;
			hash_iaddr1_d1		<=	hash_iaddr1;
		end
		else
		begin
			hash_idata1_d2	<=	hash_idata1_d2;
			hash_idata1_d1	<=	hash_idata1_d1;	
			hash_iaddr1_d2	<=	hash_iaddr1_d2;
		   hash_iaddr1_d1	<=	hash_iaddr1_d1;	
		end
	end
end
// input port 2 data and address latch
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		hash_idata2_d2		<=	32'b0;
		hash_idata2_d1		<=	32'b0;
		hash_iaddr2_d2		<=	32'b0;
		hash_iaddr2_d1		<=	32'b0;
		hash_ivalid2_d2	<=	1'b0;
		hash_ivalid2_d1	<=	1'b0;
	end
	else
	begin
		hash_ivalid2_d2	<=	hash_ivalid2_d1;
		hash_ivalid2_d1	<=	hash_ivalid2;
		if(hash_ivalid2)
		begin
			hash_idata2_d2	<=	hash_idata2_d1;
			hash_idata2_d1	<=	hash_idata2;	
			hash_iaddr2_d2	<=	hash_iaddr2_d1;
			hash_iaddr2_d1	<=	hash_iaddr2;
		end
		else
		begin
			hash_idata2_d2	<=	hash_idata2_d2;
			hash_idata2_d1	<=	hash_idata2_d1;	
			hash_iaddr2_d2	<=	hash_iaddr2_d2;
		   hash_iaddr2_d1	<=	hash_iaddr2_d1;	
		end
	end
end
// input port 3 data and address latch
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		hash_idata3_d2		<=	32'b0;
		hash_idata3_d1		<=	32'b0;
		hash_iaddr3_d2		<=	32'b0;
		hash_iaddr3_d1		<=	32'b0;
		hash_ivalid3_d2	<=	1'b0;
		hash_ivalid3_d1	<=	1'b0;
	end
	else
	begin
		hash_ivalid3_d2	<=	hash_ivalid3_d1;
		hash_ivalid3_d1	<=	hash_ivalid3;
		if(hash_ivalid3)
		begin
			hash_idata3_d2	<=	hash_idata3_d1;
			hash_idata3_d1	<=	hash_idata3;	
			hash_iaddr3_d2	<=	hash_iaddr3_d1;
			hash_iaddr3_d1	<=	hash_iaddr3;
		end
		else
		begin
			hash_idata3_d2	<=	hash_idata3_d2;
			hash_idata3_d1	<=	hash_idata3_d1;	
			hash_iaddr3_d2	<=	hash_iaddr3_d2;
		   hash_iaddr3_d1	<=	hash_iaddr3_d1;	
		end
	end
end
// input port 4 data and address latch
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		hash_idata4_d2	<=	32'b0;
		hash_idata4_d1	<=	32'b0;
		hash_iaddr4_d2	<=	32'b0;
		hash_iaddr4_d1	<=	32'b0;
		hash_ivalid4_d2	<=	1'b0;
		hash_ivalid4_d1	<=	1'b0;
	end
	else
	begin
		hash_ivalid4_d2	<=	hash_ivalid4_d1;
		hash_ivalid4_d1	<=	hash_ivalid4;
		if(hash_ivalid4)
		begin
			hash_idata4_d2	<=	hash_idata4_d1;
			hash_idata4_d1	<=	hash_idata4;	
			hash_iaddr4_d2	<=	hash_iaddr4_d1;
			hash_iaddr4_d1	<=	hash_iaddr4;
		end
		else
		begin
			hash_idata4_d2	<=	hash_idata4_d2;
			hash_idata4_d1	<=	hash_idata4_d1;	
			hash_iaddr4_d2	<=	hash_iaddr4_d2;
		   hash_iaddr4_d1	<=	hash_iaddr4_d1;	
		end
	end
end

// hash_key delay
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		hash_key1_d1	<=	15'b0;
		hash_key2_d1	<=	15'b0;
		hash_key3_d1	<=	15'b0;
		hash_key4_d1	<=	15'b0;
	end
	else
	begin
		hash_key1_d1	<=	hash_key1;	
		hash_key2_d1	<=	hash_key2;
		hash_key3_d1	<=	hash_key3;
		hash_key4_d1	<=	hash_key4;
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
							else if(hash_wr_only && hash_ivalid)
								next_state	=	HASH_WRITE;
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
							if(hash_wr_only && hash_ivalid)
								next_state	=	HASH_WRITE;
							else if(hash_ivalid)
								next_state	=	HASH_CALC;
							else
								next_state	=	WAIT;
						end
	HASH_WRITE	:	begin
							if(hash_wr_only && hash_ivalid)
								next_state	=	HASH_WRITE;
							else
								next_state	=	IDLE;
						end
	WAIT			:	begin
							if(hash_clean)
								next_state	=	STOP;
							else if(hash_wr_only && hash_ivalid)
								next_state	=	HASH_WRITE;
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
							clean_cnt_en	=	1'b0;
							hash_ovalid		=	1'b0;
							hash_oaddr		=	32'b0;
							hash_hit			=	1'b0;
							hit_status		=	3'b0;
							hit_dist			=	32'b0;
						end
	CLEAN_TABLE	:	begin
							hash_unable		=	1'b1;
							clean_cnt_en	=	1'b1;
							hash_ovalid		=	1'b0;
							hash_oaddr		=	32'b0;
							hash_hit			=	1'b0;
							hit_status		=	3'b0;
							hit_dist			=	32'b0;
						end	
	HASH_CALC	:	begin
							hash_unable		=	1'b0;
							clean_cnt_en	=	1'b0;
							hash_ovalid		=	1'b0;
							hash_oaddr		=	32'b0;
							hash_hit			=	1'b0;
							hit_status		=	3'b0;
							hit_dist			=	32'b0;
						end	
	HASH_UPDATE	:	begin
							hash_unable		=	1'b0;
							clean_cnt_en	=	1'b0;
							hash_ovalid		=	1'b1;
							if(arb_hash_hit)
							begin
								hash_oaddr		=	arb_hash_oaddr;
								hit_status		=	arb_hit_status;
								hash_hit			=	1'b1;
								hit_dist			=	arb_hit_dist;
							end
							else if(shf_hash_hit)
							begin
								hash_oaddr		=	shf_hash_oaddr;
								hit_status		=	shf_hit_status;
								hash_hit			=	1'b1;
								hit_dist			=	shf_hit_dist;
							end
							else
							begin
								hash_oaddr		=	32'b0;
								hit_status		=	3'b0;
								hash_hit			=	1'b0;
								hit_dist			=	32'b0;
							end
						end
	HASH_WRITE	:	begin
							hash_unable		=	1'b0;
							clean_cnt_en	=	1'b0;
							hash_ovalid		=	1'b0;
							hash_oaddr		=	32'b0;
							hash_hit			=	1'b0;
							hit_status		=	3'b0;
							hit_dist			=	32'b0;
						end
	WAIT			:	begin
							hash_unable		=	1'b0;
							clean_cnt_en	=	1'b0;
							hash_ovalid		=	1'b0;
							hash_oaddr		=	32'b0;
							hash_hit			=	1'b0;
							hit_status		=	3'b0;
							hit_dist			=	32'b0;
						end
	STOP			:	begin
							hash_unable		=	1'b0;
							clean_cnt_en	=	1'b0;
							hash_ovalid		=	1'b0;
							hash_oaddr		=	32'b0;
							hash_hit			=	1'b0;
							hit_status		=	3'b0;
							hit_dist			=	32'b0;
						end
	default		:	begin
							hash_unable		=	1'b0;
							clean_cnt_en	=	1'b0;
							hash_ovalid		=	1'b0;
							hash_oaddr		=	32'b0;
							hash_hit			=	1'b0;
							hit_status		=	3'b0;
							hit_dist			=	32'b0;
						end
	endcase
end

always @ (*)
begin
	case(current_state)
	IDLE			:	begin
							ram_addra		=	15'b0;
							ram_wea			=	1'b0;
							ram_dina			=	64'b0;
							ram_addrb		=	15'b0;
							ram_web			=	1'b0;
							ram_dinb			=	64'b0;
							ram_addrc		=	15'b0;
							ram_wec			=	1'b0;
							ram_dinc			=	64'b0;
							ram_addrd		=	15'b0;
							ram_wed			=	1'b0;
							ram_dind			=	64'b0;
						end
	CLEAN_TABLE	:	begin
							ram_addra		=	clean_cnt[14:0];  // write A port to initial hash ram
							ram_wea			=	1'b1;
							ram_dina			=	64'b0;
							ram_addrb		=	15'b0;
							ram_web			=	1'b0;
							ram_dinb			=	64'b0;
							ram_addrc		=	15'b0;
							ram_wec			=	1'b0;
							ram_dinc			=	64'b0;
							ram_addrd		=	15'b0;
							ram_wed			=	1'b0;
							ram_dind			=	64'b0;
						end	
	HASH_CALC	:	begin
							ram_addra		=	hash_key1;	// parralle find match
							ram_wea			=	1'b0;
							ram_dina			=	64'b0;
							ram_addrb		=	hash_key2;	
							ram_web			=	1'b0;
							ram_dinb			=	64'b0;
							ram_addrc		=	hash_key3;
							ram_wec			=	1'b0;
							ram_dinc			=	64'b0;
							ram_addrd		=	hash_key4;
							ram_wed			=	1'b0;
							ram_dind			=	64'b0;
						end	
	HASH_UPDATE	:	begin	
							ram_addra	=	hash_key1_d1;	
							ram_wea		=	hash_ivalid1_d2;
							ram_dina		=	{1'b1,hash_idata1_d1,hash_iaddr1_d1};
							ram_addrb	=	hash_key2_d1;
							ram_web		=	hash_ivalid2_d2;
							ram_dinb		=	{1'b1,hash_idata2_d1,hash_iaddr2_d1};
							ram_addrc	=	hash_key3_d1;
							ram_wec		=	hash_ivalid3_d2;
							ram_dinc		=	{1'b1,hash_idata3_d1,hash_iaddr3_d1};
							ram_addrd	=	hash_key4_d1;
							ram_wed		=	hash_ivalid4_d2;
							ram_dind		=	{1'b1,hash_idata4_d1,hash_iaddr4_d1};
						end
	HASH_WRITE	:	begin	// write A,B,C or D port to write single byte shift
							ram_addra	=	hash_key1;	
							ram_wea		=	hash_ivalid1_d1;
							ram_dina		=	{1'b1,hash_idata1_d1,hash_iaddr1_d1};
							ram_addrb	=	hash_key2;
							ram_web		=	hash_ivalid2_d1;
							ram_dinb		=	{1'b1,hash_idata2_d1,hash_iaddr2_d1};
							ram_addrc	=	hash_key3;
							ram_wec		=	hash_ivalid3_d1;
							ram_dinc		=	{1'b1,hash_idata3_d1,hash_iaddr3_d1};
							ram_addrd	=	hash_key4;
							ram_wed		=	hash_ivalid4_d1;
							ram_dind		=	{1'b1,hash_idata4_d1,hash_iaddr4_d1};
						end
	WAIT			:	begin
							ram_addra		=	15'b0;
							ram_wea			=	1'b0;
							ram_dina			=	64'b0;
							ram_addrb		=	15'b0;
							ram_web			=	1'b0;
							ram_dinb			=	64'b0;
							ram_addrc		=	15'b0;
							ram_wec			=	1'b0;
							ram_dinc			=	64'b0;
							ram_addrd		=	15'b0;
							ram_wed			=	1'b0;
							ram_dind			=	64'b0;
						end
	STOP			:	begin
							ram_addra		=	15'b0;
							ram_wea			=	1'b0;
							ram_dina			=	64'b0;
							ram_addrb		=	15'b0;
							ram_web			=	1'b0;
							ram_dinb			=	64'b0;
							ram_addrc		=	15'b0;
							ram_wec			=	1'b0;
							ram_dinc			=	64'b0;
							ram_addrd		=	15'b0;
							ram_wed			=	1'b0;
							ram_dind			=	64'b0;
						end
	default		:	begin
							ram_addra		=	15'b0;
							ram_wea			=	1'b0;
							ram_dina			=	64'b0;
							ram_addrb		=	15'b0;
							ram_web			=	1'b0;
							ram_dinb			=	64'b0;
							ram_addrc		=	15'b0;
							ram_wec			=	1'b0;
							ram_dinc			=	64'b0;
							ram_addrd		=	15'b0;
							ram_wed			=	1'b0;
							ram_dind			=	64'b0;
						end
	endcase
end



//////////////////////////////////////////////
////			  IP CORES  Module 			   ////
//////////////////////////////////////////////
// IP core 32bit absolute address and 32bit originate data
hash_4port_32Kx65bit	U_hash_ram
(
	.clk				(clk),
	.clk_2x			(clk_2x),
	.rstN				(rstN),
	.wea				(ram_wea),
	.addra			(ram_addra),
	.dina				(ram_dina),
	.web				(ram_web),
	.addrb			(ram_addrb),
	.dinb				(ram_dinb),
	.wec				(ram_wec),
	.addrc			(ram_addrc),
	.dinc				(ram_dinc),
	.wed				(ram_wed),
	.addrd			(ram_addrd),
	.dind				(ram_dind),
	
	.douta			(ram_douta),
	.doutb			(ram_doutb),
	.doutc			(ram_doutc),
	.doutd			(ram_doutd)
);

hash_match	U_hash_match
(
	// global clock and reset signal
	.clk				(clk),
	.rstN				(rstN),
	// input source data
	.hash_idata1	(hash_idata1_d1),
	.hash_iaddr1	(hash_iaddr1_d1),
	.hash_idata2	(hash_idata2_d1),
	.hash_iaddr2	(hash_iaddr2_d1),
	.hash_idata3	(hash_idata3_d1),
	.hash_iaddr3	(hash_iaddr3_d1),
	.hash_idata4	(hash_idata4_d1),
	.hash_iaddr4	(hash_iaddr4_d1),
	// input hash table outpout data    
	.hash_odata1	(hash_odata1	),
	.hash_oaddr1	(hash_oaddr1	),
	.hash_flag1		(hash_flag1		),
	.hash_odata2	(hash_odata2	),
	.hash_oaddr2	(hash_oaddr2	),
	.hash_flag2		(hash_flag2		),
	.hash_odata3	(hash_odata3	),
	.hash_oaddr3	(hash_oaddr3	),
	.hash_flag3		(hash_flag3		),
	.hash_odata4	(hash_odata4	),	
	.hash_oaddr4	(hash_oaddr4	), 
	.hash_flag4		(hash_flag4		),
	// output hash match status
	.hash_hit		(arb_hash_hit	),
	.hit_status		(arb_hit_status),
	.hash_oaddr		(arb_hash_oaddr),
	.hit_dist		(arb_hit_dist	)
);

shifter_match	U_shifter_match
(
	// global clock and reset signal
	.clk				(clk),
	.rstN				(rstN),
	// input source data
	.hash_idata1	(hash_idata1	),
	.hash_iaddr1	(hash_iaddr1	),
	.hash_ivalid1	(hash_ivalid1	),
	.hash_idata2	(hash_idata2	),
	.hash_iaddr2	(hash_iaddr2	),
	.hash_ivalid2	(hash_ivalid2	),
	.hash_idata3	(hash_idata3	),
	.hash_iaddr3	(hash_iaddr3	),
	.hash_ivalid3	(hash_ivalid3	),
	.hash_idata4	(hash_idata4	),
	.hash_iaddr4	(hash_iaddr4	),
	.hash_ivalid4	(hash_ivalid4	),
	// output hash match status
	.hash_hit		(shf_hash_hit	),
	.hit_status		(shf_hit_status),
	.hash_oaddr		(shf_hash_oaddr),
	.hit_dist		(shf_hit_dist	)
);

// hash multiplier for single Byte finding match process
hash_mul32x32 U_hash_mul1
(
  .clk	(clk), 
  .sclr	(~rstN), 
  .a		(32'h9E37_79B1), // Hash coef
  .b		(hash_idata1), 
  
  .p		(hash_temp1)
);

// hash multiplier for quad Byte matching process
hash_mul32x32 U_hash_mul2
(
  .clk	(clk), 
  .sclr	(~rstN), 
  .a		(32'h9E37_79B1), // Hash coef
  .b		(hash_idata2), 
  
  .p		(hash_temp2)
);

hash_mul32x32 U_hash_mul3
(
  .clk	(clk), 
  .sclr	(~rstN), 
  .a		(32'h9E37_79B1), // Hash coef
  .b		(hash_idata3), 
  
  .p		(hash_temp3)
);

hash_mul32x32 U_hash_mul4
(
  .clk	(clk), 
  .sclr	(~rstN), 
  .a		(32'h9E37_79B1), // Hash coef
  .b		(hash_idata4), 
  
  .p		(hash_temp4)
);

/////////////////////////////////////////////////
////			Dividual Combination Logic 		////
/////////////////////////////////////////////////
assign	hash_key1 = hash_temp1[31:17];
assign	hash_key2 = hash_temp2[31:17];
assign	hash_key3 = hash_temp3[31:17];
assign	hash_key4 = hash_temp4[31:17];

assign	hash_odata1	=	ram_douta[63:32];
assign	hash_oaddr1	=	ram_douta[31:0];
assign	hash_flag1	=	ram_douta[64];
assign	hash_odata2	=	ram_doutb[63:32];
assign	hash_oaddr2	=	ram_doutb[31:0];
assign	hash_flag2	=	ram_doutb[64];
assign	hash_odata3	=	ram_doutc[63:32];
assign	hash_oaddr3	=	ram_doutc[31:0];
assign	hash_flag3	=	ram_doutc[64];
assign	hash_odata4	=	ram_doutd[63:32];
assign	hash_oaddr4	=	ram_doutd[31:0];
assign	hash_flag4	=	ram_doutd[64];

assign	hash_ivalid	=	hash_ivalid1 | hash_ivalid2 | hash_ivalid3 | hash_ivalid4;

endmodule
