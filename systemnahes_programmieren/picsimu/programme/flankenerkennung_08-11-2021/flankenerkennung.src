 device 16f84
	
status equ 03h
rp0	equ 5

counter equ 10h
 org 0
 
cold

; Bank 1 einschalten
 BSF status, rp0
 CLRF TRISB ; Port B alles Ausgang
 BCF TRISA, 3 ; Port A RA3 Ausgang
 
; Bank 2 einschalten
 BCF status, rp0