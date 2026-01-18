`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:39:07 01/07/2016
// Design Name:   lz4_buffer
// Module Name:   E:/Xilinx_project/lz4_new_v2/lz4_new/simulation/lz4_buffer_tb_v2.v
// Project Name:  lz4_new
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: lz4_buffer
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module lz4_buffer_tb_v2;

	// Inputs
	reg clk;
	reg rstN;
	reg buf_clean;
	reg compress_end;
	reg [31:0] buf_idword;
	reg buf_idvalid;
	reg [31:0] buf_ishift;
	reg buf_isvalid;
	reg [31:0] buf_waddr;
	reg buf_rdreq;
	reg [31:0] buf_raddr;
	reg move_valid;
	reg [15:0] move_distance;

	// Outputs
	wire buf_unable;
	wire buf_full;
	wire [31:0] buf_odata;
	wire buf_ovalid;
	wire buf_empty;
	wire [31:0] head_addr;

	// Instantiate the Unit Under Test (UUT)
	lz4_buffer_v2 uut (
		.clk(clk), 
		.rstN(rstN), 
		.buf_clean(buf_clean), 
		.buf_unable(buf_unable), 
		.compress_end(compress_end), 
		.buf_idword(buf_idword), 
		.buf_idvalid(buf_idvalid), 
		.buf_ishift(buf_ishift), 
		.buf_isvalid(buf_isvalid), 
		.buf_waddr(buf_waddr), 
		.buf_full(buf_full), 
		.buf_rdreq(buf_rdreq), 
		.buf_raddr(buf_raddr), 
		.buf_odata(buf_odata), 
		.buf_ovalid(buf_ovalid), 
		.buf_empty(buf_empty), 
		.move_valid(move_valid), 
		.move_distance(move_distance), 
		.head_addr(head_addr)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rstN = 0;
		buf_clean = 0;
		compress_end = 0;
		buf_idword = 0;
		buf_idvalid = 0;
		buf_ishift = 0;
		buf_isvalid = 0;
		buf_waddr = 0;
		buf_rdreq = 0;
		buf_raddr = 0;
		move_valid = 0;
		move_distance = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

