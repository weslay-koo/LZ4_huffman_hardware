`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:19:06 03/09/2016 
// Design Name: 
// Module Name:    fifo_16x64bit 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments:  (first byte fall through) BRAM convert to FIFO  36kb+18kb
//
//////////////////////////////////////////////////////////////////////////////////
module fifo_512x47bit(
// global clock and reset signal
input	wire				clk,
input wire				rstN,
// input data and signal
input wire	[46:0]	din,
input wire				wr_en,
input wire				rd_en,
// output data and signal
output wire	[46:0]	dout,
output wire				valid,
output reg				empty,
output reg				full,
output reg	[9:0]		data_count
);

// DPRAM control signal
wire					wea;
// DPRAM address signal
wire		[8:0]		addra,addrb;
// access pointers
reg		[8:0]		wr_pointer,rd_pointer;
// first word fall through register
reg		[46:0]	prefetch;
reg					rd_en_d1;
wire		[46:0]	ram_out;	

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
		wr_pointer	<=	9'b0;
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
		rd_pointer	<=	9'b0;
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
		data_count	<=	10'b0;
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
		else if(	(data_count>=10'h200) 
				|| ((data_count>=10'h1FF) && wr_en && (!rd_en) && (!empty)) )
			full	<=	1'b1;
		else
			full	<=	full;
			
		if(empty && (!full) && wr_en)
			empty	<=	1'b0;
		else if(	(data_count<=10'h0) 
				|| ((data_count<=10'h1) && rd_en && (!wr_en) && (!full)) )
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
		prefetch	<=	47'b0;
		rd_en_d1	<=	1'b0;
	end
	else
	begin
		rd_en_d1	<=	rd_en;
		if({rd_en_d1,rd_en}==2'b01)
			prefetch	<=	47'b0;
		else if(wr_en && empty)
			prefetch	<=	din;
		else if({rd_en_d1,rd_en}==2'b10)
			prefetch	<=	dout;
		else
			prefetch	<=	prefetch;
	end
end

/////////////////////////////////////////////////
////			 	 IP CORES  Module 			   ////
/////////////////////////////////////////////////

//// use xilinx BRAM ipcore, it can be instead of user design little fifo logic (first byte fall through)
//wire	[63:0]	data_64bit;
//fifo_512x64bit_bram	U_fifo_512x64bit_bram
//(
//  .clk				(clk),
//  .rst				(~rstN),
//  .din				({17'b0,din}),
//  .wr_en				(wr_en),
//  .rd_en				(rd_en),
//  
//  .dout				(data_64bit),
//  .full				(full),
//  .empty				(),	//	(empty),
//  .valid				(valid),
//  .data_count		(data_count)
//);
//assign	dout	=	data_64bit[46:0];


// Use DP RAM
bram_512x47bit	U_bram_512x47bit
(
	.clka			(clk),
	.wea			(wea),		//	port A for write
	.addra		(addra),
	.dina			(din),
	.clkb			(clk),
	.web			(1'b0),		//	port B for read
	.addrb		(addrb),
	.dinb			(47'b0),
	
	.douta		(),
	.doutb		(ram_out)
);



endmodule
