`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:38:14 09/16/2015
// Design Name:   lz4_buffer
// Module Name:   E:/Xilinx_project/lz4_new/simulation/lz4_buffer_tb.v
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

module lz4_buffer_tb;

	// Inputs
	reg clk;
	reg rstN;
	reg buf_clear;
	reg [31:0] buf_idata;
	reg buf_ivalid;
	reg buf_rdreq;
	reg [15:0] buf_rdpointer;
	reg move_valid;
	reg [15:0] move_distance;

	// Outputs
	wire buf_buf_unable;
	wire buf_full;
	wire [31:0] buf_odata;
	wire buf_ovalid;
	wire buf_empty;
	wire dict_full;

	// Temp Variable
	integer			fp_r,fp_w,cnt;
	reg				rd_done,wr_done,rd_done_d1,wr_done_d1;
	reg	[15:0]	move_distance_d;
	reg				rd_wrN;
	reg				dict_full_d1,dict_full_d2;
	reg	[14:0]	data_in_cnt;
	reg				clear_cnt;
	reg				buf_empty_d1;

	// Instantiate the Unit Under Test (UUT)
	lz4_buffer uut (
		.clk(clk), 
		.rstN(rstN), 
		.buf_clear(buf_clear), 
		.buf_unable(buf_unable), 
		.buf_idata(buf_idata), 
		.buf_ivalid(buf_ivalid), 
		.buf_full(buf_full), 
		.buf_rdreq(buf_rdreq), 
		.buf_rdpointer(buf_rdpointer), 
		.buf_odata(buf_odata), 
		.buf_ovalid(buf_ovalid), 
		.buf_empty(buf_empty), 
		.move_valid(move_valid), 
		.move_distance(move_distance), 
		.dict_full(dict_full)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rstN = 0;
		buf_clear = 0;
		buf_idata = 0;
		buf_ivalid = 0;
		buf_rdreq = 0;
		buf_rdpointer = 0;
		move_valid = 0;
		move_distance = 0;

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
		fp_r=$fopen("./test_src/compress/book1","rb");
		fp_w=$fopen("data_out","wb");
		rd_done = 0;
		wr_done = 0;
//		while(!$feof(fp_r))
//		begin
//			#10 cnt=$fscanf(fp_r,"%c",str_data);
//			$display("%c",str_data);
//			$fwrite(fp_w,"%c",reg1);
//		end
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
//		if(!wr_done)
//		begin
//			$fwrite(fp_w,"%c",str_data);
//		end
//		else if({wr_done_d1,wr_done}==2'b01)
//		begin
//			$fclose(fp_w);
//		end
	end
	
	// Clock control File data to data_in
	always @ (posedge clk)
	begin
		if(!rstN)
		begin
			rd_done_d1		<=	1'b0	;
			buf_ivalid		<=	1'b0	;
			buf_idata		<=	32'b0	;
			move_valid 		<= 0;
			move_distance_d<= 0;
			move_distance	<= 0;
		end
		else
		begin
			move_distance	<= move_distance_d;	
			rd_done_d1		<=	rd_done	;
			if(!buf_unable)
			begin
				if((!buf_full)&&(!rd_done)&&(!rd_wrN)&&(data_in_cnt<=15'h3FFF))
				begin
					$fscanf(fp_r,"%c%c%c%c",buf_idata[31:24],buf_idata[23:16],buf_idata[15:8],buf_idata[7:0]);
					//$display("%s",buf_idata);
					move_valid 		<= 1;
					move_distance_d<= 4;
					buf_ivalid		<=	1'b1	;
				end
				else if({rd_done_d1,rd_done}==2'b01)
				begin
					$fclose(fp_r);
					buf_ivalid		<=	1'b0	;
					buf_idata		<=	32'b0	;
					move_valid 		<= 0;
					move_distance_d<= 0;
				end
				else
				begin
					buf_ivalid		<=	1'b0	;
					buf_idata		<=	32'b0	;
					move_valid 		<= 0;
					move_distance_d<= 0;
				end
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
			else if(buf_ivalid)
				data_in_cnt	<=	data_in_cnt + 1'b1;
			else
				data_in_cnt	<=	data_in_cnt;
		end
	end
	
	// read from buffer to file
	always @ (posedge clk)
	begin
		if(!rstN)
		begin
			buf_rdreq			<=	1'b0	;
			dict_full_d2	<=	1'b0	;
			dict_full_d1	<=	1'b0	;
			clear_cnt		<=	1'b0	;
		end
		else
		begin
			dict_full_d2	<=	dict_full_d1;
			dict_full_d1	<=	dict_full;
			if((dict_full && buf_ovalid)||({dict_full_d2,dict_full_d1}==2'b01)) 
			begin
				clear_cnt<=	1'b1	;
				if(!buf_empty)
				begin
					buf_rdreq	<=	1'b1 ;
				end
				else
				begin
					buf_rdreq	<=	1'b0 ;
				end
			end
			else
			begin
				clear_cnt<=	1'b0	;
				buf_rdreq	<=	1'b0 ;
			end	
		end
	end
	
	always @ (posedge clk)
	begin
		if(!rstN)
		begin
			buf_rdpointer 	<= 16'b0	;
			wr_done_d1	<=	1'b0	;
		end
		else
		begin
			wr_done_d1	<=	wr_done	;
			if(rd_wrN)
			begin
				if({dict_full_d1,dict_full}==2'b01)
				begin
					buf_rdpointer 	<= 16'b0;
				end
//				else if(rd_done)
//				begin
//					buf_rdpointer 	<= buf_rdpointer;
//				end
				else if((!buf_empty)&&(buf_ovalid))
				begin
					buf_rdpointer	<=	buf_rdpointer + 3'b100;
					$fwrite(fp_w,"%c%c%c%c",buf_odata[31:24],buf_odata[23:16],buf_odata[15:8],buf_odata[7:0]);
				end
				else
				begin
					buf_rdpointer	<=	buf_rdpointer;
					if({wr_done_d1,wr_done}==2'b01)
					begin
						$fclose(fp_r);
					end
				end
			end
			else
			begin
				buf_rdpointer	<=	buf_rdpointer;
			end
		end
	end
	
	always @ (posedge clk)
	begin
		if(!rstN)
		begin
			rd_wrN			<=	1'b0	;
			buf_empty_d1	<=	1'b1	;
			wr_done			<=	1'b0	;
		end
		else
		begin
			buf_empty_d1	<=	buf_empty	;
			if(({dict_full_d1,dict_full}==2'b01)||rd_done)
			begin
				rd_wrN	<=	1'b1	;
				wr_done	<=	1'b0	;
			end
			else if({buf_empty_d1,buf_empty}==2'b01)
			begin
				rd_wrN	<=	1'b0	;
				if(rd_done)
					wr_done	<=	1'b1	;
				else
					wr_done	<=	1'b0	;
			end
			else
			begin
				rd_wrN	<=	rd_wrN;
				wr_done	<=	wr_done;
			end
		end
	end
	
endmodule

