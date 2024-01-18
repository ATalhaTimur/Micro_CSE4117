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
              SWITCHBANK = 12'h900,               
              SEVENSEG = 12'hb00,
				  SWITCHBANK_STATUS_left=12'h901,
              SWITCHBANK_STATUS_right=12'h903;

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

//======ss7 and switchbank=====
logic [15:0] ss7_out;
logic [15:0] input_arg;
logic [15:0] switch_in_left;
logic [15:0] switch_in_right;
logic ackx;

//====== pic ===============
logic irq0, irq1, irq2, irq3, irq4, irq5, irq6, irq7;

//=====components==================

vga_sync vga (
.clk(clk), 
.hsync(hsync_input), 
.vsync(vsync_input), 
.rgb(rgb_input));

keyboard kybrd (
.clk(clk), 
.ps2d(ps2d), 
.ps2c(ps2c_input), 
.dout(data_in));

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
begin
ackx = 0;
        if (intack == 0)
        begin
            ackx = 0;
            if ( (BEGINMEM<=address) && (address<=ENDMEM) )
						 begin
							data_in=memory[address];
						  end
            else if (address==SWITCHBANK)
                    begin
                         ackx = 1;              
                         data_in = input_arg;   
                    end
				 else if (address == SWITCHBANK_STATUS_left)
							 begin
									ackx = 1;                 
									data_in <= switch_in_left;   
								end
				else if (address == SWITCHBANK_STATUS_right)
								begin
									ackx = 1;             
									data_in = switch_in_right;   
								end				
				  
            else
                      data_in=16'hf345; //last else to generate combinatorial circuit.
                
         end
         else                        //intack = 1
            begin
             if (irq0)               //highest priority interrupt is irq0
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
             else                           //  irq7 
                 data_in = 16'h7;
            end
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
					
				else if (SWITCHBANK == address)
					begin
						input_arg <= data_out;
					end
				
				else if (SEVENSEG == address) 
					begin
						ss7_out <= data_out;
					end
			end
	end



initial 
    begin
         switch_interrupt =0;
         ss7_out=16'h0001;
		   input_arg=16'h0001;
       // $readmemh("ram.dat", memory);
    end
endmodule