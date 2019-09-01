`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:40:14 05/08/2016 
// Design Name: 
// Module Name:    freq_ram_256x18bit 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 4 Bytes data statistics RAM for 32bit data input
//
//////////////////////////////////////////////////////////////////////////////////
module freq_ram_256x18bit(
// global clock and reset
input wire				clk,
input wire				rstN,
input wire				stat_en,
input wire				clean,
output reg				busy,
// data input
input wire	[31:0]	in_data,
input wire	[2:0]		in_mask,
input wire				in_valid,
// freq output
input wire	[7:0]		freq_addr1a,
input wire	[7:0]		freq_addr1b,
input wire	[7:0]		freq_addr2a,
input wire	[7:0]		freq_addr2b,
input wire	[7:0]		freq_addr3a,
input wire	[7:0]		freq_addr3b,
input wire	[7:0]		freq_addr4a,
input wire	[7:0]		freq_addr4b,
input wire				freq_oe,
output wire	[17:0]	freq_value1a,
output wire	[17:0]	freq_value1b,
output wire	[17:0]	freq_value2a,
output wire	[17:0]	freq_value2b,
output wire	[17:0]	freq_value3a,
output wire	[17:0]	freq_value3b,
output wire	[17:0]	freq_value4a,
output wire	[17:0]	freq_value4b,
output reg				freq_valid
);

reg				incr;

reg				ram1_web;
wire	[17:0]	ram1_dinb;
wire	[17:0]	ram1_douta;
wire	[7:0]		ram1_addra,ram1_addrb;

reg				ram2_web;
wire	[17:0]	ram2_dinb;
wire	[17:0]	ram2_douta;
wire	[7:0]		ram2_addra,ram2_addrb;

reg				ram3_web;
wire	[17:0]	ram3_dinb;
wire	[17:0]	ram3_douta;
wire	[7:0]		ram3_addra,ram3_addrb;

reg				ram4_web;
wire	[17:0]	ram4_dinb;
wire	[17:0]	ram4_douta;
wire	[7:0]		ram4_addra,ram4_addrb;

reg	[7:0]		clean_cnt;

reg	[31:0]	in_data_d1;

reg	[3:0]		stat_sel;

assign			ram1_dinb	=	busy ? 18'b0 :	(freq_value1a + incr);
assign			ram2_dinb	=	busy ? 18'b0 :	(freq_value2a + incr);
assign			ram3_dinb	=	busy ? 18'b0 :	(freq_value3a + incr);
assign			ram4_dinb	=	busy ? 18'b0 :	(freq_value4a + incr);

assign			ram1_addra	=	busy ? {1'b0,clean_cnt[6:0]} : (freq_oe ? freq_addr1a	:	in_data[31:24]);
assign			ram1_addrb	=	busy ? {1'b1,clean_cnt[6:0]} : (freq_oe ? freq_addr1b	:	in_data_d1[31:24]);
assign			ram2_addra	=	busy ? {1'b0,clean_cnt[6:0]} : (freq_oe ? freq_addr2a	:	in_data[23:16]);
assign			ram2_addrb	=	busy ? {1'b1,clean_cnt[6:0]} : (freq_oe ? freq_addr2b	:	in_data_d1[23:16]);
assign			ram3_addra	=	busy ? {1'b0,clean_cnt[6:0]} : (freq_oe ? freq_addr3a	:	in_data[15:8]);
assign			ram3_addrb	=	busy ? {1'b1,clean_cnt[6:0]} : (freq_oe ? freq_addr3b	:	in_data_d1[15:8]);
assign			ram4_addra	=	busy ? {1'b0,clean_cnt[6:0]} : (freq_oe ? freq_addr4a	:	in_data[7:0]);
assign			ram4_addrb	=	busy ? {1'b1,clean_cnt[6:0]} : (freq_oe ? freq_addr4b	:	in_data_d1[7:0]);

// look up module data enable signal generation
always @ (*)
begin
	case(in_mask)
	3'b001	:	stat_sel = 4'b0001;
	3'b010	:	stat_sel = 4'b0011;
	3'b011	:	stat_sel = 4'b0111;
	3'b100	:	stat_sel = 4'b1111;
	default	:	stat_sel = 4'b0;
	endcase
end

// freq_valid signal generation
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		freq_valid	<=	1'b0;
	end
	else
	begin
		freq_valid	<=	freq_oe;
	end
end

// input data delay for 1 clock cycle to sync to RAM Latency
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		in_data_d1	<=	32'b0;
	end
	else
	begin
		if(in_valid)
			in_data_d1	<=	in_data;
		else
			in_data_d1	<=	in_data_d1;
	end
end

// clean process
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		clean_cnt	<=	8'b0;
		busy			<=	1'b0;
	end
	else
	begin
		if(clean)
		begin
			clean_cnt	<=	8'b0;
			busy			<=	1'b1;
		end
		else if(busy)
		begin
			if(clean_cnt >= 8'h7F)
			begin
				clean_cnt	<=	8'b0;
				busy			<=	1'b0;
			end
			else
			begin
				clean_cnt	<=	clean_cnt + 1'b1;
				busy			<=	1'b1;
			end
		end
		else
		begin
			clean_cnt	<=	clean_cnt;
			busy			<=	busy;
		end
	end
end

// ram write enable signal generation
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		ram1_web	<=	1'b0;
		ram2_web	<=	1'b0;
		ram3_web	<=	1'b0;
		ram4_web	<=	1'b0;
		incr		<=	1'b0;
	end
	else
	begin
		if(clean | (busy && (clean_cnt >= 8'h7F)))
		begin
			ram1_web	<=	1'b1;
			ram2_web	<=	1'b1;
			ram3_web	<=	1'b1;
			ram4_web	<=	1'b1;
			incr		<=	1'b0;
		end
		else if(stat_en)
		begin
			if(in_valid)
			begin
				ram1_web	<=	stat_sel[0]; // 1'b1;
				ram2_web	<=	stat_sel[1]; // 1'b1;
				ram3_web	<=	stat_sel[2]; // 1'b1;
				ram4_web	<=	stat_sel[3]; // 1'b1;
				incr		<=	1'b1;
			end
			else
			begin
				ram1_web	<=	1'b0;
				ram2_web	<=	1'b0;
				ram3_web	<=	1'b0;
				ram4_web	<=	1'b0;
				incr		<=	1'b0;
			end
		end
		else
		begin
			ram1_web	<=	1'b0;
			ram2_web	<=	1'b0;
			ram3_web	<=	1'b0;	
			ram4_web	<=	1'b0;	
			incr		<=	1'b0;
		end
	end
end

// IP core
ram_256x18bit	U_freq_ram_1 // use Single 18K BRAM
(
  .clka			(clk),
  .wea			(1'b0),		//	port A used as Read Byte[31:24] counter
  .addra			(ram1_addra),
  .dina			(18'b0),
  .clkb			(clk),
  .web			(ram1_web),	//	port B used as Read Write[31:24] counter update
  .addrb			(ram1_addrb),
  .dinb			(ram1_dinb),
  
  .douta			(freq_value1a),
  .doutb			(freq_value1b)
);

ram_256x18bit	U_freq_ram_2 // use Single 18K BRAM
(
  .clka			(clk),
  .wea			(1'b0),		//	port A used as Read Byte[23:16] counter
  .addra			(ram2_addra),
  .dina			(18'b0),
  .clkb			(clk),
  .web			(ram2_web),	//	port B used as Read Write[23:16] counter update
  .addrb			(ram2_addrb),
  .dinb			(ram2_dinb),
  
  .douta			(freq_value2a),
  .doutb			(freq_value2b)
);

ram_256x18bit	U_freq_ram_3 // use Single 18K BRAM
(
  .clka			(clk),
  .wea			(1'b0),		//	port A used as Read Byte[15:8] counter
  .addra			(ram3_addra),
  .dina			(18'b0),
  .clkb			(clk),
  .web			(ram3_web),	//	port B used as Read Write[15:8] counter update
  .addrb			(ram3_addrb),
  .dinb			(ram3_dinb),
  
  .douta			(freq_value3a),
  .doutb			(freq_value3b)
);

ram_256x18bit	U_freq_ram_4 // use Single 18K BRAM
(
  .clka			(clk),
  .wea			(1'b0),		//	port A used as Read Byte[7:0] counter
  .addra			(ram4_addra),
  .dina			(18'b0),
  .clkb			(clk),
  .web			(ram4_web),	//	port B used as Read Write[7:0] counter update
  .addrb			(ram4_addrb),
  .dinb			(ram4_dinb),
  
  .douta			(freq_value4a),
  .doutb			(freq_value4b)
);

endmodule
