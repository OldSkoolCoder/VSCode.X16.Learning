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

.label keyW = $57
.label keyS = $53
.label keyX = $58
.label keyE = $45
.label keyD = $44
.label keyC = $43
.label keyR = $52
.label keyF = $46
.label keyV = $56
.label keyT = $54
.label keyG = $47
.label keyB = $42

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
    lda #VERA_PSG_WAVEFORM_TRI | $1F
    //lda #VERA_PSG_WAVEFORM_SAW | $00
    //lda #VERA_PSG_WAVEFORM_NOISE | $00
    sta VERADATA0

	addressRegister(0,VERA_PSG_VOICE02 + VERA_PSG_VOLUME_OFFSET,1,0)
    lda #VERA_PSG_STEREO_BOTH | %00111111
    sta VERADATA0

    //lda #VERA_PSG_WAVEFORM_PULSE | $1F
    //lda #VERA_PSG_WAVEFORM_TRI | $1F
    lda #VERA_PSG_WAVEFORM_SAW | $00
    //lda #VERA_PSG_WAVEFORM_NOISE | $00
    sta VERADATA0

	addressRegister(0,VERA_PSG_VOICE03 + VERA_PSG_VOLUME_OFFSET,1,0)
    lda #VERA_PSG_STEREO_BOTH | %00111111
    sta VERADATA0

    //lda #VERA_PSG_WAVEFORM_PULSE | $1F
    //lda #VERA_PSG_WAVEFORM_TRI | $1F
    //lda #VERA_PSG_WAVEFORM_SAW | $00
    lda #VERA_PSG_WAVEFORM_NOISE | $00
    sta VERADATA0

    lda #<VERA_PSG_NOTE_C4
    sta Voice0
    sta Voice1
    sta Voice2
    sta Voice3

    lda #>VERA_PSG_NOTE_C4
    sta Voice0 + 1 
    sta Voice1 + 1
    sta Voice2 + 1
    sta Voice3 + 1

Looper:
    jsr CHRIN

    // Voice 0 Controls
    cmp #keyW
    bne !+

    dec Voice0
    bne !ByPass+
    dec Voice0 + 1
!ByPass:
    jmp SetVoice00

!:
    cmp #keyS
    bne !+

    inc Voice0
    bne !ByPass+
    inc Voice0 + 1
!ByPass:
    jmp SetVoice00

!:
    cmp #keyX
    bne !+
	addressRegister(0,VERA_PSG_VOICE00 + VERA_PSG_VOLUME_OFFSET,0,0)
    //lda #VERA_PSG_STEREO_BOTH | %00111111
    lda VERADATA0
    eor #%00111111
    sta VERADATA0
    jmp Wait
!:
    // Voice 1 Controls
    cmp #keyE
    bne !+

    dec Voice1
    bne !ByPass+
    dec Voice1 + 1
!ByPass:
    jmp SetVoice01

!:
    cmp #keyD
    bne !+

    inc Voice1
    bne !ByPass+
    inc Voice1 + 1
!ByPass:
    jmp SetVoice01

!:
    cmp #keyC
    bne !+
	addressRegister(0,VERA_PSG_VOICE01 + VERA_PSG_VOLUME_OFFSET,0,0)
    //lda #VERA_PSG_STEREO_BOTH | %00111111
    lda VERADATA0
    eor #%00111111
    sta VERADATA0
    jmp Wait

!:
    // Voice 2 Controls
    cmp #keyR
    bne !+

    dec Voice2
    bne !ByPass+
    dec Voice2 + 1
!ByPass:
    jmp SetVoice02

!:
    cmp #keyF
    bne !+

    inc Voice2
    bne !ByPass+
    inc Voice2 + 1
!ByPass:
    jmp SetVoice02

!:
    cmp #keyV
    bne !+
	addressRegister(0,VERA_PSG_VOICE02 + VERA_PSG_VOLUME_OFFSET,0,0)
    //lda #VERA_PSG_STEREO_BOTH | %00111111
    lda VERADATA0
    eor #%00111111
    sta VERADATA0
    jmp Wait

!:
    // Voice 3 Controls
    cmp #keyT
    bne !+

    dec Voice3
    bne !ByPass+
    dec Voice3 + 1
!ByPass:
    jmp SetVoice03

!:
    cmp #keyG
    bne !+

    inc Voice3
    bne !ByPass+
    inc Voice3 + 1
!ByPass:
    jmp SetVoice03

!:
    cmp #keyB
    bne !+
	addressRegister(0,VERA_PSG_VOICE03 + VERA_PSG_VOLUME_OFFSET,0,0)
    //lda #VERA_PSG_STEREO_BOTH | %00111111
    lda VERADATA0
    eor #%00111111
    sta VERADATA0
    jmp Wait

!:

Wait:
    wai
    //wai
    //wai

    jmp Looper



    restoreVeraAddrInfo()    
	rts
}
KeyStroke: .byte $0

Voice0: .word $0
Voice1: .word $0
Voice2: .word $0
Voice3: .word $0

SetVoice00:{
	addressRegister(0,VERA_PSG_VOICE00 + VERA_PSG_FREQLO_OFFSET,0,0)
	addressRegister(1,VERA_PSG_VOICE00 + VERA_PSG_FREQHI_OFFSET,0,0)
    lda Voice0
    sta VERADATA0
    lda Voice0 + 1
    sta VERADATA1
    jmp main.Wait
}

SetVoice01:{
	addressRegister(0,VERA_PSG_VOICE01 + VERA_PSG_FREQLO_OFFSET,0,0)
	addressRegister(1,VERA_PSG_VOICE01 + VERA_PSG_FREQHI_OFFSET,0,0)
    lda Voice1
    sta VERADATA0
    lda Voice1 + 1
    sta VERADATA1
    jmp main.Wait
}

SetVoice02:{
	addressRegister(0,VERA_PSG_VOICE02 + VERA_PSG_FREQLO_OFFSET,0,0)
	addressRegister(1,VERA_PSG_VOICE02 + VERA_PSG_FREQHI_OFFSET,0,0)
    lda Voice2
    sta VERADATA0
    lda Voice2 + 1
    sta VERADATA1
    jmp main.Wait
}

SetVoice03:{
	addressRegister(0,VERA_PSG_VOICE03 + VERA_PSG_FREQLO_OFFSET,0,0)
	addressRegister(1,VERA_PSG_VOICE03 + VERA_PSG_FREQHI_OFFSET,0,0)
    lda Voice3
    sta VERADATA0
    lda Voice3 + 1
    sta VERADATA1
    jmp main.Wait
}
