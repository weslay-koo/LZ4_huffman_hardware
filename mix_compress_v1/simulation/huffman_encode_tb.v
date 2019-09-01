`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:12:19 07/20/2016
// Design Name:   huffman_encoder
// Module Name:   F:/LZ4/semi_huffman/semi_huffman/huffman/SIM/huffman_encode_tb.v
// Project Name:  huffman
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: huffman_encoder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
`include "include.v"
module huffman_encode_tb;

	// Inputs
	reg clk;
	reg rstN;
	reg start;
	reg clean;
	reg [31:0] in_data;
	reg in_valid;
	reg in_end;
	reg [2:0] last_mask;
	reg out_en;
	reg stat_end;
	
	`ifdef DEBUG_TREE
	// debug input 
	reg debug_en;
	reg debug_rd;
	reg [7:0] debug_odd_addr;
	reg [7:0] debug_even_addr;
	// debug output
	wire [9:0] debug_odd_data;
	wire [9:0] debug_even_data;
	`endif
	
	// Outputs
	wire in_full;
	wire [31:0] out_data;
	wire out_valid;
	wire out_empty;
	wire out_hfull,out_full;
	wire stat_empty;
	wire done;
	
	// variable
	integer i,j,k,file_len;
	integer fp_r,fp_w,fp_debug;
	reg [7:0] char;
	reg [31:0] file_len_reg;
	
	// parameter
	parameter	Tcq =  4; 
	parameter	FRAME_LEN_POS = 4;
	parameter	STAT_LEN	=	32'd8192;
	parameter	DEBUG_FILE_PATH = "./test_out/DEBUG.dump";
	
///////////////////////////////////////////////////////////////////	
////			 	calgary	test case V4 [100MHz / 250MHz]			////
///////////////////////////////////////////////////////////////////
//	parameter	SRC_FILE_PATH = "./test_src/test1.txt"; // OK
//	parameter	DEST_FILE_PATH = "./test_out/test1_hw.huff";

//	parameter	SRC_FILE_PATH = "./test_src/words";		// OK
//	parameter	DEST_FILE_PATH = "./test_out/words_hw.huff";

//	parameter	SRC_FILE_PATH = "./test_src/numbers";	// OK
//	parameter	DEST_FILE_PATH = "./test_out/num_hw.huff";

//	parameter	SRC_FILE_PATH = "./test_src/numlit";	// OK
//	parameter	DEST_FILE_PATH = "./test_out/numlit_hw.huff";

//	parameter	SRC_FILE_PATH = "./test_src/zero";	// 15us
//	parameter	DEST_FILE_PATH = "./test_out/zero_hw.lz4";
	
//	parameter	SRC_FILE_PATH = "./test_src/space";	// 5us
//	parameter	DEST_FILE_PATH = "./test_out/space_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/spclit";	// 
//	parameter	DEST_FILE_PATH = "./test_out/spclit_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/README_hw.lz4";	// OK
//	parameter	DEST_FILE_PATH = "./test_out/README_hwhw.shuff";

//	parameter	SRC_FILE_PATH = "./test_src/README";	// OK
//	parameter	DEST_FILE_PATH = "./test_out/README_hw.shuff";

//	parameter	SRC_FILE_PATH = "./test_src/paper1";	//	OK [729us / 292us]  (977us / 391us)  1223us / 489us
//	parameter	DEST_FILE_PATH = "./test_out/paper1_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/paper3";	//	OK [700us / 280us]  (942us / 377us)  1182us / 473us
//	parameter	DEST_FILE_PATH = "./test_out/paper3_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/paper4";	//	OK [197us / 79us]  (260us / 104us)  371us / 149us
//	parameter	DEST_FILE_PATH = "./test_out/paper4_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/paper5";	// OK
//	parameter	DEST_FILE_PATH = "./test_out/paper5_hw.huff";

//	parameter	SRC_FILE_PATH = "./test_src/paper6";	//	OK [502us / 201us]  (675us / 270us)  868us / 348us
//	parameter	DEST_FILE_PATH = "./test_out/paper6_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/paper2";	//	OK [1235us / 494us]  (1661us / 665us)  1951us / 781us
//	parameter	DEST_FILE_PATH = "./test_out/paper2_hw.lz4";
//	parameter	TEST_FILE_PATH	= "./test_feedback/paper2.fb";

//	parameter	SRC_FILE_PATH = "./test_src/bib_hw.lz4";		//	OK [1363us / 545us]	(1837us / 735us)  2261us / 904us
//	parameter	DEST_FILE_PATH = "./test_out/bib_hwhw.shuff";

//	parameter	SRC_FILE_PATH = "./test_src/geo";		//	[1272us / 509us]	(1638us / 656us)  3827us / 1531us
//	parameter	DEST_FILE_PATH = "./test_out/geo_hw.lz4";
	
//	parameter	SRC_FILE_PATH = "./test_src/obj1";		//	[247us / 99us]	(315us / 126us) 	589us / 236us
//	parameter	DEST_FILE_PATH = "./test_out/obj1_hw.lz4";
	
//	parameter	SRC_FILE_PATH = "./test_src/progc";		//	[499us / 200us]	(672us / 269us)	879us / 352us
//	parameter	DEST_FILE_PATH = "./test_out/progc_hw.lz4";
	
//	parameter	SRC_FILE_PATH = "./test_src/progp";		// [495us / 198us]	(656us / 263us)	804us / 322us
//	parameter	DEST_FILE_PATH = "./test_out/progp_hw.lz4";
	
//	parameter	SRC_FILE_PATH = "./test_src/progl";		// [786us / 315us]	(1038us / 416us)	1227us / 491us error
//	parameter	DEST_FILE_PATH = "./test_out/progl_hw.lz4";
	
//	parameter	SRC_FILE_PATH = "./test_src/trans";		// [849us / 340us]	(1107us / 443us)  1367us / 547us
//	parameter	DEST_FILE_PATH = "./test_out/trans_hw.lz4";
	
////// file over 128KB
//	parameter	SRC_FILE_PATH = "./test_src/obj2";		//	[2674us / 1070us]	(3598us / 1439us)  5023us / 2009us
//	parameter	DEST_FILE_PATH = "./test_out/obj2_hw.lz4";		

//// file over 256KB
//	parameter	SRC_FILE_PATH = "./test_src/news";		//	[4733us / 1894us]	(6414us / 2565us)  8451us / 3380us
//	parameter	DEST_FILE_PATH = "./test_out/news_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/pic";		// [2803us / 1121us]	(3444us / 1378us)  4526us / 1811us
//	parameter	DEST_FILE_PATH = "./test_out/pic_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/book1";		// [12549us / 5020us]	(17048us / 6819us)  19571us / 7829us
//	parameter	DEST_FILE_PATH = "./test_out/book1_hw.lz4";
	
//	parameter	SRC_FILE_PATH = "./test_src/book2";		// [8547us / 3419us]	(11537us / 4615us)  13252us / 5301us
//	parameter	DEST_FILE_PATH = "./test_out/book2_hw.lz4";
	
////// file over 1MB	
//	parameter	SRC_FILE_PATH = "./test_src/over1M.pdf";	// [ / 5897us] 43031us
//	parameter	DEST_FILE_PATH = "./test_out/over1M_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/jpg1M";	// fsm stop at 0x0e error
//	parameter	DEST_FILE_PATH = "./test_out/jpg1M_hw.lz4";

////// file over 4MB	
//	parameter	SRC_FILE_PATH = "./test_src/equ4M_ascii.txt";	// 6442us
//	parameter	DEST_FILE_PATH = "./test_out/equ4M_ascii_hw.lz4";	
	
///////////////////////////////////////////////////////////////////	
////			 	cantegary	test case 	(250MHz)						////
///////////////////////////////////////////////////////////////////	
//	parameter	SRC_FILE_PATH = "./test_src/kennedy.xls";	// [4042us]	6561us
//	parameter	DEST_FILE_PATH = "./test_out/kennedy_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/sum"; // [163us] 327us
//	parameter	DEST_FILE_PATH = "./test_out/sum_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/ptt5"; // [1121us] 1811us
//	parameter	DEST_FILE_PATH = "./test_out/ptt5_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/xargs.1"; // [24us] 47us
//	parameter	DEST_FILE_PATH = "./test_out/xargs_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/grammar.lsp"; // [18us] 35us
//	parameter	DEST_FILE_PATH = "./test_out/grammar_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/alice29.txt"; // [927us] 1427us
//	parameter	DEST_FILE_PATH = "./test_out/alice29_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/fields.c";  // [56us] 93us
//	parameter	DEST_FILE_PATH = "./test_out/fields_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/lcet10.txt"; // [2457us] 3738us
//	parameter	DEST_FILE_PATH = "./test_out/lcet10_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/plrabn12.txt"; // [3234us] 4944us
//	parameter	DEST_FILE_PATH = "./test_out/plrabn12_hw.lz4";

//	parameter	SRC_FILE_PATH = "./test_src/asyoulik.txt"; // [784us] 1242us
//	parameter	DEST_FILE_PATH = "./test_out/asyoulik_hw.lz4";

	parameter	SRC_FILE_PATH = "./test_src/cp_hw.lz4"; // [111us] 213us
	parameter	DEST_FILE_PATH = "./test_out/cp_hwhw.shuff";
	
	
	
///////////////////////////////////////////////////////////////////	
////			Instantiate the Unit Under Test (UUT)					////
///////////////////////////////////////////////////////////////////	
	huffman_encoder_v5 uut 
	(
		.clk(clk), 
		.rstN(rstN), 
		.start(start), 
		.clean(clean), 
		.in_data(in_data), 
		.in_valid(in_valid),
		.last_mask(last_mask),
		.stat_end(stat_end),
		.in_end(in_end), 
		.out_en(out_en), 
		
		`ifdef DEBUG_TREE
		// Debug port of huffman tree ram data
		.debug_en(debug_en),
		.debug_rd(debug_rd),
		.debug_odd_addr(debug_odd_addr),
		.debug_even_addr(debug_even_addr),
		.debug_odd_data(debug_odd_data),
		.debug_even_data(debug_even_data),
		`endif
		
		.done(done),
		.stat_empty(stat_empty),
		.in_full(in_full), 
		.out_data(out_data), 
		.out_valid(out_valid), 
		.out_empty(out_empty),
		.out_full(out_full),
		.out_hfull(out_hfull)
	);


	initial 
	begin
		// Initialize Inputs
		clk = 0;
		rstN = 0;
		start = 0;
		clean = 0;
		in_data = 0;
		in_valid = 0;
		in_end = 0;
		out_en = 0;
		last_mask = 0;
		stat_end = 0;
		file_len_reg = 0;
		
		`ifdef DEBUG_TREE
		// debug input 
		debug_en = 0;
		debug_rd = 0;
		debug_odd_addr = 0;
		debug_even_addr = 0;
		`endif
		
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
		#500;  // wait for PLL locked 
		file_length_calc();
		huffman_test_start();
		fp_r = $fopen(SRC_FILE_PATH,"rb"); 
		fp_w = $fopen(DEST_FILE_PATH,"wb"); 
		//fp_debug = $fopen(DEBUG_FILE_PATH,"wb"); 
		
		$fclose(fp_w);  // pseduo open for initial output file
		//$fclose(fp_debug); 
		
		i = 0;
		while((i + 4)<file_len) // (!($feof(fp_r)))
		begin
			if(out_hfull)
			begin
				in_valid =	1'b0;
				$display("Jump in read o_buffer");
				write_16kbytes();
			end
			
			while(in_full)
			begin
				in_valid	=	1'b0;
				if(out_hfull)
				begin
					$display("Jump in read o_buffer");
					write_16kbytes();
				end
				#Tcq ;
			end
			
			if((i + 4) >= STAT_LEN)
			begin
				stat_end_up();
			end
			
			read_4B_src();
			
			#Tcq	i = i + 4;
		end
		
		read_4B_src();
		
		if(i < STAT_LEN)
		begin
			stat_end_up();
		end
		
		last_mask = file_len - i;
		src_end_up();
		#(Tcq)	in_data	=	32'b0	;
					in_valid	=	1'b0	;
		
		while(!done)
		begin
			#Tcq;
			if(out_hfull)
			begin
				$display("Jump in read o_buffer");
				write_16kbytes();
			end
		end
		
		write_last_block();
		
		write_length();
		
		`ifdef DEBUG_TREE
			write_debug_tree();
		`endif
		
		$display("file length is %d Bytes , process time is: %d us",file_len,$time/1000.0);
		#(Tcq*10);
		$stop;
	end
	
	
	
//////////////////////////////////////////////////////////	
//////                task defination               //////
//////////////////////////////////////////////////////////	
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
	
	// huffman code start signal generation
	task	huffman_test_start;
		begin
			#(Tcq*2) start = 1'b0;
			#(Tcq*2) start = 1'b1;
			#(Tcq*1) start = 1'b0;
		end
	endtask
	
	// input source end signal high-level output generation
	task	src_end_up;
		begin
			in_end = 1'b1;
		end
	endtask
	
	// data statistic end signal high-level output generation
	task	stat_end_up;
		begin
			stat_end	=	1'b1;
		end
	endtask
	
	// read 32bit data from source file
	task	read_4B_src;
		begin
			$fscanf(fp_r,"%c%c%c%c",in_data[31:24],in_data[23:16],in_data[15:8],in_data[7:0]);
			in_valid	=	1'b1	;
		end
	endtask
	
	// write compressed data 32Kbytes block to file when compression process not done
	task	write_8kbytes;
		begin
			fp_w = $fopen(DEST_FILE_PATH,"ab+"); 
			for(j=0;j<2048;j=j+1)
			begin
				out_en = 1'b1;
				#Tcq;
				if(out_valid)
					$fwrite(fp_w,"%c%c%c%c",out_data[31:24],out_data[23:16],out_data[15:8],out_data[7:0]);
			end
			out_en = 1'b0;
			$fclose(fp_w);
		end
	endtask
	
	// write compressed data 32Kbytes block to file when compression process not done
	task	write_16kbytes;
		begin
			fp_w = $fopen(DEST_FILE_PATH,"ab+"); 
			for(j=0;j<4096;j=j+1)
			begin
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
			#(Tcq*20);
			file_len_reg = file_len & 32'hFFFF_FFFF;
			fp_w = $fopen(DEST_FILE_PATH,"rb+"); 
			$display("The fseek return value = %d",$fseek(fp_w,FRAME_LEN_POS,0));
			$fwrite(fp_w,"%c%c%c%c",file_len_reg[7:0],file_len_reg[15:8],file_len_reg[23:16],file_len_reg[31:24]);
			$fclose(fp_w);
		end
	endtask
	
	`ifdef DEBUG_TREE
	// DEBUG : write tree odd and even ram data to file
	task write_debug_tree;
		begin
			#(Tcq*20);
			fp_debug = $fopen(DEBUG_FILE_PATH,"wb"); 
			debug_en = 1'b1;
			#(Tcq*4);
			for(k = 0; k < 256; k = k+1)
			begin
				debug_rd = 1'b1;
				debug_odd_addr = k & 8'hFF;
				debug_even_addr = k & 8'hFF;
				#Tcq;
				$fwrite(fp_debug,"%c%c",{6'b0,debug_even_data[9:8]},debug_even_data[7:0]);
				$fwrite(fp_debug,"%c%c",{6'b0,debug_odd_data[9:8]},debug_odd_data[7:0]);
			end
			$fclose(fp_debug);
			$display("The debug data has been dumped");
		end
	endtask
	`endif
	
endmodule

