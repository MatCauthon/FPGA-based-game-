`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: LZJ
// 
// Create Date:    
// Design Name: 
// Module Name:    AI_move 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: It is used to decribe how the AI moves.It includes detect num.
//
// Dependencies: 
//
// Revision: 1.0
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module AI_move(clk_1,rst,position_hero_x,position_hero_y,AI_NUM,AI_DETAIL,position_AI_x,position_AI_y,detect_num);
  input clk_1;
  input rst;
  input position_hero_x;
  input position_hero_y;
  input AI_NUM;
  input [AI_NUM:0] AI_DETAIL [2:0];
  output [AI_NUM:0] position_AI_x [3:0];
  output [AI_NUM:)] position_AI_y [3:0];
  output detect_num []
  
