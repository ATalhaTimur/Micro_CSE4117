.data
.code
      	 ldi 2 0xb00  
      	 ldi 6 0x0000
      	 st 2 6
         ldi 5 0x0005 
      	 ldi 7 0x600
      	 ldi 0 0x7f2
      	 ldi 1 isr
      	 st  0 1
      	 sti
loop     jmp loop
isr   	 ldi 3 0x900
      	 ld 3 3
      	 add 6 6 5
      	 st 2 6	
	 sti
      	 iret