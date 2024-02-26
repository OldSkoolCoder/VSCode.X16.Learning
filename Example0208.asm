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

Looper:
    jsr ReadKey
    wai
    jmp Looper

    restoreVeraAddrInfo()    
	rts
}

//----readKeys start---------------------------------------------
ReadKey:
{

//kernal routine to get character from keyboard
jsr CHRIN

//compare keys to valid commands
wkey:
cmp #UpKey //w PETSCII code
bne skey
dec VERA_L1_vscrollLow
bne !ByPass+
dec VERA_L1_vscrollHi
!ByPass:
rts

skey:
cmp #DownKey //s PETSCII code
bne akey
inc VERA_L1_vscrollLow
bne !ByPass+
inc VERA_L1_vscrollHi
!ByPass:
rts

akey:
cmp #LeftKey //a PETSCII code
bne dkey
dec VERA_L1_hscrollLow
bne !ByPass+
dec VERA_L1_hscrollHi
!ByPass:
rts

dkey:
cmp #RightKey //d PETSCII code
bne novalidkey
inc VERA_L1_hscrollLow
bne !ByPass+
inc VERA_L1_hscrollHi
!ByPass:
rts

StoreNewDirection:
novalidkey:
rts
//---readKeys End-------------------------------------------------
}
