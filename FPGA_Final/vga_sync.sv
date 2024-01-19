module vga_sync
  (input logic        clk,
   output logic       hsync,
   output logic       vsync,
   output logic [2:0] rgb,
	input logic 	[15:0] x,
	input logic		[15:0] y);

   logic pixel_tick, video_on;
   logic [9:0] h_count;
   logic [9:0] v_count;
	
	logic [15:0] spaceship_bitmap[0:15];
   logic [15:0] planet_bitmap[0:15];
	
	logic [9:0] x_spaceship, y_spaceship;
	logic [9:0] x_planet, y_planet;
	
	 logic [3:0] h_speed_planet, v_speed_planet; 
    logic h_dir_planet, v_dir_planet;    

   localparam HD       = 640, //horizontal display area
              HF       = 48,  //horizontal front porch
              HB       = 16,  //horizontal back porch
              HFB      = 96,  //horizontal flyback
              VD       = 480, //vertical display area
              VT       = 10,  //vertical top porch
              VB       = 33,  //vertical bottom porch
              VFB      = 2,   //vertical flyback
                  LINE_END = HF+HD+HB+HFB-1,
              PAGE_END = VT+VD+VB+VFB-1;

   always_ff @(posedge clk)
     pixel_tick <= ~pixel_tick; //25 MHZ signal is generated.


   //=====Manages hcount and vcount======
  always_ff @(posedge clk) begin
    if (pixel_tick) begin
        // Ekranın piksel konumlarını güncelleme
        if (h_count == LINE_END) begin
            h_count <= 0;
            if (v_count == PAGE_END)
                v_count <= 0;
            else
                v_count <= v_count + 1;
        end else
            h_count <= h_count + 1;     

       
        
    end
end

      
   //=====================color generation=================  
   //== origin of display area is at (h_count, v_count) = (0,0)===
   always_comb
        begin
          rgb = 3'b000; // Arka plan rengi (yeşil)
       if ((h_count < 640) && (v_count < 480))
				begin
					if ((h_count >= x_spaceship) && (h_count < x_spaceship + 16) &&
						(v_count >= y_spaceship) && (v_count < y_spaceship + 16) &&
						 spaceship_bitmap[v_count - y_spaceship][h_count - x_spaceship]) 
							begin
								rgb = 3'b100; // Uzay gemisi rengi (kırmızı)
							end 
			  else if ((h_count >= x_planet) && (h_count < x_planet + 16) &&
                   (v_count >= y_planet) && (v_count < y_planet + 16) &&
                    planet_bitmap[v_count - y_planet][h_count - x_planet]) 
						  begin
								rgb = 3'b110; // Gezegen rengi (sarı)
							end
			  else
					rgb=3'b111;					
		end 
		
		 

		
				
end
   //=======hsync and vsync will become 1 during flybacks.=======
   //== origin of display area is at (h_count, v_count) = (0,0)===
   assign hsync = (h_count >= (HD+HB) && h_count <= (HFB+HD+HB-1));
   assign vsync = (v_count >= (VD+VB) && v_count <= (VD+VB+VFB-1));

   initial
     begin
	  // Uzay gemisi bitmapi
	  spaceship_bitmap[0] = 16'b0000000010000000;
	  spaceship_bitmap[1] = 16'b0000000111000000;
	  spaceship_bitmap[2] = 16'b0000000111000000;
	  spaceship_bitmap[3] = 16'b0000000111000000;
	  spaceship_bitmap[4] = 16'b0000000111000000;
	  spaceship_bitmap[5] = 16'b0000001111100000;
	  spaceship_bitmap[6] = 16'b0000011111110000;
	  spaceship_bitmap[7] = 16'b0000111111111000;
	  spaceship_bitmap[8] = 16'b0001111111111100;
	  spaceship_bitmap[9] = 16'b0000000111000000;
	  spaceship_bitmap[10] = 16'b0000000111000000;
	  spaceship_bitmap[11] = 16'b0000000111000000;
	  spaceship_bitmap[12] = 16'b0000000111000000;
	  spaceship_bitmap[13] = 16'b0000001111100000;
	  spaceship_bitmap[14] = 16'b0000011111110000;
	  spaceship_bitmap[15] = 16'b0000000111000000;
	  
	 planet_bitmap[0]  = 16'b0000011111100000;
    planet_bitmap[1]  = 16'b0001111111111000;
    planet_bitmap[2]  = 16'b0011111111111100;
    planet_bitmap[3]  = 16'b0111111111111110;
    planet_bitmap[4]  = 16'b0111111111111110;
    planet_bitmap[5]  = 16'b1111111111111111;
    planet_bitmap[6]  = 16'b1111111111111111;
    planet_bitmap[7]  = 16'b1111111111111111;
    planet_bitmap[8]  = 16'b1111111111111111;
    planet_bitmap[9]  = 16'b1111111111111111;
    planet_bitmap[10] = 16'b0111111111111110;
    planet_bitmap[11] = 16'b0111111111111110;
    planet_bitmap[12] = 16'b0011111111111100;
    planet_bitmap[13] = 16'b0001111111111000;
    planet_bitmap[14] = 16'b0000011111100000;
    planet_bitmap[15] = 16'b0000000000000000;
	  
		 x_spaceship = (640 - 16) / 2;
       y_spaceship = (480 - 16) / 2;
		 x_planet = (HD - 16) / 2; // Gezegen için de aynı
		 y_planet = (VD - 16) / 2;
      
		  h_speed_planet = 2; // Örnek hız değerleri
        v_speed_planet = 1;
        h_dir_planet = 1;   // 1 sağa, 0 sola
        v_dir_planet = 1;   // 1 aşağı, 0 yukarı
		  
        h_count = 0;
        v_count = 0;
        pixel_tick = 0;
		  
end

endmodule