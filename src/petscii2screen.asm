*=* "petscii2screen.asm"

// --------------------------------------------------------
// Convert A from petscii to screen code
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

    // else set to 0 and return
    lda #0
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
    // remove top bit to subtract 128
    and #%01111111

    // check if it was 255
    cmp #127
    bne !+

    // was 255 (pi) so make it the correct screen character
    lda #94

!:
    rts
// --------------------------------------------------------
