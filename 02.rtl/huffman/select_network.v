`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:12:28 08/31/2016 
// Design Name: 
// Module Name:    select_network 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: use 256 sorter unit to implement Weavesorter
//							Node frame format is:
//		(MSB)		node_number   node_weight		(LSB)
//						9bit				27bit
//		NOTICE: Input data MUST BE continuous and node number increased
//
//////////////////////////////////////////////////////////////////////////////////
module select_network#
( 
	parameter DEPTH = 256
) 
(
// clock and reset
input wire				clk,
input wire				rstN,
// frame input enable signal
input wire				net_wr,
// input node frame
input wire	[35:0]	net_in,
// output min node status
output reg	[35:0]	net_out,
output reg				net_valid
);

//////////////// FSM status ////////////////
parameter		IDLE			=	4'h0;
parameter		NET_INIT		=	4'h1;
parameter		NET_COMP		=	4'h2;
parameter		NET_OUT		=	4'h3;
parameter		DONE			=	4'h4;
////////////////////////////////////////////

// FSM signal
reg	[3:0]				current_state,next_state;
// clean node number
reg	[7:0]				clean_number;
reg						clean_en;
// initial counter
reg	[8:0]				init_cnt;
reg						init_cnt_en;
// compare counter
reg	[4:0]				level_cnt;
reg						level_cnt_en;
// processed node counter
reg	[8:0]				node_cnt;
reg						node_cnt_en;
// node frame wire
wire	[35:0]			node_frame 	[(DEPTH-1):0];
wire	[(DEPTH-1):0]	node_valid ;
// level 1 wire
wire	[35:0]			lv1_frame 		[((DEPTH/2)-1):0];
wire	[35:0]			lv1_frame_reg 	[((DEPTH/2)-1):0];
// level 2 wire
wire	[35:0]			lv2_frame 		[((DEPTH/4)-1):0];
wire	[35:0]			lv2_frame_reg 	[((DEPTH/4)-1):0];
// level 3 wire
wire	[35:0]			lv3_frame 		[((DEPTH/8)-1):0];
wire	[35:0]			lv3_frame_reg 	[((DEPTH/8)-1):0];
// level 4 wire
wire	[35:0]			lv4_frame 		[((DEPTH/16)-1):0];
wire	[35:0]			lv4_frame_reg 	[((DEPTH/16)-1):0];
// level 5 wire
wire	[35:0]			lv5_frame 		[((DEPTH/32)-1):0];
wire	[35:0]			lv5_frame_reg 	[((DEPTH/32)-1):0];
// level 6 wire
wire	[35:0]			lv6_frame 		[((DEPTH/64)-1):0];
wire	[35:0]			lv6_frame_reg 	[((DEPTH/64)-1):0];
// level 7 wire
wire	[35:0]			lv7_frame 		[((DEPTH/128)-1):0];
wire	[35:0]			lv7_frame_reg 	[((DEPTH/128)-1):0];
// level 8 wire
wire	[35:0]			lv8_min;
wire	[35:0]			lv8_min_reg;

/////////////////////////////////////////////////
////			Dividual Combination Logic 		////
/////////////////////////////////////////////////


/////////////////////////////////////////////////
////				 Sequential Logic 				////
/////////////////////////////////////////////////
// FSM main process
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
		init_cnt	<=	9'b0;
	end
	else
	begin
		if(net_valid)
			init_cnt	<=	9'b0;
		else if(init_cnt_en)
			init_cnt	<=	init_cnt + 1'b1;
		else
			init_cnt	<=	init_cnt;
	end
end

// compare counter
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		level_cnt	<=	5'b0;
	end
	else
	begin
		if(net_valid)
			level_cnt	<=	5'b0;
		else if(level_cnt_en)
			level_cnt	<=	level_cnt + 1'b1;
		else
			level_cnt	<=	level_cnt;
	end
end

// processed node counter
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		node_cnt	<=	9'b0;
	end
	else
	begin
		if(net_wr)
			node_cnt	<=	9'b0;
		else if(node_cnt_en)
			node_cnt	<=	node_cnt + 1'b1;
		else
			node_cnt	<=	node_cnt;
	end
end

/////////////////////////////////////////////////
////				Combination Logic 				////
/////////////////////////////////////////////////
// FSM state transfer
always @ (*)
begin
	case(current_state)
	IDLE			:	begin
							if(net_wr)
								next_state	=	NET_INIT;
							else
								next_state	=	IDLE;
						end	
	NET_INIT		:	begin
							if(init_cnt < 9'h100)
								next_state	=	NET_INIT;
							else
								next_state	=	NET_COMP;
						end
	NET_COMP		:	begin
							if(level_cnt < 5'h6)
								next_state	=	NET_COMP;
							else
								next_state	=	NET_OUT;
						end
	NET_OUT		:	begin
							if(node_cnt < 9'h100)
								next_state	=	NET_COMP;
							else
								next_state	=	DONE;
						end
	DONE			:	begin
							if(net_wr)
								next_state	=	NET_INIT;
							else
								next_state	=	DONE;
						end
	default		:	begin
							next_state	=	IDLE;
						end
	endcase
end

// FSM control signal
always @ (*)
begin
	case(current_state)
	IDLE			:	begin
							if(net_wr)
								init_cnt_en	=	1'b1;
							else
								init_cnt_en	=	1'b0;
							level_cnt_en	=	1'b0;
							node_cnt_en		=	1'b0;
							clean_number	=	8'b0;
							clean_en			=	1'b0;
							net_out			=	36'b0;
							net_valid		=	1'b0;
						end	
	NET_INIT		:	begin
							if(net_wr)
								init_cnt_en	=	1'b1;
							else
								init_cnt_en	=	1'b0;
							level_cnt_en	=	1'b0;
							node_cnt_en		=	1'b0;
							clean_number	=	8'b0;
							clean_en			=	1'b0;
							net_out			=	36'b0;
							net_valid		=	1'b0;
						end
	NET_COMP		:	begin
							init_cnt_en		=	1'b0;
							level_cnt_en	=	1'b1;
							node_cnt_en		=	1'b0;
							if(level_cnt < 5'h6)
							begin
								clean_number	=	8'b0;
								clean_en			=	1'b0;
							end
							else
							begin
								clean_number	=	lv8_min[34:27];
								clean_en			=	1'b1;
							end
							net_out			=	36'b0;
							net_valid		=	1'b0;
						end
	NET_OUT		:	begin
							init_cnt_en		=	1'b0;
							level_cnt_en	=	1'b0;
							node_cnt_en		=	1'b1;
							clean_number	=	8'b0;
							clean_en			=	1'b0;
							net_out		   =	lv8_min_reg;
							net_valid		=	1'b1;
						end
	DONE			:	begin
							init_cnt_en		=	1'b0;
							level_cnt_en	=	1'b0;
							node_cnt_en		=	1'b0;
							clean_number	=	8'b0;
							clean_en			=	1'b0;
							net_out			=	36'b0;
							net_valid		=	1'b0;
						end
	default		:	begin
							init_cnt_en		=	1'b0;
							level_cnt_en	=	1'b0;
							node_cnt_en		=	1'b0;
							clean_number	=	8'b0;
							clean_en			=	1'b0;
							net_out			=	36'b0;
							net_valid		=	1'b0;
						end
	endcase
end


/////////////////////////////////////////////////
////					Sub Modules						////
/////////////////////////////////////////////////
// 256 node store units array NUs
node_unit #
(
	.UNIT_NUMBER(0)
)
NU_1st
(
	.clk			(clk),
	.rstN			(rstN),
	.clean		(clean_number),
	.clean_en	(clean_en),
	.node_in		(net_in),
	.node_wr		(net_wr),
	.node_out	(node_frame[0]),
	.node_valid	(node_valid[0])
);

genvar i;
generate
	for(i=1;i<DEPTH;i=i+1)
	begin:node_units
		node_unit #
		(
			.UNIT_NUMBER(i)
		)
		NU
		(
			.clk			(clk),
			.rstN			(rstN),
			.clean		(clean_number),
			.clean_en	(clean_en),
			.node_in		(node_frame[i-1]),
			.node_wr		(node_valid[i-1]),
			.node_out	(node_frame[i]),
			.node_valid	(node_valid[i])
		);
	end
endgenerate

// LEVEL 1 CUs  DEPTH/2
generate
	for(i=0;i<DEPTH;i=i+2)
	begin:lv1_net_units
		compare_unit 	CU_lv1
		(
			.A			(node_frame[i]),
			.B			(node_frame[i+1]),
			.MIN		(lv1_frame[i/2])
		);
		dff_array	DFF_lv1
		(
			.clk		(clk),
			.rstN		(rstN),
			.D			(lv1_frame[i/2]),
			.Q			(lv1_frame_reg[i/2])
		);
	end
endgenerate

// LEVEL 2 CUs  DEPTH/4
generate
	for(i=0;i<(DEPTH/2);i=i+2)
	begin:lv2_net_units
		compare_unit 	CU_lv2
		(
			.A			(lv1_frame_reg[i]),
			.B			(lv1_frame_reg[i+1]),
			.MIN		(lv2_frame[i/2])
		);
		dff_array	DFF_lv2
		(
			.clk		(clk),
			.rstN		(rstN),
			.D			(lv2_frame[i/2]),
			.Q			(lv2_frame_reg[i/2])
		);
	end
endgenerate

// LEVEL 3 CUs  DEPTH/8
generate
	for(i=0;i<(DEPTH/4);i=i+2)
	begin:lv3_net_units
		compare_unit 	CU_lv3
		(
			.A			(lv2_frame_reg[i]),
			.B			(lv2_frame_reg[i+1]),
			.MIN		(lv3_frame[i/2])
		);
		dff_array	DFF_lv3
		(
			.clk		(clk),
			.rstN		(rstN),
			.D			(lv3_frame[i/2]),
			.Q			(lv3_frame_reg[i/2])
		);
	end
endgenerate

// LEVEL 4 CUs  DEPTH/16
generate
	for(i=0;i<(DEPTH/8);i=i+2)
	begin:lv4_net_units
		compare_unit 	CU_lv4
		(
			.A			(lv3_frame_reg[i]),
			.B			(lv3_frame_reg[i+1]),
			.MIN		(lv4_frame[i/2])
		);
		dff_array	DFF_lv4
		(
			.clk		(clk),
			.rstN		(rstN),
			.D			(lv4_frame[i/2]),
			.Q			(lv4_frame_reg[i/2])
		);
	end
endgenerate

// LEVEL 5 CUs  DEPTH/32
generate
	for(i=0;i<(DEPTH/16);i=i+2)
	begin:lv5_net_units
		compare_unit 	CU_lv5
		(
			.A			(lv4_frame_reg[i]),
			.B			(lv4_frame_reg[i+1]),
			.MIN		(lv5_frame[i/2])
		);
		dff_array	DFF_lv5
		(
			.clk		(clk),
			.rstN		(rstN),
			.D			(lv5_frame[i/2]),
			.Q			(lv5_frame_reg[i/2])
		);
	end
endgenerate

// LEVEL 6 CUs  DEPTH/64
generate
	for(i=0;i<(DEPTH/32);i=i+2)
	begin:lv6_net_units
		compare_unit 	CU_lv6
		(
			.A			(lv5_frame_reg[i]),
			.B			(lv5_frame_reg[i+1]),
			.MIN		(lv6_frame[i/2])
		);
		dff_array	DFF_lv6
		(
			.clk		(clk),
			.rstN		(rstN),
			.D			(lv6_frame[i/2]),
			.Q			(lv6_frame_reg[i/2])
		);
	end
endgenerate

// LEVEL 7 CUs  DEPTH/128
generate
	for(i=0;i<(DEPTH/64);i=i+2)
	begin:lv7_net_units
		compare_unit 	CU_lv7
		(
			.A			(lv6_frame_reg[i]),
			.B			(lv6_frame_reg[i+1]),
			.MIN		(lv7_frame[i/2])
		);
		dff_array	DFF_lv7
		(
			.clk		(clk),
			.rstN		(rstN),
			.D			(lv7_frame[i/2]),
			.Q			(lv7_frame_reg[i/2])
		);
	end
endgenerate

// LEVEL 8 CUs  DEPTH/256
compare_unit 	CU_lv8
(
	.A			(lv7_frame_reg[0]),
	.B			(lv7_frame_reg[1]),
	.MIN		(lv8_min)
);

dff_array	DFF_lv8
(
	.clk		(clk),
	.rstN		(rstN),
	.D			(lv8_min),
	.Q			(lv8_min_reg)
);



endmodule
