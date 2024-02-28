.cpu _65c02

#import "../../lib/constants.asm"
#import "../../lib/petscii.asm"
#import "../../lib/macro.asm"

*=$0801
	BasicUpstart2(main)

main: {

    // make move bytes macro .
    // copy first to last first  then move 80 < (or 81<) - quicker for more than 1 chaar i think
    

// put some chars on screen for reference
    ldx #6
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

// put chars + colour on lines to scroll
    ldx #4
!loop1:
	ldy #$80
!loop2:
	sta VERADATA0
    lda colour
    inc colour
    sta VERADATA0
    dey
	bne !loop2-
    dex
    bne !loop1-

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
    lda #8
    sec
    sbc hscroll
    asl
    sta VERA_L1_hscrollLow

waitforline150:
    lda VERASCANLINE
    cmp #150
    bne waitforline150
    lda #8
    sec
    sbc hscroll
    sta VERA_L1_hscrollLow

waitforline158:
    lda VERASCANLINE
    cmp #158
    bne waitforline158

//reset Hscroll
    stz VERA_L1_hscrollLow

//test if we scrolled 8 pixels (could do 32 using only hscroll low but line copy would need more work and i'm lazy))
    lda hscroll
    cmp #8
    beq docopy
    jmp skiplinescroll

//    jmp CharLooper
docopy:
// Copy That line elsewhere (Only the Character)
 	addressRegister(0,$1c000,1,0)
 	//addressRegister(1,$1c000,1,0)
    lda VERADATA0
    sta FirstChar
    lda VERADATA0
    sta FirstColour
    copyVERAData($1c002,$1c000,160)
    lda FirstChar
    sta VERADATA1
    lda FirstColour
    sta VERADATA1

 	addressRegister(0,$1c100,1,0)
 	lda VERADATA0
    sta FirstChar
    lda VERADATA0
    sta FirstColour
    lda VERADATA0
    sta SecondChar
    lda VERADATA0
    sta SecondColour
    copyVERAData($1c104,$1c100,160)
    lda FirstChar
    sta VERADATA1
    lda FirstColour
    sta VERADATA1
    lda SecondChar
    sta VERADATA1
    lda SecondColour
    sta VERADATA1

 	addressRegister(0,$1c2a0,1,0)
 	lda VERADATA0
    sta FirstChar
    lda VERADATA0
    sta FirstColour
    lda VERADATA0
    sta SecondChar
    lda VERADATA0
    sta SecondColour
    copyVERAData($1c200,$1c204,160)
    lda FirstChar
    sta VERADATA1
    lda FirstColour
    sta VERADATA1
    lda SecondChar
    sta VERADATA1
    lda SecondColour
    sta VERADATA1

 	addressRegister(0,$1c3a0,1,0)
 	lda VERADATA0
    sta FirstChar
    lda VERADATA0
    sta FirstColour
    copyVERAData($1c300,$1c302,160)
    //addressRegister(0,$1c2a0,1,0)
    lda FirstChar
    sta VERADATA1
    lda FirstColour
    sta VERADATA1
    



//reset hscroll
    stz hscroll

skiplinescroll:
    wai
    jmp CharLooper
//we never get here 
    restoreVeraAddrInfo()    
	rts
}

//data storage
colour:	.byte 0
hscroll: .byte 0
FirstChar: .byte 0
FirstColour: .byte 0
SecondChar: .byte 0
SecondColour: .byte 0
