		AREA question1, CODE, READONLY
		ENTRY
		ADR r1, UPC				;store the address of UPC in r1 for later use
		
sum1	     LDRB r3, [r1,r2]			;load the value of UPC at position r2 into r3
		ADD r4, r3 				;add r3 to r4, r4 holds the value of the first sum 
		ADD r2, 2					;r2 is the iterator used to find the first, third, seventh, ninth, and eleventh digits
		CMP r2, 12				;check if the r2 iterator has reached the eleventh digit
		BNE sum1					;loop exits after the eleventh digit has been added to the first sum
		SUB r4, 0x120				;subtract 288 (6x48) from the first sum to produce the actual value 
		
		MOV r5, 1					;store the value of 1 in r5 (iterator) so we can target the second, fourth, sixth, eighth, and tenth digits
sum2	     LDRB r7, [r1,r5]			;load the value of UPC at position r5 into r7
		ADD r6, r7 				;add r7 to r6, r6 holds the value of the second sum
		ADD r5, 2					;r5 is the iterator used to find the second, fourth, sixth, eighth, and tenth digits
		CMP r5, 11				;check if the r5 iterator has reached the tenth digit
		BNE sum2					;loop exits after the tenth digit has been added to the first sum
		SUB r6, 0xF0				;subtract 240 (5x48) from the second sum to produce the actual value

		MOV r9, 3 				;move the value of 3 into r9 to later be multiplied by the first sum
		MLA r8, r4, r9, r6			;multiply the first sum by r9 (3) and add the product to the second sum, store the result in r8
		
		LDRB r10, [r1,11] 			;load the check digit of UPC into r10
		SUB r10, 0x30				;subtract 48 from r10 (check digit) to produce the actual value
		ADD r8, r10				;add the sum from the first and second sum to the check digit, we need to find out if it is a multiple of 10

multiple	ADD r11, 0xA				;add 10 to r11 until r11 is greater than r8
		CMP r8,r11				;check if r11 is greater than r8
		BGT multiple 				;loop exits when r11 is greater than r8

		CMP r11, r8				;checks the difference between r8 and r11
		BEQ then					;if the value from above is 0 then branch to 'then' label
		MOV r0, 2				     ;else, the value is not equal then store 2 in r0
		b leave					;branch to 'leave' label to skip over 'then' branch
then	     MOV r0, 1					;if the value is equal then store 1 in r0
leave							;else branch exits here
									
loop	B loop

UPC		DCB	"065633454712"  		;correct UPC string
		END
