.data
.code
        ldi 7 0x700        
        ldi 0 0x7f2
        ldi 1 isr
        st  0 1
	
        
main_l  sti
        ldi 2 0x901
        ldi 3 0x0001
        ld 2 2
        sub 2 2 3	
        jz left_b
        jmp main_l

left_b  cli
	ldi 3 0x900	
        ld  3 3
       	inc 3
        ldi 4 0x900
        st 4 3
	sti
        call display	
        jmp main_l

isr     
	cli
        ldi 3 0x900
        ld 3 3
        add 3 3 3
        ldi 4 0x900
        st 4 3
	sti
	call display	
        iret

display ldi 3 0x900
        ld 3 3
        ldi 2 0xb00
        st 2 3
        ret