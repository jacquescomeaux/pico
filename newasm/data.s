.syntax unified
.cpu cortex-m0plus
.thumb

.global crlf, word, hword, byte, align, asciz, SP, LR, PC

crlf:     .asciz  "\r\n"
word:     .asciz  "word"
hword:    .asciz  "hword"
byte:     .asciz  "byte"
align:    .asciz  "align"
asciz:    .asciz  "asciz"
SP:       .asciz  "SP"
LR:       .asciz  "LR"
PC:       .asciz  "PC"
