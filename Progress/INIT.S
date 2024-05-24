#define __SFR_OFFSET 0x00
#include "avr/io.h"
.global init

init:
control_init:
MOV R25,0
MOV R26,0

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
LDI   R20, 0xC0   ;internal 2.56V, right-justified data, ADC0
STS   ADMUX, R20
LDI   R20, 0x87   ;enable ADC, ADC prescaler CLK/128
STS   ADCSRA, R20

SBI   DDRC, 0     ;set pin PC0 as i/p for ADC0
SBI   DDRC, 1     ;set pin PC0 as i/p for ADC0
SBI   DDRC, 2     ;set pin PC0 as i/p for ADC0

RET