.text //8, 9, 1
	//x starts at 0xC8000020
	//y starts at 0xC8000400
		.equ PIXEL_BASE, 0xC8000000
		.equ CHAR_BASE, 0xC9000000 //do we need 0x ?
		.global  VGA_clear_charbuff_ASM
		.global VGA_clear_pixelbuff_ASM
		.global VGA_write_char_ASM
		.global VGA_write_byte_ASM
		.global VGA_write_point_ASM
		.global VGA_draw_point_ASM
		.global _start

VGA_clear_pixelbuff_ASM:	PUSH {R0-R10, LR}
							LDR R1, =PIXEL_BASE
							MOV R2, #0 //x counter
							MOV R3, #0 //y counter
							MOV R8, #0x0000
							MOV R6, #0
							MOV R7, #0


OLOOP:	CMP R2, #320
		BGT DONE
		B ILOOP

ILOOP:	CMP R3, #240
		BGT TLOOP
		LSL R4, R3, #10 //shift R3 by 
		LSL R5, R2, #1
		ADD R6, R4, R5 //new offset
		ADD R7, R1, R6
		STRH R8, [R7]
		ADD R3, R3, #1
		MOV R6, #0
		MOV R7, #0
		B ILOOP

TLOOP:	ADD R2, R2, #1
		MOV R3, #0
		B OLOOP

							

VGA_clear_charbuff_ASM:	PUSH {R0-R10, LR}
						LDR R1, =CHAR_BASE
						MOV R2, #0
						MOV R3, #0
						MOV R8, #0x00
						MOV R6, #0
						MOV R7, #0

OuterLOOP:	CMP R2, #79
			BGT DONE
			B InnerLOOP

InnerLOOP:	CMP R3, #59
			BGT TempLOOP
			LSL R4, R3, #7
			ADD R6, R4, R2 //offset
			ADD R7, R1, R6 //new address
			STRB R8, [R7]
			ADD R3, R3, #1
			MOV R6, #0
			MOV R7, #0
			B InnerLOOP

TempLOOP:	ADD R2, R2, #1
			MOV R3, #0
			B OuterLOOP
			

DONE:	POP {R0-R10, LR}
		BX LR //idk

VGA_write_char_ASM:	PUSH {R0-R10, LR}
					LDR R3, =CHAR_BASE
					CMP R0, #79 //compare x to the maximum value it can have...?
					BGT DONE
					CMP R0, #0
					BLT DONE
					CMP R1, #59 //compare y to max value (59)
					BGT DONE
					CMP R1, #0
					BLT DONE
					MOV R4, #0
					
					MOV R4, R1
					LSL R4, R4, #7
					//ORR R4, R1
					ORR R4, R0 //changed from ORR R4, R0
					//ADD R4, R1, R0
					ORR R4, R3 //new address of character : base + offset
					STRB R2, [R4]

					B DONE

VGA_write_byte_ASM:	PUSH {R0-R10, LR}
					LDR R3, =CHAR_BASE
					CMP R0, #79 //compare x to the maximum value it can have...?
					BGT DONE
					CMP R0, #0
					BLT DONE
					CMP R1, #59 //compare y to max value (59)
					BGT DONE
					CMP R1, #0
					BLT DONE

					LSL R8, R1, #7
					ORR R4, R8, R0 //offset
					ORR R5, R3, R4 //new base
					AND R6, R2, #0xF //should keep the last 4 digits...
					CMP R6, #10
					ADDGE R6, R6, #55
					ADDLT R6, R6, #48
					STRB R6, [R5]

					ADD R0, #1
					CMP R0, #79
					MOVGT R0, #0
					ADDGT R1, #1 //go to a new row
					CMP R1, #59
					MOVGT R1, #0
					MOV R4, #0
					MOV R5, #0

					AND R7, R2, #0xF0 //should keep the first 4 digits
					LSR R7, #4
					CMP R7, #10
					ADDGE R7, R7, #55
					ADDLT R7, R7, #48
					
					LSL R9, R1, #7
					ORR R4, R9, R0 //offset
					ORR R5, R3, R4
					STRB R7, [R5] //should be one less? Or greater...
					B DONE

VGA_draw_point_ASM:	PUSH {R0-R10, LR}
					LDR R3, =PIXEL_BASE
					/*CMP R0, #320 //compare x to the maximum value it can have...?
					BGT DONE
					CMP R0, #0
					BLT DONE
					CMP R1, #240 //compare y to max value (59)
					BGT DONE
					CMP R1, #0
					BLT DONE*/
					MOV R6, #0
					MOV R5, #0
					MOV R6, #0
					
					MOV R6, R1 //R6 = R1
					//LSL R6, R6, #10
					//LSL R0, R0, #1
					//ADD R6, R6, R0 //offset
					ORR R3, R3, R0, LSL #1
					//ORR R4, R6, R0 //offset
					//ORR R5, R4, R3 //new address : base + offset
					//ADD R5, R3, R6 //new address of character : base + offset
					ORR R3, R3, R1, LSL #10
					STRH R2, [R3]

					B DONE

