// macro files

.macro addressRegister(control,address,increment,direction) {
	
	.if (control == 0){
        // CTRL Bit 0 Controls which Data Byte to use,
        // either DATA0 or DATA1 respectively

        // using DATA0
        lda VERACTRL
        and %11111110
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