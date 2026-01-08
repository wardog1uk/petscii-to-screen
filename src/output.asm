.const POINTER = $fb

// zp address for the first byte to display
.const POSITION = $02

// zp address for general usage
.const TEMP = $fd
.const TEMP2 = $fe

// key codes
.const ARROW_RIGHT = $1d
.const ARROW_LEFT = $9d
.const RETURN = $0d

.const TITLE_TEXT = "petscii to screen code"

TITLE:
    .text TITLE_TEXT
    .byte 0


*=* "Output"
output:
    lda #0
    sta POSITION

    jsr clear_screen

    // output header
    lda #40
    sta POINTER
    lda #$04
    sta POINTER+1

    ldy #(40-TITLE_TEXT.size())/2
    ldx #0

!:  lda TITLE,x
    beq output_loop
    sta (POINTER),y
    iny
    inx
    clc
    bcc !-


output_loop:
    // draw screen

    jsr output_data

    jsr output_controls

    // wait for input
!:  jsr $ffe4
    beq !-

    // process input
    cmp #ARROW_RIGHT
    bne !+
    lda POSITION
    clc
    adc #$20
    sta POSITION
    clc
    bcc output_loop

!:  cmp #ARROW_LEFT
    bne !+
    lda POSITION
    sec
    sbc #$20
    sta POSITION
    clc
    bcc output_loop

!:  cmp #RETURN
    bne output_loop

    jsr clear_screen

    // reset basic cursor
    ldy #0
    sty $d3
    sty $d6

    rts


clear_screen:
    ldx #0
!:  jsr $e9ff
    inx
    cpx #25
    bne !-
    rts


output_data:
    // copy position to temporary variables
    lda POSITION
    sta TEMP
    clc
    adc #$10
    sta TEMP2

    // point to first line
    lda #$c8
    sta POINTER
    lda #$04
    sta POINTER+1

    ldx #16

output_data_loop:
    // output first column byte
    ldy #9
    lda #'$'
    sta (POINTER),y
    iny
    lda TEMP
    jsr output_hex_byte
    iny

    lda #'$'
    sta (POINTER),y
    iny
    lda TEMP
    jsr convert_to_screen
    jsr output_value

    iny
    sta (POINTER),y
    inc TEMP

    // output second column byte
    ldy #22
    lda #'$'
    sta (POINTER),y
    iny
    lda TEMP2
    jsr output_hex_byte
    iny

    lda #'$'
    sta (POINTER),y
    iny
    lda TEMP2
    jsr convert_to_screen
    jsr output_value

    iny
    sta (POINTER),y
    inc TEMP2

    // move to next line
    lda POINTER
    clc
    adc #40
    bcc !+
    inc POINTER+1
!:  sta POINTER

    dex
    bne output_data_loop

    rts


output_controls:
    lda #$c0
    sta POINTER
    lda #$07
    sta POINTER+1

    // left arrow
    ldy #17
    lda #$3c
    sta (POINTER),y

    // number
    iny
    iny
    lda POSITION
    jsr output_hex_byte

    // right arrow
    iny
    lda #$3e
    sta (POINTER),y

    rts


output_value:
    // check if unprintable
    bcs !+
    jsr output_hex_byte
    rts

    // handle unprintable character
!:  lda #'x'
    sta (POINTER),y
    iny
    sta (POINTER),y
    iny
    lda #' '
    rts


// outputs hex byte to POINTER + y offset 
output_hex_byte:
    // save byte
    pha
    pha

    // shift high byte to low byte
    lsr
    lsr
    lsr
    lsr

    // output high byte
    jsr byte_to_char
    sta (POINTER),y
    iny

    // restore byte
    pla

    // output low byte
    jsr byte_to_char
    sta (POINTER),y
    iny

    pla

    rts


// convert low byte to screen code
byte_to_char:
    // mask off high byte
    and #$0f

    // add '0'
    ora #'0'

    // check if > 9
    cmp #'9'+1
    bcc !+

    // if > 9 then convert to 'a' to 'f' 
    sbc #'9'

!:  rts
