.cpu _65c02

#import "lib/constants.asm"
#import "lib/petscii.asm"
#import "lib/macro.asm"

*=$0801
//    .byte $0b,$08,$01,$00,$9e,$32,$30,$36,$31,$00,$00,$00
	BasicUpstart2(main)

* = $080d

main: {
    addressRegister(0,$1FA00,1,0)

    stz Counter
    stz Counter + 1
Looper:
    setDCSel(0)
    lda VERADATA0
    sta X16RGB
    lda VERADATA0
    sta X16RGB + 1

    and #%00001111
    sta RGBData     // Red

    lda X16RGB
    and #%00001111
    sta RGBData + 2     // Blue

    lda X16RGB
    lsr
    lsr
    lsr
    lsr
    sta RGBData + 1     // green

    backupVeraAddrInfo()
    // Print Red First
    lda #34
    jsr $FFD2
    lda #'#'
    jsr $FFD2
    lda RGBData
    jsr convertToHEX
    jsr $FFD2
    jsr $FFD2

    lda RGBData + 1
    jsr convertToHEX
    jsr $FFD2
    jsr $FFD2

    lda RGBData + 2
    jsr convertToHEX
    jsr $FFD2
    jsr $FFD2

    lda #34
    jsr $FFD2
    lda #','
    jsr $FFD2

    setDCSel(0)
    restoreVeraAddrInfo()

    inc Counter
    bne !ByPass+
    inc Counter + 1

!ByPass:
    lda Counter + 1
    cmp #1
    beq !exit+
    jmp Looper
!exit:
    rts
}

convertToHTML:
{
    sta AddSelf
    asl
    asl
    asl
    asl
    clc
    ora AddSelf: #00
    rts
}

convertToHEX:
{
    clc
    adc #48
    cmp #58
    bcs !Alpha+
    rts

!Alpha:
    clc
    adc #7
    rts
}

Counter: .byte 0,0
X16RGB: .byte 0,0
RGBData: .byte 0,0,0