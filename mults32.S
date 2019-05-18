		;		ARM Programming Assignment #2: 32 bit signed integer multiplier
		;
		;		Write a 32-bit SIGNED multiplier. It should take only a small modification to your
		;		unsigned version. Remember (-6)*(-6) = 36, (-6)*6 = -36.
		;		Use the standard shift-and-add operation.
		;		Use the two numbers as an example but write it so it works for any two 16-bit numbers.
		;		Write the result in the provided "fill" word.
		;		Indicate if there was a high-bit carry using the provided "fill" word.
		
		;		Your code here
		
numbers	DCD		0xA0BCFF0D, 0xFFF0ADEA
result	FILL		8
carry	FILL		4
masks	DCD		0x0000ffff , 0xffff0000
need		DCD		0x10000
		ADR		r0, masks ;get masks
		LDR		r1, [r0], #4 ; load mask 0x0000ffff
		LDR		r2, [r0] ; load mask 0xffff0000
		ADR		r0, numbers ;load numbers into memory
		LDR		r3, [r0], #4 ; load mulitpicand
		LDR		r4, [r0] ; load multiplier
		
		MOV		r8, r3, lsr #31 ;get most signifcant bit of multipicand
		MOV		r9, r4, lsr #31 ; get most signifcant bit of multiplier
		
		CMP		r8, #1 ;check bit
		MVNEQ	r3, r3 ; switch sign if negative
		ADDEQ	r3,r3, #1
		CMP		r9, #1 ; check msb of multiplier
		MVNEQ	r4, r4 ; switch sign if negative
		ADDEQ	r4,r4,#1
		;place	signs on stack for latter use so R8, and R9 can be clear for use
		STR		r8, [sp, #4]
		STR		r9 , [sp, #8]
		
		MOV		r8, #0  ; clear r8
		MOV		r9, #0  ; clear r9
		
		AND		r5, r3, r1 ; get bottom half of multipicand
		AND		r3, r3, r2 ; get top half of multipicand
		AND		r6, r4, r1 ; get bottom half of multiplier
		AND		r4, r4, r2 ; get top half of multiplier
		MOV		r1, r3, lsr #16  ; put top half of multipcand in the right place
		MOV		r2, r4 , lsr #16   ; put top half of multipiler in right place
		MOV		r3, r5
		MOV		r4, r6
		MOV		r5, #0
		MOV		r6, #0
		
		
		
		
main
		MOV		r7 , r1 ; move top multipler into generic register
		MOV		r8, r2 ; move top multicand into generic register
mul1
		TST		r7, #1 ; check least siginfcant bit of  generic multiplier
		ADDNE	r9, r9,r8 ; if 1 add multpicand to result
		ADDCS	r10,r10, #1 ; add if carry
		MOV		r8, r8 , lsl #1 ;bit shift multpicand left by 1 bit
		MOV		r7, r7, lsr #1 ;bit shift multiper right by 1 bit
		CMP		r7, #0 ; stop at N
		BNE		mul1
		
		MOV		r7 , r4 ;move bottom multiplier into generic register
		MOV		r8, r1 ; move top multicand into generic register
mul2
		TST		r7, #1 ; check least siginfcant bit of  generic multiplier
		ADDNE	r5, r5,r8 ; if 1 add multpicand to result
		ADDCS	r10,r10, #1 ; add if carry
		MOV		r8, r8 , lsl #1 ;bit shift multpicand left by 1 bit
		MOV		r7, r7, lsr #1 ;bit shift multiper right by 1 bit
		CMP		r7, #0 ; stop at N
		BNE		mul2
		
		MOV		r7 , r2 ; move bottom multiplicand into generic register
		MOV		r8, r3 ;top multipler into generic register
mul3
		TST		r7, #1 ; check least siginfcant bit of  generic multiplier
		ADDNE	r6, r6,r8 ; if 1 add multpicand to result
		ADDCS	r10,r10, #1 ; add if carry
		MOV		r8, r8 , lsl #1 ;bit shift multpicand left by 1 bit
		MOV		r7, r7, lsr #1 ;bit shift multiper right by 1 bit
		CMP		r7, #0 ; stop at N
		BNE		mul3
		
		MOV		r7 , r4 ; move bottom multipcand into generic register
		MOV		r8, r3 ; move top multicand into generic register
mul4
		TST		r7, #1 ; check least siginfcant bit of  generic multiplier
		ADDNE	r11, r11,r8 ; if 1 add multpicand to result
		ADDCS	r10,r10, #1 ; add if carry
		MOV		r8, r8 , lsl #1 ;bit shift multpicand left by 1 bit
		MOV		r7, r7, lsr #1 ;bit shift multiper right by 1 bit
		CMP		r7, #0 ; stop at N
		BNE		mul4
product
		ADR		r0, result
		ADR		r1, carry
		ADR		r7, need
		LDR		r7, [r7]
		
		
		ADDS		r5, r5, r6
		MOV		r12, r5, lsl #16
		MOV		r5, r5, lsr #16
		ADDCS	r9,  r9, r7
		ADDS		r11, r11, r12
		ADC		r9, r9 , r5
		
		MOV		r4, r11, lsr #31 ; get msb
		MOV		r5, r9, lsr #31  ; get msb
		
		
		LDR		r6, [sp, #4]    ; retrive multipcand msb from stack
		LDR		r7, [sp , #8]   ; retrive multiplier msb from stack
		
		CMP		r6,r7
		
		CMPNE	r6, r4 ; check bits
		MVNNE	r11,r11 ; flip if it doesn't match the right sign
		ADDNE	r11, r11, #1
		
		CMP		r7, r5 ; check bits
		MVNEQ	r9,r9 ; flip if it doesn't match right sign
		ADDEQ	r9, r9, #1
		
		STR		r11, [r0] ; store part of result
		STR		r9, [r0, #4] ; store part of result
		STR		r10,[r1] ; store collected carries
		
