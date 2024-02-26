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
.label CHRIN  = $FFE4
.label CHROUT  = $FFD2
.label SCREEN  = $FFED

*=$0801
//    .byte $0b,$08,$01,$00,$9e,$32,$30,$36,$31,$00,$00,$00
	BasicUpstart2(main)

* = $080d
main: {
    lda #PETSCII_CLEAR
    jsr $FFD2

    backupVeraAddrInfo()

    setDCSel(0)

    lda #DCSCALEx2
    sta VERA_DC_hscale
    sta VERA_DC_vscale

	addressRegister(0,$1f000,1,0)

    ldy #$00
Looper:
    lda CharSet,y
    sta VERADATA0
    iny
    bne Looper

    restoreVeraAddrInfo()    
	rts
}

CharSet:
#import "MyriadC64cs.asm"
