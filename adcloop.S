#define __SFR_OFFSET 0x00
#include "avr/io.h"

;----------------------------------------------------------------
.global adc_loop
;----------------------------------------------------------------
;nit adc

;--------------------------------------------------------------------------------------------------------
adc_loop:
  LDI R30, 7
  LDI R31, 48
  STS UDR0, R16
  INC R25
  CPI R25, 1
  BREQ read_ADC0
  CPI R25,2
  BREQ read_ADC1
  CPI R25,3
  BREQ read_ADC2
  CPI R25,4
  RET

read_ADC0:
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

  ADD R23, R31 ;add 48 to byte to get ASCII char 0 to 9
  
  RJMP  print_adc

read_ADC1:
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


  ADD R25, R31 ;add 48 to byte to get ASCII char 0 to 9
  
  RJMP  print_adc

read_ADC2:
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

  ADD R27, R31 ;add 48 to byte to get ASCII char 0 to 9
  
  RJMP  print_adc

;------------------

print_adc:
l1: LDS R17, UCSR0A
 SBRS R17, UDRE0 ;test data buffer if data can be sent
 RJMP l1
STS UDR0, R25 ;print ADC MSD on serial monitor
 ;----------------------------------------------------------------
PUSH R16 ;store copy of ADCH in STACK register
 ANDI R16, 0xF0 ;mask & extract high-nibble
 SWAP R16 ;swap high-nibble with low-nibble
 ADD R16, R23 ;add 48 to byte to get ASCII char 0 to 9
 MOV R28, R16 ;store a copy of byte in R28
 SUBI R28, 58 ;subtract 58 from R28
 BRPL A_F_MSD ;jump if result is +ve
 ;----------------------------------------------------------------
l2: LDS R17, UCSR0A
 SBRS R17, UDRE0 ;test data buffer if data can be sent
 RJMP l2
 ;----------------------------------------------------------------
STS UDR0, R16 ;print ADC mid digit on serial monitor
 ;----------------------------------------------------------------
POP R16 ;restore ADCH value from STACK register
 ANDI R16, 0x0F ;mask & extract low-nibble
 ADD R16, R23
 MOV R28, R16
 SUBI R28, 58
 BRPL A_F_LSD
 ;----------------------------------------------------------------
l3: LDS R17, UCSR0A
 SBRS R17, UDRE0 ;test data buffer if data can be sent
 RJMP l3
 ;----------------------------------------------------------------
STS UDR0, R16 ;print ADC LSD on serial monitor
 ;----------------------------------------------------------------
l4: LDS R17, UCSR0A
 SBRS R17, UDRE0 ;test data buffer if data can be sent
 RJMP l4
 ;----------------------------------------------------------------
LDI R18, 0x0A
 STS UDR0, R18 ;print newline on serial monitor
 ;----------------------------------------------------------------
l5: LDS R17, UCSR0A
 SBRS R17, UDRE0 ;test data buffer if data can be sent
 RJMP l5
  LDI R18, 0x0D
 STS UDR0, R18 ;print carriage return on serial monitor
 ;----------------------------------------------------------------
RCALL delay_sec ;1 second delay
 RJMP adc_loop
 ;=====================================================================

 A_F_MSD:
 ADD R16, R30 ;add 7 to byte to get ASCII chars A to F
 RJMP l2
 ;--------------------------------------------------------------------
A_F_LSD:
 ADD R16, R30 ;add 7 to byte to get ASCII chars A to F
 RJMP l3
 ;--------------------------------------------------------------------
delay_sec: ;1s delay
 LDI R20, 255
 l6: LDI R21, 255
 l7: LDI R22, 80
 l8: DEC R22
 BRNE l8
 DEC R21
 BRNE l7
 DEC R20
 BRNE l6
 RET
