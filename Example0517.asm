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
.const SpriteMemoryAddr = $13000

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

    // lda VERA_DC_video
    // ora #GLOBAL_SPRITE_ENABLE_ON
    // sta VERA_DC_video

    lda #GLOBAL_SPRITE_ENABLE_ON
    tsb VERA_DC_video

    copyDataToVera(SpriteData,SpriteMemoryAddr,_SpriteData-SpriteData)

    setUpSpriteInVera(0,SpriteMemoryAddr + 512,SPRITE_MODE_16_COLOUR,256,256,SPRITE_ZDEPTH_AFTERLAYER1,SPRITE_HEIGHT_16PX, SPRITE_WIDTH_16PX, 0)

    lda #01
    sta YPos+1
    stz XPos
    stz Frame
Looper:
    inc XPos
    bne !ByPass+
    lda XPos + 1
    clc
    adc #1
    and #%00000011
    sta XPos + 1

!ByPass:
    moveSpriteInVera(0, XPos, YPos)

    lda Frame
    clc
    adc #1
    and #%00001111
    sta Frame
    and #%00001000
    beq !ByPass+
    setSpriteAddressInVera(0, SpriteMemoryAddr + 512+128, SPRITE_MODE_16_COLOUR)
    jmp Raster
!ByPass:
    setSpriteAddressInVera(0, SpriteMemoryAddr + 512, SPRITE_MODE_16_COLOUR)

Raster:
    wai
    jmp Looper
    restoreVeraAddrInfo() 
	rts
}

XPos:   .word 0
YPos:   .word 0
Frame:  .byte 0

*=$3000
SpriteData:
.import binary "Coders\\Sorcerer\\invaders.SPR"
_SpriteData:

