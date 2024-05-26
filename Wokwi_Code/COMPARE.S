;------------------------
#define __SFR_OFFSET 0x00
#include "avr/io.h"
;------------------------
.global compare
compare:
cp r1,r7
BRNE not_equal
cp r2,r8
BRNE not_equal
cp r3,r9
BRNE not_equal
cp r4,r10
BRNE not_equal
cp r5,r11
BRNE not_equal
cp r6,r12
BRNE not_equal
LDI R29,1      ;EQUAL FLAG
RET

not_equal:
LDI R29,0      ;UNEQUAL FLAG
CBI PORTD,7
RET