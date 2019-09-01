`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:14:47 01/11/2016
// Design Name:   lz4_buffer_v2
// Module Name:   E:/Xilinx_project/lz4_new_v2/lz4_new/simulation/lz4_circle_queue_tb.v
// Project Name:  lz4_new
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: lz4_buffer_v2
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module lz4_circle_queue_tb;

	// Inputs
	reg clk;
	reg rstN;
	reg compress_start;
	reg compress_done;
	reg matching;
	reg seg_done;
	reg [2:0] move_dist;
	reg wr_req;
	reg [31:0] idata;
	reg fifo_rd;
	reg [31:0] ram_abs_addr;
	reg ram_rd;

	// Outputs
	wire [31:0] fifo_odata;
	wire fifo_ovalid;
	wire [31:0] ram_odata;
	wire [2:0] ram_omask;
	wire ram_ovalid;
	wire outofrange;
	wire buf_full;
	wire fifo_empty;
	wire [14:0]	fifo_count;
	
	// variable
	integer i;
	integer fp_r,fp_w;

	// parameter
	parameter	Tcq = 10;
	
	// Instantiate the Unit Under Test (UUT)
	lz4_buffer_v2 uut (
		.clk(clk), 
		.rstN(rstN), 
		.compress_start(compress_start), 
		.compress_done(compress_done), 
		.matching(matching), 
		.seg_done(seg_done), 
		.move_dist(move_dist), 
		.wr_req(wr_req), 
		.idata(idata), 
		.fifo_rd(fifo_rd), 
		.fifo_odata(fifo_odata), 
		.fifo_ovalid(fifo_ovalid), 
		.ram_abs_addr(ram_abs_addr), 
		.ram_rd(ram_rd), 
		.ram_odata(ram_odata), 
		.ram_omask(ram_omask), 
		.ram_ovalid(ram_ovalid), 
		.outofrange(outofrange), 
		.buf_full(buf_full), 
		.fifo_empty(fifo_empty),
		.fifo_count(fifo_count)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rstN = 0;
		compress_start = 0;
		compress_done = 0;
		matching = 0;
		seg_done = 0;
		move_dist = 0;
		wr_req = 0;
		idata = 0;
		fifo_rd = 0;
		ram_abs_addr = 0;
		ram_rd = 0;
		i	= 0;
		// Wait 100 ns for global reset to finish
		//#100;
        
		// Add stimulus here
		#(Tcq*2) rstN = 0;
		#(Tcq*2) rstN = 1;
	end
      
		
	// clock generation
	always clk = #(Tcq/2) ~clk;
	
	// test case
	initial
	begin
		#(Tcq*8); 
		fp_r = $fopen("./test_src/compress/numbers","r");//Read External ASCII file data
		fp_w = $fopen("./test_out/numbers","w");
		start_compress();
		while(!($feof(fp_r)))
		begin
			if(!buf_full)
			begin
				write_4B_src();
			end
			else
			begin
				wr_req	=	1'b0;
				idata		=	32'b0	;
			end
			#Tcq;
		end
		wr_req	=	1'b0;
		idata		=	32'b0	;
		$display("File end!");
		$fclose(fp_r);
		
		while(!fifo_empty)
		begin
			fifo_rd = 1'b1;
			#Tcq;
			read_to_file();
			if(fifo_count==15'd24)
			begin
				read_RAM();
			end
			else
			begin
				ram_abs_addr=	32'd0;
				ram_rd		=	1'b0;
			end
		end
		fifo_rd = 1'b0;
		#Tcq;
		
			
		$fclose(fp_w);
		$stop;
	end
	
//////////////////////////////////////////////////////////	
//////                task defination               //////
//////////////////////////////////////////////////////////
	
	// read 32bit data from source file
	task	write_4B_src;
		begin
			wr_req	=	1'b1;
			$fscanf(fp_r,"%c%c%c%c",idata[31:24],idata[23:16],idata[15:8],idata[7:0]);
			i = i + 1;
			if(i==65535)
			begin
				$display("The dict should become full!");
			end
		end
	endtask
	
	// start signal
	task	start_compress;
		begin
			compress_start	=	1'b0;
			#Tcq	compress_start	=	1'b1;
			#Tcq	compress_start	=	1'b0;
		end
	endtask
	
	// done signal
	task	end_compress;
		begin
			compress_done	=	1'b0;
			#Tcq	compress_done	=	1'b1;
			#Tcq	compress_done	=	1'b0;
		end
	endtask
	
	// read FIFO to file
	task	read_to_file;
		begin
			$fwrite(fp_w,"%c%c%c%c",fifo_odata[31:24],fifo_odata[23:16],fifo_odata[15:8],fifo_odata[7:0]);
		end
	endtask
	
	// read RAM
	task	read_RAM;
		begin
			ram_abs_addr	=	32'h12;
			ram_rd	=	1'b1;
		end
	endtask
	
	// matching
	task	matching_RAM;
		begin
			matching = 1'b1;
		end
	endtask
	
endmodule

