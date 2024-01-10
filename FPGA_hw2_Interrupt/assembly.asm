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
        cli	
        jz left_b	  	
        jmp to_dec

left_b  
        ldi 3 0x900	
        ld  3 3
        inc 3
        ldi 4 0x900
        st 4 3
        jmp main_l

isr     cli
        ldi 3 0x900
        ld 3 3
        add 3 3 3
        ldi 4 0x900
        st 4 3
        sti	
        iret

display ldi 1 0xb00
        st 1 2
        jmp main_l

to_dec  ldi 1 0x900
	ld 1 1
        ldi 4 0x0010
        ldi 2 0x0000
alt_loop    ldi 3 0x000f
        and 3 3 2
        ldi 5 0x0004
        sub 3 5 3
        ldi 5 0x8000
        and 3 3 5
        jz check2
        jmp add3_1
check2  ldi 3 0x00f0
        and 3 3 2
        ldi 5 0x0040
        sub 3 5 3
        ldi 5 0x8000
        and 3 3 5
        jz check3
        jmp add3_2
check3  ldi 3 0x0f00
        and 3 3 2
        ldi 5 0x0400
        sub 3 5 3
        ldi 5 0x8000
        and 3 3 5
        jz check4
        jmp add3_3
check4  ldi 3 0xf000
        and 3 3 2
        ldi 5 0x4000
        sub 3 5 3
        ldi 5 0x8000
        and 3 3 5
        jz phase2
        jmp add3_4
phase2  add 2 2 2
        ldi 5 0x8000
        and 3 1 5
        jz msb0
        ldi 5 0x0001
        add 2 2 5
msb0    add 1 1 1
        dec 4
        jz display
        jmp alt_loop
add3_1  ldi 5 0x0003
        add 2 2 5
        jmp check2
add3_2  ldi 5 0x0030
        add 2 2 5
        jmp check3
add3_3  ldi 5 0x0300
        add 2 2 5
        jmp check4
add3_4  ldi 5 0x3000
        add 2 2 5
        jmp phase2
