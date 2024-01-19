module main_module (
	input clk,
	input ps2c,
	input ps2d,
	output logic hsync,
	output logic vsync,
	output logic [2:0] rgb,
	//---output to seven segment display
	output logic [6:0] display,
	output logic [3:0] grounds,
	input pushbutton //may be used as clock
);

logic [15:0] data_all;
logic [8:0] keyb_out;
logic [3:0] keyout;
logic ack;
logic [31:0] clk1;

logic [15:0] spaceship_x;
logic [15:0] spaceship_y;
logic [15:0] prev_spaceship_x;
logic [15:0] prev_spaceship_y;
logic [15:0] planet_x;
logic [15:0] planet_y;
logic [15:0] spaceship_bitmap[0:15];
logic [15:0] planet_bitmap[0:15];
logic isUp; // if isUp == 1, planet goes up, else goes down
logic isRight; // if isRight == 1, planet goes right, else goes left

//memory map is defined here
localparam BEGINMEM = 12'h000;
localparam ENDMEM = 12'h1ff;
localparam KEYBOARD = 12'h900;

localparam VGA_SPACESHIP_X = 12'hd00; // Adjust the address based on your memory map
localparam VGA_SPACESHIP_Y = 12'hd01; // Adjust the address based on your memory map
localparam VGA_PLANET_X    = 12'hd02; // Adjust the address based on your memory map
localparam VGA_PLANET_Y    = 12'hd03; // Adjust the address based on your memory map


// seven segment icin sonradan silinebilir
localparam SEVENSEG = 12'hb00;
logic [15:0] ss7_out;

//  memory chip
logic [15:0] memory [0:150]; 

// cpu's input-output pins
logic [15:0] data_out;
logic [15:0] data_in;
logic [12:0] address;
logic memwt;

// sonradan kendi olusturduklarim
logic INT;
logic intack;

sevensegment ss1 (
	.din(ss7_out), 
	.grounds(grounds), 
	.display(display), 
	.clk(clk)
);

keyboard  kb1(
	.clk(clk),
	.ps2d(ps2d), 
	.ps2c(ps2c), 
	.dout(keyb_out), 
	.ack(ack)
);

vga_sync vg1 (
	.clk(clk), 
	.hsync(hsync), 
	.vsync(vsync), 
	.rgb(rgb),
	.x_spaceship(spaceship_x),
	.y_spaceship(spaceship_y),
	.x_planet(planet_x),
	.y_planet(planet_y)
);

mammal m1 (
	.clk(clk), 
	.data_in(data_in), 
	.data_out(data_out), 
	.address(address), 
	.memwt(memwt),
	.INT(INT), 
	.intack(intack)
);

//multiplexer for cpu input
always_comb
	begin		
		if ((BEGINMEM <= address) && (address <= ENDMEM))
			begin
				data_in = memory[address];
				ack = 0;
			end
			
		else if (address == KEYBOARD + 1)
			begin    
				data_in = keyb_out;
				ack = 0;
			end
			
		else if (address == KEYBOARD)
			begin
				data_in = keyb_out;
				ack = 1;
			end
		
		else if (address == VGA_SPACESHIP_X)
			begin
				data_in = spaceship_x;
				ack = 0;
			end
			
		else if (address == VGA_SPACESHIP_Y)
			begin
				data_in = spaceship_y;
				ack = 0;
			end
	
		else
			begin
				data_in = 16'h0000; //any number
				ack = 0;
			end
	end
	
always_ff @(posedge clk)
	begin
		clk1 <= clk1 + 1;
		
		if (clk1[25])
			begin
				clk1 <= 0;
				if (isRight)
					begin
						if ((620 <= planet_x) && (planet_x <= 640))
							begin
								isRight <= 0;
								planet_x <= 620;
							end
						else
							begin
								planet_x <= planet_x + 20;
							end
					end
					
				else if (isRight == 0)
					begin
						if (planet_x <= 0)
							begin
								isRight <= 1;
								planet_x <= 0;
							end
						else
							begin
								planet_x <= planet_x - 20;
							end
					end
					
				 if (isUp)
					begin
						if ((470 <= planet_y) && (planet_y <= 480))
							begin
								isUp <= 0;
								planet_y <= 470;
							end
						else
							begin
								planet_y <= planet_y + 10;
							end
					end
					
				else if (isUp == 0)
					begin
						if (planet_y <= 0)
							begin
								isUp <= 1;
								planet_y <= 0;
							end
						else
							begin
								planet_y <= planet_y - 10;
							end
					end
			end
	end

//multiplexer for cpu output 
always_ff @(posedge clk) //data output port of the cpu
	begin
		if (memwt)
			begin
				if ((BEGINMEM <= address) && (address <= ENDMEM))
					begin
						memory[address] <= data_out;
					end
					
				else if (VGA_SPACESHIP_X == address)
					begin
						// Update x position of the spaceship
						if (data_out <= 0)
								spaceship_x <= 4;
						else if (data_out > 624)
							spaceship_x <= 624;
						else
							spaceship_x <= data_out;
					end
					
				else if (VGA_SPACESHIP_Y == address)
					begin
						// Update y position of the spaceship
						if (data_out <= 0)
							spaceship_y <= 4;
						else if (data_out > 464)
							spaceship_y <= 464;
						else
							spaceship_y <= data_out;
					end
					
				else if (VGA_PLANET_X == address)
					begin
						
					end
					
				else if (VGA_PLANET_Y == address)
					begin
					end
					
					
				// seven segment icin sonradan silinebilir
				else if (SEVENSEG == address)
					begin
						
						ss7_out <= data_out;
					end
			end
	end


initial 
    begin
			data_all = 0;			
			ack = 0;
			// seven segment icin sonradan silinebilir
			ss7_out = 16'h3136;
			clk1 = 0;
			spaceship_x = 500;
			spaceship_y = 180;
			isUp = 1;
			isRight = 1;
			planet_x = 40;
			planet_y = 40;
			
			
			

			$readmemh("ram.dat", memory);
    end

endmodule