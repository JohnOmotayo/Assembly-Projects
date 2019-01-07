			.text
			.global _start
_start:
			LDR R4, =RESULT //R4 points to the result location
			LDR R2, [R4, #4] //R2 holds the number of elements in the list
			ADD R3, R4, #8 //R3 points to the first number
			LDR R0, [R3] //R0 holds the first number in the list
			//LDR R8, R1 //Another pointer to the first number in the dumbers location
			MOV R5, R2 //R5 is a second counter equivalent to R2...
			MOV R9, #1 //set R9 to 1
			MOV R11, R2 //R11 is a third counter equivalent to R2
			ADD R1, R4, #8

LOOP:		SUBS R2, R2, #1 //decrement the loop counter
			BEQ LOOP1 //end loop if counter has reached 0
			ADD R3, R3, #4 //R3 points to the next number in the list
			LDR R7, [R3]
			ADD R0, R0, R7 //Should add the value of R3 to whatever is in R0
			B LOOP

LOOP1:		ADDS R9, R9, #1 //increment loop counter		
			LSR R11, R11, #1 //divide by 2 each time
			CMP R11, #2 //compare R11 and 2
			BEQ NEXT 
			B LOOP1 

NEXT:		LSR R0, R0, R9 //Divide the total sum by the number of elements in the list..

LOOP2:		SUBS R5, R5, #1 //decrement the loop counter
			BEQ DONE //end loop if counter has reached 0
			LDR R8, [R1]
			SUBS R8, R8, R0
			STR R8, [R1]
			ADD R1, R1, #4 //to run through the list...
			B LOOP2

DONE:		

END:		B END 



RESULT: 	.word 0 //memory assigned for result location
N: 			.word 8 //number of entries in the list
NUMBERS: 	.word 4, 5, 3, 6 //the list data
			.word 1, 8, 2, 4
