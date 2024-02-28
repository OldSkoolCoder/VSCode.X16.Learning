.cpu _65c02

#import "../../lib/constants.asm"
#import "../../lib/petscii.asm"
#import "../../lib/macro.asm"

*=$0801
	BasicUpstart2(main)

main: {

// put some chars on screen for reference
    ldx #4
l0:
    lda #47
    sta FirstChar
    ldy #80
l1:
    inc FirstChar
    lda FirstChar
    jsr $FFD2
    dey
    bne l1
    dex
    bne l0
    backupVeraAddrInfo()

	addressRegister(0,$1c000,1,0)

// put chars + colour on line to scroll
	ldy #$80
!loop:
	sta VERADATA0
    lda colour
    inc colour
    sta VERADATA0
    dey
	bne !loop-


// put chars + colour on line to scroll
	ldy #$80
!loop:
	sta VERADATA0
    lda colour
    inc colour
    sta VERADATA0
    dey
	bne !loop-

CharLooper:

waitforline126:
    lda VERASCANLINE
    cmp #126
    bne waitforline126

    inc hscroll
    lda hscroll
    sta VERA_L1_hscrollLow

waitforline134:
    lda VERASCANLINE
    cmp #134
    bne waitforline134

    lda hscroll
    asl
    sta VERA_L1_hscrollLow

waitforline142:
    lda VERASCANLINE
    cmp #142
    bne waitforline142

//reset Hscroll
    stz VERA_L1_hscrollLow

//test if we scrolled 8 pixels (could do 32 using only hscroll low but line copy would need more work and i'm lazy))
    lda hscroll
    cmp #8
    bne skiplinescroll

//    jmp CharLooper
docopy:
// Copy That line elsewhere (Only the Character)
 	addressRegister(0,$1c000,1,0)
 	addressRegister(1,$1c000,1,0)
    jsr scroll1line

//do second line but twice
    ldx #2
line2scroll:
 	addressRegister(0,$1c100,1,0)
 	addressRegister(1,$1c100,1,0)
    jsr scroll1line
    dex
    bne line2scroll
//reset hscroll
    stz hscroll

skiplinescroll:
    wai
    jmp CharLooper
//we never get here 
    restoreVeraAddrInfo()    
	rts
}

scroll1line:
    lda VERADATA0
    sta FirstChar
    lda VERADATA0
    sta FirstColour
 	ldy #160
!lineshift:
 	lda VERADATA0
 	sta VERADATA1
 	dey
 	bne !lineshift-
//put first char back on end of line
    lda FirstChar
    sta VERADATA1
    lda FirstColour
    sta VERADATA1
    rts
//data storage
colour:	.byte 0
hscroll: .byte 0
FirstChar: .byte 0
FirstColour: .byte 0
