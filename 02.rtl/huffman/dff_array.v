`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:18:51 08/31/2016 
// Design Name: 
// Module Name:    dff_array 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 36 DFFs
//
//////////////////////////////////////////////////////////////////////////////////
module dff_array(
// clock and reset
input wire				clk,
input wire				rstN,
// input D port
input	wire	[35:0]	D,
// output Q port
output reg	[35:0]	Q
);

always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		Q	<=	36'b0;
	end
	else
	begin
		Q	<=	D;
	end
end

endmodule
