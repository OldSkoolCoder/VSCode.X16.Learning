.cpu _65c02

#import "lib/constants.asm"
#import "lib/petscii.asm"
#import "lib/macro.asm"

*=$0801
//    .byte $0b,$08,$01,$00,$9e,$32,$30,$36,$31,$00,$00,$00
	BasicUpstart2(main)

* = $080d

FirstChar: .byte 0

main: {
    lda #PETSCII_CLEAR
    jsr $FFD2

    backupVeraAddrInfo()

//	addressRegister(0,VRAMPalette,1)
// Poke 1024,y
	addressRegister(0,$1b000,2,0)

// Setting up line of H's
	ldy #80
!loop:
	tya
	sta VERADATA0
	dey
	bne !loop-

CharLooper:
// Copy That line elsewhere (Only the Character)
	addressRegister(0,$1b000,2,0)
	addressRegister(1,$1b000,2,0)

    lda VERADATA0
    sta FirstChar
// Setting up line of H's
	ldy #80
!loop:
	lda VERADATA0
	sta VERADATA1
	dey
	bne !loop-

    lda FirstChar
    sta VERADATA1

    wai
    jmp CharLooper

    restoreVeraAddrInfo()    
	rts
}

colour:
	.byte 0