//mammal CPU
module mammal (
      input clk,
      input [15:0] data_in,
      output logic [15:0] data_out,
      output logic [11:0] address,
      output memwt,
      input INT,
      output intack
);
logic [11:0] pc,ir; //program counter, instruction register
logic [11:0] interruptreg; //to hold temporary isr address during interrupt processing
logic [4:0] state; //FSM
logic [15:0] regbank [7:0];//registers
logic zeroflag; //zero flag register
logic intflag; //interrupt flag
logic [15:0] result; //output for ALU
logic zeroresult;

localparam FETCH=5'b00000,
LDI=5'b00001,
LD=5'b00010,
ST=5'b00011,
JZ=5'b00100,
JMP=5'b00101,
ALU=5'b00111,
PUSH=5'b01000,
POP1=5'b01001,
CALL=5'b01010,
RET1=5'b01011,
STI=5'b01100,
CLI=5'b01101,
IRET1=5'b01110,

POP2= 5'b10000,
RET2= 5'b10001,
IRET2=5'b10010,
IRET3=5'b10011,
INT1= 5'b10100,
INT2= 5'b10101,
INT3= 5'b10110;

always_ff @(posedge clk)
begin
    case(state)
    FETCH:
    begin
        if ( {1'b0,data_in[15:12] }==JZ)
            if (zeroflag)
               state <= JMP;
            else
               state <= FETCH;
        else
            state <= { 1'b0, data_in[15:12] };
        ir<=data_in[11:0];
        pc<=pc+1;
    end

    LDI:
    begin
        regbank[ ir[2:0] ] <= data_in;
        pc<=pc+1;
       if ( intflag & INT )
              state <= INT1;
       else
              state <= FETCH;
      end

     LD:
     begin
         regbank[ir[2:0]] <= data_in;
         if ( intflag & INT )
              state <= INT1;
         else
              state <= FETCH;
      end

      ST:
      begin
          if ( intflag & INT )
              state <= INT1;
         else
              state <= FETCH;
      end

      JMP:
      begin
           pc <= pc+ir;
           if ( intflag & INT )
                state <= INT1;
           else
                state <= FETCH;
       end

       ALU:
       begin
           regbank[ir[2:0]]<=result;
           zeroflag<=zeroresult;
           if ( intflag & INT )
                  state <= INT1;
           else
                  state <= FETCH;
           end

      PUSH:
      begin
           regbank[7]<=regbank[7]-1;
           if ( intflag & INT )
               state <= INT1;
           else
               state <= FETCH;
      end

      POP1:
      begin
           regbank[7]<=regbank[7]+1;
           state <= POP2;
      end

     POP2: //it is possible to eliminate pop2 by adding a register
     begin
           regbank[ir[2:0]] <= data_in;
           if ( intflag & INT )
                state <= INT1;
           else
                state <= FETCH;
      end

CALL:
begin
regbank[7]<=regbank[7]-1;
pc<=pc+ir;
if ( intflag & INT )
state <= INT1;
else
state <= FETCH;
end

RET1:
begin
regbank[7]<=regbank[7]+1;
state <= RET2;
end

RET2:
begin
pc<=data_in[11:0];
if ( intflag & INT )
state <= INT1;
else
state <= FETCH;
end

INT1:
begin
regbank[7]<=regbank[7]-1;
intflag <= 0;
state <= INT2;
end

INT2:
begin
regbank[7]<=regbank[7]-1;
interruptreg <= 12'(data_in+16'h07f0);
state <= INT3;
end

INT3:
begin
pc<=data_in[11:0];
state <= FETCH;
end

IRET1:
begin
regbank[7]<=regbank[7]+1;
state <= IRET2;
end

IRET2:
begin
regbank[7]<=regbank[7]+1;
zeroflag <= data_in[0];
state <= IRET3;
end

IRET3:
begin
pc <= data_in;
if ( intflag & INT )
state <= INT1;
else
state <= FETCH;
end

STI:
begin
intflag <= 1;
if ( intflag & INT )
state <= INT1;
else
state <= FETCH;
end

CLI:
begin
intflag <= 0;
state <= FETCH;
end

endcase
end

//==============address========================
always_comb
case (state)
LD: address=regbank[ir[5:3]][11:0];
ST: address=regbank[ir[5:3]][11:0];
PUSH: address=regbank[7][11:0];
POP2: address=regbank[7][11:0];
CALL: address=regbank[7][11:0];
RET2: address=regbank[7][11:0];
INT1: address=regbank[7][11:0];
INT2: address=regbank[7][11:0];
INT3: address=interruptreg;
IRET1: address=regbank[7][11:0];
IRET2: address=regbank[7][11:0];
IRET3: address=regbank[7][11:0];
default: address=pc;
endcase

//================memwt===================================
assign memwt=(state==ST)||(state==PUSH)||(state==CALL) || (state==INT1) || (state==INT2);

//=================intack================================
always_comb
begin
case (state)
INT2: intack = 1'b1;
default: intack = 1'b0;
endcase
end
//================data_out=============================
always_comb
begin
case (state)
CALL: data_out = {4'b0,pc};
INT1: data_out = {4'b0,pc};
INT2: data_out = {15'b0, zeroflag};
default: data_out = regbank[ir[8:6]];
endcase
end

always_comb //ALU Operation
case (ir[11:9])
3'h0: result = regbank[ir[8:6]]+regbank[ir[5:3]]; //000
3'h1: result = regbank[ir[8:6]]-regbank[ir[5:3]]; //001
3'h2: result = regbank[ir[8:6]]&regbank[ir[5:3]]; //010
3'h3: result = regbank[ir[8:6]]|regbank[ir[5:3]]; //011
3'h4: result = regbank[ir[8:6]]^regbank[ir[5:3]]; //100
3'h7: case (ir[8:6])
3'h0: result = !regbank[ir[5:3]];
3'h1: result = regbank[ir[5:3]];
3'h2: result = regbank[ir[5:3]]+1;
3'h3: result = regbank[ir[5:3]]-1;
default: result=16'h0000;
endcase
default: result=16'h0000;
endcase

assign zeroresult = ~|result;

initial
begin
state=FETCH;
zeroflag=0;
pc=0;
intflag=0; //at the start, interrupts are disabled. programmer must open them by a sti.
end
endmodule