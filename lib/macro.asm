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
    lda VERACTRL
    sta veraAddr
    lda VERAAddrLow
    sta veraAddr + 1
    lda VERAAddrHigh
    sta veraAddr + 2
    lda VERAAddrBank
    sta veraAddr + 3
}

.macro restoreVeraAddrInfo()
{
    lda veraAddr
    sta VERACTRL
    lda veraAddr + 1
    sta VERAAddrLow
    lda veraAddr + 2
    sta VERAAddrHigh
    sta veraAddr + 3
    lda VERAAddrBank
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
