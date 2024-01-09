module switchbank_int (
input clk,
//--user side
input [15:0]switches ,
input enter_key,
//--cpu side
input ack,
output interrupt,
output [15:0]data_reg
) ; 

logic [1:0]pressed; 
always_ff @(posedge clk)
begin
pressed <= {pressed[0],enter_key};
if ( ( pressed == 2'b10 ) && ( interrupt == 1'b0 ) )
begin
interrupt <= 1'b1;
data_reg <= switches;
end
else if ( ack && ( interrupt == 1'b1 ) )
interrupt <=1'b0;
end

initial begin
data_reg = 16'h0000;
end 
endmodule