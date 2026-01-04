.const POINTER = $fb

.const TITLE_TEXT = "petscii to screen code"

TITLE:
    .text TITLE_TEXT
    .byte 0


*=* "Output"
output:
    jsr clear_screen

    // output header
    lda #40
    sta POINTER
    lda #$04
    sta POINTER+1

    ldy #(40-TITLE_TEXT.size())/2
    ldx #0

!:  lda TITLE,x
    beq !+
    sta (POINTER),y
    iny
    inx
    clc
    bcc !-

!:
    // draw screen

    // output data

    jsr output_controls

    // wait for input
!:  jsr $ffe4
    beq !-

    // handle input

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
    lda #'x'
    ldy #19
    sta (POINTER),y
    iny
    sta (POINTER),y

    // right arrow
    lda #$3e
    ldy #22
    sta (POINTER),y

    rts
