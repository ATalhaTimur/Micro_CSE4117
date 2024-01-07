module switchbank(
	input clk,
	//--user side
	input  [15:0] switches,
	input enter_key,
	//--cpu side
	input a0,
	input ack,
	output [15:0] data_out
);

logic [1:0] pressed;
logic [15:0] status_reg; 
logic [15:0] data_reg; 

always_ff @(posedge clk)// added @(posedge clk)
    begin
        pressed <= {pressed[0], enter_key};
		  
        if ( ( pressed == 2'b10 ) && ( status_reg[0] == 1'b0 ) )
			  begin
					 status_reg  <= 16'b1;
					 data_reg    <= switches;
			  end
			  
        else if ( ack & !a0  )
			 begin
             status_reg <=16'b0;
          end
    end

always_comb
	begin
		if (a0) // a0=1 oldugunda status'u alacagiz, 0 ise devicedan datayi alacagiz
			begin
				data_out = status_reg;
			end
			
		else
			begin
				data_out = data_reg;
			end
	end

assign ack_sw = ack;
     
initial 
	begin
		status_reg = 16'b0;
	end
	
endmodule