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
    // lda #PETSCII_CLEAR
    // jsr $FFD2

    backupVeraAddrInfo()

	addressRegister(0,VERA_PSG_VOICE00 + VERA_PSG_VOLUME_OFFSET,1,0)
    lda #VERA_PSG_STEREO_BOTH | %00111111
    sta VERADATA0

    lda #VERA_PSG_WAVEFORM_PULSE | $3F // All Other Sound Effects
    //lda #VERA_PSG_WAVEFORM_TRI | $00
    //lda #VERA_PSG_WAVEFORM_SAW | $00
    //lda #VERA_PSG_WAVEFORM_NOISE | $00 // Explosion Only
    sta VERADATA0

Looper:
    //jsr SetUpFloater
    //jsr SetUpSwoopers
    //jsr SetUpBuzzerDive
    //jsr SetUpPods
    //jsr SetUpBullet

    //jsr SetUpExplosion

SimIRQ:
    sec
    lda VoiceFreqFrac
    sbc VoiceFreqStepperFrac
    sta VoiceFreqFrac
    lda VoiceFreq
    sbc VoiceFreqStepper
    sta VoiceFreq
    lda VoiceFreq + 1
    sbc VoiceFreqStepper + 1
    sta VoiceFreq + 1

!ByPass:
    lda VoiceFreq + 1
    cmp VoiceFreqThreshold + 1
    beq !CheckLo+
    bcs !ByPassSwitchOffVoice+

!CheckLo:
    lda VoiceFreq
    cmp VoiceFreqThreshold
    bcs !ByPassSwitchOffVoice+

    wai

    jmp Looper

!ByPassSwitchOffVoice:
	addressRegister(0,VERA_PSG_VOICE00 + VERA_PSG_FREQLO_OFFSET,0,0)
	addressRegister(1,VERA_PSG_VOICE00 + VERA_PSG_FREQHI_OFFSET,0,0)
    lda VoiceFreq
    sta VERADATA0
    lda VoiceFreq + 1
    sta VERADATA1

    wai

    jmp SimIRQ


}

VoiceFreqFrac: .byte 0         // Fraction
VoiceFreq:  .word $0
VoiceFreqStepperFrac: .byte 0   // Fraction
VoiceFreqStepper: .word $0
VoiceFreqThreshold: .word $0


SetUpFloater:
{
    // C64 $026E -> $0149 | $0B
    // $0063 -> 0049 
    stz VoiceFreqFrac
    lda #<VERA_PSG_NOTE_D1
    sta VoiceFreq
    lda #>VERA_PSG_NOTE_D1
    sta VoiceFreq + 1

    lda #$90
    sta VoiceFreqStepperFrac
    lda #$02
    sta VoiceFreqStepper
    stz VoiceFreqStepper + 1

    lda #<VERA_PSG_NOTE_D0
    sta VoiceFreqThreshold
    lda #>VERA_PSG_NOTE_D0
    sta VoiceFreqThreshold + 1
    rts
}

SetUpSwoopers:
{
    // C64 $3DB2 -> $1258 | $01BB
    // $093A -> 02BE 
    stz VoiceFreqFrac
    lda #<VERA_PSG_NOTE_ASharp5
    sta VoiceFreq
    lda #>VERA_PSG_NOTE_ASharp5
    sta VoiceFreq + 1

    lda #$00
    sta VoiceFreqStepperFrac
    lda #$A2
    sta VoiceFreqStepper
    stz VoiceFreqStepper + 1

    lda #<VERA_PSG_NOTE_CSharp4
    sta VoiceFreqThreshold
    lda #>VERA_PSG_NOTE_CSharp4
    sta VoiceFreqThreshold + 1
    rts
}

SetUpBuzzerDive:
{
    // C64 $1ED9 -> $0454 | $00D0
    // $04E3 -> 00B0 
    stz VoiceFreqFrac
    lda #<VERA_PSG_NOTE_ASharp4
    sta VoiceFreq
    lda #>VERA_PSG_NOTE_ASharp4
    sta VoiceFreq + 1

    lda #$00
    sta VoiceFreqStepperFrac
    lda #$21
    sta VoiceFreqStepper
    stz VoiceFreqStepper + 1

    lda #<VERA_PSG_NOTE_C2
    sta VoiceFreqThreshold
    lda #>VERA_PSG_NOTE_C2
    sta VoiceFreqThreshold + 1
    rts
}

SetUpPods:
{
    // C64 $0CF8 -> $0747 | $016B
    // $020E -> 0127 
    stz VoiceFreqFrac
    lda #<VERA_PSG_NOTE_G3
    sta VoiceFreq
    lda #>VERA_PSG_NOTE_G3
    sta VoiceFreq + 1

    lda #$00
    sta VoiceFreqStepperFrac
    lda #$39
    sta VoiceFreqStepper
    stz VoiceFreqStepper + 1

    lda #<VERA_PSG_NOTE_A2
    sta VoiceFreqThreshold
    lda #>VERA_PSG_NOTE_A2
    sta VoiceFreqThreshold + 1
    rts
}

SetUpExplosion:
{
    // C64 $0F6C -> $024B | $0066
    // $0272 -> 005D 
    stz VoiceFreqFrac
    lda #<VERA_PSG_NOTE_ASharp3
    sta VoiceFreq
    lda #>VERA_PSG_NOTE_ASharp3
    sta VoiceFreq + 1

    lda #$00
    sta VoiceFreqStepperFrac
    lda #$10
    sta VoiceFreqStepper
    stz VoiceFreqStepper + 1

    lda #<VERA_PSG_NOTE_CSharp1
    sta VoiceFreqThreshold
    lda #>VERA_PSG_NOTE_CSharp1
    sta VoiceFreqThreshold + 1
    rts
}

SetUpBullet:
{
    // C64 $1ED9 -> $092C | $015A
    // $04E3 -> 0174 
    stz VoiceFreqFrac
    lda #<VERA_PSG_NOTE_ASharp4
    sta VoiceFreq
    lda #>VERA_PSG_NOTE_ASharp4
    sta VoiceFreq + 1

    lda #$00
    sta VoiceFreqStepperFrac
    lda #$36
    sta VoiceFreqStepper
    stz VoiceFreqStepper + 1

    lda #<VERA_PSG_NOTE_CSharp3
    sta VoiceFreqThreshold
    lda #>VERA_PSG_NOTE_CSharp3
    sta VoiceFreqThreshold + 1
    rts
}