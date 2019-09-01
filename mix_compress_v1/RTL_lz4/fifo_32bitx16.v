`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:23:19 02/29/2016 
// Design Name: 
// Module Name:    fifo_32bitx16 
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
module fifo_32bitx16(
input wire				clk,
input wire				rstN,
input wire	[31:0] 	din,
input wire				byte_dwordN,
input wire				wr_en,
input wire				rd_en,
output wire	[31:0] 	dout,
output wire				empty,
output wire				valid,
output reg	[5:0]		byte_count
);

reg	[511:0]	shifter;

/////////////////////////////////////////////////
////			Dividual Combination Logic 		////
/////////////////////////////////////////////////

assign		dout	=	shifter[511:480];
assign		empty	=	(byte_count>6'b0) ? 1'b0 :	1'b1;
assign		valid	=	valid;

/////////////////////////////////////////////////
////				 Sequential Logic 				////
/////////////////////////////////////////////////
// shifter main logic
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		shifter		<=	512'b0;
		byte_count	<=	6'b0;
	end
	else
	begin
		if(rd_en)
		begin
			if(byte_dwordN)
			begin
				shifter		<=	{shifter[503:0],8'b0};
				byte_count	<=	byte_count - 6'h1;
			end
			else
			begin
				shifter		<=	{shifter[479:0],32'b0};
				byte_count	<=	byte_count - 6'h4;
			end
		end
		else if(wr_en)
		begin
			shifter		<=	{shifter[511:480],din}; // fifo function can not be implemented
			byte_count	<=	byte_count + 6'h4;
		end
		else
		begin
			shifter		<=	shifter;		
			byte_count	<=	byte_count;	
		end
	end
end

/////////////////////////////////////////////////
////				Combination Logic 			   ////
/////////////////////////////////////////////////

// none

endmodule
