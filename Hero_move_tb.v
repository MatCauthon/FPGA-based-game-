`timescale 1ns / 1ps
module Hero_move_tb();

reg clk;
reg rst;

reg left;
reg right;
reg up;
reg down;

wire [3:0] position_hero_x;
wire [3:0] position_hero_y;

Hero_move hero_move(.clk_1(clk),.rst(rst),.left(left),.right(right),.up(up),.down(down),.position_hero_x(position_hero_x),.position_hero_y(position_hero_y));
initial
begin
  left=0;
  right=0;
  up=0;
  down=0;
  clk=0;
  rst=1;
  #3;
 rst=0;
 #6;
 rst=1;
  #5;
 right=1;
  #5;
  right=0;
  up=1;
  #5 
  up=0;
  left=1;
  #5 
  left=0;
  down=1;
end
always #10 clk=~clk;

endmodule
