`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:50:39 04/25/2016 
// Design Name: 
// Module Name:    shifter_prefetch 
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
module shifter_prefetch(
// global clock and reset signal
input wire				clk,
input wire				rstN,
input wire				last_3dwords,
// input status signal
input wire				pref_rd,
// input fifo data
input wire	[31:0]	fifo_data,
input wire				fifo_valid,
input wire				fifo_empty,
// output read fifo signal
output wire				fifo_rd,
// output prefetch data and valid signal
output reg	[31:0]	pref_data,
output reg				pref_valid
);

reg	[31:0]	pref_data_reg;
reg				pref_valid_reg;

assign			fifo_rd	=	fifo_empty ? 1'b0 : pref_rd;

// prefetch data selection for sequence read and seperate read switch
always @ (*)
begin
	if(pref_rd & fifo_valid)
	begin
		pref_data	=	fifo_data;
	   pref_valid	=	fifo_valid;
	end
	else
	begin
		pref_data	=	pref_data_reg;
		pref_valid	=	pref_valid_reg;
	end
end

// prefetch data and valid signal output
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		pref_data_reg	<=	32'b0;
		pref_valid_reg	<=	1'b0;
	end
	else
	begin
		if(pref_rd)
		begin
			pref_data_reg	<=	32'b0;
			pref_valid_reg	<=	1'b0;
		end
		else if(fifo_valid)	//	(fifo_valid && (!fifo_empty))
		begin
			pref_data_reg	<=	fifo_data;
			pref_valid_reg	<=	1'b1;
		end
		else
		begin
			pref_data_reg	<=	pref_data;
			pref_valid_reg	<=	pref_valid;
		end
	end
end



endmodule
