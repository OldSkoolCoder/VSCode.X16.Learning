// Constants file

// VERA
.const VERAAddrLow       = $9F20
.const VERAAddrHigh      = $9F21
.const VERAAddrBank      = $9F22
.const VERADATA0         = $9F23
.const VERADATA1         = $9F24
.const VERACTRL	         = $9F25
.const VERA_dc_video     = $9F29
.const VERA_dc_hscale    = $9F2A
.const VERA_dc_vscale    = $9F2B
.const VERA_L0_config    = $9F2D
.const VERA_L0_mapbase   = $9F2E
.const VERA_L0_tilebase  = $9F2F
.const VERA_L1_config    = $9F34
.const VERA_L1_mapbase   = $9F35
.const VERA_L1_tilebase  = $9F36

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