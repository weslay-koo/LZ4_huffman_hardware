`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:40:34 09/15/2015 
// Design Name: 
// Module Name:    addr_convert 
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
module addr_convert(
input wire	[31:0]	head_addr,
input wire	[31:0]	abs_addr_out, // from FSM HashTable
output wire	[15:0]	relate_raddr, // from lz4_buffer
//output wire	[15:0]	relate_waddr, // from lz4_buffer
output wire				outofrange
);

wire	[31:0]	addr_distance;
assign			addr_distance = abs_addr_out - head_addr;
assign			relate_raddr  = (addr_distance>32'hFFFF) ? 16'b0 : addr_distance ;
//assign			relate_waddr  = relate_raddr;
assign			outofrange    = (addr_distance>32'hFFFF) ? 1'b1 : 1'b0 ;

endmodule
