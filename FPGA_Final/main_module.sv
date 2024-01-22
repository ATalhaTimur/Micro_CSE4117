module main_module (
	input clk,
	input ps2c,
	input ps2d,
	output logic hsync,
	output logic vsync,
	output logic [2:0] rgb,
	// seven segment 
	output logic [6:0] display,
	output logic [3:0] grounds,
	input pushbutton //may be used for interrupt
);
// This project was made by Abdulkerim Talha Timur.

//=================================================
//memory map is defined here
//=================================================
localparam BEGINMEM 			= 12'h000;
localparam ENDMEM 			= 12'h1ff;
localparam KEYBOARD 			= 12'h900;
localparam SEVENSEG 			= 12'hb00;
localparam KEYBOARD_STATUS = 12'h901;
//=================================================
localparam VGA_SPACESHIP_X = 12'ha00;
localparam VGA_SPACESHIP_Y = 12'ha01;
localparam VGA_PLANET_X    = 12'ha02;
localparam VGA_PLANET_Y    = 12'ha03;
localparam VGA_INTACK		= 12'ha04;
//=================================================
localparam CLOCK_DATA		= 12'h500;
localparam CLOCK_STATUS		= 12'h501;
//=================================================
// cpu and i/o input out variable  
logic [15:0] clk_data;
logic [15:0] data_out; 
logic [15:0] data_in;
logic [15:0] ss7_out;
logic [11:0] address;
logic [15:0] keyb_out;
logic [25:0] clk1;
//=================================================
// variable for write vga (cpu to vga)
logic [15:0] spaceship_x;
logic [15:0] spaceship_y;
logic [15:0] planet_x;
logic [15:0] planet_y;
//=================================================
// Bitmap for planet and spaceship_bitmap
logic [15:0] spaceship_bitmap[0:15];
logic [15:0] planet_bitmap[0:15];
//=================================================
// Dinamic variable for planet 
logic isUp; // if isUp == 1, planet goes up, else goes down
logic isRight; // if isRight == 1, planet goes right, else goes left
//=================================================
// INT and memory write variable
logic memwt;
logic INT;
logic intack;
logic keyb_ack;
logic vga_ack;
logic vga_interrupt;
//=================================================
//  memory chip
logic [15:0] memory [0:511]; 
//====== pic ======================================
logic irq0, irq1, irq2, irq3, irq4, irq5, irq6, irq7;
//=================================================

sevensegment ss1 (
	.din(ss7_out), 
	.grounds(grounds), 
	.display(display), 
	.clk(clk)
);

keyboard  kbrd(
	.clk(clk),
	.ps2d(ps2d), 
	.ps2c(ps2c), 
	.dout(keyb_out), 
	.ack(keyb_ack)
);

vga_sync vga (
	.clk(clk),
	.ack(vga_ack),
	.interrupt(vga_interrupt),
	.hsync(hsync),
	.vsync(vsync),
	.rgb(rgb),
	.spaceship_x(spaceship_x),
	.spaceship_y(spaceship_y),
	.planet_x(planet_x),
	.planet_y(planet_y),
	.spaceship_bitmap(spaceship_bitmap),
	.planet_bitmap(planet_bitmap)
);

mammal mml (
	.clk(clk),
	.data_in(data_in),
	.data_out(data_out),
	.address(address),
	.memwt(memwt),
	.INT(INT),
	.intack(intack)
);

//===============IRQ's==============
always_comb
	begin
      irq0 = 1'b0;
      irq1 = 1'b0;
      irq2 = vga_interrupt;
      irq3 = 1'b0;
      irq4 = 1'b0;
      irq5 = 1'b0;
      irq6 = 1'b0;
      irq7 = 1'b0;
   end
	
//we assume that the devices hold their irq until being serviced by cpu
assign INT = irq0 | irq1 | irq2 | irq3 | irq4 | irq5 | irq6 | irq7; 

//multiplexer for cpu input
always_comb
	begin
		keyb_ack = 0;
		vga_ack = 0;
		if(intack == 0)
			begin
				keyb_ack = 0;
				vga_ack = 0;
				if ((BEGINMEM <= address) && (address <= ENDMEM))
					begin
						data_in = memory[address];
					end
			
				else if (address == KEYBOARD_STATUS)
					begin    
						data_in = keyb_out;
						keyb_ack = 0;
					end
					
				else if (address == KEYBOARD)
					begin
						keyb_ack = 1;
						data_in = keyb_out;
						
					end
				
				else if (address == VGA_SPACESHIP_X)
					begin
						vga_ack = 1;
						data_in = spaceship_x;
						
					end
					
				else if (address == VGA_SPACESHIP_Y)
					begin
						vga_ack = 1;
						data_in = spaceship_y;
						
					end
				
				else if (address == VGA_PLANET_X)
					begin
						vga_ack = 1;
						data_in = planet_x;
						
					end
					
				else if (address == VGA_PLANET_Y)
					begin
						vga_ack = 1;
						data_in = planet_y;
						
					end

				else if (address == CLOCK_STATUS)
					begin
						vga_ack = 1;
						data_in = {15'b0, clk1[22]};
						
					end
				
				else if (address == CLOCK_DATA)
					begin
						data_in = clk_data;
					end

				else
					begin
						data_in = 16'h1111;
					end
			end
			
		else
			begin
				if (irq0)
					data_in = 16'h0;
				else if (irq1)
					data_in = 16'h1;
				else if (irq2)
					data_in = 16'h2;
				else if (irq3)
					data_in = 16'h3;
				else if (irq4)
					data_in = 16'h4;
				else if (irq5)
					data_in = 16'h5;
				else if (irq6)
					data_in = 16'h6;
				else
					data_in = 16'h7;
			end
	end

//multiplexer for cpu output 
always_ff @(posedge clk) //data output port of the cpu
	begin
		clk1 <= clk1 + 1;
		if (memwt)
			begin
				if ((BEGINMEM <= address) && (address <= ENDMEM))
					memory[address] <= data_out;
					
				else if (VGA_SPACESHIP_X == address)
					spaceship_x <= data_out;
					
				else if (VGA_SPACESHIP_Y == address)
					spaceship_y <= data_out;
					
				else if (VGA_PLANET_X == address)
					planet_x <= data_out;
					
				else if (VGA_PLANET_Y == address)
					planet_y <= data_out;
						
				else if (SEVENSEG == address)
					ss7_out <= data_out;
					
				else if (CLOCK_DATA == address)
					clk_data <= data_out;
					
				else if (CLOCK_STATUS == address)
					 clk1 <= 0;

				else if (address == 12'h800)
					spaceship_bitmap[0] <= data_out;
				else if (address == 12'h801)
					spaceship_bitmap[1] <= data_out;
				else if (address == 12'h802)
					spaceship_bitmap[2] <= data_out;
				else if (address == 12'h803)
					spaceship_bitmap[3] <= data_out;
				else if (address == 12'h804)
					spaceship_bitmap[4] <= data_out;
				else if (address == 12'h805)
					spaceship_bitmap[5] <= data_out;
				else if (address == 12'h806)
					spaceship_bitmap[6] <= data_out;
				else if (address == 12'h807)
					spaceship_bitmap[7] <= data_out;
				else if (address == 12'h808)
					spaceship_bitmap[8] <= data_out;
				else if (address == 12'h809)
					spaceship_bitmap[9] <= data_out;
				else if (address == 12'h80a)
					spaceship_bitmap[10] <= data_out;
				else if (address == 12'h80b)
					spaceship_bitmap[11] <= data_out;
				else if (address == 12'h80c)
					spaceship_bitmap[12] <= data_out;
				else if (address == 12'h80d)
					spaceship_bitmap[13] <= data_out;
				else if (address == 12'h80e)
					spaceship_bitmap[14] <= data_out;
				else if (address == 12'h80f)
					spaceship_bitmap[15] <= data_out;	
				else if (address == 12'h810)
					planet_bitmap[0] <= data_out;
				else if (address == 12'h811)
					planet_bitmap[1] <= data_out;
				else if (address == 12'h812)
					planet_bitmap[2] <= data_out;
				else if (address == 12'h813)
					planet_bitmap[3] <= data_out;
				else if (address == 12'h814)
					planet_bitmap[4] <= data_out;
				else if (address == 12'h815)
					planet_bitmap[5] <= data_out;
				else if (address == 12'h816)
					planet_bitmap[6] <= data_out;
				else if (address == 12'h817)
					planet_bitmap[7] <= data_out;
				else if (address == 12'h818)
					planet_bitmap[8] <= data_out;
				else if (address == 12'h819)
					planet_bitmap[9] <= data_out;
				else if (address == 12'h81a)
					planet_bitmap[10] <= data_out;
				else if (address == 12'h81b)
					planet_bitmap[11] <= data_out;
				else if (address == 12'h81c)
					planet_bitmap[12] <= data_out;
				else if (address == 12'h81d)
					planet_bitmap[13] <= data_out;
				else if (address == 12'h81e)
					planet_bitmap[14] <= data_out;
				else if (address == 12'h81f)
					planet_bitmap[15] <= data_out;
			end
	end

initial 
    begin
			vga_ack = 0;
			keyb_ack = 0;		
			clk1 = 0;
			isUp = 1;
			isRight = 1;
			clk_data = 0;
			ss7_out = 16'h1515;	
			$readmemh("ram.dat", memory);
    end

endmodule