#define __SFR_OFFSET 0x00
#include "avr/io.h"
.global adc_loop


LCD_buffer:
LDS R27, UCSR0A
SBRS R27, UDRE0
RJMP LCD_buffer
RET

ASCII_MSD:
MOV R23, R16
ANDI R16, 0xF0
SWAP R16
SUBI R16, -48
MOV R28, R16
SUBI R28, 58
BRPL A_F_D1
l1:
RET
A_F_D1:
SUBI R16, -7
RJMP l1

ASCII_LSD:
MOV R16, R23
ANDI R16, 0x0F
SUBI R16, -48
MOV R28, R16
SUBI R28, 58
BRPL A_F_D0
l2:
RET
A_F_D0:
SUBI R16, -7
RJMP l2

newline:
;print new line
RCALL LCD_buffer
LDI R16, 0x0A
STS UDR0, R16
;print carriage return
RCALL LCD_buffer
LDI R16, 0x0D
STS UDR0, R16
RET

printval:
RCALL ASCII_MSD
RCALL LCD_buffer
STS UDR0, R16
;print 4 lower byte
RCALL ASCII_LSD
RCALL LCD_buffer
STS UDR0, R16
;print new line
RET

read_ADC:
LDI   R20, 0xC7   ;set ADSC in ADCSRA to start conversion
STS   ADCSRA, R20
wait_ADC:
LDS   R21, ADCSRA ;check ADIF flag in ADCSRA
SBRS  R21, 4      ;skip jump when conversion is done (flag set)
RJMP  wait_ADC    ;loop until ADIF flag is set
LDI   R17, 0xD7   ;set ADIF flag again
STS   ADCSRA, R17 ;so that controller clears ADIF
LDS   R18, ADCL   ;get low-byte result from ADCL
LDS   R19, ADCH   ;get high-byte result from ADCH
MOV   R16, R19
RCALL printval
MOV   R16, R18
RCALL printval
RCALL newline
RCALL myDelay
RJMP  adc_store


adc_loop:
STS UDR0, R16
INC R25
CPI R25, 1
BREQ adc_init1
CPI R25,2
BREQ adc_init2
CPI R25,3
BREQ adc_init3
CPI R25,4
BREQ photoresistor
CPI R25,5
BREQ store




adc_store:
;r1 r2 = potentiometer 1
;r3 r4 = potentiometer 2
;r5 r6 = potentiometer 3
;r7 r8 = stored potentiometer 1
;r9 r10 = stored potentiometer 2
;r11 r12 = stored potentiometer 3

CPI R25, 1
BREQ adc_store1
CPI R25, 2
BREQ adc_store2
CPI R25, 3
BREQ adc_store3
CPI R25, 4
BREQ photo_led


adc_store1:
MOV R1, R19
MOV R2, R18
RJMP adc_loop

adc_store2:
MOV R3, R19
MOV R4, R18
RJMP adc_loop

adc_store3:
MOV R5, R19
MOV R6, R18
RJMP adc_loop

adc_init1:
LDI   R20, 0xFF
LDI   R20, 0xC0   ;internal 2.56V, right-justified data, ADC0
STS   ADMUX, R20
JMP read_ADC

adc_init2:
LDI   R20, 0xFF
LDI   R20, 0xC1   ;internal 2.56V, right-justified data, ADC1
STS   ADMUX, R20
JMP read_ADC

adc_init3:
LDI   R20, 0xFF
LDI   R20, 0xC2   ;internal 2.56V, right-justified data, ADC2
STS   ADMUX, R20
JMP   read_ADC

photoresistor:
LDI   R20, 0xFF
LDI   R20, 0xC3   ;internal 2.56V, right-justified data, ADC2
STS   ADMUX, R20
JMP   read_ADC

photo_led:
SUBI  R18,0X20
BRPL  light
jmp   nolight

nolight:
CBI   PORTC,4
JMP   adc_loop

light:
SBI   PORTC,4
JMP   adc_loop

myDelay:
LDI R20, 255
lay1:
LDI R21, 255
lay2:
LDI R22, 20
lay3:
DEC R22
BRNE lay3
DEC R21
BRNE lay2
DEC R20
BRNE lay1
RET

;r1 r2 = potentiometer 1
;r3 r4 = potentiometer 2
;r5 r6 = potentiometer 3
;r7 r8 = stored potentiometer 1
;r9 r10 = stored potentiometer 2
;r11 r12 = stored potentiometer 3
store:
SBIS PORTD,7
BREQ exit
mov r7,r1
mov r8,r2
mov r9,r3
mov r10,r4
mov r11,r5
mov r12,r6
RCALL newline
RCALL newline
CBI PORTD,7
JMP exit

exit:
LDI   R25, 0
RCALL myDelay
RET