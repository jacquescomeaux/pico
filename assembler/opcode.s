// choice encoding:

// end of choices
//      3  2  1  0
//   |-------------
// 0 | __ __ __ 00 
// 4 | __ __ __ __

// parse instruction
//      3  2  1  0
//   |-------------
// 0 | __ __ 00 AA      // AA == ascii char (non-zero)
// 4 | XX XX XX XX      // XX XX XX XX == parse instruction

// new choice offset
//      3  2  1  0
//   |-------------
// 0 | __ __ YY AA      // AA == ascii char (YY == non zero)
// 4 | XX XX XX XX      // XX XX == new address

.syntax unified
.cpu cortex-m0plus
.thumb

.type opcode, %function
.global opcode

// R4: start of choices, final result (parse instruction)
// R5: choice pointer
opcode:
  PUSH {LR}
  ADR R4, start     // start at the start
get_match:
  BL get_char
  MOV R5, R4        // reset choice pointer
  B first_time      // don't increment pointer on first time
next_choice:
  ADDS R5, 8        // increment choice pointer
first_time:
  LDRB R1, [R5]     // load char
  TST R1, R1        // test if char is zero
  BEQ get_match     // if run out of options, get a new char
  CMP R0, R1        // check if input matches char
  BNE next_choice   // if not match try next option
  BL uart_send      // echo char send if match
  LDR R4, [R5, 4]   // load parse instruction or offset
  LDRB R1, [R5, 1]  // load parse instruction vs offset byte
  TST R1, R1        // check if zero
  BNE get_match     // non-zero means it's an address
  POP {PC}          // zero means it's a parse instruction

.align 4

start:
  .byte 'A, 0x01 ; .hword 0x0000 ; .word A
  // .byte 'B, 0x00 ; .hword 0x0000 ; .word 0xE3E0AE88 // BICS (register)     T1  01000 01110 Rm Rdn
  // .byte 'C, 0x00 ; .hword 0x0000 ; .word 0xE3E0AB88 // CMN (register)      T1  01000 01011 Rm Rn
  // .byte 'D, 0x00 ; .hword 0x0000 ; .word 0x00C8E884 // MOVSI (immediate)   T1  00100 Rd imm8
  // .byte 'J, 0x00 ; .hword 0x0000 ; .word 0x00C8A09A // BEQ                 T1  11010 000 imm8
  // .byte 'L, 0x00 ; .hword 0x0000 ; .word 0xD5E3E08D // LDRI5 (immediate)   T1  01101 imm5 Rn Rt
  // .byte 'P, 0x00 ; .hword 0x0000 ; .word 0x0000B496 // PUSHLR              T1  10110 10100 000000
  // .byte 'R, 0x00 ; .hword 0x0000 ; .word 0xE3E0A788 // RORS (register)     T1  01000 00111 Rm Rdn
  // .byte 'S, 0x00 ; .hword 0x0000 ; .word 0xD5E3E08C // STRI5 (immediate)   T1  01100 imm5 Rn Rt
  // .byte 'T, 0x00 ; .hword 0x0000 ; .word 0xD5E3E080 // LSLSI (immediate)   T1  00000 imm5 Rm Rd
  .word 0x00000000, 0x00000000

A:
  .byte 'A, 0x01 ; .hword 0x0000 ; .word AA
  // .byte 'H, 0x01 ; .hword 0x0000 ; .word AH
  .byte 'M, 0x00 ; .hword 0x0000 ; .word 0xE3E0AD88 // MULS                T1  01000 01101 Rn Rdm
  .byte 'N, 0x00 ; .hword 0x0000 ; .word 0xE3E0A988 // NEG (immediate)     T1  01000 01001 Rn Rd
  // .byte 'S, 0x01 ; .hword 0x0000 ; .word AS
  .word 0x00000000, 0x00000000

AA:
  .byte 'A, 0x00 ; .hword 0x0000 ; .word 0x00C8E394 // ADR                 T1  10100 Rd imm8
  .byte 'C, 0x00 ; .hword 0x0000 ; .word 0xE3E0A588 // ADCS (register)     T1  01000 00101 Rm Rdn
  .byte 'I, 0x01 ; .hword 0x0000 ; .word AAI
  .byte 'R, 0x01 ; .hword 0x0000 ; .word AAR
  .word 0x00000000, 0x00000000

AAI:
  .byte '3, 0x00 ; .hword 0x0000 ; .word 0xD3E3E00E // ADDSI3 (immediate)  T1  0001110 imm3 Rn Rd
  .byte '8, 0x00 ; .hword 0x0000 ; .word 0x00C8E386 // ADDSI8 (immediate)  T2  00110 Rdn imm8
  .word 0x00000000, 0x00000000

AAR:
  .byte 'F, 0x00 ; .hword 0x0000 ; .word 0xE6E3E00C // ADDSR (register)    T1  0001100 Rm Rn Rd
  .byte 'H, 0x00 ; .hword 0x0000 ; .word 0xF3E0B288 // ADDRHI (register)   T2  010001001 Rm4 Rdn
  .byte 'L, 0x00 ; .hword 0x0000 ; .word 0xF3E0B088 // ADDRLO (register)   T2  010001000 Rm4 Rdn
  .word 0x00000000, 0x00000000

// ASC     SBCS (register)     T1  01000 00110 Rm Rdn    E3 E0 A6 88
// ASI3    SUBSI3 (immediate)  T1  0001111 imm3 Rn Rd    D3 E3 E0 0F
// ASI8    SUBSI8 (immediate)  T2  00111 Rdn imm8        00 C8 E8 87
// ASR     SUBSR (register)    T1  0001101 Rm Rn Rd      E6 E3 E0 0D

// AHI     SRSI (immediate)    T1  00010 imm5 Rm Rd      D5 E3 E0 82
// AHR     SRSR (register)     T1  01000 00100 Rm Rdn    E3 E0 A4 88

// Choice 2
// AH
// --I
// --R

// Choice 3
// AS
// --C
// --I
// --R

// Choice 6
// B 
// -A
// -C
// -I
// -O
// -T
// -X

// Choice 3
// C
// -I
// -N
// -R

// Choice 2
// CR
// --3
// --4

// Choice 2
// CR4
// ---H
// ---L

// Choice 4
// D
// -I
// -R
// -S
// -U

// Choice 3
// DR
// --F
// --H
// --L

// Choice 2
// DS
// --B
// --H

// Choice 2
// DU
// --B
// --H

// Choice 12
// J
// -A
// -E
// -G
// -H
// -I
// -L
// -M
// -N
// -P
// -R
// -S
// -V

// Choice 2
// JG
// --E
// --T

// Choice 2
// JH
// --I
// --S

// Choice 2
// JI
// --H
// --L

// Choice 5
// JL
// --E
// --O
// --R
// --S
// --T

// Choice 2
// JV
// --C
// --S

// Choice 6
// L
// -B
// -H
// -I
// -L
// -R
// -S

// Choice 2
// LB
// --I
// --R

// Choice 2
// LH
// --I
// --R

// Choice 2
// LI
// --5
// --8

// Choice 2
// LS
// --B
// --H

// Choice 2
// P
// -L
// -P

// Choice 2
// R
// -B
// -R

// Choice 3
// RB
// --H
// --S
// --W

// Choice 4
// S
// -B
// -H
// -I
// -R

// Choice 2
// SB
// --I
// --R

// Choice 2
// SH
// --I
// --R

// Choice 2
// SI
// --5
// --8

// Choice 2
// T
// -L
// -R

// Choice 2
// TL
// --I
// --R

// Choice 2
// TR
// --I
// --R
