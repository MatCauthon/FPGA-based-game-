module VGA(
				Rst_N, 
				Clk_Pixel, 
				H_Sysc, 
				V_Sysc,
				H_Enable_Write,
				V_Enable_Write,
				H_Pixel_Count, 
				V_Line_Count				
			 );
			 
    input 					Rst_N;            // system reset signal, asserted by low 
    input 					Clk_Pixel;        // 25Mhz pixel clock
    output 					H_Sysc;           // horizontal sysc signal
    output 					V_Sysc;           // vertical sysc signal
	 output					H_Enable_Write;   // horizontal enable draw signal
	 output					V_Enable_Write;   // vertical enable draw signal

    output 	[9:0] 		H_Pixel_Count;    // current pixel count of horizontal pixel
    output 	[9:0] 		V_Line_Count;		// current line count of vertical pixel
	 
	 reg 						H_Sysc;
    reg 						V_Sysc;
	 reg						H_Enable_Write;
	 reg						V_Enable_Write;
	 reg		[9:0]			H_Pixel_Count;
    reg 		[9:0] 		V_Line_Count;
	 
	 parameter H_PIXELS = 800;
	 parameter V_LINES  = 521;
	 parameter H_ACTIVE_REGION = 640;
	 parameter V_ACTIVE_REGION = 480;
	 parameter H_FRONT_PORCH = 16;
	 parameter H_BACK_PORCH  = 48;
	 parameter V_FRONT_PORCH = 10;
	 parameter V_BACK_PORCH  = 29;
	 parameter H_SYSC_PERIOD = 96;
	 parameter V_SYSC_PERIOD = 2;
	 
	 
	 /////////////////////////////////////////////////////////////////////////////////
	 //                                                                             //
	 // Generate the current horizontal pixel count and vertical line count.        //
	 //                                                                             //        
	 /////////////////////////////////////////////////////////////////////////////////
	 always @ ( posedge Clk_Pixel or negedge Rst_N )
	 begin
		if(!Rst_N)
			begin
				H_Pixel_Count <= 0;
				V_Line_Count  <= 0;
			end
		else
			begin
				H_Pixel_Count <= (H_Pixel_Count==(H_PIXELS-1))?10'h000:H_Pixel_Count+1;
				V_Line_Count  <= (H_Pixel_Count==(H_PIXELS-1))?((V_Line_Count==(V_LINES-1))?10'h000:V_Line_Count+1):V_Line_Count;
			end
	 end
	
	 /////////////////////////////////////////////////////////////////////////////////
	 //                                                                             //
	 // Generate the horizontal sysc pulse signal and vertical sysc pulse signal.   //
	 // The sysc signal is active by 0                                              //
	 //                                                                             //
	 /////////////////////////////////////////////////////////////////////////////////
	 always @ ( posedge Clk_Pixel or negedge Rst_N )
	 begin
		if(!Rst_N)
			begin
				H_Sysc <= 0;
				V_Sysc <= 0;
			end
		else
			begin
				H_Sysc <= ( H_Pixel_Count>= H_SYSC_PERIOD )?1:0;								
				V_Sysc <= ( V_Line_Count>= V_SYSC_PERIOD )?1:0;				
			end
	 end
	 
	 /////////////////////////////////////////////////////////////////////////////////
	 //                                                                             //
	 // Generate the enable signal to write into RGB                               //
	 //                                                                             //
	 /////////////////////////////////////////////////////////////////////////////////
	 always @ ( posedge Clk_Pixel or negedge Rst_N )
	 begin
		if(!Rst_N)
			begin
				H_Enable_Write <= 0;
				V_Enable_Write <= 0;
			end
		else
			begin
				H_Enable_Write <= ( (H_Pixel_Count >= (H_SYSC_PERIOD+H_BACK_PORCH))&&
										  (H_Pixel_Count < (H_SYSC_PERIOD+H_BACK_PORCH+H_ACTIVE_REGION)) )?1:0;								
				V_Enable_Write <= ( (V_Line_Count >= (V_SYSC_PERIOD+V_BACK_PORCH))&&
										  (V_Line_Count < (V_SYSC_PERIOD+V_BACK_PORCH+V_ACTIVE_REGION)) )?1:0;
			end
	 end

endmodule
