module main_module (
                        input clk,
								output logic [2:0] rgb_input,
								output logic hsync_input,
								output logic vsync_input,              
                        output logic [3:0] grounds,
                        output logic [6:0] display,
								input   ps2d_input,
								input   ps2c_input
								
);


localparam    BEGINMEM = 12'h000,
              ENDMEM = 12'h7ff,                           
              SEVENSEG = 12'hb00,
				  KEYBOARD=12'h900,
				  VGAx=12'hc00,
				  VGAy=12'hc01;
//====memory chip==============
logic [15:0] memory [0:127]; 
 
//=====cpu's input-output pins=====
logic [15:0] data_out;
logic [15:0] data_in;
logic [11:0] address;
logic memwt;
logic INT;    //interrupt pin
logic intack; //interrupt acknowledgement
logic switch_interrupt;

//======ss7 and vga , kybrd=====
logic [15:0] ss7_out;
logic [15:0] input_arg;
logic [15:0] data_all;
logic [8:0] keyb_out; 
logic [3:0] keyout;
logic [15:0] x;
logic [15:0] y;


logic ackx;
logic ack;

//====== pic ===============
logic irq0, irq1, irq2, irq3, irq4, irq5, irq6, irq7;

//=====components==================
sevensegment sg1 (.clk(clk), .din(ss7_out), .display(display), .grounds(grounds));
vga_sync vga (
.clk(clk), 
.hsync(hsync_input), 
.vsync(vsync_input), 
.rgb(rgb_input),
.x(x), .y(y)
);

keyboard kybrd (
.clk(clk), 
.ps2d(ps2d_input), 
.ps2c(ps2c_input), 
.dout(keyb_out),
.ack(ack)
);

mammal m1( 
.clk(clk), 
.data_in(data_in), 
.data_out(data_out), 
.address(address), 
.memwt(memwt),
.INT(INT), 
.intack(intack));



//===============IRQ's==============
always_comb
    begin
      irq0 = 1'b0;
      irq1 = 1'b0;
      irq2 = switch_interrupt;
      irq3 = 1'b0;
      irq4 = 1'b0;
      irq5 = 1'b0;
      irq6 = 1'b0;
      irq7 = 1'b0;
   end

//we assume that the devices hold their irq until being serviced by cpu
assign INT = irq0 | irq1 | irq2 | irq3 | irq4 | irq5 | irq6 | irq7; 

//====multiplexer for cpu input======

always_comb
    if ( (BEGINMEM<=address) && (address<=ENDMEM) )
        begin
            data_in=memory[address];
            ack=0;
        end
    else if (address==KEYBOARD+1)
        begin    
            data_in=keyb_out;
            ack=0;
        end
    else if (address==KEYBOARD)
        begin
            data_in = keyb_out;
				ack = 1;
        end
    else
        begin
            data_in=16'h0000; //any number
            ack=0;
        end

//=====multiplexer for cpu output=========== 
always_ff @(posedge clk) //data output port of the cpu
   	begin
		if (memwt) // yazma islemi yapilacaksa
			begin
				if ((BEGINMEM <= address) && (address <= ENDMEM)) // address memorynin araligindaysa
					begin
						memory[address] <= data_out;
					end				
				
				else if (SEVENSEG == address) 
					begin
						ss7_out <= data_out;
					end
			   else if ( VGAx == address)
				   begin
					x <= data_out;					
					end
				else if (VGAy == address)
					begin
					y <= data_out;					
				   end					
				
			end
	end



initial 
    begin
         switch_interrupt =0;
         ss7_out=16'h0011;
		   data_all=0;
			ack=0;
         $readmemh("ram.dat", memory);
    end
endmodule