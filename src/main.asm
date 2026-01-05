BasicUpstart2(main)

jmp main

#import "petscii2screen.asm"
#import "output.asm"

*=* "Main"
main:
    jsr output
    rts
