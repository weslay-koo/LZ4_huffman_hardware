`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:23:19 02/06/2016
// Design Name:   xxh32_calc
// Module Name:   E:/xilinx_project/LZ4_proj/lz4_new_v2/lz4_new/simulation/xxh32_cal_tb.v
// Project Name:  lz4_new
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: xxh32_calc
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module xxh32_cal_tb;

	// Inputs
	reg clk;
	reg rstN;
	reg compress_start;
	reg compress_done;
	reg [31:0] length;
	reg length_valid;
	reg [31:0] data;
	reg data_valid;

	// Outputs
	wire [31:0] digest;
	wire digest_valid;

	// variable
	integer i,file_len;
	integer fp_r,fp_w;
	reg  [7:0]  char;
	
	// parameter
	parameter	Tcq = 10;

	// Instantiate the Unit Under Test (UUT)
	xxh32_calc_v2 uut (
		.clk(clk), 
		.rstN(rstN), 
		.compress_start(compress_start), 
		.compress_done(compress_done), 
		.length(length), 
		.length_valid(length_valid), 
		.data(data), 
		.data_valid(data_valid), 
		.digest(digest), 
		.digest_valid(digest_valid)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rstN = 0;
		compress_start = 0;
		compress_done = 0;
		length = 0;
		length_valid = 0;
		data = 0;
		data_valid = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
			// Add stimulus here
		#(Tcq*2) rstN = 0;
		#(Tcq*2) rstN = 1;
	end	
	
	// clock generation
	always clk = #(Tcq/2) ~clk;
	
	// test case
	initial
	begin
		#(Tcq*20)
		i = 0;
		fp_r = $fopen("./test_src/compress/numbers","r"); 
		char = $fgetc(fp_r);
		while(!($feof(fp_r)))
		begin
			#Tcq;
			i = i + 1;
			char = $fgetc(fp_r);
			//$display("%c",char);
		end
		$fclose(fp_r);
		
		compress_test_start();
		
		file_len			= i;
		length 			= 32'hFFFF_FFFF & i;
		length_valid	= 1'b1;
		#(Tcq*1)
		length 			= 32'b0;
		length_valid	= 1'b0;
		
		fp_r = $fopen("./test_src/compress/numbers","r"); 
		
		i = 0;
		#Tcq ;
		while(i<file_len) // (!($feof(fp_r)))
		begin
			read_4B_src();
			#Tcq i = i + 4;
		end

		data			=	32'b0	;
		data_valid	=	1'b0	;
		
		compress_test_done();
	end
	
	//#Tcq*1000	$stop;
	
	
//////////////////////////////////////////////////////////	
//////                task defination               //////
//////////////////////////////////////////////////////////  
	// read 32bit data from source file
	task	read_4B_src;
		begin
			$fscanf(fp_r,"%c%c%c%c",data[31:24],data[23:16],data[15:8],data[7:0]);
			//$fread(data,fp_r);
			$display("%s",data);
			data_valid	=	1'b1	;
		end
	endtask
	
	// compress start signal generation
	task	compress_test_start;
		begin
			#(Tcq*2) compress_start = 1'b0;
			#(Tcq*2) compress_start = 1'b1;
			#(Tcq*1) compress_start = 1'b0;
		end
	endtask
	
	// compress done signal generation
	task	compress_test_done;
		begin
			#(Tcq*6) compress_done = 1'b0;
			#(Tcq*1) compress_done = 1'b1;
			#(Tcq*1) compress_done = 1'b0;
		end
	endtask
		
endmodule

