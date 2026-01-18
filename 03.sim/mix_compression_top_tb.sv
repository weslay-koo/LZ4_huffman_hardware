`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:07:04 03/29/2017
// Design Name:   mix_compression_top
// Module Name:   F:/LZ4/mix_compress/mix_compress_v1/simulation/mix_compression_top_tb.v
// Project Name:  mix_compress_v1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mix_compression_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
`include "../02.rtl/include.v"
module mix_compression_top_tb;

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
	reg [16:0] max_stat_len;
	reg max_stat_valid;
	reg clean;
	
	// Outputs
	wire mfifo_full;
	wire mfifo_empty;
	wire [31:0] out_data;
	wire out_empty;
	wire out_valid;
	wire obuf_full;
	wire ohalf_full;
	wire compress_done;
	wire [31:0] source_len;
	
	`ifdef DEBUG_TREE
		// debug variable
		integer fp_debug;
		// debug input 
		reg debug_en;
		reg debug_rd;
		reg [7:0] debug_odd_addr;
		reg [7:0] debug_even_addr;
		// debug output
		wire [9:0] debug_odd_data;
		wire [9:0] debug_even_data;
	`endif
	
	// test interface
	wire [31:0] mfifo_data;
	wire mfifo_valid;
	
	// variable
	integer i,j,k,file_len;
	integer fp_r,fp_w,fp_t,fp_log;
	reg [7:0] char;
	`ifdef AUTO_TEST
		reg [8*128:1] SRC_FILE_PATH;
		reg [8*128:1] DEST_FILE_PATH;
		reg [16:0]	  MAX_STAT_LENGTH;
		reg [31:0]	  sel_file_num;
	`endif
	
	
	// parameter
	parameter	Tcq =  4; // 10; // 
	parameter	FRAME_LEN_POS = 4;
	`ifndef AUTO_TEST
		parameter	MAX_STAT_LENGTH = 17'd65536;
	`endif
	parameter SRC_BASE_PATH  =   "../../../../../03.sim/test_src";
	parameter DST_BASE_PATH  =   "../../../../../03.sim/test_out";

	parameter	DEBUG_FILE_PATH = $sformatf("%s/semihuffman/DEBUG.dump",DST_BASE_PATH);
	parameter	PROC_TIME_LOG = $sformatf("%s/semihuffman/time_usage.simlog",DST_BASE_PATH);
	
///////////////////////////////////////////////////////////////////	
////			 	calgary	test case V4 [100MHz / 250MHz]			////
///////////////////////////////////////////////////////////////////
//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/words",SRC_BASE_PATH);
//	parameter	DEST_FILE_PATH = $sformatf("%s/words_hw.lz4",DST_BASE_PATH);

//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/numbers",SRC_BASE_PATH);
//	parameter	DEST_FILE_PATH = $sformatf("%s/num_hw.lz4",DST_BASE_PATH);

//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/numlit",SRC_BASE_PATH);
//	parameter	DEST_FILE_PATH = $sformatf("%s/semihuffman/numlit_mhw.shuff",DST_BASE_PATH);

//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/zero",SRC_BASE_PATH);	// 15us
//	parameter	DEST_FILE_PATH = $sformatf("%s/zero_hw.lz4",DST_BASE_PATH);
	
//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/space",SRC_BASE_PATH);	// 5us
//	parameter	DEST_FILE_PATH = $sformatf("%s/space_hw.lz4",DST_BASE_PATH);

//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/spclit",SRC_BASE_PATH);	// 6us  compress ratio error
//	parameter	DEST_FILE_PATH = $sformatf("%s/spclit_hw.lz4",DST_BASE_PATH);

//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/README",SRC_BASE_PATH);	//	OK [36us / 15us]  (46us / 19us)  84us / 34us
//	parameter	DEST_FILE_PATH = $sformatf("%s/semihuffman/README_mhw.shuff",DST_BASE_PATH);

parameter	SRC_FILE_PATH = $sformatf("%s/compress/paper1",SRC_BASE_PATH);	//	{289us 4K} {288us 8K} [729us / 292us]  (977us / 391us)  1223us / 489us
parameter	DEST_FILE_PATH = $sformatf("%s/semihuffman/paper1_mhw.shuff",DST_BASE_PATH);

//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/paper3",SRC_BASE_PATH);	//	{277us 4K} {277us 8K} [700us / 280us]  (942us / 377us)  1182us / 473us
//	parameter	DEST_FILE_PATH = $sformatf("%s/semihuffman/paper3_mhw.shuff",DST_BASE_PATH);

//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/paper4",SRC_BASE_PATH);	//	{122us 4K} {166us 8K} [197us / 79us]  (260us / 104us)  371us / 149us
//	parameter	DEST_FILE_PATH = $sformatf("%s/semihuffman/paper4_mhw.shuff",DST_BASE_PATH);

//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/paper5",SRC_BASE_PATH);	//	{117us 4K} {154us 8K} [175us / 70us]  (230us / 92us)  333us / 133us
//	parameter	DEST_FILE_PATH = $sformatf("%s/semihuffman/paper5_mhw.shuff",DST_BASE_PATH);

//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/paper6",SRC_BASE_PATH);	//	{199us 4K} {221us 8K} [502us / 201us]  (675us / 270us)  868us / 348us
//	parameter	DEST_FILE_PATH = $sformatf("%s/semihuffman/paper6_mhw.shuff",DST_BASE_PATH);

//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/paper2",SRC_BASE_PATH);	// {490us 4K} {488us 8K} [1235us / 494us]  (1661us / 665us)  1951us / 781us
//	parameter	DEST_FILE_PATH = $sformatf("%s/semihuffman/paper2_mhw.shuff",DST_BASE_PATH);
//	parameter	TEST_FILE_PATH	= "./test_feedback/paper2.fb";

// parameter	SRC_FILE_PATH = $sformatf("%s/compress/bib",SRC_BASE_PATH);		// {542us 4K} {556us 8K} [1363us / 545us]	(1837us / 735us)  2261us / 904us
// parameter	DEST_FILE_PATH = $sformatf("%s/semihuffman/bib_mhw.shuff",DST_BASE_PATH);

//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/geo",SRC_BASE_PATH);		//	{513us 4K} {509us 8K} [1272us / 509us]	(1638us / 656us)  3827us / 1531us
//	parameter	DEST_FILE_PATH = $sformatf("%s/semihuffman/geo_mhw.shuff",DST_BASE_PATH);
	
//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/obj1",SRC_BASE_PATH);		//	{151us 4K} {183us 8K} [247us / 99us]	(315us / 126us) 	589us / 236us
//	parameter	DEST_FILE_PATH = $sformatf("%s/semihuffman/obj1_mhw.shuff",DST_BASE_PATH);
	
//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/progc",SRC_BASE_PATH);		//	{198us 4K} {214us 8K} [499us / 200us]	(672us / 269us)	879us / 352us
//	parameter	DEST_FILE_PATH = $sformatf("%s/semihuffman/progc_mhw.shuff",DST_BASE_PATH);
	
//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/progp",SRC_BASE_PATH);		// {212us 4K} {219us 8K} [495us / 198us]	(656us / 263us)	804us / 322us
//	parameter	DEST_FILE_PATH = $sformatf("%s/semihuffman/progp_mhw.shuff",DST_BASE_PATH);
	
//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/progl",SRC_BASE_PATH);		// {310us 4K} {310us 8K} [786us / 315us]	(1038us / 416us)	1227us / 491us error
//	parameter	DEST_FILE_PATH = $sformatf("%s/semihuffman/progl_mhw.shuff",DST_BASE_PATH);
	
//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/trans",SRC_BASE_PATH);		// {337us 4K} {336us 8K} [849us / 340us]	(1107us / 443us)  1367us / 547us
//	parameter	DEST_FILE_PATH = $sformatf("%s/semihuffman/trans_mhw.shuff",DST_BASE_PATH);
	
//// file over 128KB
//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/obj2",SRC_BASE_PATH);		//	{1077us 4K} {1073us 8K} [2674us / 1070us]	(3598us / 1439us)  5023us / 2009us
//	parameter	DEST_FILE_PATH = $sformatf("%s/semihuffman/obj2_mhw.shuff",DST_BASE_PATH);		

//// file over 256KB
//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/news",SRC_BASE_PATH);		//	{1893us 4K} {1888us 8K} [4733us / 1894us]	(6414us / 2565us)  8451us / 3380us
//	parameter	DEST_FILE_PATH = $sformatf("%s/semihuffman/news_mhw.shuff",DST_BASE_PATH);

//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/pic",SRC_BASE_PATH);		// {1124us 4K} {1122us 8K} [2803us / 1121us]	(3444us / 1378us)  4526us / 1811us
//	parameter	DEST_FILE_PATH = $sformatf("%s/semihuffman/pic_mhw.shuff",DST_BASE_PATH);

//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/book1",SRC_BASE_PATH);		// {5011us 4K} {5018us 8K} [12549us / 5020us]	(17048us / 6819us)  19571us / 7829us
//	parameter	DEST_FILE_PATH = $sformatf("%s/semihuffman/book1_mhw.shuff",DST_BASE_PATH);
	
//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/book2",SRC_BASE_PATH);		// {3419us 4K} {3408us 8K} [8547us / 3419us]	(11537us / 4615us)  13252us / 5301us
//	parameter	DEST_FILE_PATH = $sformatf("%s/semihuffman/book2_mhw.shuff",DST_BASE_PATH);
	
////// file over 1MB	
//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/over1M.pdf",SRC_BASE_PATH);	// [ / 5897us] 43031us
//	parameter	DEST_FILE_PATH = $sformatf("%s/over1M_hw.lz4",DST_BASE_PATH);

//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/jpg1M",SRC_BASE_PATH);	// fsm stop at 0x0e error
//	parameter	DEST_FILE_PATH = $sformatf("%s/jpg1M_hw.lz4",DST_BASE_PATH);

////// file over 4MB	
//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/equ4M_ascii.txt",SRC_BASE_PATH);	// 6442us
//	parameter	DEST_FILE_PATH = $sformatf("%s/equ4M_ascii_hw.lz4",DST_BASE_PATH);	
	
///////////////////////////////////////////////////////////////////	
////			 	cantegary	test case 	(250MHz)						////
///////////////////////////////////////////////////////////////////	
//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/kennedy.xls",SRC_BASE_PATH);	// {4038us 4K} {4039us 8K} [4042us]	6561us
//	parameter	DEST_FILE_PATH = $sformatf("%s/semihuffman/kennedy_mhw.shuff",DST_BASE_PATH);

//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/sum",SRC_BASE_PATH); // {177us 4K} {203us 8K} [163us] 327us
//	parameter	DEST_FILE_PATH = $sformatf("%s/semihuffman/sum_mhw.shuff",DST_BASE_PATH);

//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/ptt5",SRC_BASE_PATH); // {1124us 4K} {1122us 8K} [1121us] 1811us
//	parameter	DEST_FILE_PATH = $sformatf("%s/semihuffman/ptt5_mhw.shuff",DST_BASE_PATH);

//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/xargs.1",SRC_BASE_PATH); // {76us 4K} {76us 8K} [24us] 47us
//	parameter	DEST_FILE_PATH = $sformatf("%s/semihuffman/xargs_mhw.shuff",DST_BASE_PATH);

//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/grammar.lsp",SRC_BASE_PATH); // {65us 4K} {65us 8K} [18us] 35us
//	parameter	DEST_FILE_PATH = $sformatf("%s/semihuffman/grammar_mhw.shuff",DST_BASE_PATH);

//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/alice29.txt",SRC_BASE_PATH); // {932us 4K} {930us 8K} [927us] 1427us
//	parameter	DEST_FILE_PATH = $sformatf("%s/semihuffman/alice29_mhw.shuff",DST_BASE_PATH);

//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/fields.c",SRC_BASE_PATH);  // {114us 4K} {128us 8K} [56us] 93us
//	parameter	DEST_FILE_PATH = $sformatf("%s/semihuffman/fields_mhw.shuff",DST_BASE_PATH);

//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/lcet10.txt",SRC_BASE_PATH); // {2458us 4K} {2451us 8K} [2457us] 3738us
//	parameter	DEST_FILE_PATH = $sformatf("%s/semihuffman/lcet10_mhw.shuff",DST_BASE_PATH);

//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/plrabn12.txt",SRC_BASE_PATH); // {3221us 4K} {3222us 8K} [3234us] 4944us
//	parameter	DEST_FILE_PATH = $sformatf("%s/semihuffman/plrabn12_mhw.shuff",DST_BASE_PATH);

//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/asyoulik.txt",SRC_BASE_PATH); // {778us 4K} {789us 8K} [784us] 1242us
//	parameter	DEST_FILE_PATH = $sformatf("%s/semihuffman/asyoulik_mhw.shuff",DST_BASE_PATH);

//	parameter	SRC_FILE_PATH = $sformatf("%s/compress/cp.html",SRC_BASE_PATH); // {136us 4K} {176us 8K} [111us] 213us
//	parameter	DEST_FILE_PATH = $sformatf("%s/semihuffman/cp_mhw.shuff",DST_BASE_PATH);


///////////////////////////////////////////////////////////////////	
////			Instantiate the Unit Under Test (UUT)					////
///////////////////////////////////////////////////////////////////	
	mix_compression_top uut (
		.clk(clk), 
		.rstN(rstN), 
		.idata(idata), 
		.idata_req(idata_req), 
		.data_terminal(data_terminal), 
		.start_compress(start_compress), 
		.compress_done(compress_done),
		.max_stat_len(max_stat_len),	// max statistic length is 65536
		.max_stat_valid(max_stat_valid),
		.clean(clean),
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
		.source_len(source_len),
		// virtual test interface
		`ifdef DEBUG_TREE
			// Debug port of huffman tree ram data
			.debug_en(debug_en),
			.debug_rd(debug_rd),
			.debug_odd_addr(debug_odd_addr),
			.debug_even_addr(debug_even_addr),
			.debug_odd_data(debug_odd_data),
			.debug_even_data(debug_even_data),
		`endif
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
		max_stat_len = 0;
		max_stat_valid = 0;
		clean = 0;
		char = 0;
		
		`ifdef DEBUG_TREE	// debug input 
			debug_en = 0;
			debug_rd = 0;
			debug_odd_addr = 0;
			debug_even_addr = 0;
		`endif
		
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
		
		`ifdef AUTO_TEST
			select_file();
		`endif
		
		file_length_calc();
		compress_test_start();
		
		fp_r = $fopen(SRC_FILE_PATH,"rb"); 
		fp_w = $fopen(DEST_FILE_PATH,"wb"); 
//		fp_t = $fopen(TEST_FILE_PATH,"wb");
		
		$fclose(fp_w);  // pseduo open for initial output file
		
		file_length_init();	
		max_stat_init();
		
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
		`ifdef DEBUG_TREE
			write_debug_tree();
		`endif
		
		`ifdef AUTO_TEST
			#(Tcq*20);
			fp_log = $fopen(PROC_TIME_LOG,"ab+"); 
			$fwrite(fp_log," (%s:%d us) ",SRC_FILE_PATH,$time/1000.0);
			$fclose(fp_log);
		`endif
		
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
	
	// statistic length reg initial
	task	max_stat_init;
		begin
			#Tcq 	max_stat_len 		= 17'b0;
					max_stat_valid		= 1'b0;
			#Tcq 	max_stat_len 		= MAX_STAT_LENGTH;
					max_stat_valid		= 1'b1;
			#Tcq 	max_stat_len 		= 17'b0;
					max_stat_valid		= 1'b0;
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
			$fwrite(fp_w,"%c%c%c%c",source_len[7:0],source_len[15:8],source_len[23:16],source_len[31:24]);
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
	
	`ifdef AUTO_TEST
		// Automatic test all 29 files
		task select_file;
			begin
				$value$plusargs("NO=%d", sel_file_num);
				MAX_STAT_LENGTH = (sel_file_num >> 8) & 17'h1FFFF;
				case(sel_file_num & 32'hFF)
//				8'd0 : 	begin
//								SRC_FILE_PATH = $sformatf("%s/compress/space",SRC_BASE_PATH);
//								DEST_FILE_PATH = $sformatf("%s/semihuffman/space_mhw.shuff",DST_BASE_PATH);
//							end
//				8'd1 : 	begin
//								SRC_FILE_PATH = $sformatf("%s/compress/spclit",SRC_BASE_PATH);
//								DEST_FILE_PATH = $sformatf("%s/semihuffman/spclit_mhw.shuff",DST_BASE_PATH);
//							end
//				8'd2 : 	begin
//								SRC_FILE_PATH = $sformatf("%s/compress/zero",SRC_BASE_PATH);	
//								DEST_FILE_PATH = $sformatf("%s/semihuffman/zero_mhw.shuff",DST_BASE_PATH);
//							end
							
				8'd0 : 	begin		
								SRC_FILE_PATH = $sformatf("%s/compress/paper1",SRC_BASE_PATH);	//	{289us 4K} {288us 8K} [729us / 292us]  (977us / 391us)  1223us / 489us
								DEST_FILE_PATH = $sformatf("%s/semihuffman/paper1_mhw.shuff",DST_BASE_PATH);
							end
				8'd1 : 	begin
								SRC_FILE_PATH = $sformatf("%s/compress/paper3",SRC_BASE_PATH);	//	{277us 4K} {277us 8K} [700us / 280us]  (942us / 377us)  1182us / 473us
								DEST_FILE_PATH = $sformatf("%s/semihuffman/paper3_mhw.shuff",DST_BASE_PATH);
							end
				8'd2 : 	begin
								SRC_FILE_PATH = $sformatf("%s/compress/paper4",SRC_BASE_PATH);	//	{122us 4K} {166us 8K} [197us / 79us]  (260us / 104us)  371us / 149us
								DEST_FILE_PATH = $sformatf("%s/semihuffman/paper4_mhw.shuff",DST_BASE_PATH);
							end
				8'd3 : 	begin
								SRC_FILE_PATH = $sformatf("%s/compress/paper5",SRC_BASE_PATH);	//	{117us 4K} {154us 8K} [175us / 70us]  (230us / 92us)  333us / 133us
								DEST_FILE_PATH = $sformatf("%s/semihuffman/paper5_mhw.shuff",DST_BASE_PATH);
							end
				8'd4 : 	begin
								SRC_FILE_PATH = $sformatf("%s/compress/paper6",SRC_BASE_PATH);	//	{199us 4K} {221us 8K} [502us / 201us]  (675us / 270us)  868us / 348us
								DEST_FILE_PATH = $sformatf("%s/semihuffman/paper6_mhw.shuff",DST_BASE_PATH);
							end
				8'd5 : 	begin
								SRC_FILE_PATH = $sformatf("%s/compress/paper2",SRC_BASE_PATH);	// {490us 4K} {488us 8K} [1235us / 494us]  (1661us / 665us)  1951us / 781us
								DEST_FILE_PATH = $sformatf("%s/semihuffman/paper2_mhw.shuff",DST_BASE_PATH);
							end
				8'd6 : 	begin
								SRC_FILE_PATH = $sformatf("%s/compress/bib",SRC_BASE_PATH);		// {542us 4K} {556us 8K} [1363us / 545us]	(1837us / 735us)  2261us / 904us
								DEST_FILE_PATH = $sformatf("%s/semihuffman/bib_mhw.shuff",DST_BASE_PATH);
							end
				8'd7 : 	begin
								SRC_FILE_PATH = $sformatf("%s/compress/geo",SRC_BASE_PATH);		//	{513us 4K} {509us 8K} [1272us / 509us]	(1638us / 656us)  3827us / 1531us
								DEST_FILE_PATH = $sformatf("%s/semihuffman/geo_mhw.shuff",DST_BASE_PATH);
							end
				8'd8 : 	begin
								SRC_FILE_PATH = $sformatf("%s/compress/obj1",SRC_BASE_PATH);		//	{151us 4K} {183us 8K} [247us / 99us]	(315us / 126us) 	589us / 236us
								DEST_FILE_PATH = $sformatf("%s/semihuffman/obj1_mhw.shuff",DST_BASE_PATH);
							end
				8'd9 : 	begin
								SRC_FILE_PATH = $sformatf("%s/compress/progc",SRC_BASE_PATH);		//	{198us 4K} {214us 8K} [499us / 200us]	(672us / 269us)	879us / 352us
								DEST_FILE_PATH = $sformatf("%s/semihuffman/progc_mhw.shuff",DST_BASE_PATH);
							end
				8'd10 : 	begin
								SRC_FILE_PATH = $sformatf("%s/compress/progp",SRC_BASE_PATH);		// {212us 4K} {219us 8K} [495us / 198us]	(656us / 263us)	804us / 322us
								DEST_FILE_PATH = $sformatf("%s/semihuffman/progp_mhw.shuff",DST_BASE_PATH);
							end
				8'd11 : 	begin
								SRC_FILE_PATH = $sformatf("%s/compress/progl",SRC_BASE_PATH);		// {310us 4K} {310us 8K} [786us / 315us]	(1038us / 416us)	1227us / 491us error
								DEST_FILE_PATH = $sformatf("%s/semihuffman/progl_mhw.shuff",DST_BASE_PATH);
							end
				8'd12 : 	begin
								SRC_FILE_PATH = $sformatf("%s/compress/trans",SRC_BASE_PATH);		// {337us 4K} {336us 8K} [849us / 340us]	(1107us / 443us)  1367us / 547us
								DEST_FILE_PATH = $sformatf("%s/semihuffman/trans_mhw.shuff",DST_BASE_PATH);
							end
				8'd13 : 	begin
								SRC_FILE_PATH = $sformatf("%s/compress/obj2",SRC_BASE_PATH);		//	{1077us 4K} {1073us 8K} [2674us / 1070us]	(3598us / 1439us)  5023us / 2009us
								DEST_FILE_PATH = $sformatf("%s/semihuffman/obj2_mhw.shuff",DST_BASE_PATH);		
							end
				8'd14 : 	begin
								SRC_FILE_PATH = $sformatf("%s/compress/news",SRC_BASE_PATH);		//	{1893us 4K} {1888us 8K} [4733us / 1894us]	(6414us / 2565us)  8451us / 3380us
								DEST_FILE_PATH = $sformatf("%s/semihuffman/news_mhw.shuff",DST_BASE_PATH);
							end
				8'd15 : 	begin
								SRC_FILE_PATH = $sformatf("%s/compress/pic",SRC_BASE_PATH);		// {1124us 4K} {1122us 8K} [2803us / 1121us]	(3444us / 1378us)  4526us / 1811us
								DEST_FILE_PATH = $sformatf("%s/semihuffman/pic_mhw.shuff",DST_BASE_PATH);
							end
				8'd16 : 	begin
								SRC_FILE_PATH = $sformatf("%s/compress/book1",SRC_BASE_PATH);		// {5011us 4K} {5018us 8K} [12549us / 5020us]	(17048us / 6819us)  19571us / 7829us
								DEST_FILE_PATH = $sformatf("%s/semihuffman/book1_mhw.shuff",DST_BASE_PATH);
							end
				8'd17 : 	begin
								SRC_FILE_PATH = $sformatf("%s/compress/book2",SRC_BASE_PATH);		// {3419us 4K} {3408us 8K} [8547us / 3419us]	(11537us / 4615us)  13252us / 5301us
								DEST_FILE_PATH = $sformatf("%s/semihuffman/book2_mhw.shuff",DST_BASE_PATH);
							end
				8'd18 : 	begin
								SRC_FILE_PATH = $sformatf("%s/compress/kennedy.xls",SRC_BASE_PATH);	// {4038us 4K} {4039us 8K} [4042us]	6561us
								DEST_FILE_PATH = $sformatf("%s/semihuffman/kennedy_mhw.shuff",DST_BASE_PATH);
							end
				8'd19 : 	begin
								SRC_FILE_PATH = $sformatf("%s/compress/sum",SRC_BASE_PATH); // {177us 4K} {203us 8K} [163us] 327us
								DEST_FILE_PATH = $sformatf("%s/semihuffman/sum_mhw.shuff",DST_BASE_PATH);
							end
				8'd20 : 	begin
								SRC_FILE_PATH = $sformatf("%s/compress/ptt5",SRC_BASE_PATH); // {1124us 4K} {1122us 8K} [1121us] 1811us
								DEST_FILE_PATH = $sformatf("%s/semihuffman/ptt5_mhw.shuff",DST_BASE_PATH);
							end
				8'd21 : 	begin
								SRC_FILE_PATH = $sformatf("%s/compress/xargs.1",SRC_BASE_PATH); // {76us 4K} {76us 8K} [24us] 47us
								DEST_FILE_PATH = $sformatf("%s/semihuffman/xargs_mhw.shuff",DST_BASE_PATH);
							end
				8'd22 : 	begin
								SRC_FILE_PATH = $sformatf("%s/compress/grammar.lsp",SRC_BASE_PATH); // {65us 4K} {65us 8K} [18us] 35us
								DEST_FILE_PATH = $sformatf("%s/semihuffman/grammar_mhw.shuff",DST_BASE_PATH);
							end
				8'd23 : 	begin
								SRC_FILE_PATH = $sformatf("%s/compress/alice29.txt",SRC_BASE_PATH); // {932us 4K} {930us 8K} [927us] 1427us
								DEST_FILE_PATH = $sformatf("%s/semihuffman/alice29_mhw.shuff",DST_BASE_PATH);
							end
				8'd24 : 	begin
								SRC_FILE_PATH = $sformatf("%s/compress/fields.c",SRC_BASE_PATH);  // {114us 4K} {128us 8K} [56us] 93us
								DEST_FILE_PATH = $sformatf("%s/semihuffman/fields_mhw.shuff",DST_BASE_PATH);
							end
				8'd25 : 	begin
								SRC_FILE_PATH = $sformatf("%s/compress/lcet10.txt",SRC_BASE_PATH); // {2458us 4K} {2451us 8K} [2457us] 3738us
								DEST_FILE_PATH = $sformatf("%s/semihuffman/lcet10_mhw.shuff",DST_BASE_PATH);
							end
				8'd26 : 	begin
								SRC_FILE_PATH = $sformatf("%s/compress/plrabn12.txt",SRC_BASE_PATH); // {3221us 4K} {3222us 8K} [3234us] 4944us
								DEST_FILE_PATH = $sformatf("%s/semihuffman/plrabn12_mhw.shuff",DST_BASE_PATH);
							end
				8'd27 : 	begin
								SRC_FILE_PATH = $sformatf("%s/compress/asyoulik.txt",SRC_BASE_PATH); // {778us 4K} {789us 8K} [784us] 1242us
								DEST_FILE_PATH = $sformatf("%s/semihuffman/asyoulik_mhw.shuff",DST_BASE_PATH);
							end
				8'd28 : 	begin
								SRC_FILE_PATH = $sformatf("%s/compress/cp.html",SRC_BASE_PATH); // {136us 4K} {176us 8K} [111us] 213us
								DEST_FILE_PATH = $sformatf("%s/semihuffman/cp_mhw.shuff",DST_BASE_PATH);							
							end		
				default: begin
								SRC_FILE_PATH = $sformatf("%s/compress/zero",SRC_BASE_PATH);	
								DEST_FILE_PATH = $sformatf("%s/semihuffman/zero_mhw.shuff",DST_BASE_PATH);
							end			
				endcase
			end
		endtask
	`endif

endmodule

