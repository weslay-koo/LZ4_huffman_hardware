`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:56:29 02/25/2016 
// Design Name: 
// Module Name:    shifter_96bit 
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
module shifter_96bit(
// clock and reset
input wire				clk,
input wire				rstN,
// 32bit data input
input wire	[31:0]	in_data,
input wire	[2:0]		in_shift,  // to point out the bytes of shifter move left
input wire				shift_valid,
input wire				data_valid,
input	wire				load_done,
output reg				in_req,
output reg				in_stb,
output reg	[3:0]		shift_remind,
// 32bit data output
output wire	[31:0]	out_data,  // always the top 32bit of the 96bit shift reg
output wire	[2:0]		out_mask,  // to point out the how many bytes are valid in output data
output wire				out_empty
);

// shift register
reg	[95:0]	shifter;
//reg	[3:0]		shift_remind;

/////////////////////////////////////////////////
////			Dividual Combination Logic 		////
/////////////////////////////////////////////////
// data glue logic
function	[95:0]	GLUE;
	input	[95:0]	src;
	input [31:0]	update;
	input	[3:0]		shift_remind;
	case(shift_remind)
	4'h0		:	GLUE	=	{update,64'b0};
	4'h1		:	GLUE	=	{src[95:88],update,56'b0};
	4'h2		:	GLUE	=	{src[95:80],update,48'b0};
	4'h3		:	GLUE	=	{src[95:72],update,40'b0};
	4'h4		:	GLUE	=	{src[95:64],update,32'b0};				
	4'h5		:	GLUE	=	{src[95:56],update,24'b0};				
	4'h6		:	GLUE	=	{src[95:48],update,16'b0};				
	4'h7		:	GLUE	=	{src[95:40],update,8'b0};				
	4'h8		:	GLUE	=	{src[95:32],update};					
	default	:	GLUE	=	src;
	endcase
endfunction

// output data
assign		out_data	=	shifter[95:64];
assign		out_mask	=	shift_remind[2:0];
// out empty signal
assign		out_empty	=	(shift_remind > 4'h0) ? 1'b0 : 1'b1;

/////////////////////////////////////////////////
////				 Sequential Logic 				////
/////////////////////////////////////////////////
// main logic of shifter
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		shifter			<=	96'b0;
		shift_remind	<=	4'b0;
	end
	else
	begin
		case({data_valid,shift_valid})
		2'b00	:	begin
						shifter			<=	shifter;
						shift_remind	<=	shift_remind;
					end
		2'b01	:	begin  // only shift
						case(in_shift)
						3'h1		:	begin
											shifter			<=	{shifter[87:0],8'b0};
											shift_remind	<=	shift_remind - 4'h1;
										end
						3'h2		:	begin
											shifter			<=	{shifter[79:0],16'b0};
											shift_remind	<=	shift_remind - 4'h2;
										end
						3'h3		:	begin
											shifter			<=	{shifter[71:0],24'b0};
											shift_remind	<=	shift_remind - 4'h3;
										end
						3'h4		:	begin
											shifter			<=	{shifter[63:0],32'b0};
											shift_remind	<=	shift_remind - 4'h4;
										end
						default	:	begin
											shifter			<=	shifter;
											shift_remind	<=	shift_remind ;
										end
						endcase
					end
		2'b10	:	begin  // only data load
						shift_remind	<=	shift_remind + 4'h4;
						shifter			<=	GLUE(shifter,in_data,shift_remind);
					end
		2'b11	:	begin  // shift and load
						case(in_shift)
						3'h0		:	begin
											shifter			<=	GLUE(shifter,in_data,shift_remind);
											shift_remind	<=	shift_remind + 4'h4;
										end
						3'h1		:	begin
											shifter			<=	GLUE({shifter[87:0],8'b0},in_data,shift_remind-4'h1);
											shift_remind	<=	shift_remind + 4'h3;
										end
						3'h2		:	begin
											shifter			<=	GLUE({shifter[79:0],16'b0},in_data,shift_remind-4'h2);
											shift_remind	<=	shift_remind + 4'h2;
										end
						3'h3		:	begin
											shifter			<=	GLUE({shifter[71:0],24'b0},in_data,shift_remind-4'h3);
											shift_remind	<=	shift_remind + 4'h1;
										end
						3'h4		:	begin
											shifter			<=	GLUE({shifter[63:0],32'b0},in_data,shift_remind-4'h4);
											shift_remind	<=	shift_remind;
										end
						default	:	begin
											shifter			<=	shifter;
											shift_remind	<=	shift_remind ;
										end
						endcase
					end
		default:	begin
						shift_remind	<=	shift_remind;					
						shifter			<=	shifter;
					end
		endcase
	end
end


//////////////////////////////////////////////
////				Combination Logic 			////
//////////////////////////////////////////////
// in_req signal generation
always @ (*)
begin
	if((shift_remind <= 4'h8)&&(!load_done))
		in_req	=	1'b1;
	else
		in_req	=	1'b0;
		
	if(shift_remind <= 4'h6)
		in_stb	=	1'b1;
	else if((shift_remind <= 4'hA)&&load_done)
		in_stb	=	1'b1;
	else
		in_stb	=	1'b0;	
		
//	if(({1'b0,match_mask} + shift_remind) > 4'hC)
//		load_en	=	1'b0;
//	else
//		load_en	=	1'b1;
//	if(match_mask == 3'b100)
//		load_en	=	1'b1;
//	else
//		load_en	=	1'b0;
end

//////////////////////////////////////////////
////			  IP CORES  Module 			   ////
//////////////////////////////////////////////
// None

endmodule