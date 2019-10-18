//----------------------------------------------------------------------------
// user_logic.vhd - module
//----------------------------------------------------------------------------
//
// ***************************************************************************
// ** Copyright (c) 1995-2010 Xilinx, Inc.  All rights reserved.            **
// **                                                                       **
// ** Xilinx, Inc.                                                          **
// ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"         **
// ** AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND       **
// ** SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,        **
// ** OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,        **
// ** APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION           **
// ** THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,     **
// ** AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE      **
// ** FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY              **
// ** WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE               **
// ** IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR        **
// ** REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF       **
// ** INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       **
// ** FOR A PARTICULAR PURPOSE.                                             **
// **                                                                       **
// ***************************************************************************
//
//----------------------------------------------------------------------------
// Filename:          user_logic.vhd
// Version:           1.00.a
// Description:       User logic module.
// Date:              Sat Sep 25 16:40:13 2010 (by Create and Import Peripheral Wizard)
// Verilog Standard:  Verilog-2001
//----------------------------------------------------------------------------
// Naming Conventions:
//   active low signals:                    "*_n"
//   clock signals:                         "clk", "clk_div#", "clk_#x"
//   reset signals:                         "rst", "rst_n"
//   generics:                              "C_*"
//   user defined types:                    "*_TYPE"
//   state machine next state:              "*_ns"
//   state machine current state:           "*_cs"
//   combinatorial signals:                 "*_com"
//   pipelined or register delay signals:   "*_d#"
//   counter signals:                       "*cnt*"
//   clock enable signals:                  "*_ce"
//   internal version of output port:       "*_i"
//   device pins:                           "*_pin"
//   ports:                                 "- Names begin with Uppercase"
//   processes:                             "*_PROCESS"
//   component instantiations:              "<ENTITY_>I_<#|FUNC>"
//----------------------------------------------------------------------------

module user_logic
(
  // -- ADD USER PORTS BELOW THIS LINE ---------------
  // --USER ports added here 
  xsvi_pix_clk,
  xsvi_h_sync,
  xsvi_v_sync,
  xsvi_video_data,
  xsvi_video_active,
  
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
  done,
  // -- ADD USER PORTS ABOVE THIS LINE ---------------

  // -- DO NOT EDIT BELOW THIS LINE ------------------
  // -- Bus protocol ports, do not add to or delete 
  Bus2IP_Clk,                     // Bus to IP clock
  Bus2IP_Reset                   // Bus to IP reset
//  Bus2IP_Data,                    // Bus to IP data bus
//  Bus2IP_BE,                      // Bus to IP byte enables
//  Bus2IP_RdCE,                    // Bus to IP read chip enable
//  Bus2IP_WrCE,                    // Bus to IP write chip enable
//  IP2Bus_Data,                    // IP to Bus data bus
//  IP2Bus_RdAck,                   // IP to Bus read transfer acknowledgement
//  IP2Bus_WrAck,                   // IP to Bus write transfer acknowledgement
//  IP2Bus_Error                    // IP to Bus error response
  // -- DO NOT EDIT ABOVE THIS LINE ------------------
); // user_logic

// -- ADD USER PARAMETERS BELOW THIS LINE ------------
// --USER parameters added here 
// -- ADD USER PARAMETERS ABOVE THIS LINE ------------

// -- DO NOT EDIT BELOW THIS LINE --------------------
// -- Bus protocol parameters, do not add to or delete
parameter C_SLV_DWIDTH                   = 32;
parameter C_NUM_REG                      = 16;
// -- DO NOT EDIT ABOVE THIS LINE --------------------

// -- ADD USER PORTS BELOW THIS LINE -----------------
// --USER ports added here 
input xsvi_pix_clk;
input xsvi_h_sync;
input xsvi_v_sync;
input [23:0] xsvi_video_data;
input xsvi_video_active;

output CH7301_clk_p;
output CH7301_clk_n;
output [11:0] CH7301_data;
output CH7301_h_sync;
output CH7301_v_sync;
output CH7301_de;
output CH7301_scl;
inout  CH7301_sda;
output CH7301_rstn;

output [7:0] xsvi_debug;
output       done;
// -- ADD USER PORTS ABOVE THIS LINE -----------------

// -- DO NOT EDIT BELOW THIS LINE --------------------
// -- Bus protocol ports, do not add to or delete
input                                     Bus2IP_Clk;
input                                     Bus2IP_Reset;

// -- DO NOT EDIT ABOVE THIS LINE --------------------

//----------------------------------------------------------------------------
// Implementation
//----------------------------------------------------------------------------

  // --USER nets declarations added here, as needed for user logic
//  wire done;
 // reg        [0 : C_SLV_DWIDTH-1]           debug_reg0;

  // --USER logic implementation added here
  Reset_Delay RESET_DELAY(
  .iCLK(Bus2IP_Clk),
  .iRST(~Bus2IP_Reset),
  .oRST_0(Reset_n),
  .oRST_1(),
  .oRST_2()
);
  iic_init_7301 iic_init_7301_inst (
  .Clk(Bus2IP_Clk),
  .Reset_n(Reset_n),
  .SDA(CH7301_sda),
  .SCL(CH7301_scl),
  .Done(done)
  ); 

  oddr_12 oddr_12_inst( 
  .Clk(xsvi_pix_clk),
  .Reset(Bus2IP_Reset|~done),
  .D1_12(xsvi_video_active ? xsvi_video_data[23:12] : 12'h000),//12'h000),
  .D2_12(xsvi_video_active ? xsvi_video_data[11:0] : 12'h000),//12'h0FF),
  .Q_12(CH7301_data)
  );

  assign CH7301_clk_p = xsvi_pix_clk;
  assign CH7301_clk_n = ~xsvi_pix_clk;
  assign CH7301_rstn = ~Bus2IP_Reset;
  assign CH7301_h_sync = (~done)? 0 : xsvi_h_sync;//h_sync_reg;
  assign CH7301_v_sync = (~done)? 0 : xsvi_v_sync;//v_sync_reg;
  assign CH7301_de = (~done)? 0 : xsvi_video_active;//de_reg;
  
  /*always @(posedge xsvi_pix_clk)
  if(Bus2IP_Reset)
	debug_reg0 <= 0;
  else
	debug_reg0 <= {CH7301_rstn, CH7301_de, CH7301_h_sync, CH7301_v_sync, xsvi_video_data};*/
  
  assign xsvi_debug[0] = CH7301_rstn;
  assign xsvi_debug[1] = Bus2IP_Reset;
  assign xsvi_debug[2] = xsvi_h_sync;
  assign xsvi_debug[3] = xsvi_v_sync;
  assign xsvi_debug[4] = CH7301_h_sync;
  assign xsvi_debug[5] = CH7301_v_sync;
  assign xsvi_debug[6] = CH7301_de;
  assign xsvi_debug[7] = xsvi_video_active;
  
//  reg [10:0] cnt_x;
//  reg [9:0] cnt_y;
//  
//  always@( posedge xsvi_pix_clk or posedge Bus2IP_Reset)
//	if( Bus2IP_Reset )
//	begin
//		cnt_x <= 0;
//		cnt_y <= 0;
//	end
//	else if( done )
//	begin
//		cnt_x <= ( cnt_x == 1023 ) ? 0 : cnt_x + 1;
//		if( cnt_x == 1023 )
//			cnt_y <= ( cnt_y == 626 ) ? 0 : cnt_y + 1;
//	end
//	else
//	begin
//		cnt_x <= 0;
//		cnt_y <= 0;
//	end
//
//  reg h_sync_reg;
//  reg v_sync_reg;
//  reg de_reg;
//
//  always@( posedge xsvi_pix_clk or posedge Bus2IP_Reset)
//	if( Bus2IP_Reset )
//	begin
//		h_sync_reg <= 0;
//		v_sync_reg <= 0;
//		de_reg <= 0;
//	end
//	else
//	begin
//		h_sync_reg <= ( cnt_x <= 32 ) ? 0 : 1;
//		v_sync_reg <= ( cnt_y == 0 ) ? 0 : 1;
//		de_reg <= ( cnt_x >=  150 && cnt_x < 950 && cnt_y >= 10 && cnt_y < 610 ) ? 1 : 0;
//	end
	

endmodule
