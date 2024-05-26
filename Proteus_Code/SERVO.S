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
    CPI   R29,1
    BREQ  continue
    SBIC  PORTD,6
    JMP   ALARM_3
    SBIC  PORTD,5
    JMP   ALARM_2
ALARM_1:
    SBI   PORTD,5     ;ALARM COUNTER SET
    CBI   PORTB,0
    RET
ALARM_2:
    SBI   PORTD,6
    CBI   PORTB,0
    RET
ALARM_3:
    SBI   PORTD,4
    CBI   PORTB,0
    RET

continue:     
    SBIS  PORTC,3
    BREQ  rotate_ninety
    JMP   rotate_zero
;---------------------------------------------------------------
rotate_zero:
    CBI   PORTC,3
    LDI   ZL, lo8(zero)
    LDI   ZH, hi8(zero)
    JMP   move_servo
    
rotate_ninety:
    SBI   PORTC,3
    CBI   PORTD,5
    CBI   PORTD,6
    CBI   PORTD,4
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
.byte 40
ninety:
.byte 90
;===============================================================
rotate_servo:
;------------
    LDI   R20, 10         ;count to give enough cycles of PWM
l2: SBI   PORTB, 1
    RCALL delay_timer0
    CBI   PORTB, 1        ;send msec pulse to rotate servo
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
    CLR   R25
    OUT   TCNT0, R25      ;initialize timer0 with count=0
    MOV   R25, R24
    OUT   OCR0A, R25
    LDI   R25, 0b00001100
    OUT   TCCR0B, R25     ;timer0: CTC mode, prescaler 256
    ;-----------------------------------------------------------
l3: IN    R25, TIFR0      ;get TIFR0 byte & check
    SBRS  R25, OCF0A      ;if OCF0=1, skip next instruction
    RJMP  l3              ;else, loop back & check OCF0 flag
    ;-----------------------------------------------------------
    CLR   R25
    OUT   TCCR0B, R25     ;stop timer0
    ;-----------------------------------------------------------
    LDI   R25, (1<<OCF0A)
    OUT   TIFR0, R25      ;clear OCF0 flag
    RET
;===============================================================
delay_20ms:               ;delay 20ms
    LDI   R25, 255
l4: LDI   R30, 210
l5: LDI   R31, 2
l6: DEC   R31
    BRNE  l6
    DEC   R30
    BRNE  l5
    DEC   R25
    BRNE  l4
    RET
;===============================================================
delay_ms:                 ;delay 0.5s
    LDI   R25, 255
l7 :LDI   R30, 255
l8 :LDI   R31, 41
l9 :DEC   R31
    BRNE  l9
    DEC   R30
    BRNE  l8
    DEC   R25
    BRNE  l7
    RET
