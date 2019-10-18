`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:37:57 06/15/2012 
// Design Name: 
// Module Name:    hdmi 
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
module hdmi(
	sys_clk,
	sys_rst,
   Bus2IP_Reset,
   CH7301_clk_p,
   CH7301_clk_n,
   CH7301_data,
   CH7301_h_sync,
   CH7301_v_sync,
   CH7301_de,
   CH7301_scl,
   CH7301_sda,
   CH7301_rstn,
	xsvi_debug,
	
	xsvi_pix_clk,
   xsvi_h_sync,
   xsvi_v_sync,
   xsvi_video_data,
   xsvi_video_active,
	Bus2IP_Clk
    );

	input             sys_clk;
	input             sys_rst;
   input             Bus2IP_Reset;
   output            CH7301_clk_p;
   output            CH7301_clk_n;
   output[11:0]      CH7301_data;
   output            CH7301_h_sync;
   output            CH7301_v_sync;
   output            CH7301_de;
   output            CH7301_scl;
   output            CH7301_sda;
   output            CH7301_rstn;
	output[7:0]       xsvi_debug;
	
	input					xsvi_pix_clk;
	input					xsvi_video_data;
   input					xsvi_h_sync;
   input					xsvi_v_sync;
   input					xsvi_video_active;
	input					Bus2IP_Clk;

	wire              xsvi_h_sync;
	wire              xsvi_v_sync;
	wire[23:0]			xsvi_video_data;
	wire              xsvi_video_active;
	

	wire              xsvi_pix_clk;
	wire              Bus2IP_Clk;
	wire              done;
	
	//wire[15:0]			addra;
	//wire[23:0]			douta;

/*	parameter C_HOR_TOTAL = 1056;
	parameter C_HOR_SYNC = 128;
	parameter C_HOR_BACK = 88;
	parameter C_HOR_FRONT = 40;
	
	parameter C_VER_TOTAL = 628;
	parameter C_VER_SYNC = 4;
	parameter C_VER_BACK = 23;
	parameter C_VER_FRONT = 1;

	parameter C_HOR_TOTAL = 1056;
	parameter C_HOR_SYNC = 80;
	parameter C_HOR_BACK = 160;
	parameter C_HOR_FRONT = 16;
	
	parameter C_VER_TOTAL = 625;
	parameter C_VER_SYNC = 3;
	parameter C_VER_BACK = 21;
	parameter C_VER_FRONT = 1;
*/
/*rom1 uut (
		.clka(xsvi_pix_clk), 
		.wea(1'b0), 
		.addra(addra), 
		.dina(), 
		.douta(douta)
	);*/

/*hdmi_pll hdmi_pll_inst (
    .CLKIN1_IN(sys_clk), 
    .RST_IN(sys_rst), 
    .CLKFBOUT_OUT(), 
    .CLKOUT0_OUT(Bus2IP_Clk), 
    .CLKOUT1_OUT(xsvi_pix_clk), 
    .LOCKED_OUT(LOCKED_OUT)
    );*/

user_logic user_inst
(
  .xsvi_pix_clk				(xsvi_pix_clk),
  .xsvi_h_sync					(xsvi_h_sync),
  .xsvi_v_sync             (xsvi_v_sync),
  .xsvi_video_data         (xsvi_video_data),
  .xsvi_video_active			(xsvi_video_active),
  
  .CH7301_clk_p				(CH7301_clk_p),
  .CH7301_clk_n				(CH7301_clk_n),
  .CH7301_data					(CH7301_data),
  .CH7301_h_sync				(CH7301_h_sync),
  .CH7301_v_sync				(CH7301_v_sync),
  .CH7301_de					(CH7301_de),
  .CH7301_scl					(CH7301_scl),
  .CH7301_sda					(CH7301_sda),
  .CH7301_rstn					(CH7301_rstn), 
  .xsvi_debug					(xsvi_debug),
  .done							(done),
  .Bus2IP_Clk					(Bus2IP_Clk),             
  .Bus2IP_Reset				(Bus2IP_Reset)
);  
/*
  reg [10:0] cnt_x;
  reg [9:0] cnt_y;
  
  always@( posedge xsvi_pix_clk or posedge Bus2IP_Reset)
	if( Bus2IP_Reset )
	begin
		cnt_x <= 0;
		cnt_y <= 0;
	end
	else if( done )
	begin
		cnt_x <= ( cnt_x == C_HOR_TOTAL-1 ) ? 0 : cnt_x + 1;
		if( cnt_x == C_HOR_TOTAL-1 )
			cnt_y <= ( cnt_y == C_VER_TOTAL-1 ) ? 0 : cnt_y + 1;
	end
	else
	begin
		cnt_x <= 0;
		cnt_y <= 0;
	end

  reg h_sync_reg;
  reg v_sync_reg;
  reg de_reg;

  always@( posedge xsvi_pix_clk or posedge Bus2IP_Reset)
	if( Bus2IP_Reset )
	begin
		h_sync_reg <= 0;
		v_sync_reg <= 0;
		de_reg <= 0;
	end
	else
	begin
		h_sync_reg <= ( cnt_x <= C_HOR_SYNC-1 ) ? 0 : 1;
		v_sync_reg <= ( cnt_y == C_VER_SYNC-1 ) ? 0 : 1;
		de_reg <= ( cnt_x >=  C_HOR_SYNC+C_HOR_BACK-1 && cnt_x < C_HOR_TOTAL-C_HOR_FRONT-1 
					&& cnt_y >= C_VER_SYNC+C_VER_BACK-1 && cnt_y < C_VER_TOTAL-C_VER_FRONT-1 ) ? 1 : 0;
	end

	assign xsvi_h_sync = h_sync_reg;
	assign xsvi_v_sync = v_sync_reg;
	assign xsvi_video_active = de_reg;
	//assign xsvi_video_data = ((cnt_x-C_HOR_SYNC-C_HOR_BACK)>=(cnt_y-C_VER_SYNC-C_VER_BACK))
										//? 24'hFF0000:24'h00FFFF;
	assign addra=(cnt_x-C_HOR_SYNC-C_HOR_BACK)+256*(cnt_y-C_VER_SYNC-C_VER_BACK);
	assign xsvi_video_data=douta;
*/
	
endmodule
