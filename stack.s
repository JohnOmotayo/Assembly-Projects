.text
			.global _start
_start:		MOV R3, #4 //R3 holds a number
			MOV R2, #0 //R2 should hold 0
			MOV R0, [R0]
PUSH:		SUB SP, SP, #4
			STR R2, [SP]
			  //should be equivalent to STR R2, [R13, #4!], #-4]!
POP:		LDR R2, [SP]
			ADD SP, SP, #4 //should be equivalent to LDR R3, [R13], #4
