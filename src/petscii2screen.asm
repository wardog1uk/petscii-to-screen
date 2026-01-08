*=* "petscii2screen.asm"

// --------------------------------------------------------
// Convert A from petscii to screen code
// clears carry if converted, sets carry if unprintable
convert_to_screen:
    // check if shifted (128 to 255)
    cmp #128
    bcs convert_shifted
// --------------------------------------------------------


// --------------------------------------------------------
// Convert petscii codes 0 to 127 to screen code
convert_unshifted:
    // check if printable (>31)
    cmp #32

    // branch if printable
    bcs convert_unshifted_printable

    // else set carry and return
    sec
    rts


// Convert petscii codes 32 to 127 to screen code
convert_unshifted_printable:
    cmp #96

    // branch if < 96
    bcc convert_unshifted_characters


// Convert petscii codes 96 to 127 to screen code
convert_unshifted_symbols:
    // subtract 32 and return
    and #%11011111  // $df
    clc
    rts


// Convert petscii codes 32 to 95 to screen code
convert_unshifted_characters:
    // subtract 64 from 64 to 95 (32 to 63 are unchanged)
    and #%00111111  // $3f
    rts
// --------------------------------------------------------


// --------------------------------------------------------
// Convert petscii codes 128 to 255 to screen code
convert_shifted:
    // check if printable (>159)
    cmp #160

    // branch if printable
    bcs convert_shifted_printable

    // else set carry and return
    sec
    rts


// Convert petscii codes 160 to 255 to screen code
convert_shifted_printable:
    // check if it is 255 (pi)
    cmp #255
    bne !+

    // was 255 so make it the correct screen value
    lda #94
    clc
    rts

!:  // remove top bit to subtract 128
    and #%01111111

    // is 32 to 127 (was 160 to 254)
    // return if >= 64 (was 192)
    cmp #64
    bcs !+

    // else add 64 to 32 to 63 (was 160 to 191)
    ora #%01000000

!:  clc
    rts
// --------------------------------------------------------
