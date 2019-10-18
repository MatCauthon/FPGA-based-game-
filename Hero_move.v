`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Create Date:    
// Design Name: 
// Module Name:    Hero_move 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: It is used to decribe how the hero moves
//
// Dependencies: 
//
// Revision: 1.0
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Hero_move(
  clk_1,
  rst,
  right,
  left,
  up,
  down,
  position_hero_x,
  position_hero_y
  );
  
  input clk_1;// divide clk signal 
  input rst;//reset signal
  input left;
  input right;
  input up;
  input down;
  output position_hero_x;
  output position_hero_y;
  
  reg [3:0] position_hero_x;
  reg [3:0] position_hero_y;
  
  always@(negedge rst)
  begin
    if (!rst)
      begin
        position_hero_x<=4'd8;
        position_hero_y<=4'b0;
      end
  end
  
  always@(posedge left or posedge right)
  begin
    if (!right)
      begin
      if(position_hero_x)
        position_hero_x<=position_hero_x-1;
      end
    else
      begin
        if(position_hero_x<4'd13)
        position_hero_x<=position_hero_x+1;
      end     
  end
  
  always@(posedge up or posedge down)
  begin
    if (!down)
      begin
      if(position_hero_y<4'd13)
        position_hero_y<=position_hero_y+1;
      end
    else
      begin
        if(position_hero_y)
        position_hero_y<=position_hero_y-1;
      end     
  end
  
endmodule
