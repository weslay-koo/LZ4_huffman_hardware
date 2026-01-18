`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:58:49 08/05/2016 
// Design Name: 
// Module Name:    reg_array_16x9bit 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: For bl_count (how many leaf have the same bit lengths).
//								All VLC bit length must less than 15 and greater than 0, 
//								if VLC code length over 15 or code doesn't appear, "addr"
//								should be set to 4'd0 and overflow counter will increase.
//								
//				incr_en  decr_en			function
//					0			0				Read Only	
//					0			1				array[addr] = array[addr] - 1	for Tree optimous
//					1			0				array[addr] = array[addr] + 1	for BL statistics or Tree BLoptimous
//					1			1				array[addr] = array[addr] + 2	for Tree optimous
//
// 		NOTICE:increase or decrease operation will cost at least 3 clock cycles 
//////////////////////////////////////////////////////////////////////////////////
module reg_array_16x9bit(
// global clock and reset
input wire				clk,
input wire				rstN,
// access signal
input wire	[3:0]		addr,	// input bit length (Only this port have self-increase/self-decrease function)
input wire	[3:0]		addr_aux,
input wire				incr_en,
input wire				decr_en,
output wire	[8:0]		bl_count,		// register array is READ_FIRST
output wire	[8:0]		bl_count_aux,	//	Aux output for Dual-Port READ
output wire				busy				// To indicate if the reg array is updating and aux port disabled
);

/*
// Optimus for BRAM resource
reg	[8:0]	array [15:0];

always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		array[0]		<=	9'b0;
		array[1]		<=	9'b0;
		array[2]		<=	9'b0;
		array[3]		<=	9'b0;
		array[4]		<=	9'b0;
		array[5]		<=	9'b0;
		array[6]		<=	9'b0;
		array[7]		<=	9'b0;
		array[8]		<=	9'b0;
		array[9]		<=	9'b0;
		array[10]	<=	9'b0;
		array[11]	<=	9'b0;
		array[12]	<=	9'b0;
		array[13]	<=	9'b0;
		array[14]	<=	9'b0;
		array[15]	<=	9'b0;
	end
	else
	begin
		case(addr)
		4'h0	:	begin	
						if(incr_en)
							array[0]	<=	array[0] + 1'b1;
						else
							array[0]	<=	array[0];
						bl_count	<=	array[0];
					end
		4'h1	:	begin	
						if(incr_en)
							array[1]	<=	array[1] + 1'b1;
						else
							array[1]	<=	array[1];
						bl_count	<=	array[1];
					end
		4'h2	:	begin	
						if(incr_en)
							array[2]	<=	array[2] + 1'b1;
						else
							array[2]	<=	array[2];
						bl_count	<=	array[2];
					end
		4'h3	:	begin	
						if(incr_en)
							array[3]	<=	array[3] + 1'b1;
						else
							array[3]	<=	array[3];
						bl_count	<=	array[3];
					end
		4'h4	:	begin	
						if(incr_en)
							array[4]	<=	array[4] + 1'b1;
						else
							array[4]	<=	array[4];
						bl_count	<=	array[4];
					end
		4'h5	:	begin	
						if(incr_en)
							array[5]	<=	array[5] + 1'b1;
						else
							array[5]	<=	array[5];
						bl_count	<=	array[5];
					end
		4'h6	:	begin	
						if(incr_en)
							array[6]	<=	array[6] + 1'b1;
						else
							array[6]	<=	array[6];
						bl_count	<=	array[6];
					end
		4'h7	:	begin	
						if(incr_en)
							array[7]	<=	array[7] + 1'b1;
						else
							array[7]	<=	array[7];
						bl_count	<=	array[7];
					end
		4'h8	:	begin	
						if(incr_en)
							array[8]	<=	array[8] + 1'b1;
						else
							array[8]	<=	array[8];
						bl_count	<=	array[8];
					end
		4'h9	:	begin	
						if(incr_en)
							array[9]	<=	array[9] + 1'b1;
						else
							array[9]	<=	array[9];
						bl_count	<=	array[9];
					end
		4'hA	:	begin	
						if(incr_en)
							array[10]<=	array[10] + 1'b1;
						else
							array[10]<=	array[10];
						bl_count	<=	array[10];
					end
		4'hB	:	begin	
						if(incr_en)
							array[11]<=	array[11] + 1'b1;
						else
							array[11]<=	array[11];
						bl_count	<=	array[11];
					end
		4'hC	:	begin	
						if(incr_en)
							array[12]<=	array[12] + 1'b1;
						else
							array[12]<=	array[12];
						bl_count	<=	array[12];
					end
		4'hD	:	begin	
						if(incr_en)
							array[13]<=	array[13] + 1'b1;
						else
							array[13]<=	array[13];
						bl_count	<=	array[13];
					end
		4'hE	:	begin	
						if(incr_en)
							array[14]<=	array[14] + 1'b1;
						else
							array[14]<=	array[14];
						bl_count	<=	array[14];
					end
		4'hF	:	begin	
						if(incr_en)
							array[15]<=	array[15] + 1'b1;
						else
							array[15]<=	array[15];
						bl_count	<=	array[15];
					end
		default:	begin	
						bl_count	<=	array[0];
					end
		endcase
	end
end
*/

reg			incr_en_d1,decr_en_d1;
reg	[3:0]	addr_d1;
wire	[3:0]	addrb;
wire			we;
reg	[8:0]	dinb;

assign		addrb	=	(incr_en_d1 | decr_en_d1) ? addr_d1 : addr_aux;
assign		we		=	incr_en_d1 | decr_en_d1;
assign		busy	=	incr_en_d1 | decr_en_d1;

always @ (*)
begin
	if(incr_en_d1 & decr_en_d1)
		dinb	=	bl_count + 2'h2;
	else if(incr_en_d1)
		dinb	=	bl_count + 1'b1;
	else if(decr_en_d1)
		dinb	=	bl_count - 1'b1;
	else
		dinb	=	9'b0;
end

always @ (posedge clk or negedge rstN)
begin
	if(!rstN)
	begin
		addr_d1		<=	4'b0;
		incr_en_d1	<=	1'b0;
		decr_en_d1	<=	1'b0;
	end
	else
	begin
		addr_d1		<=	addr;
		incr_en_d1	<=	incr_en;
		decr_en_d1	<=	decr_en;
	end
end

ram_16x9bit	U_reg_array
(
  .clka		(clk),
  .wea		(1'b0),
  .addra		(addr),
  .dina		(9'b0),
  .clkb		(clk),
  .web		(we),
  .addrb		(addrb),
  .dinb		(dinb),
  
  .douta		(bl_count),
  .doutb		(bl_count_aux)
);

endmodule
