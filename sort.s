.text
			.global _start
_start: 
			LDR R4, =RESULT
			LDR R2, [R4, #4]
			ADD R3, R4, #8
			ADD R6, R4, #12
			LDR R8, [R6]
			LDR R7, [R3]
			MOV R1, #1
			//MOV R11, #0
			//MOV R12, #0
			//LDR R5, N
			//SUBS R5, R5, #2

LOOP:		CMP R1, #0
			BEQ DONE //should branch if 					   it equals 0, which 					   stands for true
			MOV R1, #0 //0 stand for true
			ADD R3, R4, #8
			ADD R6, R4, #12
			LDR R2, [R4, #4]
			LDR R8, [R6]
			LDR R7, [R3]
			B LOOP2

LOOP2:		SUB R2, R2, #1
			CMP R2, #0
			BEQ LOOP
			/*ADD R12, R12, #1
			//SUBS R2, R2, R11
			CMP R12, R2*/
			CMP R8, R7
			BLT SWAP
			ADD R3, R3, #4
			ADD R6, R6, #4
			LDR R8, [R6]
			LDR R7, [R3]
			B LOOP2
			//B LOOP3
			

/*LOOP3:		ADD R11, R11, #1
			CMP R11, R5
			BEQ LOOP2
			CMP R8, R7
			BLT SWAP
			ADD R3, R3, #4
			ADD R6, R6, #4
			LDR R8, [R6]
			LDR R7, [R3]
			SUBS R5, R5, R12
*/
SWAP: 		LDR R10, [R6]
			LDR R9, [R3]
			STR R9, [R6]
			STR R10, [R3]

			ADD R3, R3, #4
			ADD R6, R6, #4
			LDR R8, [R6] 
			LDR R7, [R3]
			MOV R1, #1
			B LOOP2

DONE:		B DONE//we’re done

RESULT: 	.word 0 //memory assigned for result location
N: 			.word 8 //number of entries in the list
NUMBERS: 	.word 4, 5, 3, 6 //the list data
			.word 1, 8, 2, 4
