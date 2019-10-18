`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:45:04 07/04/2015 
// Design Name: 
// Module Name:    hdmi_top 
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
module hdmi_top(
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
		AC97Clk,
		SData_In,
		AC97Reset_n,
		SData_Out,
		Sync,
		song_led,
		play_led,
		clk_ps2,
		data_ps2
    );
	 
	input             sys_clk;
	input             sys_rst;
   input             Bus2IP_Reset;
	input					AC97Clk;
	input					SData_In;
	
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
	output AC97Reset_n;        // Reset signal for AC97 controller/clock
	output SData_Out;          // Serial data out (control and playback data)SData_Out
	output Sync; 
	output [1:0] song_led;
	output play_led;
	
	input clk_ps2;
	input data_ps2;
	
	reg Bus2IP_Clk;
	always @(posedge sys_clk)
			Bus2IP_Clk <= ~Bus2IP_Clk;
	
	wire vga_clk,h_sysc,v_sysc,h_enable_write,v_enable_write;
	wire [7:0] vga_red,vga_green,vga_blue;
	
	wire xsvi_pix_clk = vga_clk;
	wire xsvi_h_sync = h_sysc;
	wire xsvi_v_sync = v_sysc;
	wire [23:0] xsvi_video_data = {vga_red,vga_green,vga_blue};
	wire xsvi_video_active = h_enable_write & v_enable_write;
	hdmi hdmi_inst(
	.sys_clk(sys_clk),
	.sys_rst(sys_rst),
   .Bus2IP_Reset(Bus2IP_Reset),
   .CH7301_clk_p(CH7301_clk_p),
   .CH7301_clk_n(CH7301_clk_n),
   .CH7301_data(CH7301_data),
   .CH7301_h_sync(CH7301_h_sync),
   .CH7301_v_sync(CH7301_v_sync),
   .CH7301_de(CH7301_de),
   .CH7301_scl(CH7301_scl),
   .CH7301_sda(CH7301_sda),
   .CH7301_rstn(CH7301_rstn),
	.xsvi_debug(xsvi_debug),
	
	.xsvi_pix_clk(xsvi_pix_clk),
   .xsvi_h_sync(xsvi_h_sync),
   .xsvi_v_sync(xsvi_v_sync),
   .xsvi_video_data(xsvi_video_data),
   .xsvi_video_active(xsvi_video_active),
	.Bus2IP_Clk(Bus2IP_Clk)
    );
	 
	 disp_top display_inst(
	 .Rst_N(~sys_rst),
	 .sys_clk(sys_clk),
	 .AC97Clk(AC97Clk),
	 .SData_In(SData_In),
	 
	 .H_Sysc(h_sysc),
	 .V_Sysc(v_sysc),
	 .RGB_R(vga_red),
	 .RGB_G(vga_green),
	 .RGB_B(vga_blue),
    .clk_pixel(vga_clk),
	// .vga_out_blank(vga_out_blank),
	// .vga_comp_synch(vga_comp_synch),
	 
	 .H_Enable(h_enable_write),
	 .V_Enable(v_enable_write),
	 .AC97Reset_n(AC97Reset_n),
	 .SData_Out(SData_Out),
	 .Sync(Sync),
	 .song_led(song_led),
	 .play_led(play_led)
			  );
	
endmodule
