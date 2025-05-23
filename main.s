.org $E000

LCD_CMD = $8000
LCD_DAT = $8001

;.define j $FF
;j = $FF

start:
    ; затримка для ініціалізації дисплею
    LDX #$FF
    LDY #$FF
   ; STA j
    JSR delay

    ; ініціалізація дисплея
    LDA #$38    ; 8-бітний режим, 2 рядки, шрифт 5х7
    STA LCD_CMD
    JSR lcd_busy

    LDA #$0C    ; увімкнути дисплей, вимкнути курсор, вимкнути блимання
    STA LCD_CMD
    JSR lcd_busy

    LDA #$06    ; переміщувати курсор при введенні
    STA LCD_CMD
    JSR lcd_busy

    LDA #$01    ; очистити дисплей
    STA LCD_CMD
    JSR lcd_busy

    LDA #$80    ; Перемістити курсор на початок екрану
    STA LCD_CMD
    JSR lcd_busy

    ; Виведемо якийсь текст на екран
    
msg:  .byte "Ready to work!", 0

    LDX #0
@next:
    LDA msg, X
    BEQ @done
    INX
    STA LCD_DAT
    JMP @next
@done:

@loop:
    JMP @loop

delay:
    TYA
@loop:
    TAY
@innerloop:
    DEY
    BNE @innerloop
    DEX
    BNE @loop
    RTS
  
lcd_busy:

@wait:
    LDA LCD_CMD
    AND #$80
    BNE @wait
    RTS

    .res $FFFA - *

    .word 0
    .word start
    .word 0
