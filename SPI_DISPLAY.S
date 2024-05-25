;=================================================================
;delay subroutines
;=================================================================
#define __SFR_OFFSET 0x00
#include "avr/io.h"
.global display

;===============================================================
;MAX7219 subroutines
;===============================================================
display:
SPI_MAX7219_init:
;----------------
.equ  SCK, 5
.equ  MOSI, 3
.equ  SS, 2
;--------------------------------------------------------------
      LDI   R17, (1<<MOSI)|(1<<SCK)|(1<<SS)
      OUT   DDRB, R17       ;set MOSI, SCK, SS as o/p
      ;--------------------------------------------------------
      LDI   R17, (1<<SPE)|(1<<MSTR)|(1<<SPR0)
      OUT   SPCR, R17       ;enable SPI as master, fsck=fosc/16
      ;--------------------------------------------------------
      LDI   R17, 0x0A       ;set segment intensity (0 to 15)
      LDI   R18, 8          ;intensity level = 8
      RCALL send_bytes      ;send command & data to MAX7219
      ;--------------------------------------------------------
      LDI   R17, 0x09       ;set decoding mode command
      LDI   R18, 0b01100011 ;decoding byte
      RCALL send_bytes      ;send command & data to MAX7219
      ;--------------------------------------------------------
      LDI   R17, 0x0B       ;set scan limit command
      LDI   R18, 0x07       ;8 digits connected to MAX7219
      RCALL send_bytes      ;send command & data to MAX7219
      ;--------------------------------------------------------
      LDI   R17, 0x0C       ;set turn ON/OFF command
      LDI   R18, 0x01       ;turn ON MAX7219
      RCALL send_bytes      ;send command & data to MAX7219
      ;--------------------------------------------------------
;==============================================================
MAX7219_disp_text:
      SBIC  PORTB,1
      JMP   unlocked
      SBIC  PORTD,4         ;CHECK ALARM FLAG
      INC   R26             ;INC IF SET
      SBIC  PORTD,6
      INC   R26
      SBIC  PORTD,5
      INC   R26
;-----------------
      CPI   R26,3
      BREQ  alert

locked:

      LDI   R17, 0x08       ;select digit 7
      LDI   R18, 0b11111100      
      RCALL send_bytes      ;send command & data to MAX7219

      LDI   R17, 0x07       ;select digit 6
      LDI   R18, 0b11111100      
      RCALL send_bytes      ;send command & data to MAX7219

      LDI   R17, 0x06       ;select digit 5
      LDI   R18, 0b00001100       ;data = t
      RCALL send_bytes      ;send command & data to MAX7219

      LDI   R17, 0x05       ;select digit 5
      LDI   R18, 0b00001100       ;data = t
      RCALL send_bytes      ;send command & data to MAX7219

      LDI   R17, 0x04       ;select digit 5
      LDI   R18, 0b00001100       ;data = t
      RCALL send_bytes      ;send command & data to MAX7219

      LDI   R17, 0x03       ;select digit 5
      LDI   R18, 0b00001100       ;data = t
      RCALL send_bytes      ;send command & data to MAX7219

      LDI   R17, 0x02       ;select digit 5
      LDI   R18, 0b00001100       ;data = t
      RCALL send_bytes      ;send command & data to MAX7219
      
      CPI   R26,0
      BREQ  lock_0
      CPI   R26,1
      BREQ  lock_1
      CPI   R26,2
      BREQ  lock_2
      


      lock_0:

      LDI   R17, 0x01       ;select digit 5
      LDI   R18, 0b00001100       ;data = t
      RCALL send_bytes      ;send command & data to MAX7219
      JMP   back

      lock_1:
      LDI   R17, 0x01       ;select digit 5
      LDI   R18, 0b10001100       ;data = t
      RCALL send_bytes      ;send command & data to MAX7219
      JMP   back

      lock_2:
      LDI   R17, 0x01       ;select digit 5
      LDI   R18, 0b11001100       ;data = t
      RCALL send_bytes      ;send command & data to MAX7219
      JMP   back

      alert:
      ;-----------------
      LDI   R17, 0x01       ;select digit 7
      LDI   R18, 0b00111000      
      RCALL send_bytes      ;send command & data to MAX7219

      LDI   R17, 0x02       ;select digit 7
      LDI   R18, 0b001000100      
      RCALL send_bytes      ;send command & data to MAX7219

      LDI   R17, 0x03       ;select digit 7
      LDI   R18, 0b001000100      
      RCALL send_bytes      ;send command & data to MAX7219

      LDI   R17, 0x04      ;select digit 7
      LDI   R18, 0b001000100      
      RCALL send_bytes      ;send command & data to MAX7219

      LDI   R17, 0x04      ;select digit 7
      LDI   R18, 0b001111100      
      RCALL send_bytes      ;send command & data to MAX7219

      LDI   R17, 0x05      ;select digit 7
      LDI   R18, 0b001000100      
      RCALL send_bytes      ;send command & data to MAX7219

      LDI   R17, 0x06      ;select digit 7
      LDI   R18, 0b001000100      
      RCALL send_bytes      ;send command & data to MAX7219

      LDI   R17, 0x07      ;select digit 7
      LDI   R18, 0b001000100      
      RCALL send_bytes      ;send command & data to MAX7219

      LDI   R17, 0x08      ;select digit 7
      LDI   R18, 0b001000100      
      RCALL send_bytes      ;send command & data to MAX7219

ALARM_BUZZ:
      SBI  PORTC,5
      CALL mytimer
      CBI  PORTC,5
      RET
;==============================================================
    unlocked:
     LDI   R17, 0x01       ;select digit 7
      LDI   R18, 0b001000100       
      RCALL send_bytes      ;send command & data to MAX7219

      LDI   R17, 0x02       ;select digit 7
      LDI   R18, 0b001000100      
      RCALL send_bytes      ;send command & data to MAX7219

      LDI   R17, 0x03       ;select digit 7
      LDI   R18, 0b001000100      
      RCALL send_bytes      ;send command & data to MAX7219

      LDI   R17, 0x04      ;select digit 7
      LDI   R18, 0b001000100      
      RCALL send_bytes      ;send command & data to MAX7219

      LDI   R17, 0x04      ;select digit 7
      LDI   R18, 0b001000100     
      RCALL send_bytes      ;send command & data to MAX7219

      LDI   R17, 0x05      ;select digit 7
      LDI   R18, 0b001000100      
      RCALL send_bytes      ;send command & data to MAX7219

      LDI   R17, 0x06      ;select digit 7
      LDI   R18, 0b001000100      
      RCALL send_bytes      ;send command & data to MAX7219

      LDI   R17, 0x07      ;select digit 7
      LDI   R18, 0b001000100      
      RCALL send_bytes      ;send command & data to MAX7219

      LDI   R17, 0x08      ;select digit 7
      LDI   R18, 0b001111100      
      RCALL send_bytes      ;send command & data to MAX7219
      back:
      RET
;==============================================================
send_bytes:
      CBI   PORTB, SS       ;enable slave device MAX7219
      OUT   SPDR, R17       ;transmit command
      ;--------------------------------------------------------
ll2:  IN    R19, SPSR
      SBRS  R19, SPIF       ;wait for byte transmission
      RJMP  ll2             ;to complete
      ;--------------------------------------------------------
      OUT   SPDR, R18       ;transmit data
      ;--------------------------------------------------------
ll3:  IN    R19, SPSR
      SBRS  R19, SPIF       ;wait for byte transmission
      RJMP  ll3             ;to complete
      ;--------------------------------------------------------
      SBI   PORTB, SS       ;disable slave device MAX7219
      RET

mytimer:
    ;-------------------------------------------------------
.EQU value, 12589         ;value to give 5 sec delay
  LDI   R20, hi8(value)
  STS   TCNT1H, R20
  LDI   R20, lo8(value)
  STS   TCNT1L, R20

  LDI   R20, 0b00000000
  STS   TCCR1A, R20
  LDI   R20, 0b00000101
  STS   TCCR1B, R20     ;normal mode, prescaler = 1024

loop2: 
  IN    R20, TIFR1
  SBRS  R20, TOV1
  RJMP  loop2

  LDI   R20, 1<<TOV1
  OUT   TIFR1, R20      ;clear TOV1 flag

  LDI   R20, 0b00000000
  STS   TCCR1B, R20     ;stop timer0
  RET