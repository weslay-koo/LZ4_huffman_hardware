`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:29:55 01/16/2016 
// Design Name: 
// Module Name:    unmatch_fifo 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: should store most 16K Byte  First Byte fall through
//
//////////////////////////////////////////////////////////////////////////////////
module unmatch_fifo(
// input global signal
input	wire				clk,
input	wire				rstN,
// input data and write signal
input	wire	[7:0]		din,
input	wire				wr_en,
input	wire				rd_en,
input	wire				byte_done,	
// output data and status signal
output wire	[31:0]	dout,
output reg	[1:0]		dout_mask,
output wire				valid,
output reg				full,
output reg				empty,
output wire	[11:0]	rd_data_count,
output wire	[13:0]	wr_data_count
);

// internal address
reg	[11:0]	rd_addr;
reg	[13:0]	wr_addr;
wire	[13:0]	addra,addrb;
// internal data
wire	[31:0]	douta,doutb;
// internal control signal
wire				wea,web;
reg				data_sel;  // pick data from B when data_sel==1, or from A when data_sel==0
wire				first_dword,last_dword;
reg				rd_en_d1;
// wr_count correct value
reg	[1:0]		waddr_corr;

/////////////////////////////////////////////////
////		 Dividual Combination Logic 			////
/////////////////////////////////////////////////

assign			valid	=	rd_en;

assign			addra	=	(wr_en & data_sel) ? wr_addr : {rd_addr,2'b00};
assign			addrb	=	(wr_en & (!data_sel)) ? wr_addr : {rd_addr+1'b1,2'b00};
assign			wea	=	wr_en & data_sel;
assign			web	=	wr_en & (!data_sel);
assign			dout	=	data_sel ? doutb : douta;

assign			wr_data_count	=	wr_addr - {rd_addr,2'b0} - waddr_corr;
assign			rd_data_count	=	wr_addr[13:2] - rd_addr;

assign			first_dword		=	({rd_en_d1,rd_en}==2'b01) ? 1'b1 : 1'b0;
assign			last_dword		=	({rd_en_d1,rd_en}==2'b10) ? 1'b1 : 1'b0;

/////////////////////////////////////////////////
////				 Sequential Logic 				////
/////////////////////////////////////////////////
// rd_addr
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		rd_addr	<=	10'b0;
		rd_en_d1	<=	1'b0;
	end
	else
	begin
		rd_en_d1	<=	rd_en;
		if(empty && rd_en)
			rd_addr	<=	rd_addr;
		else if(rd_en)
			rd_addr	<=	rd_addr + 2'h1;
		else
			rd_addr	<=	rd_addr;
	end
end

// wr_addr
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		wr_addr		<=	14'b0;
		waddr_corr	<=	2'b0;
	end
	else
	begin
		if(byte_done && (wr_addr[1:0]!=2'b00))
		begin
			wr_addr		<=	{(wr_addr[13:2]+1'b1),2'b00};
			waddr_corr	<=	wr_addr[1:0];
		end
		else if(full && wr_en)
		begin
			wr_addr		<=	wr_addr;
			waddr_corr	<=	waddr_corr;	
		end
		else if(wr_en)
		begin
			wr_addr		<=	wr_addr + 1'b1;
			waddr_corr	<=	2'b0;	
		end
		else
		begin
			wr_addr		<=	wr_addr;
			if(rd_en)
				waddr_corr	<=	2'b0;	
			else
				waddr_corr	<=	waddr_corr;	
		end
	end
end

//// wr_data_count
//always @ (posedge clk or negedge rstN)
//begin
//	if(!rstN)
//	begin
//		wr_data_count	<=	12'b0;
//	end
//	else
//	begin
//		wr_data_count	<=	wr_addr - {rd_addr,2'b0};
//	end
//end

//// rd_data_count
//always @ (posedge clk or negedge rstN)
//begin
//	if(!rstN)
//	begin
//		rd_data_count	<=	10'b0;
//	end
//	else
//	begin
//		rd_data_count	<=	wr_addr[11:2] - rd_addr;
//	end
//end

// dout_mask
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		dout_mask	<=	2'b0;
	end
	else
	begin
		if(rd_addr == wr_addr[13:2])
			dout_mask	<=	wr_addr[1:0];
		else
			dout_mask	<=	2'b0;
	end
end

// data_sel
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		data_sel		<=	1'b0;
	end
	else
	begin
		if((!rd_en) && last_dword)
			data_sel	<=	1'b0;
		else if(rd_en && first_dword)
			data_sel	<=	~data_sel;
		else
			data_sel	<=	 data_sel;
	end
end

/////////////////////////////////////////////////
////		 		Combination Logic		 			////
/////////////////////////////////////////////////
// full and empty
always @ (*)
begin
	if(wr_data_count>=14'h3FFE)
		full 	=	1'b1;
	else
		full 	=	1'b0;
		
	if(rd_data_count<=12'h000)
		empty	=	1'b1;
	else
		empty	=	1'b0;
end

/////////////////////////////////////////////////
////			    IP CORES  Module 			   ////
/////////////////////////////////////////////////

unmatch_ram_4Kx32bit	U_unmatch_ram
(
  .clka			(clk),
  .clkb			(clk),
  .wea			(wea),
  .addra			(addra),
  .dina			(din),
  .web			(web),
  .addrb			(addrb),
  .dinb			(din),
  
  .douta			({douta[7:0],douta[15:8],douta[23:16],douta[31:24]}),
  .doutb			({doutb[7:0],doutb[15:8],doutb[23:16],doutb[31:24]})  // little endian to big endian
);

endmodule
