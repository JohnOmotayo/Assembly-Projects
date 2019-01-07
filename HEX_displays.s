.text
		.equ HEX0_BASE, 0xFF200020
		.equ HEX4_BASE, 0xFF200030
		.global HEX_clear_ASM
		.global HEX_flood_ASM
		.global HEX_write_ASM
		.global _start

HEX_clear_ASM:	PUSH {R3-R9, LR}
				LDR R2, =HEX0_BASE
				MOV R3, #0xFFFFFF00 //ROR instruction
				MOV R4, R3
				MOV R5, #0
CHECKC:			CMP R5, #6 //should be 5 or 6??
				BEQ DONE
				CMP R5, #4
				LDREQ R2, =HEX4_BASE
				MOVEQ R3, R4 //resets R3
				AND R6, R0, #1 //could use TST
				CMP R6, #1
				BEQ CLEAR
NEXTC:			ASR R0, R0, #1 //why should i shift right AND should it be ASL??
				ADD R5, R5, #1
				LSL R3, R3, #8
				ADD R3, #0xFF //ask the TA if this will work
				B CHECKC
CLEAR:			LDR R7, [R2]
				AND R7, R7, R3 //should preserve the rest, only changing bits of curr. hex
				STR R7, [R2]
				B NEXTC
DONE:			POP {R3-R9, LR}
				BX LR

HEX_flood_ASM:	PUSH {R3-R9, LR}
				LDR R2, = HEX0_BASE
				MOV R3, #0x000000FF
				MOV R4, R3
				MOV R5, #0
CHECKF:			CMP R5, #6
				BEQ DONE
				CMP R5, #4
				LDREQ R2, =HEX4_BASE
				MOVEQ R3, R4
				AND R6, R0, #1
				CMP R6, #1 //If 1, this is the hex display we want to operate on
				BEQ FLOOD
NEXTF:			ASR R0, R0, #1
				ADD R5, R5, #1
				LSL R3, R3, #8
				B CHECKF
FLOOD:			LDR R7, [R2]
				ORR R7, R7, R3
				STR R7, [R2]
				B NEXTF

HEX_write_ASM:	//MOV R10, R0 //- if we need to clear
				
				//MOV R0, R10
				LDR R2, =HEX0_BASE
				PUSH {R3-R10, LR}
				MOV R9, #0xFFFFFF00 //used to clear the numbers when a new number is asserted
				MOV R8, R9
				MOV R3, #0 //this is our flag
				MOV R4, #0 //this is our operating byte
				

CHECKW:			CMP R1, #0 //draw 0 on the display
				MOVEQ R4, #0x3F
				BEQ WRITE

				CMP R1, #1
				MOVEQ R4, #0x06
				BEQ WRITE
	
				CMP R1, #2
				MOVEQ R4, #0x5B
				BEQ WRITE

				CMP R1, #3
				MOVEQ R4, #0x4F
				BEQ WRITE

				CMP R1, #4
				MOVEQ R4, #0x66
				BEQ WRITE

				CMP R1, #5
				MOVEQ R4, #0x6D
				BEQ WRITE

				CMP R1, #6
				MOVEQ R4, #0x7D
				BEQ WRITE

				CMP R1, #7
				MOVEQ R4, #0x07
				BEQ WRITE

				CMP R1, #8
				MOVEQ R4, #0x7F
				BEQ WRITE

				CMP R1, #9
				MOVEQ R4, #0x67
				BEQ WRITE

				CMP R1, #0xA
				MOVEQ R4, #0x77
				BEQ WRITE

				CMP R1, #0xB
				MOVEQ R4, #0x7C
				BEQ WRITE

				CMP R1, #0xC
				MOVEQ R4, #0x39
				BEQ WRITE

				CMP R1, #0xD
				MOVEQ R4, #0x5E
				BEQ WRITE

				CMP R1, #0xE
				MOVEQ R4, #0x79
				BEQ WRITE

				CMP R1, #0xF
				MOVEQ R4, #0x71
				BEQ WRITE

WRITE:			MOV R5, R4 //stores the value in R4, into R5, for later use

WRITEL:
				CMP R3, #6
				BEQ DONEW
				CMP R3, #4
				LDREQ R2, =HEX4_BASE
				MOVEQ R4, R5
				MOVEQ R9, R8
				AND R6, R0, #1
				CMP R6, #0 //if its 0, just go next 
				BEQ NEXTW

				//PUSH {R1-R9, LR}
				//BL HEX_clear_ASM //- do we need to clear it first?
				//POP {R1-R9, LR}

				LDR R7, [R2] //if not 0, operate on this display
				AND R7, R7, R9 //for the first case - NAND R7 with 0x000000FF
				ORR R7, R7, R4 //assuming R7 was previously cleared, ADD should work?
				STR R7, [R2]

NEXTW:			ASR R0, R0, #1
				ADD R3, R3, #1
				LSL R4, R4, #8
				LSL R9, R9, #8
				ADD R9, #0xFF
				B WRITEL

DONEW:			POP {R3-R10, LR}
				BX LR
