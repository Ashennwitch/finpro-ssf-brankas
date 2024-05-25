#define __SFR_OFFSET 0x00
#include "avr/io.h"
.global init

init:
init_serial:
 CLR R28
 STS UCSR0A, R28 ;clear UCSR0A register
 STS UBRR0H, R28 ;clear UBRR0H register
 LDI R28, 103 ;& store in UBRR0L 103
 STS UBRR0L, R28 ;to set baud rate 9600
 LDI R28, 1<<RXEN0 | 1<<TXEN0
 STS UCSR0B, R28 ;enable RXB & TXB
 LDI R28, 1<<UCSZ00 | 1<<UCSZ01
 STS UCSR0C, R28 ;asynch, no parity, 1 stop, 8 bits

init_ADC:
  LDI R20, 0xFF
  OUT DDRD, R20   ; set port D as output for low byte result
  OUT DDRB, R20   ; set port B as output for high byte result
  SBI DDRC, 0     ; set pin PC0 as input for ADC0
  SBI DDRC, 1     ; set pin PC1 as input for ADC1
  SBI DDRC, 2     ; set pin PC2 as input for ADC2
  SBI DDRB, 4     ; set pin PB4 as output for servo control

  ; Initialize ADMUX for ADC0
  LDI R20, 0xC0   ; internal 2.56V, right-justified data, ADC0
  STS ADMUX, R20
  LDI R20, 0x87   ; enable ADC, ADC prescaler CLK/128
  STS ADCSRA, R20

  RET