#define __SFR_OFFSET 0x00
#include "avr/io.h"
.global main

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
RJMP  adc_loop




main:
MOV R25,0
serial_init:
CLR R24
STS UCSR0A, R24
STS UBRR0H, R24
LDI R24, 103
STS UBRR0L, R24
LDI R24, 1<<RXEN0 | 1<<TXEN0
STS UCSR0B, R24
LDI R24, 1<<UCSZ00 | 1<<UCSZ01
STS UCSR0C, R24

adc_init:
LDI   R20, 0xFF
SBI   DDRC, 0     ;set pin PC0 as i/p for ADC0
;--------------------------------------------------------------
LDI   R20, 0xC0   ;internal 2.56V, right-justified data, ADC0
STS   ADMUX, R20
LDI   R20, 0x87   ;enable ADC, ADC prescaler CLK/128
STS   ADCSRA, R20

adc_loop:
INC R25
CPI R25,1
BREQ adc_init1
CPI R25,2
BREQ adc_init2
CPI R25,3
BREQ adc_init3


adc_init1:
LDI   R20, 0xFF
SBI   DDRC, 0     ;set pin PC0 as i/p for ADC0
;--------------------------------------------------------------
LDI   R20, 0xC0   ;internal 2.56V, right-justified data, ADC0
STS   ADMUX, R20

JMP read_ADC

adc_init2:
LDI   R20, 0xFF
SBI   DDRC, 1     ;set pin PC0 as i/p for ADC0
;--------------------------------------------------------------
LDI   R20, 0xC1   ;internal 2.56V, right-justified data, ADC1
STS   ADMUX, R20


JMP read_ADC

adc_init3:
LDI   R20, 0xFF
SBI   DDRC, 2     ;set pin PC0 as i/p for ADC0
LDI   R20, 0xC2   ;internal 2.56V, right-justified data, ADC2
STS   ADMUX, R20


MOV   R25,0
JMP   read_ADC

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
