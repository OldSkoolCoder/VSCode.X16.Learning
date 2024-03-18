// macro files

veraAddr: .byte 0,0,0,0

.macro addressRegister(control,address,increment,direction) {
	
	.if (control == 0){
        // CTRL Bit 0 Controls which Data Byte to use,
        // either DATA0 or DATA1 respectively

        // using DATA0
        lda VERACTRL
        and #%11111110
		sta VERACTRL
	} else {
        // using DATA1
        lda VERACTRL
		ora #$01
		sta VERACTRL
	}

	lda #address
	sta VERAAddrLow

	lda #address>>8
	sta VERAAddrHigh
	
	lda #(increment<<4 ) | address>>16 | direction<<3
	sta VERAAddrBank

}

.macro resetVera() {
	
    lda #$80
    sta VERACTRL
}

.macro backupVeraAddrInfo()
{
    lda VERAAddrLow
    //sta veraAddr + 1
    pha
    lda VERAAddrHigh
    //sta veraAddr + 2
    pha
    lda VERAAddrBank
    //sta veraAddr + 3
    pha
    lda VERACTRL
    //sta veraAddr
    pha
}

.macro restoreVeraAddrInfo()
{
    pla
    //lda veraAddr
    sta VERACTRL
    pla
    //lda veraAddr + 3
    sta VERAAddrBank
    pla
    //lda veraAddr + 2
    sta VERAAddrHigh
    pla
    //lda veraAddr + 1
    sta VERAAddrLow
}

.macro backupVERAForIRQ()
{
    backupVeraAddrInfo()
    eor #%00000001
    sta VERACTRL
    backupVeraAddrInfo()
}

.macro restoreVERAForIRQ()
{
    restoreVeraAddrInfo()
    restoreVeraAddrInfo()
}

.macro setDCSel(dcSel)
 {
    lda VERACTRL
    and #%10000001
    ora #dcSel<<1
    sta VERACTRL
 }

 .macro copyVERAData(source,destination,bytecount)
{
    // source greater than dest - regular copy
    .if (source > destination) {
    addressRegister(0,source,1,0)
    addressRegister(1,destination,1,0)
    } else {
    // source below dest - do backwards starting at end
    addressRegister(0,source + bytecount-2,1,1)
    addressRegister(1,destination+bytecount-2,1,1)
    }
    ldy #bytecount
copyloop:
    lda VERADATA0
 	sta VERADATA1
 	dey
 	bne copyloop
}

.macro copyDataToVera(source,destination,bytecount) 
// source is x16 memory . dest is vera location, bytecount max 65535
// destroys a
{
    addressRegister(0,destination,1,0)
    lda counter: $deaf
    lda #bytecount & $ff
    sta counter
    lda #(bytecount >> 8) & $ff
    sta counter+1
    lda #source & $ff
    sta copyFrom
    lda #(source >>8) & $ff
    sta copyFrom + 1

    loop:
    lda copyFrom: $deaf
    sta VERADATA0
    inc copyFrom
    bne skip1
    inc copyFrom+1
skip1:
    dec counter
    bne loop
    dec counter+1
    bpl loop
}

.macro setUpSpriteInVera(SpriteNumber, SpriteAddress, Mode, XPos, YPos, ZDepth, Height, Width, PalletOffset)
{
    lda #<(SpriteNumber<<3)
	sta VERAAddrLow

    lda #>(SpriteNumber<<3)
    clc
    adc #>(SPRITEREGBASE-$10000)
	sta VERAAddrHigh

	lda #%00010001
	sta VERAAddrBank

    // using DATA0
    lda VERACTRL
    and #%11111110
    sta VERACTRL

    lda #<(SpriteAddress>>5)
    sta VERADATA0
    lda #>(SpriteAddress>>5) | Mode
    sta VERADATA0

    lda #<XPos
    sta VERADATA0
    lda #>XPos
    sta VERADATA0

    lda #<YPos
    sta VERADATA0
    lda #>YPos
    sta VERADATA0

    lda #ZDepth
    sta VERADATA0

    lda #Height | Width | PalletOffset
    sta VERADATA0

}

.macro moveSpriteInVera(SpriteNumber, XPosAddr, YPosAddr)
{
    lda #<(SpriteNumber<<3)+ SPRITE_POSITION_X_LO_OFFSET
	sta VERAAddrLow

    lda #>(SpriteNumber<<3)
    clc
    adc #>(SPRITEREGBASE-$10000)
	sta VERAAddrHigh

	lda #%00010001
	sta VERAAddrBank

    // using DATA0
    lda VERACTRL
    and #%11111110
    sta VERACTRL

    lda XPosAddr
    sta VERADATA0
    lda XPosAddr+1
    sta VERADATA0

    lda YPosAddr
    sta VERADATA0
    lda YPosAddr + 1
    sta VERADATA0

}

.macro setSpriteAddressInVera(SpriteNumber, SpriteAddress, Mode)
{
    lda #<(SpriteNumber<<3)
	sta VERAAddrLow

    lda #>(SpriteNumber<<3)
    clc
    adc #>(SPRITEREGBASE-$10000)
	sta VERAAddrHigh

	lda #%00010001
	sta VERAAddrBank

    // using DATA0
    lda VERACTRL
    and #%11111110
    sta VERACTRL

    lda #<(SpriteAddress>>5)
    sta VERADATA0
    lda #>(SpriteAddress>>5) | Mode
    sta VERADATA0

}

