#define __SFR_OFFSET 0x00
#include "avr/io.h"
.global init

init:
control_init:
LDI R25,0       ;ADC COUNTER
LDI R30,0       ;STORE COUNTER
LDI R26,0       ;COUNTER ALARM

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
LDI   R29, 0      ;CHECK IF ADC STORED == ADC CURRENT
LDI   R20, 0xFF
SBI   DDRC, 0     ;set pin PC0 as i/p for ADC0
LDI   R20, 0xC0   ;internal 2.56V, right-justified data, ADC0
STS   ADMUX, R20
LDI   R20, 0x87   ;enable ADC, ADC prescaler CLK/128
STS   ADCSRA, R20

CBI   DDRC, 0     ;set pin PC0 as i/p for ADC0
CBI   DDRC, 1     ;set pin PC1 as i/p for ADC0
CBI   DDRC, 2     ;set pin PC2 as i/p for ADC0
CBI   DDRC, 3     ;set pin PC3 as i/p for ADC0
SBI   DDRC, 4
SBI   DDRC, 5


interrupt_init:
CBI   DDRD,  2       ; Clear bit 2 in DDRD, setting PD2 as input
CBI   DDRD,  3 
SBI   DDRD,  4       ;ALARM CHECK3
SBI   DDRD,  6       ;ALARM CHECK2
SBI   DDRD,  5       ;ALARM CHECK1
SBI   PORTD, 2 
SBI   PORTD, 3
SBI   DDRB,  0
SBI   DDRB,  1
SBI   DDRD,  7
; Enable INT0 and INT1
LDI R23, (1<<INT0) | (1<<INT1)
OUT EIMSK, R23
; Configure INT0 and INT1 to trigger on falling edge
LDI R23, (1<<ISC01) | (1<<ISC11)
STS EICRA, R23
SEI                 ; Enable global interrupts
RET