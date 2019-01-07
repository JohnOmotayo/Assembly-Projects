.text
			.equ PUSH0_BASE, 0xFF200050
			.equ EDGE0_BASE, 0xFF20005C
			.equ PBINT, 0xFF200058
			.global read_PB_data_ASM
			.global enable_PB_INT_ASM
			.global PB_clear_edgecp_ASM
			.global read_PB_edgecap_ASM
			.global _start

read_PB_data_ASM:	LDR R1, =PUSH0_BASE
					LDR R0, [R1]
					BX LR

PB_data_is_pressed_ASM:	
			MOV R3, R0 //assume you return 1 if true, 0 if false - R0 is return register
						MOV R0, #0 //start as false
						LDR R1, =PUSH0_BASE //address of the ‘data’ push button
						LDR R2, [R1]
						AND R4, R3, R2
						CMP R4, R3
						MOVEQ R0, #1
						BX LR

read_PB_edgecap_ASM:	LDR R0, =EDGE0_BASE
						LDR R0, [R0]
						AND R0, R0, #0xF //just to get the last 4 bits of the 32-bit value
						BX LR
PB_edgecap_is_pressed_ASM:	MOV R3, R0
							MOV R0, #0 //the false condition
							LDR R1, =EDGE0_BASE
							LDR R2, [R2]
							AND R4, R3, R2
							CMP R4, R3
							MOVEQ R0, #1
							BX LR
PB_clear_edgecp_ASM:	LDR R1, =EDGE0_BASE //should write to the register in order to clear it
						MOV R3, #0xF //clear the edge cap register…could use less bits
						STR R3, [R1]
						BX LR
enable_PB_INT_ASM:		LDR R1, =PBINT
						MOV R2, #0xE //move 0111 into the register
						ORR R3, R2, R0
						STR R3, [R1]
						BX LR
						
						
disable_PB_INT_ASM:		LDR R1, =PBINT
						MOV R2, #0x0 //move 0000 into the register
						AND R3, R2, R0
						STR R3, [R1]
						BX LR

