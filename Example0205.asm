.cpu _65c02

#import "lib/constants.asm"
#import "lib/macro.asm"

*=$0801
//    .byte $0b,$08,$01,$00,$9e,$32,$30,$36,$31,$00,$00,$00
	BasicUpstart2(main)

* = $080d

main: {
    backupVeraAddrInfo()

//	addressRegister(0,VRAMPalette,1)
// Poke 1024,y
	addressRegister(0,$1b000,1,0)

// Setting up line of H's
	ldy #80
!loop:
	lda #8
	sta VERADATA0
	dey
	bne !loop-

// Copy That line elsewhere (Only the Character)
	addressRegister(0,$1b000,2,0)
	addressRegister(1,$1b600,2,0)

// Setting up line of H's
	ldy #40
!loop:
	lda VERADATA0
	sta VERADATA1
	dey
	bne !loop-

    restoreVeraAddrInfo()    
	rts
}

colour:
	.byte 0