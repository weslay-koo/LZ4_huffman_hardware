`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:56:24 08/31/2016 
// Design Name: 
// Module Name:    compare_unit 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: combination only
//								output MIN frame of node
//
//////////////////////////////////////////////////////////////////////////////////
module compare_unit(
input wire	[35:0]	A,
input wire	[35:0]	B,
output reg	[35:0]	MIN
);

always @ (*)
begin
	if(A[26:0] > B[26:0])
		MIN = B;
	else if(A[26:0] < B[26:0])
		MIN = A;
	else
	begin
		if(A[35:27] > B[35:27])
			MIN = B;
		else
			MIN = A;
	end
end

endmodule
