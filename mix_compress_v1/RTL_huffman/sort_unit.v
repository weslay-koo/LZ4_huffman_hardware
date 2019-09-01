`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:43:11 09/01/2016 
// Design Name: 
// Module Name:    sort_unit 
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
//								output MAX and MIN frame of node
//
//////////////////////////////////////////////////////////////////////////////////
module sort_unit(
input wire	[35:0]	A,
input wire	[35:0]	B,
output reg	[35:0]	MAX,
output reg	[35:0]	MIN
);

always @ (*)
begin
	if(A[26:0] > B[26:0])
	begin
		MAX	=	A;
		MIN 	= 	B;
	end
	else if(A[26:0] < B[26:0])
	begin
		MAX	=	B;
		MIN 	= 	A;
	end
	else
	begin
		if(A[35:27] > B[35:27])
		begin
			MAX	=	A;
			MIN 	= 	B;
		end
		else
		begin
			MAX	=	B;
			MIN 	= 	A;
		end
	end
end

endmodule
