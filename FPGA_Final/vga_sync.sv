module vga_sync (
	input logic 	clk,
	input logic 	ack,
	output logic 	interrupt,
   output logic	hsync,
   output logic	vsync,
   output logic [2:0]	rgb,
	input logic [15:0] 	spaceship_x,
	input logic [15:0] 	spaceship_y,
	input logic [15:0] 	planet_x,
	input logic [15:0] 	planet_y,
	input logic [15:0] 	spaceship_bitmap[0:15],
	input logic [15:0] 	planet_bitmap[0:15]
);

logic pixel_tick, video_on;
logic [9:0] h_count, v_count;

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
	begin
		pixel_tick <= ~pixel_tick; //25 MHZ signal is generated.
	end

//=====Manages hcount and vcount======
always_ff @(posedge clk)
	begin
		if (pixel_tick) 
			begin
				if (h_count == LINE_END)
					begin
						h_count <= 0;
						if (v_count == PAGE_END)
							v_count <= 0;
                  else
                     v_count <= v_count + 1;
               end
				else
					h_count <= h_count + 1;
			 end
	end

//=====================color generation=================  
//== origin of display area is at (h_count, v_count) = (0,0)===
always_comb
	begin
		rgb = 3'b000;
		if ((h_count < HD) && (v_count < VD))
			begin
				if ((h_count >= spaceship_x) && (h_count < spaceship_x + 16) &&
					 (v_count >= spaceship_y) && (v_count < spaceship_y + 16) &&
					  spaceship_bitmap[v_count - spaceship_y][h_count - spaceship_x])
					begin
						rgb = 3'b100;
					end
					
				else if ((h_count >= planet_x) && (h_count < planet_x + 16) &&
							(v_count >= planet_y) && (v_count < planet_y + 16) &&
							 planet_bitmap[v_count - planet_y][h_count - planet_x])
					begin
						rgb = 3'b110;
					end
					
				else
					begin
						rgb = 3'b010;
					end
			end
			
	end

//=======hsync and vsync will become 1 during flybacks.=======
//== origin of display area is at (h_count, v_count) = (0,0)===
assign hsync = (h_count >= (HD+HB) && h_count <= (HFB+HD+HB-1));
assign vsync = (v_count >= (VD+VB) && v_count <= (VD+VB+VFB-1));

always_ff @(posedge clk) // I'm trying to integrate interrupt
	begin
		if ((vsync == 1'b0) && (interrupt == 1'b0))
			begin
				interrupt <= 1'b1;
			end
			
		else if (ack && (interrupt == 1'b1))
			begin
				interrupt <= 1'b0;
			end
	end

initial
	begin
		h_count = 0;
		v_count = 0;
		pixel_tick = 0;
	end

endmodule