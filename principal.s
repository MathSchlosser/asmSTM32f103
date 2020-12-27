;----------------------------------------------------------------
;	Project: 	Simple baremetal software in ASM for ARM arch
;	Author: 	Matheus Schlosser Basso
;	Version:	1.0.0
;	Date:		12/2020
;	uC:			STM32f103c8
;	Software:	Keil uVison 5
;----------------------------------------------------------------
			AREA mySection4, DATA
			ALIGN
				
;------------- Periféricos ---------------------------------
RCC			EQU		0x40021000			
Port_C		EQU		0x40011000
Port_B		EQU		0x40010C00
Port_A		EQU		0x40010800

;------------- OffSets -------------------------------------
rdOs		EQU		0x08		;OffSet para leitura de GPIO

;------------- SRAM ----------------------------------------
sramBase	equ		0x20000000

;------------- Dados ---------------------------------------
name		dcb		"Teste",0

;-----------------------------------------------------------
			
			AREA mySection3, CODE, READONLY
			EXPORT myApplication
			ALIGN 
			

myApplication
			
;----------- Rotinas de configuração-------------------------
			BL	gpioInit
			BL	lcdConfig

;---------- Hello
			LDR R2, ='T'
			BL	printMen
			LDR R2, ='E'
			BL	printMen
			LDR R2, ='S'
			BL	printMen
			LDR R2, ='T'
			BL	printMen
			LDR R2, ='E'
			BL	printMen
			LDR R2, =' '
			BL	printMen
			
			LDR R2, =1
			ADD R2, #0x30 ;Int -> ASCII = num + 0x30
			BL	printMen
			
			BL	newLine
			LDR R2, ='A'
			BL	printMen
			LDR R2, ='S'
			BL	printMen
			LDR R2, ='S'
			BL	printMen
			LDR R2, ='E'
			BL	printMen
			LDR R2, ='M'
			BL	printMen
			LDR R2, ='B'
			BL	printMen
			LDR R2, ='L'
			BL	printMen
			LDR R2, ='Y'
			BL	printMen
			LDR R2, =' '
			BL	printMen
			LDR R2, ='Y'
			BL	printMen
			LDR R2, ='E'
			BL	printMen
			LDR R2, ='A'
			BL	printMen
			LDR R2, ='H'
			BL	printMen
			
;----------- Rotinas exec. na inicialização------------------
			;BL	dataMove

;----------- Rotinas do loop infinito------------------------
loop		
			BL	gpioRead
			BL	toggleOnOff		
				
			B	loop							

;------------------------------------------------------------
lcdConfig	proc
;---------- Modo 16x2 8bit - LDC 
			push {lr}
			
			LDR r1, =Port_B
			
			LDR r0, =2_0000000000000010
			
			STR r0, [r1, #0x0c]
			
			LDR r1, =Port_A
			LDR r0, =2_0000000000111000
			
			STR r0, [r1, #0x0c]
			
			LDR	 r4, =10000
			;LDR	 r4, =1
			
			BL timer
		
			LDR r1, =Port_B
			
			LDR r0, =2_0000000000000000
			
			STR r0, [r1, #0x0c]
			
;---------- Inicializa Display
			LDR r1, =Port_B
			
			LDR r0, =2_0000000000000010
			
			STR r0, [r1, #0x0c]
			
			LDR r1, =Port_A
			LDR r0, =2_0000000000001110
			
			STR r0, [r1, #0x0c]
			
			LDR	 r4, =10000
			;LDR	 r4, =1
				
			BL	timer
			
			LDR r1, =Port_B
			
			LDR r0, =2_0000000000000000
			
			STR r0, [r1, #0x0c]

;---------- Limpa a tela
			LDR r1, =Port_B
			
			LDR r0, =2_0000000000000010
			
			STR r0, [r1, #0x0c]
			
			LDR r1, =Port_A
			LDR r0, =2_0000000000000001
			
			STR r0, [r1, #0x0c]
			
			LDR	 r4, =10000
			;LDR	 r4, =1	
			
			BL timer
			
			LDR r1, =Port_B
			
			LDR r0, =2_0000000000000000
			
			STR r0, [r1, #0x0c]

;---------- Modo de entrada -> Incrementa um caracter a direita
			LDR r1, =Port_B
			
			LDR r0, =2_0000000000000010
			
			STR r0, [r1, #0x0c]
			
			LDR r1, =Port_A
			LDR r0, =2_0000000000000110
			
			STR r0, [r1, #0x0c]
			
			LDR	 r4, =10000
			;LDR	 r4, =1	
			
			BL timer
						
			LDR r1, =Port_B
			
			LDR r0, =2_0000000000000000
			
			STR r0, [r1, #0x0c]

			pop {pc}
			BX LR
			endp
;------------------------------------------------------------
newLine		PROC
			PUSH {LR}
			LDR r1, =Port_B
			
			LDR r0, =2_0000000000000010
			
			STR r0, [r1, #0x0c]
			
			LDR r1, =Port_A
			LDR r2, =2_11000000	
			
			STR r2, [r1, #0x0c]
			
			LDR	 r4, =10000
			;LDR	 r4, =1	
			
			BL timer
			
			LDR r1, =Port_B
			
			LDR r0, =2_0000000000000000
			
			STR r0, [r1, #0x0c]
			
			POP	{PC}
			BX	LR
			ENDP

;------------------------------------------------------------
printMen	PROC
			PUSH {LR}
			LDR r1, =Port_B
			
			LDR r0, =2_0000000000000011
			
			STR r0, [r1, #0x0c]
			
			LDR r1, =Port_A
									
			STR r2, [r1, #0x0c]
			
			LDR	 r4, =10000
			;LDR	 r4, =1	
			
			BL timer
			
			LDR r1, =Port_B
			
			LDR r0, =2_0000000000000001
			
			STR r0, [r1, #0x0c]
			
			POP	{PC}
			BX	LR
			ENDP

;------------------------------------------------------------
timer		proc
			push {lr}
			
tm			SUBS R4, R4, #1
			NOP
			BNE  tm
			
			
			pop {pc}
			BX	LR
			endp

;------------------------------------------------------------			
toggleOnOff	PROC
;gpioTogleOn
			
			PUSH {LR}
			; GPIO PC13 -> Liga		|	offset 0x0c
			LDR r1, =Port_C
			MOV	r0, #0x2000
			STR	r0, [r1, #0x0C]

			; GPIO PB11 -> Liga		|	offset 0x0c
			LDR r1, =Port_B
			MOV	r0, #0x800 ;0000 1000 0000 0000
			STR	r0, [r1, #0x0C]
			
			;BX	LR
			
			LDR R4, =100000
			BL timer
;------------------------------------------------------------
;gpioTogleOff			
			; GPIO PC13 -> Desliga	|	offset 0x0c
			LDR r1, =Port_C
			ldr	r0, =0x0000
			str r0, [r1, #0x0C]
			
			; GPIO PB11 -> Desliga		|	offset 0x0c
			LDR r1, =Port_B
			MOV	r0, #0x000 ;0000 1000 0000 0000
			STR	r0, [r1, #0x0C]
			
			LDR R4, =100000
			BL timer

			POP {PC}						
			BX	LR
			ENDP
;------------------------------------------------------------
gpioRead	proc
			LDR	r0, =Port_C
			MOV	r1, #rdOs
			ORR r0, r0, r1
			LDR r1, [r0, #0x01] ;OffSet deslocado em 1 = 0x09
			LSR	r1, #6 ; R1 >> 6 -> 0100 0000 >> 0000 0001 

;---------	Se r1 = 1 realiza a soma
			CMP r1, #1
			BEQ	sum
			B	endRd	

;---------	Incrementa em 1 o reg
sum			ADD	r5, r5, #1
			
;---------	Guarda o valor da soma na sram
			;LDR r4, [sramBase, #0x300]

;---------	Delay debounce
			;LDR	 R0, =1000
			LDR	 R0, =1	
			
dc			SUBS R0, R0, #1
			NOP
			BNE  dc

;---------	Fim da rotina
endRd		BX LR
			endp
;--------------------------------------------------------------------------------------------------------
gpioInit	proc
			
			; RCC APB1-> habilita 	| 	offset 0x18
			; RCC deve abilitar o clock para as GPIO conforme user ref
			MOV	r0,	#0x1C ;0000 0000 0000 0000 0000 0000 0001 1100 -> Bits em 1 habilitam GPIO A, B e C 
			LDR r1, =RCC
			STR r0, [r1, #0x18]
			
			
			; GPIO PC13 -> saida 	|	offset 0x04
			; GPIO PC14	-> entrada	|	offset 0x04 
			LDR	r0, =0x28222222 ; 0010 1000 0010 0010 0010 0010 0010 0010
			LDR r1, =Port_C
			STR	r0, [r1, #0x04]
			
			; GPIO PB0, PB1 e PB11 -> saida 	|	offset 0x04
			; PB0 e PB1 -> D6 e D7 LCD
			LDR	r0, =0x44442444 ;0100 0100 0100 0100 0010 0100 0100 0100
			LDR r1, =Port_B
			;----- CHR
			STR	r0, [r1, #0x04]
			
			LDR r0, =0x44444422 ;0100 0100 0100 0100 0100 0100 0010 0010
			;----- CLR
			STR	r0, [r1]
			
			; GPIO PA0~PA7 	-> saída - LCD
			LDR	r0, =0x22222222 ;0010 0010 0010 0010 0010 0010 0010 0010
			LDR r1, =Port_A
			STR	r0, [r1, #0x00]
			
			
			BX	LR
			endp
;----------------------------------------------------------------------------------------------------------
dataMove	proc
			mov 	r0, #2
			ldr		r1, =sramBase
			str		r0, [r1, #0x305]
			
			mov		r0, #0xFFFFFF0A
			ldr 	r1, =sramBase
			str		r0, [r1, #0x300]
			
			mov		r0, #0xFFFFFF0B
			ldr 	r1, =sramBase
			str		r0, [r1, #0x301]
			
			ldr 	r2, [r1, #0x301]
												
			BX	LR
			endp
;-------------------------------------------------------------
			ALIGN
			END