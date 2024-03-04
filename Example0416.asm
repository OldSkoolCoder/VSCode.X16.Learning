.cpu _65c02

#import "lib/constants.asm"
#import "lib/petscii.asm"
#import "lib/macro.asm"

//key mapping
.label UpKey  = $57
.label DownKey  = $53
.label LeftKey  = $41
.label RightKey =  $44
.label ExitKey =  $58
.label StartKey  = $53

.const SCREENHI_OFFSET = $B0

//kernel routine to get keyboard character and Print character
// .label CHRIN  = $FFE4
// .label CHROUT  = $FFD2
// .label SCREEN  = $FFED

*=$0801
//    .byte $0b,$08,$01,$00,$9e,$32,$30,$36,$31,$00,$00,$00
	BasicUpstart2(main)

* = $080d
main: {
    lda #PETSCII_CLEAR
    jsr CHROUT

    backupVeraAddrInfo()

    // Joystick Get Results
    // Acc: | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
    //  SNES| B | Y |SEL|STA| UP|DN |LFT|RGT|
    // X:
    //  SNES| A | X |LSB|RSB| 1 | 1 | 1 | 1 |
    // Y:
    //      $00 = Joystick Present, $FF = Not
    // Default State of Bits = 1; inverted 0 = Pressed

Looper:
    lda #CONTROLLER_KBD
    jsr JOYSTICK_GET

    jsr BinaryOutput

    phy
    phx

    lda #PETSCII_SPACE
    jsr CHROUT

    pla
    jsr BinaryOutput

    lda #PETSCII_SPACE
    jsr CHROUT

    pla
    jsr BinaryOutput

    lda #PETSCII_RETURN
    jsr CHROUT

    lda #PETSCII_CUR_UP
    jsr CHROUT

    restoreVeraAddrInfo() 

    jmp Looper   
	rts
}

BinaryOutput:
{
    phx
    phy
    sta Temp

    ldy #0
!Looper:
    asl Temp
    lda #$00
    adc #$30
    jsr CHROUT
    iny
    cpy #8
    bne !Looper-

    ply
    plx

    rts
}
Temp: .byte 0
