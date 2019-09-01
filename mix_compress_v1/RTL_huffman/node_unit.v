`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:31:15 08/31/2016 
// Design Name: 
// Module Name:    node_unit 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: Store element for node
//
//////////////////////////////////////////////////////////////////////////////////
module node_unit#
(
	parameter	UNIT_NUMBER = 8'h00
)
(
// clock and reset
input wire				clk,
input wire				rstN,
// input clean signal for node has been output
input wire	[7:0]		clean,
input wire				clean_en,
// input node frame
input wire	[35:0]	node_in,
input wire				node_wr,
// output min node status
output reg	[35:0]	node_out,
output wire				node_valid
);

assign		node_valid	=	node_wr;

always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		node_out		<=	36'b0;
		//node_valid	<=	1'b0;
	end
	else
	begin
		if(node_wr)
		begin
			node_out		<=	node_in;
			//node_valid	<=	1'b1;
		end
		else if(clean_en && (clean == UNIT_NUMBER))
		begin
			node_out		<=	36'hF_FFFF_FFFF;
			//node_valid	<=	1'b0;
		end
		else
		begin
			node_out		<=	node_out;
			//node_valid	<=	1'b0;
		end
	end
end

endmodule
