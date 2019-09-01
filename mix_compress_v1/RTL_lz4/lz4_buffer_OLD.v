`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:33:25 05/27/2015 
// Design Name: 
// Module Name:    lz4_buffer 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//   
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module lz4_buffer(
// clk and rst
input	wire				clk,
input wire				rstN,
input wire				buf_clear,
output reg				buf_unable,
// external data input
input wire	[31:0]	buf_idata,
input wire				buf_ivalid,
output reg				buf_full,
// data output
input wire				buf_rdreq,
input wire	[15:0]	buf_rdpointer, // Byte addressed
output reg	[31:0]	buf_odata,
output reg				buf_ovalid,
output reg				buf_empty,
// dictionart window move distance
input wire				move_valid,
input wire	[15:0]	move_distance, // Byte addressed
output reg				dict_full,
output reg	[31:0]	head_addr  // absolutely address 64kB block head
);

// Clean control
reg	[15:0]	clean_cnt;
// RAM write and read signal
wire	[14:0]	ram_waddr,ram_raddr;
wire				ram_wea;
wire	[31:0]	ram_din;
reg				wr_ram;
reg	[31:0]	wr_data;
// Address counter 
reg	[14:0]	wr_addr;
reg				wr_cnt_en;
// Address convert signal
reg	[14:0]	rd_addr;
reg				duo_read;
// Dictionary pointers
reg	[14:0]	dict_head,anchor;
// Double World cut and glue
wire	[31:0]	ram_dout;
reg	[31:0]	ram_dout_d1;
// delay signal
reg	[31:0]	buf_idata_d1;

assign			ram_waddr	=	buf_unable ? clean_cnt[14:0]	: wr_addr;
assign			ram_raddr	=	buf_unable ? 15'b0				: rd_addr;
assign			ram_wea		=	buf_unable ? 1'b1			   	: wr_ram;
assign			ram_din		=	buf_unable ? 32'b0		     	: wr_data;

buffer_ram32Kx32bit	U_buffer_ram  // 2x64KB RAM
(
  .clka		(clk),
  .wea		(ram_wea),
  .addra		(ram_waddr),
  .dina		(ram_din),
  .clkb		(clk),
  .addrb		(ram_raddr),
  
  .doutb		(ram_dout)
);

// for ram Clean process
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		buf_unable	<=	1'b0;	// 1'b1;
		clean_cnt	<=	16'b0;
	end
	else
	begin
		if(buf_clear)
		begin
			buf_unable	<=	1'b1;
			clean_cnt	<=	16'b0;
		end
		else if(buf_unable&&(clean_cnt<16'h7FFF))
		begin
			buf_unable	<=	1'b1;
			clean_cnt	<=	clean_cnt + 1'b1;
		end
		else
		begin
			buf_unable	<=	1'b0;
			clean_cnt	<=	16'b0;
		end
	end
end

// RAM Write Logic
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		wr_addr	<=	15'b0	;
	end
	else
	begin
		if(wr_cnt_en)
			wr_addr	<=	wr_addr + 1'b1	;
		else
			wr_addr	<=	wr_addr	;
	end
end

always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		buf_idata_d1<=	32'b0	;
		wr_ram		<=	1'b0	;
		wr_data		<=	32'b0	;
		wr_cnt_en	<=	1'b0	;	
	end
	else
	begin
		buf_idata_d1	<=	buf_idata	;
		if(buf_ivalid)
		begin
			wr_cnt_en<=	1'b1	;
			wr_ram	<=	1'b1	;
			wr_data	<=	buf_idata;//buf_idata_d1;
		end
		else
		begin
			wr_cnt_en	<=	1'b0	;	
			wr_ram		<=	1'b0	;
			wr_data		<=	32'b0	;
		end
	end
end

// RAM Address Convert
always @ (*)
begin
	rd_addr	=	dict_head + {1'b0,buf_rdpointer[15:2]} + duo_read;
	case(buf_rdpointer[1:0])
	2'b00		:	buf_odata	=	ram_dout;
	2'b01		:	buf_odata	=	{ram_dout_d1[23:0],ram_dout[31:24]};
	2'b10		:	buf_odata	=	{ram_dout_d1[15:0],ram_dout[31:16]};
	2'b11		:	buf_odata	=	{ram_dout_d1[7:0],ram_dout[31:8]};
	default	:	buf_odata	=	32'b0	;
	endcase
end

always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		duo_read		<=	1'b0	;
		buf_ovalid	<=	1'b0	;
		ram_dout_d1	<=	32'b0	;
	end
	else
	begin
		ram_dout_d1	<=	ram_dout	;
		if((buf_rdpointer[1:0]==2'b00)&&buf_rdreq)
		begin
			duo_read		<=	1'b0	;
			buf_ovalid	<=	1'b1	;
		end
		else if(buf_rdreq)
		begin
			duo_read		<=	1'b1	;
			buf_ovalid	<=	1'b0	;
		end
		else if(duo_read)
		begin
			duo_read		<=	1'b0	;
			buf_ovalid	<=	1'b1	;
		end
		else
		begin
			duo_read		<=	1'b0	;
			buf_ovalid	<=	1'b0	;
		end
	end
end

always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		buf_empty	<=	1'b0	;
	end
	else
	begin
		if(rd_addr < anchor)
			buf_empty	<=	1'b0	;
		else
			buf_empty	<=	1'b1	;
	end
end

// dictionary Movement
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		dict_head	<=	15'b0	;
		anchor		<=	15'b0	;
		head_addr	<=	32'b0	;
	end
	else
	begin
		if(move_valid)
		begin
			head_addr	<=	head_addr + {16'b0,move_distance};
			if(anchor - dict_head > 15'h3FFE)
			begin
				anchor		<=	anchor 	 + {1'b0,move_distance[15:2]};
				dict_head	<=	dict_head + {1'b0,move_distance[15:2]};
				dict_full	<=	1'b1	;
			end
			else
			begin
				if(anchor - dict_head + {1'b0,move_distance[15:2]} > 15'h3FFE)
				begin
					anchor		<=	anchor + {1'b0,move_distance[15:2]};
					dict_head	<=	anchor + {1'b0,move_distance[15:2]} - 15'h3FFF;
					dict_full	<=	1'b1	;
				end
				else
				begin
					anchor		<=	anchor + {1'b0,move_distance[15:2]};
					dict_head	<=	dict_head;
					dict_full	<=	1'b0	;
				end
			end
		end
		else
		begin
			head_addr	<=	head_addr;
			anchor		<=	anchor;
			dict_head	<=	dict_head;
			dict_full	<=	dict_full;
		end
	end
end

// Write buf_full signal, indicate the write operate is forbiden
always @ (*)
begin
	if(	(wr_addr < dict_head)||(wr_addr > anchor)
		||	((dict_head==15'b0)&&(anchor==15'b0)&&(wr_addr==15'b0)))
		buf_full	=	1'b0;
	else
		buf_full	=	1'b1;
end

endmodule
