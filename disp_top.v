`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:39:45 07/13/2015 
// Design Name: 
// Module Name:    disp_top 
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
module disp_top(Rst_N,
	 sys_clk,
	 AC97Clk,
	 SData_In,
	 
	 H_Sysc,
	 V_Sysc,
	 RGB_R,
	 RGB_G,
	 RGB_B,
    clk_pixel,
	 H_Enable,
	 V_Enable,
	 AC97Reset_n,
	 SData_Out,
	 Sync,
	 song_led,
	 play_led
    );
input	Rst_N;
input	sys_clk;
input  AC97Clk;            // AC97 clock (~12 Mhz)
input  SData_In;
output H_Sysc;
output V_Sysc;
output RGB_R;
output RGB_G;
output RGB_B;
output H_Enable;
output V_Enable;
output clk_pixel;
output AC97Reset_n;        // Reset signal for AC97 controller/clock
output SData_Out;          // Serial data out (control and playback data)SData_Out
output Sync;  
output [1:0] song_led;
output play_led;
	
wire [7:0] RGB_R;
wire [7:0] RGB_G;
wire [7:0] RGB_B;
wire flag_out;
disp disp(.sys_clk(sys_clk),
			.Rst_N(Rst_N),
			.clk_pixel(clk_pixel),
			.H_Sysc(H_Sysc),
			.V_Sysc(V_Sysc),
			.RGB_R(RGB_R),
			.RGB_G(RGB_G),
			.RGB_B(RGB_B),
			.H_Enable(H_Enable),
			.V_Enable(V_Enable),
			.flag_out(flag_out)
    );
	 




endmodule
