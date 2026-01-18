`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:55:49 01/03/2016
// Design Name:   lz4_top
// Module Name:   E:/Xilinx_project/lz4_new_v2/lz4_new/simulation/lz4_top_tb_v2.v
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

module lz4_top_tb_v2;

	// Inputs
	reg clk;
	reg rstN;
	reg [31:0] idata;
	reg idata_req;
	reg data_terminal;
	reg start_compress;
	reg out_en;
	reg [31:0] file_length;
	reg file_length_valid;
	
	// Outputs
	wire mfifo_full;
	wire mfifo_empty;
	wire [31:0] out_data;
	wire out_empty;
	wire out_valid;
	wire obuf_full;
	wire ohalf_full;
	wire compress_done;
	wire [31:0] compressed_len;
	
	// test interface
	wire [31:0] mfifo_data;
	wire mfifo_valid;
	
	// variable
	integer i,j,file_len;
	integer fp_r,fp_w,fp_t;
	reg [7:0] char;
	
	// parameter
	parameter	Tcq =  4; // 10; // 
	parameter	FRAME_LEN_POS = 7;
	
///////////////////////////////////////////////////////////////////	
////			 	calgary	test case V4 [100MHz / 250MHz]			////
///////////////////////////////////////////////////////////////////
//	parameter	SRC_FILE_PATH = "./test_src/compress/words";
//	parameter	DEST_FILE_PATH = "./test_out/words_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/compress/numbers";
//	parameter	DEST_FILE_PATH = "./test_out/num_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/compress/numlit";
//	parameter	DEST_FILE_PATH = "./test_out/numlit_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/compress/zero";	// 15us
//	parameter	DEST_FILE_PATH = "./test_out/zero_hw.lz4";
	
//	parameter	SRC_FILE_PATH = "./test_src/compress/space";	// 5us
//	parameter	DEST_FILE_PATH = "./test_out/space_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/compress/spclit";	// 6us  compress ratio error
//	parameter	DEST_FILE_PATH = "./test_out/spclit_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/compress/README";	//	[36us / 15us]  (46us / 19us)  84us / 34us
//	parameter	DEST_FILE_PATH = "./test_out/README_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/compress/paper1";	//	[729us / 292us]  (977us / 391us)  1223us / 489us
//	parameter	DEST_FILE_PATH = "./test_out/paper1_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/compress/paper3";	//	[700us / 280us]  (942us / 377us)  1182us / 473us
//	parameter	DEST_FILE_PATH = "./test_out/paper3_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/compress/paper4";	//	[197us / 79us]  (260us / 104us)  371us / 149us
//	parameter	DEST_FILE_PATH = "./test_out/paper4_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/compress/paper5";	//	[175us / 70us]  (230us / 92us)  333us / 133us
//	parameter	DEST_FILE_PATH = "./test_out/paper5_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/compress/paper6";	//	[502us / 201us]  (675us / 270us)  868us / 348us
//	parameter	DEST_FILE_PATH = "./test_out/paper6_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/compress/paper2";	//	[1235us / 494us]  (1661us / 665us)  1951us / 781us
//	parameter	DEST_FILE_PATH = "./test_out/paper2_hw.lz4";
//	parameter	TEST_FILE_PATH	= "./test_feedback/paper2.fb";

//	parameter	SRC_FILE_PATH = "./test_src/compress/bib";		//	[1363us / 545us]	(1837us / 735us)  2261us / 904us
//	parameter	DEST_FILE_PATH = "./test_out/bib_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/compress/geo";		//	[1272us / 509us]	(1638us / 656us)  3827us / 1531us
//	parameter	DEST_FILE_PATH = "./test_out/geo_hw.lz4";
	
//	parameter	SRC_FILE_PATH = "./test_src/compress/obj1";		//	[247us / 99us]	(315us / 126us) 	589us / 236us
//	parameter	DEST_FILE_PATH = "./test_out/obj1_hw.lz4";
	
//	parameter	SRC_FILE_PATH = "./test_src/compress/progc";		//	[499us / 200us]	(672us / 269us)	879us / 352us
//	parameter	DEST_FILE_PATH = "./test_out/progc_hw.lz4";
	
//	parameter	SRC_FILE_PATH = "./test_src/compress/progp";		// [495us / 198us]	(656us / 263us)	804us / 322us
//	parameter	DEST_FILE_PATH = "./test_out/progp_hw.lz4";
	
//	parameter	SRC_FILE_PATH = "./test_src/compress/progl";		// [786us / 315us]	(1038us / 416us)	1227us / 491us error
//	parameter	DEST_FILE_PATH = "./test_out/progl_hw.lz4";
	
//	parameter	SRC_FILE_PATH = "./test_src/compress/trans";		// [849us / 340us]	(1107us / 443us)  1367us / 547us
//	parameter	DEST_FILE_PATH = "./test_out/trans_hw.lz4";
	
////// file over 128KB
//	parameter	SRC_FILE_PATH = "./test_src/compress/obj2";		//	[2674us / 1070us]	(3598us / 1439us)  5023us / 2009us
//	parameter	DEST_FILE_PATH = "./test_out/obj2_hw.lz4";		

//// file over 256KB
//	parameter	SRC_FILE_PATH = "./test_src/compress/news";		//	[4733us / 1894us]	(6414us / 2565us)  8451us / 3380us
//	parameter	DEST_FILE_PATH = "./test_out/news_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/compress/pic";		// [2803us / 1121us]	(3444us / 1378us)  4526us / 1811us
//	parameter	DEST_FILE_PATH = "./test_out/pic_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/compress/book1";		// [12549us / 5020us]	(17048us / 6819us)  19571us / 7829us
//	parameter	DEST_FILE_PATH = "./test_out/book1_hw.lz4";
	
//	parameter	SRC_FILE_PATH = "./test_src/compress/book2";		// [8547us / 3419us]	(11537us / 4615us)  13252us / 5301us
//	parameter	DEST_FILE_PATH = "./test_out/book2_hw.lz4";
	
////// file over 1MB	
//	parameter	SRC_FILE_PATH = "./test_src/compress/over1M.pdf";	// [ / 5897us] 43031us
//	parameter	DEST_FILE_PATH = "./test_out/over1M_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/compress/jpg1M";	// fsm stop at 0x0e error
//	parameter	DEST_FILE_PATH = "./test_out/jpg1M_hw.lz4";

////// file over 4MB	
//	parameter	SRC_FILE_PATH = "./test_src/compress/equ4M_ascii.txt";	// 6442us
//	parameter	DEST_FILE_PATH = "./test_out/equ4M_ascii_hw.lz4";	
	
///////////////////////////////////////////////////////////////////	
////			 	cantegary	test case 	(250MHz)						////
///////////////////////////////////////////////////////////////////	
//	parameter	SRC_FILE_PATH = "./test_src/compress/kennedy.xls";	// [4042us]	6561us
//	parameter	DEST_FILE_PATH = "./test_out/kennedy_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/compress/sum"; // [163us] 327us
//	parameter	DEST_FILE_PATH = "./test_out/sum_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/compress/ptt5"; // [1121us] 1811us
//	parameter	DEST_FILE_PATH = "./test_out/ptt5_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/compress/xargs.1"; // [24us] 47us
//	parameter	DEST_FILE_PATH = "./test_out/xargs_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/compress/grammar.lsp"; // [18us] 35us
//	parameter	DEST_FILE_PATH = "./test_out/grammar_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/compress/alice29.txt"; // [927us] 1427us
//	parameter	DEST_FILE_PATH = "./test_out/alice29_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/compress/fields.c";  // [56us] 93us
//	parameter	DEST_FILE_PATH = "./test_out/fields_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/compress/lcet10.txt"; // [2457us] 3738us
//	parameter	DEST_FILE_PATH = "./test_out/lcet10_hw.lz4";

	parameter	SRC_FILE_PATH = "./test_src/compress/plrabn12.txt"; // [3234us] 4944us
	parameter	DEST_FILE_PATH = "./test_out/plrabn12_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/compress/asyoulik.txt"; // [784us] 1242us
//	parameter	DEST_FILE_PATH = "./test_out/asyoulik_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/compress/cp.html"; // [111us] 213us
//	parameter	DEST_FILE_PATH = "./test_out/cp_hw.lz4";


///////////////////////////////////////////////////////////////////	
////			Instantiate the Unit Under Test (UUT)					////
///////////////////////////////////////////////////////////////////	
	lz4_top_v3 uut (
		.clk(clk), 
		.rstN(rstN), 
		.idata(idata), 
		.idata_req(idata_req), 
		.data_terminal(data_terminal), 
		.start_compress(start_compress), 
		.compress_done(compress_done),
		.mfifo_full(mfifo_full), 
		.mfifo_empty(mfifo_empty),
		.file_length(file_length),
		.file_length_valid(file_length_valid),		
		.out_en(out_en), 
		.out_data(out_data), 
		.out_empty(out_empty), 
		.out_valid(out_valid),
		.obuf_full(obuf_full),
		.ohalf_full(ohalf_full),
		.compressed_len(compressed_len),
		// virtual test interface
		.mfifo_valid(mfifo_valid),
		.mfifo_data(mfifo_data)
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
		file_length = 0;
		file_length_valid = 0;
		char = 0;
		// Wait 100 ns for global reset to finish
//		#100;
        
		// Add stimulus here
		#(Tcq*2) rstN = 0;
		#(Tcq*2) rstN = 1;
	end
      
	// clock generation
	always clk = #(Tcq/2) ~clk;
	
	// test case
	initial
	begin
		#500;  // wait for PLL locked 
		file_length_calc();
		compress_test_start();
		fp_r = $fopen(SRC_FILE_PATH,"rb"); 
		fp_w = $fopen(DEST_FILE_PATH,"wb"); 
//		fp_t = $fopen(TEST_FILE_PATH,"wb");
		
		$fclose(fp_w);  // pseduo open for initial output file
		
		file_length_init();	
		i = 0;
		while(i<file_len) // (!($feof(fp_r)))
		begin
			if(ohalf_full)
			begin
				idata_req =	1'b0;
				$display("Jump in read o_buffer");
				write_16kbytes();
			end
			while(mfifo_full)
			begin
				idata_req	=	1'b0;
				if(ohalf_full)
				begin
					$display("Jump in read o_buffer");
					write_16kbytes();
				end
				#Tcq ;
			end
			read_4B_src();
			#Tcq	i = i + 4;
		end
		idata			=	32'b0	;
		idata_req	=	1'b0	;
		
		while(!compress_done)
		begin
			#Tcq;
//			feedback_test_file();	// ##
			if(ohalf_full)
			begin
				$display("Jump in read o_buffer");
				write_16kbytes();
			end
		end
		
		write_last_block();
		write_length();
		$display("file length is %d Bytes , process time is: %d us",file_len,$time/1000.0);
//		$fclose(fp_t);
		#(Tcq*10);
		$stop;
	end
	
//////////////////////////////////////////////////////////	
//////                task defination               //////
//////////////////////////////////////////////////////////
	
	// read 32bit data from source file
	task	read_4B_src;
		begin
//			feedback_test_file();	// ##
			$fscanf(fp_r,"%c%c%c%c",idata[31:24],idata[23:16],idata[15:8],idata[7:0]);
			//$display("%s",buf_idata);
			idata_req	=	1'b1	;
		end
	endtask
	
	// compress start signal generation
	task	compress_test_start;
		begin
			#(Tcq*2) start_compress = 1'b0;
			#(Tcq*2) start_compress = 1'b1;
			#(Tcq*1) start_compress = 1'b0;
		end
	endtask
	
	// compress done signal generation
	task	compress_test_done;
		begin
			#(Tcq*6) data_terminal = 1'b1;
		end
	endtask
	
	// file length reg initial
	task	file_length_init;
		begin
			#Tcq 	file_length 		= 32'b0;
					file_length_valid = 1'b0;
			#Tcq 	file_length 		= 32'hFFFF_FFFF & file_len;
					file_length_valid = 1'b1;
			#Tcq 	file_length 		= 32'b0;
					file_length_valid = 1'b0;
		end
	endtask
	
	// file length calculate
	task	file_length_calc;
		begin
			#(Tcq*20)
			i = 0;
			fp_r = $fopen(SRC_FILE_PATH,"rb"); 
			char = $fgetc(fp_r);
			while(!($feof(fp_r)))
			begin
				//#(Tcq);
				i = i + 1;
				char = $fgetc(fp_r);
				//$display("%c",char);
			end
			file_len = i;
			$fclose(fp_r);
			$display("The file length is 0x%x",file_len);
			i = 0;
		end
	endtask
	
	// write compressed data 32Kbytes block to file when compression process not done
	task	write_16kbytes;
		begin
			fp_w = $fopen(DEST_FILE_PATH,"ab+"); 
			for(j=0;j<4096;j=j+1)
			begin
//				feedback_test_file();	// ##
				out_en = 1'b1;
				#Tcq;
				if(out_valid)
					$fwrite(fp_w,"%c%c%c%c",out_data[31:24],out_data[23:16],out_data[15:8],out_data[7:0]);
			end
			out_en = 1'b0;
			$fclose(fp_w);
		end
	endtask
	
	// write last compressed data block to file when compression process done
	task	write_last_block;
		begin
			i = 0;
			fp_w = $fopen(DEST_FILE_PATH,"ab+"); 
			while(!out_empty)
			begin
//				feedback_test_file();	// ##
				out_en = 1'b1;
				#Tcq;
				if(out_valid)
					$fwrite(fp_w,"%c%c%c%c",out_data[31:24],out_data[23:16],out_data[15:8],out_data[7:0]);
			end
			out_en = 1'b0;
			$fclose(fp_w);
		end
	endtask
	
	// write compressed data length to file when compression process done
	task	write_length;
		begin
			#(Tcq*20)
			fp_w = $fopen(DEST_FILE_PATH,"rb+"); 
			$display("The fseek return value = %d",$fseek(fp_w,FRAME_LEN_POS,0));
			$fwrite(fp_w,"%c%c%c%c",compressed_len[7:0],compressed_len[15:8],compressed_len[23:16],compressed_len[31:24]);
			$fclose(fp_w);
		end
	endtask
	
	// write mfifo data to file fp_t
	task	feedback_test_file;
		begin
			if(mfifo_valid)
				$fwrite(fp_t,"%c%c%c%c",mfifo_data[31:24],mfifo_data[23:16],mfifo_data[15:8],mfifo_data[7:0]);
		end
	endtask
	
endmodule

