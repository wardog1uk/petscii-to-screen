*=* "Output"

output:
    ldx #0

    .var list = List().add(255, 'H', 'I', '!', 115, 160, 176, 99, 99, 99, 174)
    .var n = 0
    .while(n < list.size()) {
        lda #list.get(n)
        jsr process
        .eval n++
    }

    rts


process:
    jsr convert_to_screen
    sta $0400,x
    inx
    rts
