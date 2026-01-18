`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:20:55 04/27/2016 
// Design Name: 
// Module Name:    shifter_match 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments:  compare data from external 
//
//////////////////////////////////////////////////////////////////////////////////
module shifter_match(
// global clock and reset signal
input wire				clk,
input wire				rstN,
// input source data
input wire	[31:0]	hash_idata1,
input wire	[31:0]	hash_iaddr1,
input wire				hash_ivalid1,
input wire	[31:0]	hash_idata2,
input wire	[31:0]	hash_iaddr2,
input wire				hash_ivalid2,
input wire	[31:0]	hash_idata3,
input wire	[31:0]	hash_iaddr3,
input wire				hash_ivalid3,
input wire	[31:0]	hash_idata4,
input wire	[31:0]	hash_iaddr4,
input wire				hash_ivalid4,
// output hash match status
output reg				hash_hit,
output reg	[2:0]		hit_status,
output reg	[31:0]	hash_oaddr,
output reg	[31:0]	hit_dist
);

reg				hash_hit_reg;
reg	[2:0]		hit_status_reg;
reg	[31:0]	hash_oaddr_reg;
reg	[31:0]	hit_dist_reg;



always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		hash_hit_reg		<=	1'b0;
		hit_status_reg		<=	3'b0;
		hash_oaddr_reg		<=	32'b0;
		hit_dist_reg		<=	32'b0;
	end
	else
	begin
		if((hash_idata2 == hash_idata1) && (hash_ivalid1 & hash_ivalid2))
		begin
			hash_hit_reg	<=	1'b1;
			hit_status_reg	<=	3'h1;
			hash_oaddr_reg	<=	hash_iaddr1;
			hit_dist_reg	<=	32'h1;
		end
		else if((hash_idata3 == hash_idata1) && (hash_ivalid1 & hash_ivalid3))
		begin
			hash_hit_reg	<=	1'b1;
			hit_status_reg	<=	3'h2;
			hash_oaddr_reg	<=	hash_iaddr1;
			hit_dist_reg	<=	32'h2;
		end
		else if((hash_idata3 == hash_idata2) && (hash_ivalid2 & hash_ivalid3))
		begin
			hash_hit_reg	<=	1'b1;
			hit_status_reg	<=	3'h2;
			hash_oaddr_reg	<=	hash_iaddr2;
			hit_dist_reg	<=	32'h1;
		end
		else if((hash_idata4 == hash_idata1) && (hash_ivalid1 & hash_ivalid4))
		begin
			hash_hit_reg	<=	1'b1;
			hit_status_reg	<=	3'h3;
			hash_oaddr_reg	<=	hash_iaddr1;
			hit_dist_reg	<=	32'h3;
		end
		else if((hash_idata4 == hash_idata2) && (hash_ivalid2 & hash_ivalid4))
		begin
			hash_hit_reg	<=	1'b1;
			hit_status_reg	<=	3'h3;
			hash_oaddr_reg	<=	hash_iaddr2;
			hit_dist_reg	<=	32'h2;
		end
		else if((hash_idata4 == hash_idata3) && (hash_ivalid3 & hash_ivalid4))
		begin
			hash_hit_reg	<=	1'b1;
			hit_status_reg	<=	3'h3;
			hash_oaddr_reg	<=	hash_iaddr3;
			hit_dist_reg	<=	32'h1;
		end
		else
		begin
			hash_hit_reg	<=	1'b0;
			hit_status_reg	<=	3'b0;
			hash_oaddr_reg	<=	32'b0;
			hit_dist_reg	<=	32'b0;
		end
	end
end

// delay output signal for 1 clock cycle
always @ (posedge clk)
begin
	hash_hit		<=	hash_hit_reg;		
	hit_status	<=	hit_status_reg;		
	hash_oaddr	<=	hash_oaddr_reg;		
	hit_dist		<=	hit_dist_reg;		
end


endmodule
