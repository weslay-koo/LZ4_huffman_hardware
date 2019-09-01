`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:21:04 09/24/2015
// Design Name:   lz4_top
// Module Name:   E:/Xilinx_project/lz4_new/simulation/lz4_top_tb.v
// Project Name:  lz4_new
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: lz4_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module lz4_top_tb;

	// Inputs
	reg clk;
	reg rstN;
	reg [31:0] idata;
	reg idata_req;
	reg data_terminal;
	reg start_compress;
	reg out_en;
	
	// Outputs
	wire mfifo_full;
	wire mfifo_empty;
	wire [31:0] out_data;
	wire out_valid;
	wire out_empty;
	
	// Temp Variable
	integer			fp_r;
	reg				rd_done,rd_done_d1;
	reg	[14:0]	data_in_cnt;
	reg				clear_cnt;

	// Instantiate the Unit Under Test (UUT)
	lz4_top uut (
		.clk(clk), 
		.rstN(rstN), 
		.idata(idata), 
		.idata_req(idata_req), 
		.data_terminal(data_terminal), 
		.start_compress(start_compress), 
		.mfifo_full(mfifo_full), 
		.mfifo_empty(mfifo_empty), 
		.out_en(out_en),
		.out_data(out_data),
		.out_empty(out_empty),
		.out_valid(out_valid)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rstN = 0;
		idata = 0;
		idata_req = 0;
		data_terminal = 0;
		start_compress = 0;
		out_en = 0;
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		rstN = 1;
	end
   
	always clk	=	#5 ~clk;
	
	// Read External ASCII file data
	initial
	begin
		#200;
		//fp_r=$fopen("./test_src/compress/book1","rb");
		fp_r=$fopen("./test_src/compress/numbers","r");
		rd_done = 0;
	end

	// Read External ASCII file EOF
	always @ (posedge clk)
	begin
		if(rd_done)
		begin
			rd_done	<=	rd_done;
		end
		else if($feof(fp_r))
		begin
			rd_done	<=	1'b1;
		end
		else
		begin
			rd_done	<=	rd_done;
		end
	end
	
	// Clock control File data to data_in
	always @ (posedge clk)
	begin
		if(!rstN)
		begin
			rd_done_d1		<=	1'b0	;
			idata				<=	32'b0	;
			idata_req		<=	1'b0	;
		end
		else
		begin
			rd_done_d1		<=	rd_done	;
			if((!rd_done)&&(data_in_cnt<=15'h3FFF)&&(!mfifo_full))
			begin
				$fscanf(fp_r,"%c%c%c%c",idata[31:24],idata[23:16],idata[15:8],idata[7:0]);
				//$display("%s",buf_idata);
				idata_req		<=	1'b1	;
			end
			else if({rd_done_d1,rd_done}==2'b01)
			begin
				$fclose(fp_r);
				idata				<=	32'b0	;
				idata_req		<=	1'b0	;
			end
			else
			begin
				idata				<=	32'b0	;
				idata_req		<=	1'b0	;
			end
		end
	end
	
	always @ (posedge clk)
	begin
		if(!rstN)
		begin
			data_in_cnt	<=	15'b0	;
		end
		else
		begin
			if(clear_cnt)
				data_in_cnt	<=	15'b0	;
			else if(idata_req)
				data_in_cnt	<=	data_in_cnt + 1'b1;
			else
				data_in_cnt	<=	data_in_cnt;
		end
	end

   
endmodule

