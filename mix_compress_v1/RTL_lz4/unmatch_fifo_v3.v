`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:51:55 04/20/2016 
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
// Revision 3.01 - File Created
// Additional Comments: should store most 16K Byte  First Byte fall through
//
//////////////////////////////////////////////////////////////////////////////////
module unmatch_fifo_v3(
// input global signal
input	wire				clk,
input	wire				rstN,
// input data and write signal
input	wire	[31:0]	din,
input	wire				wr_en,
input	wire				rd_en,	
// output data and status signal
output wire	[31:0]	dout,
output wire				valid,
output reg				full,
output reg				empty,
output reg	[12:0]	data_count
);

// DPRAM control signal
wire					wea;
// DPRAM address signal
wire		[11:0]	addra,addrb;
// access pointers
reg		[11:0]	wr_pointer,rd_pointer;
// first word fall through register
reg		[31:0]	prefetch;
reg					rd_en_d1;
wire		[31:0]	ram_out;	

/////////////////////////////////////////////////
////			Dividual Combination Logic 		////
/////////////////////////////////////////////////
assign				addra	=	wr_pointer;
assign				addrb	=	rd_pointer + 1'b1;
assign				wea	=	wr_en;
assign				valid	=	empty ? 1'b0 : rd_en;
assign				dout	=	({rd_en_d1,rd_en}==2'b01) ? prefetch : ram_out;
/////////////////////////////////////////////////
////				 Sequential Logic 				////
/////////////////////////////////////////////////
// write pointer update
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		wr_pointer	<=	12'b0;
	end
	else
	begin
		if((!full) && wr_en)
			wr_pointer	<=	wr_pointer + 1'b1;
		else
			wr_pointer	<=	wr_pointer;
	end
end

// read pointer update
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		rd_pointer	<=	12'b0;
	end
	else
	begin
		if((!empty) && rd_en)
			rd_pointer	<=	rd_pointer + 1'b1;
		else
			rd_pointer	<=	rd_pointer;
	end
end

// data counter update
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		data_count	<=	13'b0;
	end
	else
	begin
		if( ((!full) && wr_en) && ((!empty) && rd_en) )
			data_count	<=	data_count;
		else if( ((!full) && wr_en) && (!((!empty) && rd_en)) )
			data_count	<=	data_count + 1'b1;
		else if( (!((!full) && wr_en)) && ((!empty) && rd_en) )
			data_count	<=	data_count - 1'b1;
		else
			data_count	<=	data_count;
	end
end

// full and empty signal
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		full	<=	1'b0;
		empty <=	1'b1;
	end
	else
	begin
		if(full && (!empty) && rd_en)
			full	<=	1'b0;
		else if(	(data_count>=13'h1000) 
				|| ((data_count>=13'hFFF) && wr_en && (!rd_en) && (!empty)) )
			full	<=	1'b1;
		else
			full	<=	full;
			
		if(empty && (!full) && wr_en)
			empty	<=	1'b0;
		else if(	(data_count<=13'h0) 
				|| ((data_count<=13'h1) && rd_en && (!wr_en) && (!full)) )
			empty	<=	1'b1;
		else
			empty	<=	empty;
	end
end

// prefetch logic
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		prefetch	<=	32'b0;
		rd_en_d1	<=	1'b0;
	end
	else
	begin
		rd_en_d1	<=	rd_en;
		if({rd_en_d1,rd_en}==2'b01)
			prefetch	<=	32'b0;
		else if(wr_en && empty)
			prefetch	<=	din;
		else if({rd_en_d1,rd_en}==2'b10)
			prefetch	<=	dout;
		else
			prefetch	<=	prefetch;
	end
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
  .web			(1'b0),
  .addrb			(addrb),
  .dinb			(32'b0),
  
  .douta			(),
  .doutb			(ram_out)  // little endian to big endian
);

endmodule
