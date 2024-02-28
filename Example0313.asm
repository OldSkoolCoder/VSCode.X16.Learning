.cpu _65c02

#import "lib/constants.asm"
#import "lib/petscii.asm"
#import "lib/macro.asm"
#import "lib/VERA_PSG_Constants.asm"

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

	addressRegister(0,VERA_PSG_VOICE00 + VERA_PSG_VOLUME_OFFSET,1,0)
    lda #VERA_PSG_STEREO_BOTH | %00111111
    sta VERADATA0

    lda #VERA_PSG_WAVEFORM_PULSE | $3F
    //lda #VERA_PSG_WAVEFORM_TRI | $00
    //lda #VERA_PSG_WAVEFORM_SAW | $00
    sta VERADATA0

	addressRegister(0,VERA_PSG_VOICE01 + VERA_PSG_VOLUME_OFFSET,1,0)
    lda #VERA_PSG_STEREO_BOTH | %00111111
    sta VERADATA0

    //lda #VERA_PSG_WAVEFORM_PULSE | $1F
    //lda #VERA_PSG_WAVEFORM_TRI | $1F
    //lda #VERA_PSG_WAVEFORM_SAW | $00
    lda #VERA_PSG_WAVEFORM_NOISE | $00
    sta VERADATA0

	addressRegister(0,VERA_PSG_VOICE00 + VERA_PSG_FREQLO_OFFSET,0,0)
	addressRegister(1,VERA_PSG_VOICE00 + VERA_PSG_FREQHI_OFFSET,0,0)

    lda #<VERA_PSG_NOTE_C2
    sta Voice0

    lda #>VERA_PSG_NOTE_C2
    sta Voice0 + 1 

Looper:
	addressRegister(0,VERA_PSG_VOICE00 + VERA_PSG_FREQLO_OFFSET,3,0)
	addressRegister(1,VERA_PSG_VOICE00 + VERA_PSG_FREQHI_OFFSET,3,0)

    lda Voice0
    sta VERADATA0
    sta VERADATA0

    lda Voice0 + 1
    sta VERADATA1
    sta VERADATA1


    wai
    //wai
    //wai

    inc Voice0
    bne Looper
    inc Voice0 + 1
    jmp Looper



    restoreVeraAddrInfo()    
	rts

Voice0: .word $0
}
