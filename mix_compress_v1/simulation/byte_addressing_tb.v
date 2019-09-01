`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:04:11 09/16/2015
// Design Name:   byte_addressing
// Module Name:   E:/Xilinx_project/lz4_new/simulation/byte_addressing_tb.v
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

module byte_addressing_tb;

	// Inputs
	reg clk;
	reg rstN;
	reg [31:0] fifo_data;
	reg fifo_valid;
	reg fifo_empty;
	reg rd_shift_en;
	reg rd_data_en;

	// Outputs
	wire rd_fifo_en;
	wire byte4_busy;
	wire [31:0] byte4_shift;
	wire byte4_svalid;
	wire [31:0]	abs_addr;
	
	// Temp Variable
	integer			fp_r;
	reg				rd_done,rd_done_d1;
	reg				init_done,first_byte4;
	
	// Instantiate the Unit Under Test (UUT)
	byte_addressing uut (
		.clk(clk), 
		.rstN(rstN), 
		.fifo_data(fifo_data), 
		.fifo_valid(fifo_valid), 
		.fifo_empty(fifo_empty), 
		.rd_fifo_en(rd_fifo_en), 
		.rd_shift_en(rd_shift_en), 
		.rd_data_en(rd_data_en), 
		.byte4_busy(byte4_busy), 
		.byte4_shift(byte4_shift), 
		.abs_addr(abs_addr),
		.byte4_svalid(byte4_svalid)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		fifo_data = 0;
		fifo_valid = 0;
		fifo_empty = 0;
		rd_shift_en = 0;
		rd_data_en = 0;
		rd_done = 0;
		rd_done_d1 = 0;
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
	end
	
   initial begin
		init_done = 0;
		rstN = 0;		
		#1000 init_done = 1;
				rstN = 1;
	end	 
	
	  always clk	=	#5 ~clk;
	
	// Read External ASCII file data
	initial
	begin
		#200;
		fp_r=$fopen("./test_src/compress/book1","rb");
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
	always @ (posedge clk or negedge rstN)
	begin
		if(!rstN)
		begin
			rd_done_d1		<=	1'b0	;
			fifo_valid		<=	1'b0	;
		end
		else
		begin
			rd_done_d1		<=	rd_done	;
			if(rd_fifo_en)
			begin
				if(!rd_done)
				begin
					$fscanf(fp_r,"%c%c%c%c",fifo_data[31:24],fifo_data[23:16],fifo_data[15:8],fifo_data[7:0]);
					//$display("%s",buf_idata);
					fifo_valid	<=	1'b1	;
				end
				else if({rd_done_d1,rd_done}==2'b01)
				begin
					$fclose(fp_r);
					fifo_data	<=	32'b0	;
					fifo_valid	<=	1'b0	;
				end
				else
				begin
					fifo_data	<=	32'b0	;
					fifo_valid	<=	1'b0	;
				end
			end
		end
	end
	
// Read data from byte_addressing module
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		rd_shift_en	<=	1'b0;
	end
	else
	begin
		if((byte4_svalid||first_byte4) && init_done && (!byte4_busy) && (!rd_done))
		begin
			rd_shift_en	<=	1'b1;
		end
		else
		begin
			rd_shift_en	<=	1'b0;
		end
		
//		if(byte4_dvalid&&init_done)
//		begin
//			rd_data_en	<=	1'b1;
//		end
//		else
//		begin
//			rd_data_en	<=	1'b0;
//		end
	end
end

always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		first_byte4	<= 1'b1;
	end
	else
	begin
		if(rd_shift_en)
			first_byte4	<= 1'b0;
		else
			first_byte4	<= first_byte4;
	end
end

endmodule

