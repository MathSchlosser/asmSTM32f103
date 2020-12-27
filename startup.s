;----------------------------------------------------------------
;	Project: 	Simple baremetal software in ASM for ARM arch
;	Author: 	Matheus Schlosser Basso
;	Date:		12/2020
;	uC:			STM32f103c8
;	Software:	Keil uVison 5
;----------------------------------------------------------------

					THUMB
					
stackStartAdress	EQU		0x20000100
						
					AREA mySection1, DATA, READONLY
					
					DCD		stackStartAdress
					DCD		myResetHandler
					
					AREA mySection2, CODE, READONLY
					
					ENTRY
					
myResetHandler
	
					IMPORT 	myApplication
						

					B		myApplication
					
					END