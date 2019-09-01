`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:08:04 09/16/2015
// Design Name:   hash_table
// Module Name:   E:/Xilinx_project/lz4_new/simulation/hash_table_tb.v
// Project Name:  lz4_new
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: hash_table
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module hash_table_tb;

	// Inputs
	reg clk;
	reg rstN;
	reg hash_clean;
	reg [31:0] hash_idata;
	reg [31:0] hash_iaddr;
	reg hash_ivalid;

	// Outputs
	wire hash_unable;
	wire [31:0] hash_oaddr;
	wire hash_ovalid;
	wire hash_hit;
	// Temp Variable
	integer			fp_r;
	reg				rd_done,rd_done_d1;
	reg	[14:0]	data_in_cnt;
	reg				clear_cnt;
	reg				initial_undone;

	// Instantiate the Unit Under Test (UUT)
	hash_table_v3 uut (
		.clk(clk), 
		.rstN(rstN), 
		.hash_clean(hash_clean), 
		.hash_unable(hash_unable), 
		.hash_idata(hash_idata), 
		.hash_iaddr(hash_iaddr), 
		.hash_ivalid(hash_ivalid), 
		.hash_oaddr(hash_oaddr), 
		.hash_ovalid(hash_ovalid),
		.hash_hit(hash_hit)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rstN = 0;
		hash_clean = 0;
		hash_idata = 0;
		hash_iaddr = 0;
		hash_ivalid = 0;
		rd_done = 0;
		rd_done_d1 = 0;
		clear_cnt = 0;
		initial_undone = 0;
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		rstN = 1;
		initial_undone = 1;
	end
	
   always clk	=	#5 ~clk;
	
	// Read External ASCII file data
	initial
	begin
		#20;
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
			hash_ivalid		<=	1'b0	;
			hash_idata		<=	32'b0	;
			hash_iaddr		<=	32'b0	;
			initial_undone	<=	1'b1	;
		end
		else
		begin
			rd_done_d1		<=	rd_done	;
			if(!hash_unable)
			begin
				if((hash_ovalid||initial_undone)&&(!rd_done)&&(data_in_cnt<=15'h3FFF))
				begin
					$fscanf(fp_r,"%c%c%c%c",hash_idata[31:24],hash_idata[23:16],hash_idata[15:8],hash_idata[7:0]);
					//$display("%s",buf_idata);
					hash_ivalid		<=	1'b1	;
					hash_iaddr		<= hash_iaddr + 1'b1;
					initial_undone	<=	1'b0	;
				end
				else if({rd_done_d1,rd_done}==2'b01)
				begin
					$fclose(fp_r);
					hash_ivalid		<=	1'b0	;
					hash_idata		<=	32'b0	;
					hash_iaddr		<=	32'b0	;
					initial_undone	<=	1'b0	;
				end
				else
				begin
					hash_ivalid		<=	1'b0	;
					hash_idata		<=	32'b0	;
					hash_iaddr		<=	hash_iaddr;
					initial_undone	<=	initial_undone;
				end
			end
			else
			begin
				hash_ivalid		<=	1'b0	;
				hash_idata		<=	32'b0	;
				hash_iaddr		<=	hash_iaddr;
				initial_undone	<=	initial_undone;
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
			else if(hash_ivalid)
				data_in_cnt	<=	data_in_cnt + 1'b1;
			else
				data_in_cnt	<=	data_in_cnt;
		end
	end
	
	
endmodule

