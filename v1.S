#define __SFR_OFFSET 0x00
#include "avr/io.h"

//------------------------
.global init_ADC
.global read_ADC

//------------------------
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

//----------------------------------------------------------------
read_ADC:
  ; Read ADC0
  LDI R20, 0xC0   ; internal 2.56V, right-justified data, ADC0
  STS ADMUX, R20
  LDI R20, 0xC7   ; set ADSC in ADCSRA to start conversion
  STS ADCSRA, R20

wait_ADC0:
  LDS R21, ADCSRA ; check ADIF flag in ADCSRA
  SBRS R21, 4     ; skip jump when conversion is done (flag set)
  RJMP wait_ADC0  ; loop until ADIF flag is set

  LDI R17, 0xD7   ; set ADIF flag again
  STS ADCSRA, R17 ; so that controller clears ADIF
  LDS R18, ADCL   ; get low-byte result from ADCL
  LDS R19, ADCH   ; get high-byte result from ADCH

  ; Save ADC0 result to registers
  MOV R22, R18
  MOV R23, R19

  ; Read ADC1
  LDI R20, 0xC1   ; internal 2.56V, right-justified data, ADC1
  STS ADMUX, R20
  LDI R20, 0xC7   ; set ADSC in ADCSRA to start conversion
  STS ADCSRA, R20

wait_ADC1:
  LDS R21, ADCSRA ; check ADIF flag in ADCSRA
  SBRS R21, 4     ; skip jump when conversion is done (flag set)
  RJMP wait_ADC1  ; loop until ADIF flag is set

  LDI R17, 0xD7   ; set ADIF flag again
  STS ADCSRA, R17 ; so that controller clears ADIF
  LDS R18, ADCL   ; get low-byte result from ADCL
  LDS R19, ADCH   ; get high-byte result from ADCH

  ; Save ADC1 result to registers
  MOV R24, R18
  MOV R25, R19

  ; Read ADC2
  LDI R20, 0xC2   ; internal 2.56V, right-justified data, ADC2
  STS ADMUX, R20
  LDI R20, 0xC7   ; set ADSC in ADCSRA to start conversion
  STS ADCSRA, R20

wait_ADC2:
  LDS R21, ADCSRA ; check ADIF flag in ADCSRA
  SBRS R21, 4     ; skip jump when conversion is done (flag set)
  RJMP wait_ADC2  ; loop until ADIF flag is set

  LDI R17, 0xD7   ; set ADIF flag again
  STS ADCSRA, R17 ; so that controller clears ADIF
  LDS R18, ADCL   ; get low-byte result from ADCL
  LDS R19, ADCH   ; get high-byte result from ADCH

  ; Save ADC2 result to registers
  MOV R26, R18
  MOV R27, R19

  ; Compare ADC values with the hardcoded key combination
  LDI R28, 0x00   ; hardcoded key value for ADC0
  LDI R29, 0x00   ; hardcoded key value for ADC1
  LDI R30, 0x00   ; hardcoded key value for ADC2

  CP R22, R28     ; compare ADC0 low byte with key value
  BRNE wrong_key
  CP R23, R1      ; compare ADC0 high byte with 0 (assuming 8-bit value)
  BRNE wrong_key
  CP R24, R29     ; compare ADC1 low byte with key value
  BRNE wrong_key
  CP R25, R1      ; compare ADC1 high byte with 0 (assuming 8-bit value)
  BRNE wrong_key
  CP R26, R30     ; compare ADC2 low byte with key value
  BRNE wrong_key
  CP R27, R1      ; compare ADC2 high byte with 0 (assuming 8-bit value)
  BRNE wrong_key

  ; Correct key combination
  LDI R24, 90     ; set servo position to 90 degrees (open)
  RJMP rotate_servo

wrong_key:
  ; Wrong key combination
  LDI R24, 0      ; set servo position to 0 degrees (closed)
  RJMP rotate_servo

rotate_servo:
  LDI R20, 10     ; count to give enough cycles of PWM

l2:
  SBI PORTB, 3
  RCALL delay_timer0
  CBI PORTB, 3    ; send msec pulse to rotate servo
  RCALL delay_20ms ; wait 20ms before re-sending pulse
  DEC R20
  BRNE l2         ; go back & repeat PWM signal

  RET

//----------------------------------------------------------------
; delay subroutines
;===============================================================
delay_timer0:       ; delay via Timer0
  CLR R21
  OUT TCNT0, R21    ; initialize timer0 with count=0
  MOV R21, R24      ; set compare match value based on servo position
  OUT OCR0A, R21
  LDI R21, 0b00001100
  OUT TCCR0B, R21   ; timer0: CTC mode, prescaler 256

l3:
  IN R21, TIFR0     ; get TIFR0 byte & check
  SBRS R21, OCF0A   ; if OCF0=1, skip next instruction
  RJMP l3           ; else, loop back & check OCF0 flag

  CLR R21
  OUT TCCR0B, R21   ; stop timer0
  LDI R21, (1<<OCF0A)
  OUT TIFR0, R21    ; clear OCF0 flag
  RET

;===============================================================
delay_20ms:         ; delay 20ms
  LDI R21, 255
l4:
  LDI R22, 210
l5:
  LDI R23, 2
l6:
  DEC R23
  BRNE l6
  DEC R22
  BRNE l5
  DEC R21
  BRNE l4
  RET