`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:46:26 03/03/2016 
// Design Name: 
// Module Name:    hash_table_v2 
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
module hash_table_v2(
// clk and rst
input wire				clk,
input wire				rstN,
input wire				hash_clean,
input wire				hash_wr_only,
input wire	[2:0]		match_mask,
output reg				hash_unable,
// external unmatched data 4 byte input 
input wire	[31:0]	hash_idata,
input wire	[31:0]	hash_iaddr,  // first char address (64KB range)
input wire				hash_ivalid,  // single pulse signal with valid data input
// external dictionary data 4 byte input 
output reg				hash_hit,
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
reg	[31:0]	hash_idata_d1,hash_idata_d2,hash_iaddr_d1,hash_iaddr_d2;	
wire	[14:0]	hash_key1,hash_key2,hash_key3,hash_key4;
reg	[14:0]	hash_key1_d1,hash_key2_d1,hash_key3_d1,hash_key4_d1;
wire	[63:0]	hash_temp1,hash_temp2,hash_temp3,hash_temp4;
// data match judgement
wire	[31:0]	hash_odata1,hash_odata2;
wire	[31:0]	hash_oaddr1,hash_oaddr2;
wire				hash_flag1,hash_flag2;
// all byte update to hash
reg				prev_mask_clr;
reg	[2:0]		prev_match_mask;
reg	[1:0]		match_remand;	// to indicate the number of previous match data didn't update to hash
wire	[7:0]		mul2_data_sel;
wire	[15:0]	mul3_data_sel;

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
		hash_idata_d2	<=	32'b0;
		hash_idata_d1	<=	32'b0;
		hash_iaddr_d2	<=	32'b0;
		hash_iaddr_d1	<=	32'b0;
	end
	else
	begin
		if(hash_ivalid)
		begin
			hash_idata_d2	<=	hash_idata_d1;
			hash_idata_d1	<=	hash_idata;	
			hash_iaddr_d2	<=	hash_iaddr_d1;
			hash_iaddr_d1	<=	hash_iaddr;
		end
		else
		begin
			hash_idata_d2	<=	hash_idata_d2;
			hash_idata_d1	<=	hash_idata_d1;	
			hash_iaddr_d2	<=	hash_iaddr_d2;
		   hash_iaddr_d1	<=	hash_iaddr_d1;	
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

//	match mask and match data signal delay
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		prev_match_mask	<=	3'b0;
	end
	else
	begin
		if(prev_mask_clr)
			prev_match_mask	<=	3'b0;	
		else if(hash_wr_only)
			prev_match_mask	<=	match_mask;
		else
			prev_match_mask	<=	prev_match_mask;
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
							hash_hit			=	1'b0;
							hash_ovalid		=	1'b0;
							hash_oaddr		=	32'b0;
							match_remand	=	2'b0;
							prev_mask_clr	=	1'b0;
						end
	CLEAN_TABLE	:	begin
							hash_unable		=	1'b1;
							clean_cnt_en	=	1'b1;
							hash_hit			=	1'b0;
							hash_ovalid		=	1'b0;
							hash_oaddr		=	32'b0;
							match_remand	=	2'b0;
							prev_mask_clr	=	1'b0;
						end	
	HASH_CALC	:	begin
							hash_unable		=	1'b0;
							clean_cnt_en	=	1'b0;
							hash_ovalid		=	1'b0;
							hash_oaddr		=	32'b0;
							hash_hit			=	1'b0;
							match_remand	=	prev_match_mask[1:0];
							prev_mask_clr	=	1'b0;
						end	
	HASH_UPDATE	:	begin
							hash_unable		=	1'b0;
							clean_cnt_en	=	1'b0;
							hash_ovalid		=	1'b1;
							match_remand	=	2'b0;
							prev_mask_clr	=	1'b1;
							if(	((hash_odata1==hash_idata_d1) && hash_flag1)
								&&	((hash_odata2==hash_idata_d1)	&& hash_flag2)	)  
							begin		//  Could be optimous for LAZY MATCH
								hash_hit		=	1'b1;
								if(hash_oaddr1 > hash_oaddr2)
									hash_oaddr	=	hash_oaddr1;
								else
									hash_oaddr	=	hash_oaddr2;
							end
							else if((hash_odata1 == hash_idata_d1)	&& hash_flag1)
							begin
								hash_oaddr	=	hash_oaddr1;
								hash_hit		=	1'b1;
							end
							else if((hash_odata2 == hash_idata_d1)	&& hash_flag2)
							begin
								hash_oaddr	=	hash_oaddr2;
								hash_hit		=	1'b1;
							end
							else
							begin
								hash_oaddr	=	32'b0;
								hash_hit		=	1'b0;
							end
						end
	HASH_WRITE	:	begin
							hash_unable		=	1'b0;
							clean_cnt_en	=	1'b0;
							hash_hit			=	1'b0;
							hash_ovalid		=	1'b0;
							hash_oaddr		=	32'b0;
							match_remand	=	2'b0;
							prev_mask_clr	=	1'b0;
						end
	WAIT			:	begin
							hash_unable		=	1'b0;
							clean_cnt_en	=	1'b0;
							hash_hit			=	1'b0;
							hash_ovalid		=	1'b0;
							hash_oaddr		=	32'b0;
							match_remand	=	2'b0;
							prev_mask_clr	=	1'b0;
						end
	STOP			:	begin
							hash_unable		=	1'b0;
							clean_cnt_en	=	1'b0;
							hash_hit			=	1'b0;
							hash_ovalid		=	1'b0;
							hash_oaddr		=	32'b0;
							match_remand	=	2'b0;
							prev_mask_clr	=	1'b0;
						end
	default		:	begin
							hash_unable		=	1'b0;
							clean_cnt_en	=	1'b0;
							hash_hit			=	1'b0;
							hash_ovalid		=	1'b0;
							hash_oaddr		=	32'b0;
							match_remand	=	2'b0;
							prev_mask_clr	=	1'b0;
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
							ram_addra		=	clean_cnt[14:0];  // write A port and C port to initial hash ram
							ram_wea			=	1'b1;
							ram_dina			=	64'b0;
							ram_addrb		=	15'b0;
							ram_web			=	1'b0;
							ram_dinb			=	64'b0;
							ram_addrc		=	clean_cnt[14:0];
							ram_wec			=	1'b1;
							ram_dinc			=	64'b0;
							ram_addrd		=	15'b0;
							ram_wed			=	1'b0;
							ram_dind			=	64'b0;
						end	
	HASH_CALC	:	begin
							ram_addra		=	15'b0;
							ram_wea			=	1'b0;
							ram_dina			=	64'b0;
							ram_addrb		=	hash_key1;	// read B port and D port to find hash match
							ram_web			=	1'b0;
							ram_dinb			=	64'b0;
							ram_addrc		=	15'b0;
							ram_wec			=	1'b0;
							ram_dinc			=	64'b0;
							ram_addrd		=	hash_key1;
							ram_wed			=	1'b0;
							ram_dind			=	64'b0;
						end	
	HASH_UPDATE	:	begin	
							if(prev_match_mask <= 3'h1)	// write A port and C port to write single byte shift
							begin
								ram_addra	=	hash_key1_d1;	
								ram_wea		=	1'b1;
								ram_dina		=	{1'b1,hash_idata_d1,hash_iaddr_d1};
								ram_addrb	=	15'b0;
								ram_web		=	1'b0;
								ram_dinb		=	64'b0;
								ram_addrc	=	hash_key1_d1;
								ram_wec		=	1'b1;
								ram_dinc		=	{1'b1,hash_idata_d1,hash_iaddr_d1};
								ram_addrd	=	15'b0;
								ram_wed		=	1'b0;
								ram_dind		=	64'b0;
							end
							else if(prev_match_mask == 3'h2)	// write A, B, C and D port to write 2 bytes shift
							begin
								ram_addra	=	hash_key1_d1;	
								ram_wea		=	1'b1;
								ram_dina		=	{1'b1,hash_idata_d1,hash_iaddr_d1};
								ram_addrb	=	hash_key2_d1;
								ram_web		=	1'b1;
								ram_dinb		=	{1'b1,hash_idata_d2[23:0],hash_idata_d1[15:8],(hash_iaddr_d1-3'h1)};
								ram_addrc	=	hash_key1_d1;
								ram_wec		=	1'b1;
								ram_dinc		=	{1'b1,hash_idata_d1,hash_iaddr_d1};
								ram_addrd	=	hash_key2_d1;
								ram_wed		=	1'b1;
								ram_dind		=	{1'b1,hash_idata_d2[23:0],hash_idata_d1[15:8],(hash_iaddr_d1-3'h1)};
							end
							else if(prev_match_mask == 3'h3)	// write A, B, C and D port to write 3 bytes shift
							begin
								ram_addra	=	hash_key1_d1;	
								ram_wea		=	1'b1;
								ram_dina		=	{1'b1,hash_idata_d1,hash_iaddr_d1};
								ram_addrb	=	hash_key2_d1;
								ram_web		=	1'b1;
								ram_dinb		=	{1'b1,hash_idata_d2[23:0],hash_idata_d1[23:16],(hash_iaddr_d1-3'h2)};
								ram_addrc	=	hash_key1_d1;
								ram_wec		=	1'b1;
								ram_dinc		=	{1'b1,hash_idata_d1,hash_iaddr_d1};
								ram_addrd	=	hash_key3_d1;
								ram_wed		=	1'b1;
								ram_dind		=	{1'b1,hash_idata_d2[15:0],hash_idata_d1[23:8],(hash_iaddr_d1-3'h1)};
							end
							else
							begin
								ram_addra	=	hash_key1_d1;	
								ram_wea		=	1'b1;
								ram_dina		=	{1'b1,hash_idata_d1,hash_iaddr_d1};
								ram_addrd	=	hash_key4_d1;
								ram_wed		=	1'b1;
								ram_dind		=	{1'b1,hash_idata_d2[7:0],hash_idata_d1[31:8],(hash_iaddr_d1-3'h1)};
								ram_addrc	=	hash_key3_d1;
								ram_wec		=	1'b1;
								ram_dinc		=	{1'b1,hash_idata_d2[15:0],hash_idata_d1[31:16],(hash_iaddr_d1-3'h2)};
								ram_addrb	=	hash_key2_d1;
								ram_web		=	1'b1;
								ram_dinb		=	{1'b1,hash_idata_d2[23:0],hash_idata_d1[31:24],(hash_iaddr_d1-3'h3)};
							end
						end
	HASH_WRITE	:	begin	// write A,B,C and D port to write single byte shift
							ram_addra	=	hash_key1;	
							ram_wea		=	1'b1;
							ram_dina		=	{1'b1,hash_idata_d1,(hash_iaddr_d2+3'h4)};
							ram_addrd	=	hash_key4;
							ram_wed		=	1'b1;
							ram_dind		=	{1'b1,hash_idata_d2[7:0],hash_idata_d1[31:8],(hash_iaddr_d2+3'h3)};
							ram_addrc	=	hash_key3;
							ram_wec		=	1'b1;
							ram_dinc		=	{1'b1,hash_idata_d2[15:0],hash_idata_d1[31:16],(hash_iaddr_d2+3'h2)};
							ram_addrb	=	hash_key2;
							ram_web		=	1'b1;
							ram_dinb		=	{1'b1,hash_idata_d2[23:0],hash_idata_d1[31:24],(hash_iaddr_d2+3'h1)};
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
//hash_ram_32Kx64bit	U_hash_ram
//(
//  .clka			(clk),
//  .wea			(hash_ram_wea),
//  .addra			(hash_ram_waddr),
//  .dina			(hash_ram_din),
//  .clkb			(clk),
//  .web			(1'b0),
//  .addrb			(hash_ram_raddr),
//  .dinb			(64'b0),
//  
//  .douta			(),
//  .doutb			({hash_odata,hash_oaddr})
//);
hash_4port_32Kx65bit	U_hash_ram
(
	.clk				(clk),
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


// hash multiplier for single Byte finding match process
hash_mul32x32 U_hash_mul1
(
  .clk	(clk), 
  .sclr	(~rstN), 
  .a		(32'h9E37_79B1), // Hash coef
  .b		(hash_idata), 
  
  .p		(hash_temp1)
);

// hash multiplier for quad Byte matching process
hash_mul32x32 U_hash_mul2
(
  .clk	(clk), 
  .sclr	(~rstN), 
  .a		(32'h9E37_79B1), // Hash coef
  .b		({hash_idata_d1[23:0],mul2_data_sel}), 
  
  .p		(hash_temp2)
);

hash_mul32x32 U_hash_mul3
(
  .clk	(clk), 
  .sclr	(~rstN), 
  .a		(32'h9E37_79B1), // Hash coef
  .b		({hash_idata_d1[15:0],mul3_data_sel}), 
  
  .p		(hash_temp3)
);

hash_mul32x32 U_hash_mul4
(
  .clk	(clk), 
  .sclr	(~rstN), 
  .a		(32'h9E37_79B1), // Hash coef
  .b		({hash_idata_d1[7:0],hash_idata[31:8]}), 
  
  .p		(hash_temp4)
);

/////////////////////////////////////////////////
////			Dividual Combination Logic 		////
/////////////////////////////////////////////////
assign	hash_key1 = hash_temp1[31:17];
assign	hash_key2 = hash_temp2[31:17];
assign	hash_key3 = hash_temp3[31:17];
assign	hash_key4 = hash_temp4[31:17];

assign	hash_odata1	=	ram_doutb[63:32];
assign	hash_oaddr1	=	ram_doutb[31:0];
assign	hash_flag1	=	ram_doutb[64];
assign	hash_odata2	=	ram_doutd[63:32];
assign	hash_oaddr2	=	ram_doutd[31:0];
assign	hash_flag2	=	ram_doutd[64];
assign	mul2_data_sel	=	match_remand[1] ? (match_remand[0] ? hash_idata[23:16] : hash_idata[15:8]) : hash_idata[31:24];
assign	mul3_data_sel	=	match_remand[1] ? hash_idata[23:8] : hash_idata[31:16];

endmodule
