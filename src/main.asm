BasicUpstart2(main)

jmp main

#import "petscii2screen.asm"

main:
    lda #88
    jsr convert_to_screen
    sta $0400
    rts
