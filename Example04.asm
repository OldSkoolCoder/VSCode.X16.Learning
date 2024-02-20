.cpu _65c02

BasicUpstart2(StartUp)

#import "lib/petscii.asm"

.label KERNAL_CHROUT = $FFD2

.encoding "petscii_mixed"

HelloWorldTXT:
    .byte PETSCII_CLEAR, PETSCII_WHITE
    .text "hello "
    .byte PETSCII_BROWN
    .text "world "
    .byte PETSCII_PURPLE
    .text "everyone"
    .byte 0

StartUp:
    ldy #0

Looper:
    lda HelloWorldTXT,y
    beq Exit
    jsr KERNAL_CHROUT
    iny
    jmp Looper

Exit:
    rts