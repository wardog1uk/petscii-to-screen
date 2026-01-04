.const POINTER = $fb

// zp address for the first byte to display
.const POSITION = $02

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

    // output data

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

    rts


clear_screen:
    ldx #0
!:  jsr $e9ff
    inx
    cpx #25
    bne !-
    rts


output_controls:
    lda #$c0
    sta POINTER
    lda #$07
    sta POINTER+1

    // left arrow
    lda #$3c
    ldy #17
    sta (POINTER),y

    // number
    lda POSITION
    ldy #19
    jsr output_byte

    // right arrow
    lda #$3e
    ldy #22
    sta (POINTER),y

    rts


// outputs hex byte to POINTER + y offset 
output_byte:
    // save byte
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
