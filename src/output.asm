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
    rts


clear_screen:
    ldx #0
!:  jsr $e9ff
    inx
    cpx #25
    bne !-
    rts
