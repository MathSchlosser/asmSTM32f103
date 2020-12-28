;-------------------------------------------------------------------------
;	Project: 	Simple baremetal software in ASM for ARM architecture
;	Author: 	Matheus Schlosser Basso
;	Version:	1.1.0
;	Date:		12/2020
;	Board:		Bluepill -> STM32f103c8 
;	Software:	Keil uVison 5
;-------------------------------------------------------------------------
			AREA mySection4, DATA
			ALIGN
				
;------------- Periferics ------------------------------------------------
RCC			EQU		0x40021000			
Port_C		EQU		0x40011000
Port_B		EQU		0x40010C00
Port_A		EQU		0x40010800

;------------- OffSets ----------------------------------------------------
rdOs		EQU		0x08		;GPIO reading Offset

;------------- SRAM -------------------------------------------------------
sramBase	EQU		0x20000000
			
;------------- Data -------------------------------------------------------
;CR			EQU		0x0D ;Finish string char
str1		DCB		"Hello ",0
str2		DCB		"ASM Rules",0
str3		DCB		"GPIO Read Test",0
str4		DCB		"Pressed: ",0
;--------------------------------------------------------------------------
			
			AREA mySection3, CODE, READONLY
			EXPORT myApplication
			ALIGN 
			

myApplication
			
;----------- Config runtimes ----------------------------------------------
			BL			gpioInit
			BL			lcdConfig

;---------- Print initial msg
			LDR			R5, =str1
			BL			printStr

;---------- Print an int value converted to ascii
			LDR 		R2, =1
			BL			printInt

;---------- Print scnd line
			BL			newLine
			
			LDR			R5, =str2
			BL			printStr
			
			LDR			r4, =10000000
			BL			timer
			BL			clearScr
			LDR			r4, =1000
			BL			timer
			
;----------- Inital SRAM runtimes --------------------
			
			BL			sramInit

;----------- While(true) -----------------------------
loop		
			LDR			R5, =str3
			BL			printStr
			BL			newLine
			LDR			R5, =str4
			BL			printStr
			
			BL			gpioRead
			BL			toggleOnOff		

;---------- Call timer with R4 as parameter
			;LDR	 		r4, =100000
			;LDR	 	r4, =1	
			;BL			timer
;---------------------------------------------
			BL			clearScr

			
			B			loop							

;-------------------------------------------------------------------------------------------------------------
lcdConfig	proc
;---------- 16x2 8bit LDC Mode
			push 		{lr}
			
			LDR 		r1, =Port_B
			
			LDR 		r0, =2_0000000000000010
			
			STR 		r0, [r1, #0x0c]
			
			LDR 		r1, =Port_A
			LDR 		r0, =2_0000000000111000
			
			STR 		r0, [r1, #0x0c]

;---------- Call timer with R4 as parameter
			;LDR	 		r4, =10000
			LDR	 	r4, =1
			
			BL 			timer
			
;------------------------------------------		
			LDR 		r1, =Port_B
			
			LDR 		r0, =2_0000000000000000
			
			STR 		r0, [r1, #0x0c]
			
;---------- Display Init
			LDR 		r1, =Port_B
			
			LDR 		r0, =2_0000000000000010
			
			STR 		r0, [r1, #0x0c]
			
			LDR 		r1, =Port_A
			LDR 		r0, =2_0000000000001110
			
			STR 		r0, [r1, #0x0c]

;---------- Call timer with R4 as parameter
			;LDR	 		r4, =10000
			LDR	 	r4, =1
				
			BL			timer

;--------------------------------------------
			
			LDR 		r1, =Port_B
			
			LDR 		r0, =2_0000000000000000
			
			STR 		r0, [r1, #0x0c]

;---------- First clear screen (only for init)
			LDR 		r1, =Port_B
			
			LDR 		r0, =2_0000000000000010
			
			STR 		r0, [r1, #0x0c]
			
			LDR 		r1, =Port_A
			LDR 		r0, =2_0000000000000001
			
			STR 		r0, [r1, #0x0c]
			
;---------- Call timer with R4 as parameter
			LDR	 		r4, =10000
			;LDR	 	r4, =1	
			
			BL 			timer
			
			LDR 		r1, =Port_B
			
			LDR 		r0, =2_0000000000000000
			
			STR 		r0, [r1, #0x0c]

;---------- LCD Input mode -> Inc a char to right
			LDR 		r1, =Port_B
			
			LDR 		r0, =2_0000000000000010
			
			STR 		r0, [r1, #0x0c]
			
			LDR 		r1, =Port_A
			LDR 		r0, =2_0000000000000110
			
			STR 		r0, [r1, #0x0c]

;---------- Call timer with R4 as parameter
			;LDR	 		r4, =10000
			LDR	 	r4, =1	
			
			BL 			timer

;---------------------------------------------
						
			LDR 		r1, =Port_B
			
			LDR 		r0, =2_0000000000000000
			
			STR 		r0, [r1, #0x0c]

			pop 		{pc}
			BX 			LR
			endp
				
;-------------------------------------------------------------------------------------------------------------
newLine		PROC
			PUSH 		{LR}
			LDR 		r1, =Port_B
			
			LDR 		r0, =2_0000000000000010
			
			STR 		r0, [r1, #0x0c]
			
			LDR 		r1, =Port_A
			LDR 		r2, =2_11000000	
			
			STR 		r2, [r1, #0x0c]

;---------- Call timer with R4 as parameter
			LDR	 		r4, =10000
			;LDR	 	r4, =1	
			
			BL 			timer
			
;---------------------------------------------
			
			LDR 		r1, =Port_B
			
			LDR 		r0, =2_0000000000000000
			
			STR 		r0, [r1, #0x0c]
			
			POP			{PC}
			BX			LR
			ENDP
				
;-------------------------------------------------------------------------------------------------------------
clearScr	PROC
			PUSH		{LR}
			LDR 		r1, =Port_B
			
			LDR 		r0, =2_0000000000000010
			
			STR 		r0, [r1, #0x0c]
			
			LDR 		r1, =Port_A
			LDR 		r0, =2_0000000000000001
			
			STR 		r0, [r1, #0x0c]

;---------- Call timer with R4 as parameter
			LDR	 		r4, =10000
			;LDR	 	r4, =1	
			
			BL 			timer
			
;-----------------------------------------------
			LDR 		r1, =Port_B
			
			LDR 		r0, =2_0000000000000000
			
			STR 		r0, [r1, #0x0c]
			POP			{PC}
			BX			LR
			ENDP
				
;-------------------------------------------------------------------------------------------------------------
printStr	PROC
			PUSH 		{LR}
			
nextChar	LDRB 		r2, [r5], #1 ; Load the first byte into R2
			CMP 		r2, #0
			BEQ			outRt
			
			LDR 		r1, =Port_B
			
			LDR 		r0, =2_0000000000000011
			
			STR 		r0, [r1, #0x0c]
			
			LDR 		r1, =Port_A
									
			STR 		r2, [r1, #0x0c]
			
;---------- Call timer with R4 as parameter
			LDR	 		r4, =10000
			;LDR	 	r4, =1	
			
			BL 			timer

;--------------------------------------------
			
			LDR 		r1, =Port_B
			
			LDR 		r0, =2_0000000000000001
			
			STR 		r0, [r1, #0x0c]
			
			BAL			nextChar
outRt
			POP			{PC}
			BX			LR
			ENDP

;-------------------------------------------------------------------------------------------------------------
printInt	PROC
			PUSH 		{LR}
			
			ADD 		R2, #0x30 ;Int -> ASCII = num + 0x30
			
			LDR 		r1, =Port_B
			
			LDR 		r0, =2_0000000000000011
			
			STR 		r0, [r1, #0x0c]
			
			LDR 		r1, =Port_A
									
			STR 		r2, [r1, #0x0c]
			
;---------- Call timer with R4 as parameter
			LDR	 		r4, =10000
			;LDR	 	r4, =1	
			
			BL 			timer

;--------------------------------------------
			
			LDR 		r1, =Port_B
			
			LDR 		r0, =2_0000000000000001
			
			STR 		r0, [r1, #0x0c]
			
			POP			{PC}
			BX			LR
			ENDP

;-------------------------------------------------------------------------------------------------------------
timer		PROC
			push 		{lr}
			
tm			SUBS 		R4, R4, #1
			NOP
			BNE  		tm
			
			
			pop 		{pc}
			BX			LR
			ENDP

;-------------------------------------------------------------------------------------------------------------			
toggleOnOff	PROC
;---------- Turn on PC13 and PB11
			
			PUSH 		{LR}
			
			; GPIO PC13 -> ON		|	offset 0x0c
			LDR 		r1, =Port_C
			MOV			r0, #0x2000
			STR			r0, [r1, #0x0C]

			; GPIO PB11 -> ON		|	offset 0x0c
			LDR 		r1, =Port_B
			MOV			r0, #0x800 ;0000 1000 0000 0000
			STR			r0, [r1, #0x0C]
			
			;LDR			r4, =1
			LDR 		R4, =100000
			BL 			timer

;---------- Turn off PC13 and PB11			
			
			; GPIO PC13 -> Off		|	offset 0x0c
			LDR 		r1, =Port_C
			ldr			r0, =0x0000
			str 		r0, [r1, #0x0C]
			
			; GPIO PB11 -> Off		|	offset 0x0c
			LDR 		r1, =Port_B
			MOV			r0, #0x000 ;0000 1000 0000 0000
			STR			r0, [r1, #0x0C]
			
			;LDR			r4, =1
			LDR 		R4, =100000
			BL 			timer

			POP 		{PC}						
			BX			LR
			ENDP
				
;-------------------------------------------------------------------------------------------------------------
gpioRead	proc
			PUSH		{LR}
			LDR			r0, =Port_C
			MOV			r1, #rdOs
			ORR 		r0, r0, r1
			LDR 		r1, [r0, #0x01] ;OffSet 0x08 + 0x01
			LSR			r1, #6 ; R1 >> 6 -> 0100 0000 >> 0000 0001 

;---------	If r1 = 1 then call sum
			CMP 		r1, #1
			BEQ			sum

;---------	Else, exits the runtime
			B			endRd	

;---------	read from sram 0x300 offset and R5 += 1
			
sum			LDR			r0, =sramBase
			LDR			r2, [r0, #0x3e6]
			ADD			r2, r2, #1
			
;---------	Move to SRAM the new value to R5
			STR 		r2, [r0, #0x3e6]

;---------	Print the Sram value to LCD
			BL			printInt


;---------	Delay debounce
			LDR	 	R0, =1000
			;LDR	 		R0, =1	
			
dc			SUBS 		R0, R0, #1
			NOP
			BNE  		dc

;---------	Runtime ending
endRd		POP			{PC}
			BX 			LR
			ENDP
				
;-------------------------------------------------------------------------------------------------------------
gpioInit	PROC
			
;---------- RCC APB1-> Enable 	| 	offset 0x18
;----------	Every port used in the program must be enabled otherwise it wont work -> See STM user ref RM008		
			MOV			r0,	#0x1C ;0000 0000 0000 0000 0000 0000 0001 1100 -> Bits = 1 enable GPIO A, B and C 
			LDR 		r1, =RCC
			STR 		r0, [r1, #0x18]
			
			
;---------- GPIO PC13 -> OUTPUT 	|	offset 0x04
;---------- GPIO PC14	-> INPUT	|	offset 0x04 
			LDR			r0, =0x28222222 ; 0010 1000 0010 0010 0010 0010 0010 0010
			LDR 		r1, =Port_C
			STR			r0, [r1, #0x04]
			
;---------- GPIO PB0, PB1 and PB11 -> OUTPUT 	|	offset 0x04
;---------- PB0 e PB1 -> D6 and D7 LCD
			LDR			r0, =0x44442444 ;0100 0100 0100 0100 0010 0100 0100 0100
			LDR 		r1, =Port_B
			STR			r0, [r1, #0x04]
			
			LDR 		r0, =0x44444422 ;0100 0100 0100 0100 0100 0100 0010 0010
			STR			r0, [r1] ;CRL
			
;---------- GPIO PA0~PA7 	-> OUTPUT - LCD
			LDR			r0, =0x22222222 ;0010 0010 0010 0010 0010 0010 0010 0010
			LDR 		r1, =Port_A
			STR			r0, [r1, #0x00]
			
			
			BX			LR
			ENDP
				
;----------------------------------------------------------------------------------------------------------
sramInit	PROC
			
			MOV 		r0, #0
			LDR			r1, =sramBase
			STR			r0, [r1, #0x3e6]
													
			BX			LR
			ENDP
				
;----------------------------------------------------------------------------------------------------------
			ALIGN
			END