.cpu _65c02

#import "lib/constants.asm"
#import "lib/macro.asm"

*=$0801
//    .byte $0b,$08,$01,$00,$9e,$32,$30,$36,$31,$00,$00,$00
	BasicUpstart2(main)

* = $080d

main: {

//	addressRegister(0,VRAMPalette,1)
// Poke 1024,y
	addressRegister(0,$1b000,1,0)


	ldy #79
!loop:
	lda #8
	sta DATA0
	dey
	
	bne !loop-

	rts
}

colour:
	.byte 0