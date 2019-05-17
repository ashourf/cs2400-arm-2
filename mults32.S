		;		ARM Programming Assignment #2: 32 bit signed integer multiplier
		;
		;		Write a 32-bit SIGNED multiplier. It should take only a small modification to your
		;		unsigned version. Remember (-6)*(-6) = 36, (-6)*6 = -36.
		;		Use the standard shift-and-add operation.
		;		Use the two numbers as an example but write it so it works for any two 16-bit numbers.
		;		Write the result in the provided "fill" word.
		;		Indicate if there was a high-bit carry using the provided "fill" word.
		
		;		Your code here
		
		;numbers	DCD		0xA0BCFF0D, 0xFFF0ADEA
		;result	FILL		8
		;carry	FILL		4
		;		todo implement booths multipication algorithm for signed numbers
		
numbers	DCD		-12 , -20
result	FILL		4
carry	FILL		8
		
		
		ADR		r0, numbers ;load numbers into memory
		LDR		r1, [r0], #4
		LDR		r2, [r0]
		ADR		r3, result ;load result block into memory
		MOV		r4, #16 ; create counter
		MOV		r5 , #0
		ADR		r6, carry ; load carry memory block
		MOV		r7, #0 ; temp locations for result
		MOV		r8, #0 ; temp location for carry.
		ADR		r0, carry
main
		
		AND		r11, r2, #0b00
		AND		r12, r2, #0b11
		CMP		r11, r9
		CMP		r12, r9
		BEQ		shifter
after
		ADDNE	r7, r7,r1 ; if 1 add multpicand to result
		
		END
shifter
		MOV		r7, r7, lsr #1 ; shift product
		MOV		r2, r2, lsr #1 ; shift multiplier right
