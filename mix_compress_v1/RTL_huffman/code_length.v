`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:28:38 07/18/2016 
// Design Name: 
// Module Name:    code_length 
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
module code_length(
// global clock and reset
input wire				clk,
input wire				rstN,
// input 16bit VLC data
input wire	[21:0]	vlc_code,
input wire				vlc_valid,
// output 5bit code length
output reg	[4:0]		code_length
);

always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		code_length	<=	5'b0;
	end
	else
	begin
		if(vlc_valid)
			code_length	<=	vlc_code[20:16];
		else
			code_length	<=	code_length;
	end
end


/*
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		code_length	<=	5'b0;
	end
	else
	begin
		if(vlc_valid)
		begin
			casex(vlc_code)
			16'b1xxx_xxxx_xxxx_xxxx	:	code_length	<=	5'd16;
			16'b01xx_xxxx_xxxx_xxxx	:	code_length	<=	5'd15;
			16'b001x_xxxx_xxxx_xxxx	:	code_length	<=	5'd14;
			16'b0001_xxxx_xxxx_xxxx	:	code_length	<=	5'd13;
			16'b0000_1xxx_xxxx_xxxx	:	code_length	<=	5'd12;
			16'b0000_01xx_xxxx_xxxx	:	code_length	<=	5'd11;
			16'b0000_001x_xxxx_xxxx	:	code_length	<=	5'd10;
			16'b0000_0001_xxxx_xxxx	:	code_length	<=	5'd9;
			16'b0000_0000_1xxx_xxxx	:	code_length	<=	5'd8;
			16'b0000_0000_01xx_xxxx	:	code_length	<=	5'd7;
			16'b0000_0000_001x_xxxx	:	code_length	<=	5'd6;
			16'b0000_0000_0001_xxxx	:	code_length	<=	5'd5;
			16'b0000_0000_0000_1xxx	:	code_length	<=	5'd4;
			16'b0000_0000_0000_01xx	:	code_length	<=	5'd3;
			16'b0000_0000_0000_001x	:	code_length	<=	5'd2;
			16'b0000_0000_0000_0001	:	code_length	<=	5'd1;
			default						:	code_length	<=	5'd0;
			endcase
		end
		else
		begin
			code_length	<=	code_length;
		end
	end
end
*/

endmodule
