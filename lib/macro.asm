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