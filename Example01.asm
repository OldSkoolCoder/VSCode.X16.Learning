.cpu _65c02

BasicUpstart2(StartUp)

.label KERNAL_CHROUT = $FFD2

.encoding "petscii_mixed"

HelloWorldTXT:
    .byte 147
    .text "hello world everyone"
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