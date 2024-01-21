.data	
		x_max: 628
		y_max: 468
		x_min: 0
		y_min: 0
		s_x: 320
		s_y: 240
		p_x: 96
		p_y: 42
		is_p_up: 1
		is_p_right: 1
		ssbm0: 0x0080
        ssbm1: 0x01C0
        ssbm2: 0x01C0
        ssbm3: 0x01C0
        ssbm4: 0x01C0
        ssbm5: 0x03E0
        ssbm6: 0x07F0
        ssbm7: 0x0FF8
        ssbm8: 0x1FFC
        ssbm9: 0x01C0
        ssbm10: 0x01C0
        ssbm11: 0x01C0
        ssbm12: 0x01C0
        ssbm13: 0x03E0
        ssbm14: 0x07F0
        ssbm15: 0x01C0
	pbm0: 0x07E0
        pbm1: 0x1FF8
        pbm2: 0x3FFC
        pbm3: 0x7FFE
        pbm4: 0x7FFE
        pbm5: 0xFFFF
        pbm6: 0xFFFF
        pbm7: 0xFFFF
        pbm8: 0xFFFF
        pbm9: 0xFFFF
        pbm10: 0x7FFE
        pbm11: 0x7FFE
        pbm12: 0x3FFC
        pbm13: 0x1FF8
        pbm14: 0x07E0
        pbm15: 0x0000
.code	
		ldi 0 0x710
		ldi 1 pbm0
		ld 1 1
		st 0 1
		inc 0
		ldi 1 pbm1
		ld 1 1
		st 0 1
		inc 0
		ldi 1 pbm2
		ld 1 1
		st 0 1
		inc 0
		ldi 1 pbm3
		ld 1 1
		st 0 1
		inc 0
		ldi 1 pbm4
		ld 1 1
		st 0 1
		inc 0
		ldi 1 pbm5
		ld 1 1
		st 0 1
		inc 0
		ldi 1 pbm6
		ld 1 1
		st 0 1
		inc 0
		ldi 1 pbm7
		ld 1 1
		st 0 1
		inc 0
		ldi 1 pbm8
		ld 1 1
		st 0 1
		inc 0
		ldi 1 pbm9
		ld 1 1
		st 0 1
		inc 0
		ldi 1 pbm10
		ld 1 1
		st 0 1
		inc 0
		ldi 1 pbm11
		ld 1 1
		st 0 1
		inc 0
		ldi 1 pbm12
		ld 1 1
		st 0 1
		inc 0
		ldi 1 pbm13
		ld 1 1
		st 0 1
		inc 0
		ldi 1 pbm14
		ld 1 1
		st 0 1
		inc 0
		ldi 1 pbm15
		ld 1 1
		st 0 1
		ldi 0 0x700
		ldi 1 ssbm0
		ld 1 1
		st 0 1
		inc 0
		ldi 1 ssbm1
		ld 1 1
		st 0 1
		inc 0
		ldi 1 ssbm2
		ld 1 1
		st 0 1
		inc 0
		ldi 1 ssbm3
		ld 1 1
		st 0 1
		inc 0
		ldi 1 ssbm4
		ld 1 1
		st 0 1
		inc 0
		ldi 1 ssbm5
		ld 1 1
		st 0 1
		inc 0
		ldi 1 ssbm6
		ld 1 1
		st 0 1
		inc 0
		ldi 1 ssbm7
		ld 1 1
		st 0 1
		inc 0
		ldi 1 ssbm8
		ld 1 1
		st 0 1
		inc 0
		ldi 1 ssbm9
		ld 1 1
		st 0 1
		inc 0
		ldi 1 ssbm10
		ld 1 1
		st 0 1
		inc 0
		ldi 1 ssbm11
		ld 1 1
		st 0 1
		inc 0
		ldi 1 ssbm12
		ld 1 1
		st 0 1
		inc 0
		ldi 1 ssbm13
		ld 1 1
		st 0 1
		inc 0
		ldi 1 ssbm14
		ld 1 1
		st 0 1
		inc 0
		ldi 1 ssbm15
		ld 1 1
		st 0 1
		ldi 7 0x7ff
		ldi 0 s_x
		ld 0 0
		ldi 1 0xd00
		st 1 0
		ldi 0 s_y
		ld 0 0
		ldi 1 0xd01
		st 1 0
		ldi 0 p_x
		ld 0 0
		ldi 1 0xd02
		st 1 0
		ldi 0 p_y
		ld 0 0
		ldi 1 0xd03
		st 1 0
		ldi 0 0x7f2
        ldi 1 try
        st  0 1
		
loop		ldi 1 0x0501
		ld 1 1
		ldi 2 0x0001
		sub 1 1 2
		jz clk
		ldi 4 0x0001
		ldi 3 0x0901
		ld 3 3
		and 3 3 4
		jz loop
		ldi 1 0x0900
		ld 1 1
		ldi 2 0x001d
		xor 3 1 2
		jz sps_uy
		ldi 1 0x0900
		ld 1 1
		ldi 2 0x001b
		xor 3 1 2
		jz sps_dy
		ldi 1 0x0900
		ld 1 1
		ldi 2 0x001c
		xor 3 1 2
		jz sps_lx
		ldi 1 0x0900
		ld 1 1
		ldi 2 0x0023
		xor 3 1 2
		jz sps_rx
		jmp loop

try		ldi 5 0x5050
		ldi 6 0xb00
		st 6 5
		jmp loop		

clk	ldi 1 0x0501
		ldi 2 0x0000
		st 1 2
		jmp p_upy
		jmp loop

p_up_r	ldi 4 is_p_up
		ldi 1 0x0000
		st 4 1
		jmp clk

p_dow_r	ldi 4 is_p_up
		ldi 1 0x0001
		st 4 1
		jmp clk

p_rig_r	ldi 4 is_p_right
		ldi 1 0x0000
		st 4 1
		jmp clk

p_lef_r	ldi 4 is_p_right
		ldi 1 0x0001
		st 4 1
		jmp clk

p_upy	ldi 1 is_p_up
		ld 1 1
		ldi 2 0x0001
		and 1 1 2
		jz p_dy
		ldi 4 0x0d03
        ld 4 4
        ldi 1 0x0006
        sub 4 4 1
		ldi 2 y_min
		ld 2 2
		mov 3 4
		sub 3 3 2
		jz p_up_r
        ldi 1 0x0d03
        st 1 4
        jmp p_rx

p_dy	ldi 4 0x0d03
        ld 4 4
        ldi 1 0x0006
        add 4 4 1
		ldi 2 y_max
		ld 2 2
		mov 3 4
		sub 3 3 2
		jz p_dow_r
        ldi 1 0x0d03
        st 1 4
        jmp p_rx

p_rx	ldi 1 is_p_right
		ld 1 1
		ldi 2 0x0001
		and 1 1 2
		jz p_lx
		ldi 4 0x0d02
        ld 4 4
        ldi 1 0x0004
        add 4 4 1
		ldi 2 x_max
		ld 2 2
		mov 3 4
		sub 3 3 2
		jz p_rig_r
        ldi 1 0x0d02
        st 1 4
		jmp loop

p_lx	ldi 4 0x0d02
        ld 4 4
        ldi 1 0x0004
        sub 4 4 1
		ldi 2 x_min
		ld 2 2
		mov 3 4
		sub 3 3 2
		jz p_lef_r
        ldi 1 0x0d02
        st 1 4
		jmp loop

sps_uy	ldi 4 0x0d01
        ld 4 4
        ldi 1 0x0004
        sub 4 4 1
		ldi 2 y_min
		ld 2 2
		mov 3 4
		sub 3 3 2
		jz loop
        ldi 1 0x0d01
        st 1 4
        jmp loop

sps_dy	ldi 4 0x0d01
        ld 4 4
        ldi 1 0x0004
        add 4 4 1
		ldi 2 y_max
		ld 2 2
		mov 3 4
		sub 2 2 3
		jz loop
        ldi 1 0x0d01
        st 1 4
        jmp loop

sps_lx	ldi 4 0x0d00
        ld 4 4
        ldi 1 0x0004
        sub 4 4 1
		ldi 2 x_min
		ld 2 2
		mov 3 4
		sub 3 3 2
		jz loop
        ldi 1 0x0d00
        st 1 4
		jmp loop

sps_rx	ldi 4 0x0d00
        ld 4 4
        ldi 1 0x0004
        add 4 4 1
		ldi 2 x_max
		ld 2 2
		mov 3 4
		sub 3 3 2
		jz loop
        ldi 1 0x0d00
        st 1 4
		jmp loop
