`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:36:33 12/28/2015 
// Design Name: 
// Module Name:    encode_glue_v2 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Revision 2.00 - add data mask to data frame
// Additional Comments: data frame structure
//								2bit				32bit
//						00:4Byte valid	
//						01:1Byte valid			data
//						10:2Byte valid
//						11:3Byte valid
//
//////////////////////////////////////////////////////////////////////////////////
module encode_glue_v2(
input wire				clk,
input wire				rstN,
// External seperated data input
input wire	[2:0]		wr_mask,  // Mask signal : 100 no mask     ; 001 mask 3Bytes ;
input wire	[31:0]	wr_data,  //  					010 mask 2Bytes ; 011 mask 1Bytes
input wire				wr_valid,
input wire				encode_done,	//	all encode done
input wire				seg_done,	//	segment encode done
// fifo interface for read final encode
input wire				rd_en,
output wire	[33:0]	rd_data,
output wire				rd_empty,
output wire				rd_valid,
output wire				ofifo_full,
output wire				ohalf_full
);

reg	[31:0]	fifo_din;
reg	[1:0]		fifo_mask;	
reg				fifo_wr;
reg	[2:0]		mask_sum;
reg	[63:0]	glue_shift;
wire	[31:0]	conv_data;
reg				encode_done_d1,encode_done_d2;
reg				last_dword;
wire	[12:0]	fifo_count;

// half full signal generation
assign			ohalf_full	=	(fifo_count >= 13'd4096) ? 1'b1 : 1'b0; 

// Little Endian convert
assign			conv_data	=	{wr_data[7:0],wr_data[15:8],wr_data[23:16],wr_data[31:24]};

// last Dword signal generate
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		last_dword	<=	1'b0;
	end
	else
	begin
		if(seg_done&&(mask_sum>3'b100))
		begin
			last_dword	<=	1'b1;
		end
		else
		begin
			last_dword	<=	1'b0;
		end
	end
end

// data glue
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		glue_shift	<=	64'b0;
	end
	else
	begin
		if(wr_valid)
		begin
			if(wr_mask==3'b100)
			begin
				glue_shift	<=	{glue_shift[31:0],wr_data[31:0]};
			end
			else if(wr_mask[2]==1'b0)
			begin
				case(wr_mask[1:0])
				2'b00	:	glue_shift	<=	glue_shift;
				2'b01	:	glue_shift	<=	{glue_shift[55:0],wr_data[ 7:0]};
				2'b10	:	glue_shift	<=	{glue_shift[47:0],wr_data[15:0]};
				2'b11	:	glue_shift	<=	{glue_shift[39:0],wr_data[23:0]};
				default:	glue_shift	<=	glue_shift;
				endcase	
			end
		end
//		else if(last_dword)
//		begin
//			glue_shift	<=	{glue_shift[31:0],32'b0};
//		end
		else
		begin
			glue_shift	<=	glue_shift;
		end
	end
end

// encode_done signal delay
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		encode_done_d2	<=	1'b0;
		encode_done_d1	<=	1'b0;
	end
	else
	begin
		encode_done_d2	<=	encode_done_d1;
		encode_done_d1	<=	encode_done;
	end
end

// mask signal delay
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		mask_sum		<=	3'b0;
	end
	else
	begin
		if(last_dword)
			mask_sum		<=	{1'b0,mask_sum[1:0]};
		else if(wr_valid)
			mask_sum		<=	{1'b0,mask_sum[1:0]} + wr_mask;
		else
			mask_sum		<=	mask_sum;	
	end
end

// data glue
always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		fifo_wr		<=	1'b0;
		fifo_din		<=	32'b0;
		fifo_mask	<=	2'b0;
	end
	else
	begin
		if(wr_valid)
		begin
			if(mask_sum[2])	// mask_sum[2] is a 32bit data glue completely signal
			begin					// which should be used as a data write to fifo request signal
				fifo_wr		<=	1'b1;
				fifo_mask	<=	2'b0;
				case(mask_sum[1:0])
				2'b00	:	fifo_din	<=	glue_shift[31:0];	
				2'b01	:	fifo_din	<=	glue_shift[39:8];
				2'b10	:	fifo_din	<=	glue_shift[47:16];
				2'b11	:	fifo_din	<=	glue_shift[55:24];
				default:	fifo_din	<=	fifo_din;
				endcase
			end
			else
			begin
				fifo_wr	<=	1'b0	;
				fifo_din	<=	32'b0	;
			end
		end
		else if(last_dword)
		begin
			fifo_wr		<=	1'b1;
			fifo_mask	<=	2'b0;
			case(mask_sum[1:0])
			2'b01	:	fifo_din	<=	glue_shift[39:8];
			2'b10	:	fifo_din	<=	glue_shift[47:16];
			2'b11	:	fifo_din	<=	glue_shift[55:24];
			default:	fifo_din	<=	fifo_din;
			endcase
		end
		else if({encode_done_d2,encode_done_d1}==2'b01)
		begin
			fifo_wr		<=	1'b1;
			fifo_mask	<=	2'b0;
			case(mask_sum[1:0])
			2'b00	:	begin	
							fifo_din		<=	glue_shift[31:0];	
							fifo_mask	<=	2'h0;
						end
			2'b01	:	begin	
							fifo_din		<=	{glue_shift[7:0],24'b0};
							fifo_mask	<=	2'h1;
						end
			2'b10	:	begin	
							fifo_din		<=	{glue_shift[15:0],16'b0};
							fifo_mask	<=	2'h2;
						end
			2'b11	:	begin	
							fifo_din		<=	{glue_shift[23:0],8'b0};
							fifo_mask	<=	2'h3;
						end
			default:	begin
							fifo_din		<=	fifo_din;
							fifo_mask	<=	2'b0;
						end
			endcase
		end
		else
		begin
			fifo_mask	<=	2'b0;
			fifo_wr		<=	1'b0	;
			fifo_din		<=	32'b0	;
		end
	end
end

// FIFO
fifo_8kx34bit	U_encode_fifo
(
  .clk			(clk),
  .rst			(~rstN),
  .din			({fifo_mask,fifo_din}),
  .wr_en			(fifo_wr),
  .rd_en			(rd_en),
	
  .dout			(rd_data),
  .valid			(rd_valid),
  .full			(ofifo_full),
  .empty			(rd_empty),
  .data_count	(fifo_count)
);

endmodule
