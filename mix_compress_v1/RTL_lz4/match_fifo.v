`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:41:12 09/15/2015 
// Design Name: 
// Module Name:    match_fifo 
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
module match_fifo(
// clk and rst
input	wire				clk,
input wire				rstN,  
input wire				data_terminal,
input wire				start_compress,
//	fifo signal
input wire				rd_req,
input wire				wr_req,
input wire	[31:0]	idata,
output wire	[31:0]	odata,
output wire				odata_valid,
// status signal
output wire				empty,
output wire				full,
output reg				file_end
);

reg		file_end_ready;

fifo_4kx32b	U_fifo_4kx32b
(
  .clk			(clk),
  .rst			(~rstN),
  .din			(idata),
  .wr_en			(wr_req),
  .rd_en			(rd_req),
  
  .dout			(odata),
  .full			(full),
  .empty			(empty),
  .valid			(odata_valid)
);

always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		file_end			<=	1'b0	;
		file_end_ready	<=	1'b0	;
	end
	else
	begin
		if(data_terminal)
			file_end_ready	<=	1'b1	;
		else
			file_end_ready	<=	file_end_ready;
			
		if(start_compress)	
			file_end		<=	1'b0	;
		else if(file_end_ready & empty)
			file_end		<=	1'b1	;
		else
			file_end		<=	file_end	;
	end
end


endmodule
