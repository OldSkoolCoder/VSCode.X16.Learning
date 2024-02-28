// Constants file

// VERA
.const VERAAddrLow       = $9F20
.const VERAAddrHigh      = $9F21
.const VERAAddrBank      = $9F22
.const VERADATA0         = $9F23
.const VERADATA1         = $9F24
.const VERACTRL	         = $9F25
.const VERASCANLINE       = $9F28
.const VERA_DC_video     = $9F29
.const VERA_DC_hscale    = $9F2A
.const VERA_DC_vscale    = $9F2B
.const VERA_DC_border    = $9F2C
.const VERA_DC_hstart    = $9F29
.const VERA_DC_hstop     = $9F2A
.const VERA_DC_vstart    = $9F2B
.const VERA_DC_vstop     = $9F2C

.const VERA_L0_config    = $9F2D
.const VERA_L0_mapbase   = $9F2E
.const VERA_L0_tilebase  = $9F2F
.const VERA_L1_config    = $9F34
.const VERA_L1_mapbase   = $9F35
.const VERA_L1_tilebase  = $9F36
.const VERA_L1_hscrollLow= $9F37
.const VERA_L1_hscrollHi = $9F38
.const VERA_L1_vscrollLow= $9F39
.const VERA_L1_vscrollHi = $9F3A

// VRAM Addresses
.const VRAM_layer1_map   = $1B000
.const VRAM_layer0_map   = $00000
.const VRAM_lowerchars   = $0B000
.const VRAM_lower_rev    = VRAM_lowerchars + 128*8
.const VRAM_petscii      = $1F000
.const VRAMPalette      = $1FA00

// ROM Banks
.const ROM_BANK          = $01
.const BASIC_BANK        = 4
.const CHARSET_BANK      = 6

//DCSCALE Factors
.const DCSCALEx1 = $80
.const DCSCALEx2 = $40
.const DCSCALEx4 = $20
.const DCSCALEx8 = $10
.const DCSCALEx16 = $08
.const DCSCALEx32 = $04
.const DCSCALEx64 = $02
.const DCSCALEx128 = $01
