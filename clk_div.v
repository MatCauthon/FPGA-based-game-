`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:29:03 07/07/2015 
// Design Name: 
// Module Name:    clk_div 
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
module clk_div(rst_n, 
			   clk_100mhz, 
			   clk_25mhz,
			   clk_500khz);
input rst_n, clk_100mhz;
  
  //Outputs
  output clk_25mhz,clk_500khz;
  
  wire rst_n, clk_100mhz;
  reg clk_25mhz,clk_500khz;
  reg counter1;
  reg [26:0]counter2;

  
  always @(posedge clk_100mhz or negedge rst_n)
  begin
    if(!rst_n)
	begin
      counter1 <= 1'b0;
	end
    else
	begin
      counter1 <= counter1+1;
	end
	end
  
  always @(posedge clk_100mhz or negedge rst_n)
  begin
    if(!rst_n)
      clk_25mhz <= 0;
    else if(counter1 == 1)
      clk_25mhz <= ~clk_25mhz;
  end
  
  always @(posedge clk_100mhz or negedge rst_n)
  begin
    if(!rst_n)
	 begin
      clk_500khz <= 0;
		counter2<=0;
	end
    else 
	 begin
		counter2<=counter2+1;
		if(counter2 == 250000)
		begin
			clk_500khz <= ~clk_500khz;
			counter2<=0;
		end
	 end
	end
 endmodule