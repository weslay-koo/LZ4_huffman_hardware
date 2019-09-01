`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:16:05 06/08/2016 
// Design Name: 
// Module Name:    tree_down_traversal 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: Tree downward traversal for update all child nodes of current node
//
//        17bit Frame in Link RAM is
// (MSB)	Node_exist	 left_child		right_child(LSB)
// 			1bit			10bit				10bit
//////////////////////////////////////////////////////////////////////////////////
module tree_down_traversal(
// global clock and reset
input wire				clk,
input wire				rstN,
// control and status signal
output reg				trav_done,
// root node input
input wire	[9:0]		root_number,
input wire				root_number_valid,
// iteratively output child node
output wire	[7:0]		leaf_number,
output wire				leaf_number_valid
);

//////////////// FSM status ////////////////
parameter		IDLE			=	4'h0;
parameter		ROOT_INPUT	=	4'h1;
parameter		LEAF_SEEK	=	4'h2;
parameter		LEAF_UPDATE	=	4'h3;
parameter		TRAV_DONE	=	4'h4;
////////////////////////////////////////////

// FSM signal
reg	[3:0]		current_state,next_state;
// Link RAM signal
reg				link_wea,link_web;
reg	[20:0]	link_dina,link_dinb;
reg	[20:0]	link_douta,link_doutb;
reg	[7:0]		link_addra,link_addrb;

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


/////////////////////////////////////////////////
////				Combination Logic 				////
/////////////////////////////////////////////////
// FSM state transfer
always @ (*)
begin
	case(current_state)
	IDLE			:	begin
							if(root_number_valid)
								next_state	=	ROOT_INPUT;	
							else
								next_state	=	IDLE;
						end
   ROOT_INPUT	:	begin
							next_state	=	LEAF_SEEK;
						end
   LEAF_SEEK	:	begin
							if(leaf_valid)
								next_state	=	LEAF_UPDATE;
							else
								next_state	=	LEAF_SEEK;
						end
   LEAF_UPDATE	:	begin
							if(all_leaf_done)
								next_state	=	TRAV_DONE;
							else
								next_state	=	LEAF_SEEK;
						end
   TRAV_DONE	:	begin
							next_state	=	IDLE;
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
							
						end
   ROOT_INPUT	:	begin
							
						end
   LEAF_SEEK	:	begin
							
						end
   LEAF_UPDATE	:	begin
							
						end
   TRAV_DONE	:	begin
							
						end
	default		:	begin
							
						end
	endcase
end

/////////////////////////////////////////////////
////					Sub Modules						////
/////////////////////////////////////////////////
// RAM 256x21bit for leaf and root connective nodes
ram_256x21bit	U_link_ram
(
  .clka			(clk),
  .wea			(link_wea),
  .addra			(link_addra),
  .dina			(link_dina),
  .clkb			(clk),
  .web			(link_web),
  .addrb			(link_addrb),
  .dinb			(link_dinb),
  
  .douta			(link_douta),
  .doutb			(link_doutb)
);

endmodule
