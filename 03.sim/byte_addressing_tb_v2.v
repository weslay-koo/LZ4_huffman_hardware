`timescale 1ns / 1ns

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:40:12 01/04/2016
// Design Name:   byte_addressing
// Module Name:   E:/Xilinx_project/lz4_new_v2/lz4_new/simulation/byte_addressing_tb_v2.v
// Project Name:  lz4_new
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: byte_addressing
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module byte_addressing_tb_v3;

	// Inputs
	reg clk;
	reg rstN;
	reg [31:0] fifo_data;
	reg fifo_valid;
	reg fifo_empty;
	reg rd_data_en;
	reg byte4_en;
	reg [2:0] shift_dist;
	reg shift_en;
	// Outputs
	wire rd_fifo_en;
	wire byte4_busy;
	wire [31:0] byte4_data1;
	wire [31:0] byte4_data2;
	wire [31:0] byte4_data3;
	wire [31:0] byte4_data4;
	wire byte4_valid;
	
	// regs
//	reg	clk_reg;
	
	// variable
	integer i;
	integer fp_r,fp_w;
	
	// parameter
	parameter	Tcq = 10;

	// Instantiate the Unit Under Test (UUT)
	byte_addressing_v4 uut (
		.clk(clk), 
		.rstN(rstN), 
		.fifo_data(fifo_data), 
		.fifo_valid(fifo_valid), 
		.fifo_empty(fifo_empty), 
		.rd_fifo_en(rd_fifo_en), 
		.rd_data_en(rd_data_en), 
		.byte4_en(byte4_en),
		.byte4_busy(byte4_busy), 
		.byte4_data1(byte4_data1), 
		.byte4_data2(byte4_data2), 
		.byte4_data3(byte4_data3), 
		.byte4_data4(byte4_data4), 
		.byte4_valid(byte4_valid),
		.shift_dist(shift_dist),
		.shift_en(shift_en)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rstN = 0;
		fifo_data = 0;
		fifo_valid = 0;
		fifo_empty = 0;
		rd_data_en = 0;
		byte4_en = 0;
		shift_dist = 3'b0;
		shift_en   = 1'b0;
		
		// Wait 100 ns for global reset to finish
//		#100;
        
		// Add stimulus here
		#(Tcq*2) rstN = 0;
		#(Tcq*2) rstN = 1;
	end
   
	// clock generation
	always 	clk = #(Tcq/2) ~clk ;
//	always 	clk = #1 clk_reg;
	
	// test case
	initial
	begin
		#(Tcq*4); 
		fp_r = $fopen("./test_src/compress/numbers","rb");//Read External ASCII file data
		fifo_empty = 1'b1	;
		fifo_empty = 1'b0;
		
		#(Tcq*4) byte4_en = 0;
		#(Tcq*4) byte4_en = 1;
		
//		if(rd_fifo_en)
//		begin
//			read_4B_src();
//		end
//		#Tcq fifo_empty = 1'b1;
//		#Tcq fifo_empty = 1'b0;
		
		while(!($feof(fp_r)))
		begin
			if(rd_fifo_en)
			begin
				read_4B_src();
			end
			else
			begin
				fifo_data	=	32'b0	;
				fifo_valid	=	1'b0	;
			end
			#Tcq;
		end
		fifo_empty	=	1'b1	;
		
		#(Tcq*4) byte4_en = 0;
	end
	
	initial
	begin
		rd_data_en = 1'b0;
		while(byte4_busy)
		begin
			#Tcq	rd_data_en = 1'b0;
			rd_data_en = 1'b0;
		end
		#(Tcq*20) rd_data_en = 1'b1;
		#Tcq 		 shift_dist = 3'h1;
					 shift_en   = 1'b1;
	end
	
//////////////////////////////////////////////////////////	
//////                task defination               //////
//////////////////////////////////////////////////////////
	
	// read 32bit data from source file
	task	read_4B_src;
		begin
			$fscanf(fp_r,"%c%c%c%c",fifo_data[31:24],fifo_data[23:16],fifo_data[15:8],fifo_data[7:0]);
			//$display("%s",buf_idata);
			fifo_valid	=	1'b1	;
		end
	endtask

	
endmodule

