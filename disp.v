module disp(
      sys_clk,
			Rst_N,
			clk_pixel,
			H_Sysc,
			V_Sysc,
			RGB_R,
			RGB_G,
			RGB_B,
			H_Enable,
			V_Enable,
			flag_out
    );
    
    
	input Rst_N;
	input sys_clk;				//100mhz
	output clk_pixel;			//25mhz
	output H_Sysc;
	output V_Sysc;
	output [7:0] RGB_R;
	output [7:0] RGB_G;
	output [7:0] RGB_B;
	output H_Enable;
	output V_Enable;
	output flag_out;
	
	reg [7:0] RGB_RED;
	reg [7:0] RGB_GREEN;
	reg [7:0] RGB_BLUE;
	wire [7:0] RGB_R;
	wire [7:0] RGB_G;
	wire [7:0] RGB_B;
	
	reg [9:0] addrb;
	wire [9:0] addra;

	wire H_Sysc;
	wire V_Sysc;
	wire H_Enable;
	wire V_Enable;
	wire flag_out;
	wire [9:0]H_Pixel_Count;
	wire [9:0]V_Line_Count;
	wire [9:0]H_count;
	wire [9:0]V_count;
	wire [7:0]douta;
	wire clk_500khz;
	
	assign H_count=H_Pixel_Count-8'd144; // the original of the floor
	assign V_count=V_Line_Count-5'd31;
	assign addra=addrb;
	
	assign RGB_R = RGB_RED;
	assign RGB_G = RGB_GREEN;
	assign RGB_B = RGB_BLUE;

abonus abonus( .clka(clk_pixel),
				       .addra(addra),
				       .douta(douta));

clk_div clk_div(.rst_n(Rst_N),
                .clk_100mhz(sys_clk),
					 .clk_25mhz(clk_pixel),
						.clk_500khz(clk_500khz)
						);
						
VGA vga(
				.Rst_N(Rst_N), 
				.Clk_Pixel(clk_pixel), 
				.H_Sysc(H_Sysc), 
				.V_Sysc(V_Sysc),
				.H_Enable_Write(H_Enable),
				.V_Enable_Write(V_Enable),
				.H_Pixel_Count(H_Pixel_Count), 
				.V_Line_Count(V_Line_Count)			
			 );
			 				       
always @ (posedge clk_pixel)
		if(H_Enable&&V_Enable)
		begin
		  if(H_Pixel_Count>10'd576 && H_Pixel_Count<10'd609 && V_Line_Count>10'd127 && V_Line_Count<10'd160)
		    begin
		    if(V_Line_Count>10'd127 && V_Line_Count<10'd160)
			    begin
					addrb<=(H_count-10'd432)+(V_count-10'd96)*6'd32;
					RGB_RED<={douta[7:5],5'b0};
					RGB_GREEN<={douta[4:2],5'b0};
					RGB_BLUE<={douta[1:0],6'b0};
					end
				end
			else
			begin
					RGB_RED<=8'b11111111;
					RGB_GREEN<=8'b11111111;
					RGB_BLUE<=8'b11111111;
			end				
		end
endmodule