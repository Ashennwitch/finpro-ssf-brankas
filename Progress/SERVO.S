;------------------------
; Assembly Code
;------------------------
#define __SFR_OFFSET 0x00
#include "avr/io.h"
;------------------------
.global servo
;===============================================================
servo:
;-----------
check:
    SBIS  PORTB,0
    RET   
    SBIS  PORTB,1
    BREQ  rotate_ninety
    JMP   rotate_zero
;---------------------------------------------------------------
rotate_zero:
    CBI   PORTB,1
    LDI   ZL, lo8(zero)
    LDI   ZH, hi8(zero)
    JMP   move_servo
    
rotate_ninety:
    SBI   PORTB,1
    LDI   ZL, lo8(ninety)
    LDI   ZH, hi8(ninety)
    ;-----------------------------------------------------------
    
move_servo: 
    LPM   R24, Z         ;load rotation pos
    RCALL rotate_servo    ;& rotate servo
    CBI   PORTB,0
    RET
    ;-----------------------------------------------------------
    
;---------------------------------------------------------------
zero:
.byte 90
ninety:
.byte 40
;===============================================================
rotate_servo:
;------------
    LDI   R20, 10         ;count to give enough cycles of PWM
l2: SBI   PORTB, 4
    RCALL delay_timer0
    CBI   PORTB, 4        ;send msec pulse to rotate servo
    RCALL delay_20ms      ;wait 20ms before re-sending pulse
    DEC   R20
    BRNE  l2              ;go back & repeat PWM signal
    ;-----------------------------------------------------------
bak:RCALL delay_ms        ;0.5s delay
    RET                   ;& return to main subroutine
;-------------------
;===============================================================
;delay subroutines
;===============================================================
delay_timer0:             ;delay via Timer0
    ;-----------------------------------------------------------
    CLR   R26
    OUT   TCNT0, R26      ;initialize timer0 with count=0
    MOV   R26, R24
    OUT   OCR0A, R26
    LDI   R26, 0b00001100
    OUT   TCCR0B, R26     ;timer0: CTC mode, prescaler 256
    ;-----------------------------------------------------------
l3: IN    R26, TIFR0      ;get TIFR0 byte & check
    SBRS  R26, OCF0A      ;if OCF0=1, skip next instruction
    RJMP  l3              ;else, loop back & check OCF0 flag
    ;-----------------------------------------------------------
    CLR   R26
    OUT   TCCR0B, R26     ;stop timer0
    ;-----------------------------------------------------------
    LDI   R26, (1<<OCF0A)
    OUT   TIFR0, R26      ;clear OCF0 flag
    RET
;===============================================================
delay_20ms:               ;delay 20ms
    LDI   R26, 255
l4: LDI   R30, 210
l5: LDI   R31, 2
l6: DEC   R31
    BRNE  l6
    DEC   R30
    BRNE  l5
    DEC   R26
    BRNE  l4
    RET
;===============================================================
delay_ms:                 ;delay 0.5s
    LDI   R26, 255
l7 :LDI   R30, 255
l8 :LDI   R31, 41
l9 :DEC   R31
    BRNE  l9
    DEC   R30
    BRNE  l8
    DEC   R26
    BRNE  l7
    RET
