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

    ldx #0
OuterLooper:
	ldy #0
!loop:
    tya
    and #%00000001
    // If Not Zero = Odd Number
    // else Even Number
    beq !ByPass+

    // Odd Number Code
    lda colour
    inc colour

    // .byte $2C       // BIT $0000
    bra !StoreData0+
!ByPass:
    lda #8

!StoreData0:
	sta VERADATA0
	dey
	
	bne !loop-

    inx
    cpx #10
    bne OuterLooper

	rts
}

colour:
	.byte 0