.text 
		.equ PS2_Data, 0xFF200100
		.global  read_PS2_data_ASM

read_PS2_data_ASM:	PUSH {R7-R10, LR}
				LDR R2, =PS2_Data
				MOV R3, #0x8000
				LDR R1, [R2] //R1 holds the contents of the ps2_data register
				AND R5, R1, R3 //check if the 16th bit is on
				CMP R5, #0
				BEQ WRONG //if equal to 0, go to wrong
				MOV R7, #0xFF
				AND R6, R1, R7 //to get the last 8 bits
				STR R6, [R0] //store the last 8 bits to the address of data..
				MOV R0, #1 //return 1
				
				B DONE

WRONG:	MOV R0, #0
		B DONE

READ_DATA:		
				
				

DONE:	POP {R7-R10, LR}		
		BX LR
				
