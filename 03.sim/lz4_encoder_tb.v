`timescale 1ns / 1ns

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:09:18 12/29/2015
// Design Name:   lz4_encoder
// Module Name:   E:/Xilinx_project/lz4_new_v2/lz4_new/simulation/lz4_encoder_tb.v
// Project Name:  lz4_new
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: lz4_encoder
//
// Dependencies:
// 
// Revision:
// Revision 3.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////


module lz4_encoder_tb;

	// Inputs
	reg clk;
	reg rstN;
	reg [15:0] match_offset;
	reg [31:0] match_length;
	reg [31:0] unmatch_length;
	reg info_valid;
	reg [31:0] unmatch_data;
	reg data_valid;
	reg encode_en;
	reg out_en;
	reg compress_done;
	reg compress_start;
	reg [31:0] xxh32_dword;
	
	// Outputs
	wire encode_done;
	wire encode_busy;
	wire [31:0] out_data;
	wire out_empty;
	wire out_valid;
	wire seg_done;
	
	// variable
	integer i;
	integer file_len;
	
	// parameter
	parameter	Tcq = 10;
	
	// Instantiate the Unit Under Test (UUT)
	lz4_encoder_v3 uut (
		.clk(clk), 
		.rstN(rstN), 
		.match_offset(match_offset), 
		.match_length(match_length), 
		.unmatch_length(unmatch_length), 
		.info_valid(info_valid), 
		.blocksize_id(8'h40),
		.header_crc(8'hA7),	
		.head_valid(1'b1),
		.unmatch_data(unmatch_data), 
		.data_valid(data_valid), 
		.last_5bytes(1'b0),
		.compress_start(compress_start),
		.compress_done(compress_done),
		.xxh32_dword(xxh32_dword),
		.encode_en(encode_en), 
		.seg_done(seg_done),
		.encode_done(encode_done), 
		.encode_busy(encode_busy), 
		.out_en(out_en), 
		.out_data(out_data), 
		.out_empty(out_empty), 
		.out_valid(out_valid)
	);

	initial begin
		// Initialize Inputs
		rstN = 0;
		clk = 0;
		match_offset = 0;
		match_length = 0;
		unmatch_length = 0;
		info_valid = 0;
		unmatch_data = 0;
		data_valid = 0;
		encode_en = 0;
		out_en = 0;
		compress_done = 0;
		xxh32_dword = 0;
		// Wait 100 ns for global reset to finish
		//#100;
        
		// Add stimulus here
		#(Tcq*2) rstN = 0;
		#(Tcq*2) rstN = 1;
		#(Tcq*4) xxh32_dword = 32'hABCD_4321;
	end	
	
	// clock generation
	always clk = #(Tcq/2) ~clk;
	
	// test case
	initial
	begin
		compress_test_start();
		//					 unmatch  offset  match
//		test_pattern_gen(32'd76,16'd512,32'd17);
		test_pattern_gen(32'd3,16'hC04,32'd267);
//		test_pattern_gen(32'd0,16'hC04,32'd267);
//		test_pattern_gen(32'd0,16'hC04,32'd271);
//		test_pattern_gen(32'd0,16'h5,32'd13567);
//		#(Tcq*100)
//		test_pattern_gen(32'd1290,16'd1025,32'd784);
//		test_pattern_gen(32'd780,16'd1025,32'd784);
		compress_test_done();
	end
	
	//#Tcq*1000	$stop;
	
	// task defination
		task	test_pattern_gen;
			input [31:0]	unmatch_len;
			input [15:0]	offset;
			input	[31:0]	match_len;
			begin
				// print infomation
				if(unmatch_len>=15)
				begin
					$display("Unmatch length extend bytes is:%d",(unmatch_len-15)/255+1);
					$display("Last Hex Byte of unmatch length is:%x",(unmatch_len-15)%255);
				end
				else
				begin
					$display("Do not need extend bytes");
					$display("The Last Hex Byte of unmatch length is:%x",unmatch_len);
				end	
				if(match_len>=19)
				begin
					$display("Match length extend bytes is:%d",(match_len-19)/255+1);
					$display("Last Hex Byte of match length is:%x",(match_len-19)%255);
				end
				else
				begin
					$display("Do not need extend bytes");
					$display("The Last Hex Byte of match length is:%x",match_len-4);
				end
				// Stimulus signal sequences
				
				
				#(Tcq*6)	
						match_offset 	= offset;//16'd512;
						match_length 	= match_len;//16'd17;
						unmatch_length = unmatch_len;//32'd76; // 19*4
						info_valid 		= 1'b1;
						encode_en		= 1'b1;
				#Tcq 	
						match_offset 	= 16'd0;
						match_length 	= 32'd0;
						unmatch_length = 32'b0;
						info_valid 		= 1'b0;
				for(i=0;i<=(unmatch_len/4);i=i+1)	
				begin
					#Tcq	
					unmatch_data 	= 	32'b0 | i;//32'h1234_5678;		
					data_valid		=	1'b1;
				end
				data_valid		=	1'b0;
				unmatch_data 	= 	32'b0;
			
				while(!seg_done)
				begin
					#Tcq;
				end
			end
		endtask
   
		task	compress_test_start;
			begin
				#(Tcq*2) compress_start = 1'b0;
				#(Tcq*2) compress_start = 1'b1;
				#(Tcq*1) compress_start = 1'b0;
			end
		endtask
		
		task	compress_test_done;
			begin
				#(Tcq*6) compress_done = 1'b1;
				while(!encode_done)
				begin
					#Tcq;
				end
				#(Tcq*1) compress_done = 1'b0;
				
				#(Tcq*10)
				while(!out_empty)	
				begin
					#Tcq	
					out_en 	= 	1'b1;		
				end
				out_en 	=	1'b0;
				encode_en=	1'b0;
				
				#Tcq compress_done = 1'b0;
			end
		endtask
endmodule

