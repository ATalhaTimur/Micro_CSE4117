.data
.code   
loop	ldi 0 0x903
	ldi 1 0x0001
	ld 0 0
	sub 0 0 1
	jz right
	ldi 0 0x901
	ldi 1 0x0001
	ld 0 0
	sub 0 0 1
	jz left
	jmp loop
right	ldi 0 0x900
	ld 0 0
	inc 0
	ldi 1 0xb00
	st 1 0
	ldi 1 0x900
	st 1 0
	jmp loop
left	ldi 0 0x900
	ld 0 0
	inc 0
	inc 0
	inc 0
	inc 0
	ldi 1 0xb00
	st 1 0
	ldi 1 0x900
	st 1 0
	jmp loop