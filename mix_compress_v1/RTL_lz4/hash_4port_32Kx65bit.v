`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:32:08 03/04/2016 
// Design Name: 
// Module Name:    hash_4port_32Kx64bit 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 			Access port time slot use
//								time slot 		RAM_porta   RAM_portb
//									1				group a		group b
//									2				group c		group d
//////////////////////////////////////////////////////////////////////////////////
module hash_4port_32Kx65bit(
// input clock signal
input wire				clk,
input wire				clk_2x,
input wire				rstN,
// group A input we, data and address
input wire				wea,
input wire	[14:0] 	addra,
input wire	[64:0]	dina,
// group B input we, data and address
input wire				web,
input wire	[14:0] 	addrb,
input wire	[64:0]	dinb,
// group C input we, data and address
input wire				wec,
input wire	[14:0] 	addrc,
input wire	[64:0]	dinc,
// group D input we, data and address
input wire				wed,
input wire	[14:0] 	addrd,
input wire	[64:0]	dind,
// group A output data
output wire	[64:0] 	douta,
// group B output data
output wire	[64:0] 	doutb,
// group C output data
output wire	[64:0] 	doutc,
// group D output data
output wire	[64:0] 	doutd
);

// Double frequence RAM signal
wire				ram_wea,ram_web;
wire	[14:0]	ram_addra,ram_addrb;
wire	[64:0]	ram_dina,ram_dinb;
wire	[64:0]	ram_douta,ram_doutb;

// time slot reg 
reg	[14:0]	addrc_reg,addrd_reg;	// Port C access in Port A time slot,Port D access in Port B time slot
reg	[64:0]	dinc_reg,dind_reg;
reg				wec_reg,wed_reg;
reg				time_slot;	// 0:time slot 1  1:time slot 2
reg	[64:0]	douta_reg,doutb_reg,doutc_reg,doutd_reg;

/////////////////////////////////////////////////
////				 Sequential Logic 				////
/////////////////////////////////////////////////
// sync logic (signal hold double clk_2x circles)
always @ (posedge clk_2x or negedge rstN)
begin
	if(!rstN)
	begin
		addrc_reg	<=	15'b0;
		addrd_reg	<=	15'b0;
		dinc_reg		<=	65'b0;
		dind_reg		<=	65'b0;
		wec_reg		<=	1'b0;
		wed_reg		<=	1'b0;
	end
	else
	begin
		addrc_reg	<=	addrc;
		addrd_reg	<=	addrd;
		dinc_reg		<=	dinc;
		dind_reg		<=	dind;
		wec_reg		<=	wec;
		wed_reg		<=	wed;
	end
end

// time slot direct
always @ (posedge clk_2x or negedge rstN)
begin
	if(!rstN)
	begin
		time_slot	<=	1'b0;
	end
	else
	begin
		time_slot	<=	~time_slot;
	end
end

// data latch
always @ (posedge clk_2x or negedge rstN)
begin
	if(!rstN)
	begin
		douta_reg	<=	65'b0;
		doutb_reg	<=	65'b0;
		doutc_reg	<=	65'b0;
		doutd_reg	<=	65'b0;
	end
	else
	begin
		if(time_slot)
		begin
			douta_reg	<=	ram_douta;
			doutb_reg	<=	ram_doutb;
		end
		else
		begin
			douta_reg	<=	douta_reg;
			doutb_reg	<=	doutb_reg;
		end
		
		if(!time_slot)
		begin
			doutc_reg	<=	ram_douta;
			doutd_reg	<=	ram_doutb;
		end
		else
		begin
			doutc_reg	<=	doutc_reg;	
		   doutd_reg	<=	doutd_reg;	
		end
	end
end

//////////////////////////////////////////////
////				Combination Logic 			////
//////////////////////////////////////////////
// address switch
assign			ram_addra	=	time_slot ? addrc_reg : addra;
assign			ram_addrb	=	time_slot ? addrd_reg : addrb;
// data switch
assign			ram_dina		=	time_slot ? dinc_reg : dina;
assign			ram_dinb		=	time_slot ? dind_reg : dinb;
// we switch	
assign			ram_wea		=	time_slot ? wec_reg : wea;
assign			ram_web		=	time_slot ? wed_reg : web;
// port A B C D output
assign			douta			=	douta_reg;
assign			doutb			=	doutb_reg;
assign			doutc			=	time_slot ? doutc_reg : ram_douta;
assign			doutd			=	time_slot ? doutd_reg : ram_doutb;

//////////////////////////////////////////////
////			  IP CORES  Module 			   ////
//////////////////////////////////////////////
hash_ram_32Kx64bit	U_hash_ram
(
  .clka			(clk_2x),
  .wea			(ram_wea),
  .addra			(ram_addra),
  .dina			(ram_dina),
  .clkb			(clk_2x),
  .web			(ram_web),
  .addrb			(ram_addrb),
  .dinb			(ram_dinb),
  
  .douta			(ram_douta),
  .doutb			(ram_doutb)
);

endmodule
