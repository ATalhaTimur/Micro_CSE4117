.data 	
.code
	ldi 0 0x0140
	ldi 1 x
	st 1 0
	ldi 4 0x0c00
	st 4 0
	ldi 0 0x00f0
	ldi 1 y
	st 1 0
	ldi 4 0x0c01
	st 4 0
check	ldi 6 0x0001
	ldi 0 0x0901
	ld 0 0
	and 0 0 6
	jz check
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
	jmp check

upy	ldi 5 0x0001
	ldi 4 0xb00	
	add 5 5 5
	st 4 5
	jmp check

		


	