.data 
.code
loop    ldi 6 0x0001
	ldi 0 0x0901
	ld 0 0
	and 0 0 6
	jz loop
        ldi 1 0x0900
	ld 1 1
	ldi 2 0x001d
	xor 3 1 2
	jz upy
	ldi 1 0x0900
	ld 1 1
	ldi 2 0x001b
	xor 3 1 2
	jz dowy
	ldi 1 0x0900
	ld 1 1
	ldi 2 0x001c
	xor 3 1 2
	jz leftx
	ldi 1 0x0900
	ld 1 1
	ldi 2 0x0023
	xor 3 1 2
	jz rightx
	jmp loop

upy     ldi 0 0x0d01
        ld 0 0
        ldi 1 0x0004
        sub 0 0 1
        ldi 1 0x0d01
        st 1 0
        jmp loop

dowy    ldi 0 0x0d01
        ld 0 0
        ldi 1 0x0004
        add 0 0 1
        ldi 1 0x0d01
        st 1 0
        jmp loop

leftx   ldi 0 0x0d00
        ld 0 0
        ldi 1 0x0004
        sub 0 0 1
        ldi 1 0x0d00
        st 1 0
	jmp loop

rightx  ldi 0 0x0d00
        ld 0 0
        ldi 1 0x0004
        add 0 0 1
        ldi 1 0x0d00
        st 1 0
	jmp loop
