; Binärzähler

 device 16f84

; \***************** Symbol Names **********************\
 
; Statusregister
status equ 3 ; Adresse des Statusregisters im RAM-File
rp0 equ 5 ; Bank select
carry equ 0 ; carry flag - Zeigt an, ob bei der letzten Rechenoperation ein Übertrag auftrat.
zero equ 2 ; zero flag - Zeigt an, ob das Ergebnis einer Operation gleich 0 war.

; PORTA
porta equ 5
; Bitstellen von Port A 
takt equ 0 ; Zähleingang RA0
reset equ 1 ; Reseteingang RA1
inhibit equ 2 ; Inhitbiteingang RA2 
carry equ 3 ; Carryausgang RA3 
maske equ 1 ; 00000001 ; Maske für Zähleingang RA0

portb equ 6
; TRIS: TRI-State. Mit einem TRIS Register kann Portpins auf Eingang oder Ausgang schalten. 
trisa equ 5
trisb equ 6

; Variablen - Speichersetellen
counter equ 10h ; 0c erste freie Adresse, 10h ist im Simulator leicht zu finden
aktWert equ 11h
alterWert equ 12h 
flanke equ 13h

; \***************** Symbol Names **********************\

 org 0 ; Programm beginnt bei Adresse 0
 
cold
; Ports initalisieren
 bsf status,rp0 ; auf Bank 1 umschlaten
 bcf trisa,carry ; Port A carry auf Ausgang setzen
 clrf trisb ; Port B alles Ausgang

 bcf status,rp0 ; zurück auf Bank 0

; ersten Wert lesen
 movf porta,w ; Port A ins W-file lesen
 andlw maske ; RA0 Zähleingang maskieren
 movewf alterWert ; W-file in alterWert Schreiben: Erster Vergleichswert
 
resetCNT
 clrf counter ; Counter mit 0 initalisieren
 bcf porta,carry ; carry zurücksetzen

xxxx
 movf counter,w
 movwf portb ; Counterinhalt ausgeben
 
mainloop
 btfsc porta,reset ; Resteingang 1? 
 goto resetCNT ; ja --> reset

 btfsc porta,inhibit ; Inhibit-Eingang 1? 
 goto mainloop ; ja --> Zähler anhalten
 call checkEdge ; Flanke da? Nein --> W = 0, 
 iorlw 0 ; Inklusives oder mit x: 
 btfsc status,zero ; Prüfe ob iorlw 0 ergeben hat
 goto mainloop ; nein

checkEdge