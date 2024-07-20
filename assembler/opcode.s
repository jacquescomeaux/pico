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
opcode: PUSH    {LR}
        ADR     R4, start     // start at the start
10:     BLX     R10
        MOV     R5, R4        // reset choice pointer
        B       30f           // don't increment pointer on first time
20:     ADDS    R5, 8         // increment choice pointer
30:     LDRB    R1, [R5]      // load char
        TST     R1, R1        // test if char is zero
        BEQ     10b           // if run out of options, get a new char
        CMP     R0, R1        // check if input matches char
        BNE     20b           // if not match try next option
        BLX     R9            // echo char send if match
        LDRB    R1, [R5, 2]   // load set end char byte
        TST     R1, R1        // test value
        BEQ     40f           // if zero skip set end char
        LDRB    R1, [R5, 3]   // load new end char
        MOV     R8, R1        // set new end char
40:     LDR     R4, [R5, 4]   // load parse instruction or offset
        LDRB    R1, [R5, 1]   // load parse instruction vs offset byte
        TST     R1, R1        // check if zero
        BNE     10b           // non-zero means it's an address
50:     BLX     R10
        BNE     50b
        POP     {PC}          // zero means it's a parse instruction

.align 4

start:
  .byte 'A, 0x01 ; .hword 0x0000 ; .word A
  .byte 'B, 0x01 ; .hword 0x0000 ; .word B
  .byte 'C, 0x01 ; .hword 0x0000 ; .word C
  .byte 'D, 0x01 ; .hword 0x0000 ; .word D
  .byte 'J, 0x01 ; .hword 0x0000 ; .word J
  .byte 'L, 0x01 ; .hword 0x0000 ; .word L
  .byte 'P, 0x01 , 0x01, '\r     ; .word P
  .byte 'Q, 0x00 ; .hword 0x0000 ; .word 0x0000C6DA // QUOTE                   imm10 imm6
  .byte 'R, 0x01 ; .hword 0x0000 ; .word R
  .byte 'S, 0x01 ; .hword 0x0000 ; .word S
  .byte 'T, 0x01 ; .hword 0x0000 ; .word T
  .word 0x00000000, 0x00000000

A:
  .byte 'A, 0x01 ; .hword 0x0000 ; .word AA
  .byte 'H, 0x01 ; .hword 0x0000 ; .word AH
  .byte 'M, 0x00 ; .hword 0x0000 ; .word 0xE3E0AD88 // MULS                T1  01000 01101 Rn Rdm
  .byte 'N, 0x00 ; .hword 0x0000 ; .word 0xE3E0A988 // NEG (immediate)     T1  01000 01001 Rn Rd
  .byte 'S, 0x01 ; .hword 0x0000 ; .word AS
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

AH:
  .byte 'I, 0x00 ; .hword 0x0000 ; .word 0xD5E3E082 // ASRSI (immediate)   T1  00010 imm5 Rm Rd
  .byte 'R, 0x00 ; .hword 0x0000 ; .word 0xE3E0A488 // ASRSR (register)    T1  01000 00100 Rm Rdn
  .word 0x00000000, 0x00000000

AS:
  .byte 'C, 0x00 ; .hword 0x0000 ; .word 0xE3E0A688 // SBCS (register)     T1  01000 00110 Rm Rdn
  .byte 'I, 0x01 ; .hword 0x0000 ; .word ASI
  .byte 'R, 0x00 ; .hword 0x0000 ; .word 0xE6E3E00D // SUBSR (register)    T1  0001101 Rm Rn Rd
  .word 0x00000000, 0x00000000

ASI:
  .byte '3, 0x00 ; .hword 0x0000 ; .word 0xD3E3E00F // SUBSI3 (immediate)  T1  0001111 imm3 Rn Rd
  .byte '8, 0x00 ; .hword 0x0000 ; .word 0x00C8E887 // SUBSI8 (immediate)  T2  00111 Rdn imm8
  .word 0x00000000, 0x00000000

B:
  .byte 'A, 0x00 ; .hword 0x0000 ; .word 0xE3E0A088 // ANDS (register)     T1  01000 00000 Rm Rdn
  .byte 'C, 0x00 ; .hword 0x0000 ; .word 0xE3E0AE88 // BICS (register)     T1  01000 01110 Rm Rdn
  .byte 'I, 0x00 ; .hword 0x0000 ; .word 0xE3E0AF88 // MVNS (register)     T1  01000 01111 Rm Rd
  .byte 'O, 0x00 ; .hword 0x0000 ; .word 0xE3E0AC88 // ORRS (register)     T1  01000 01100 Rm Rdn
  .byte 'T, 0x00 ; .hword 0x0000 ; .word 0xE3E0A888 // TST (register)      T1  01000 01000 Rm Rd
  .byte 'X, 0x00 ; .hword 0x0000 ; .word 0xE3E0A188 // EORS (register)     T1  01000 00001 Rm Rdn
  .word 0x00000000, 0x00000000

C:
  .byte 'I, 0x00 ; .hword 0x0000 ; .word 0x00C8E885 // CMPI (immediate)    T1  00101 Rn imm8
  .byte 'N, 0x00 ; .hword 0x0000 ; .word 0xE3E0AB88 // CMN (register)      T1  01000 01011 Rm Rn
  .byte 'R, 0x01 ; .hword 0x0000 ; .word CR
  .word 0x00000000, 0x00000000

CR:
  .byte '3, 0x00 ; .hword 0x0000 ; .word 0xE3E0AA88 // CMPR (register)     T1  01000 01010 Rm Rn
  .byte '4, 0x01 ; .hword 0x0000 ; .word CR4
  .word 0x00000000, 0x00000000

CR4:
  .byte 'H, 0x00 ; .hword 0x0000 ; .word 0xF3E0B688 // CMPRHI (register)   T2  010001011 Rm4 Rd
  .byte 'L, 0x00 ; .hword 0x0000 ; .word 0xF3E0B488 // CMPRLO (register)   T2  010001010 Rm4 Rd
  .word 0x00000000, 0x00000000

D:
  .byte 'I, 0x00 ; .hword 0x0000 ; .word 0x00C8E884 // MOVSI (immediate)   T1  00100 Rd imm8
  .byte 'R, 0x01 ; .hword 0x0000 ; .word DR
  .byte 'S, 0x01 ; .hword 0x0000 ; .word DS
  .byte 'U, 0x01 ; .hword 0x0000 ; .word DU
  .word 0x00000000, 0x00000000

DR:
  .byte 'F, 0x00 ; .hword 0x0000 ; .word 0xE3E0A080 // MOVSR (register)    T2  00000 00000 Rm
  .byte 'H, 0x00 ; .hword 0x0000 ; .word 0xF3E0BA88 // MOVRHI (register)   T1  010001101 Rm4
  .byte 'L, 0x00 ; .hword 0x0000 ; .word 0xF3E0B888 // MOVRLO (register)   T1  010001100 Rm4
  .word 0x00000000, 0x00000000

DS:
  .byte 'B, 0x00 ; .hword 0x0000 ; .word 0xE3E0A996 // SXTB                T1  10110 01001 Rm
  .byte 'H, 0x00 ; .hword 0x0000 ; .word 0xE3E0A896 // SXTH                T1  10110 01000 Rm
  .word 0x00000000, 0x00000000

DU:
  .byte 'B, 0x00 ; .hword 0x0000 ; .word 0xE3E0AB96 // UXTB                T1  10110 01011 Rm
  .byte 'H, 0x00 ; .hword 0x0000 ; .word 0xE3E0AA96 // UXTH                T1  10110 01010 Rm
  .word 0x00000000, 0x00000000

J:
  .byte 'A, 0x00 ; .hword 0x0000 ; .word 0x0000CB9C // B                   T2  11100 imm11
  .byte 'E, 0x00 ; .hword 0x0000 ; .word 0x00C8A09A // BEQ                 T1  11010 000 imm8
  .byte 'G, 0x01 ; .hword 0x0000 ; .word JG
  .byte 'H, 0x01 ; .hword 0x0000 ; .word JH
  .byte 'I, 0x01 ; .hword 0x0000 ; .word JI
  .byte 'L, 0x01 ; .hword 0x0000 ; .word JL
  .byte 'M, 0x00 ; .hword 0x0000 ; .word 0x00C8B09A // BMI                 T1  11010 100 imm8
  .byte 'N, 0x00 ; .hword 0x0000 ; .word 0x00C8A49A // BNE                 T1  11010 001 imm8
  .byte 'P, 0x00 ; .hword 0x0000 ; .word 0x00C8B49A // BPL                 T1  11010 101 imm8
  .byte 'R, 0x00 ; .hword 0x0000 ; .word 0x00F3BC88 // BX                  T1  01000 1110 Rm4 000
  .byte 'S, 0x00 ; .hword 0x0000 ; .word 0x00C8BC9B // SVC                 T1  11011 111 imm8
  .byte 'V, 0x01 ; .hword 0x0000 ; .word JV
  .word 0x00000000, 0x00000000

JG:
  .byte 'E, 0x00 ; .hword 0x0000 ; .word 0x00C8A89B // BGE                 T1  11011 010 imm8
  .byte 'T, 0x00 ; .hword 0x0000 ; .word 0x00C8B09B // BGT                 T1  11011 100 imm8
  .word 0x00000000, 0x00000000

JH:
  .byte 'I, 0x00 ; .hword 0x0000 ; .word 0x00C8A09B // BHI                 T1  11011 000 imm8
  .byte 'S, 0x00 ; .hword 0x0000 ; .word 0x00C8A89A // BHS                 T1  11010 010 imm8
  .word 0x00000000, 0x00000000

JI:
  .byte 'H, 0x00 ; .hword 0x0000 ; .word 0x0000CB9E // BLHI                T1  11110 imm11
  .byte 'L, 0x00 ; .hword 0x0000 ; .word 0x0000CB9F // BLLO                T1  11111 imm11
  .word 0x00000000, 0x00000000

JL:
  .byte 'E, 0x00 ; .hword 0x0000 ; .word 0x00C8B49B // BLE                 T1  11011 101 imm8
  .byte 'O, 0x00 ; .hword 0x0000 ; .word 0x00C8AC9A // BLO                 T1  11010 011 imm8
  .byte 'R, 0x00 ; .hword 0x0000 ; .word 0x00F3BE88 // BLX                 T1  01000 1111 Rm4 000
  .byte 'S, 0x00 ; .hword 0x0000 ; .word 0x00C8A49B // BLS                 T1  11011 001 imm8
  .byte 'T, 0x00 ; .hword 0x0000 ; .word 0x00C8AC9B // BLT                 T1  11011 011 imm8
  .word 0x00000000, 0x00000000

JV:
  .byte 'C, 0x00 ; .hword 0x0000 ; .word 0x00C8BC9A // BVC                 T1  11010 111 imm8
  .byte 'S, 0x00 ; .hword 0x0000 ; .word 0x00C8B89A // BVS                 T1  11010 110 imm8
  .word 0x00000000, 0x00000000

L:
  .byte 'B, 0x01 ; .hword 0x0000 ; .word LB
  .byte 'H, 0x01 ; .hword 0x0000 ; .word LH
  .byte 'I, 0x01 ; .hword 0x0000 ; .word LI
  .byte 'L, 0x00 ; .hword 0x0000 ; .word 0x00C8E889 // LDRL (literal)      T1  01001 Rt imm8
  .byte 'R, 0x00 ; .hword 0x0000 ; .word 0xE6E3E02C // LDRR (register)     T1  0101100 Rm Rn Rt
  .byte 'S, 0x01 ; .hword 0x0000 ; .word LS
  .word 0x00000000, 0x00000000

LB:
  .byte 'I, 0x00 ; .hword 0x0000 ; .word 0xD5E3E08F // LDRBI (immediate)   T1  01111 imm5 Rn Rt
  .byte 'R, 0x00 ; .hword 0x0000 ; .word 0xE6E3E02E // LDRBR (register)    T1  0101110 Rm Rn Rt
  .word 0x00000000, 0x00000000

LH:
  .byte 'I, 0x00 ; .hword 0x0000 ; .word 0xD5E3E091 // LDRHI (immediate)   T1  10001 imm5 Rn Rt
  .byte 'R, 0x00 ; .hword 0x0000 ; .word 0xE6E3E02D // LDRHR (register)    T1  0101101 Rm Rn Rt
  .word 0x00000000, 0x00000000

LI:
  .byte '5, 0x00 ; .hword 0x0000 ; .word 0xD5E3E08D // LDRI5 (immediate)   T1  01101 imm5 Rn Rt
  .byte '8, 0x00 ; .hword 0x0000 ; .word 0x00C8E893 // LDRI8 (immediate)   T2  10011 Rt imm8
  .word 0x00000000, 0x00000000

LS:
  .byte 'B, 0x00 ; .hword 0x0000 ; .word 0xE6E3E02B // LDRSB (register)    T1  0101011 Rm Rn Rt
  .byte 'H, 0x00 ; .hword 0x0000 ; .word 0xE6E3E02F // LDRSH (register)    T1  0101111 Rm Rn Rt
  .word 0x00000000, 0x00000000

P:
  .byte 'L, 0x00 ; .hword 0x0000 ; .word 0x0000B496 // PUSHLR              T1  10110 10100 000000
  .byte 'P, 0x00 ; .hword 0x0000 ; .word 0x0000B497 // POPPC               T1  10111 10100 000000
  .word 0x00000000, 0x00000000

R:
  .byte 'B, 0x01 ; .hword 0x0000 ; .word RB
  .byte 'R, 0x00 ; .hword 0x0000 ; .word 0xE3E0A788 // RORS (register)     T1  01000 00111 Rm Rdn
  .word 0x00000000, 0x00000000

RB:
  .byte 'H, 0x00 ; .hword 0x0000 ; .word 0xE3E0A997 // REV16               T1  10111 01001 Rm Rd
  .byte 'S, 0x00 ; .hword 0x0000 ; .word 0xE3E0AB97 // REVSH               T1  10111 01011 Rm Rd
  .byte 'W, 0x00 ; .hword 0x0000 ; .word 0xE3E0A897 // REV                 T1  10111 01000 Rm Rd
  .word 0x00000000, 0x00000000

S:
  .byte 'B, 0x01 ; .hword 0x0000 ; .word SB
  .byte 'H, 0x01 ; .hword 0x0000 ; .word SH
  .byte 'I, 0x01 ; .hword 0x0000 ; .word SI
  .byte 'R, 0x00 ; .hword 0x0000 ; .word 0xE6E3E028 // STRR (register)     T1  0101000 Rm Rn Rt
  .word 0x00000000, 0x00000000

SB:
  .byte 'I, 0x00 ; .hword 0x0000 ; .word 0xD5E3E08E // STRBI (immediate)   T1  01110 imm5 Rn Rt
  .byte 'R, 0x00 ; .hword 0x0000 ; .word 0xE6E3E02A // STRBR (register)    T1  0101010 Rm Rn Rt
  .word 0x00000000, 0x00000000

SH:
  .byte 'I, 0x00 ; .hword 0x0000 ; .word 0xD5E3E090 // STRHI (immediate)   T1  10000 imm5 Rn Rt
  .byte 'R, 0x00 ; .hword 0x0000 ; .word 0xE6E3E029 // STRHR (register)    T1  0101001 Rm Rn R
  .word 0x00000000, 0x00000000

SI:
  .byte '5, 0x00 ; .hword 0x0000 ; .word 0xD5E3E08C // STRI5 (immediate)   T1  01100 imm5 Rn Rt
  .byte '8, 0x00 ; .hword 0x0000 ; .word 0x00C8E892 // STRI8 (immediate)   T2  10010 Rt imm8
  .word 0x00000000, 0x00000000

T:
  .byte 'L, 0x01 ; .hword 0x0000 ; .word TL
  .byte 'R, 0x01 ; .hword 0x0000 ; .word TR
  .word 0x00000000, 0x00000000

TL:
  .byte 'I, 0x00 ; .hword 0x0000 ; .word 0xD5E3E080 // LSLSI (immediate)   T1  00000 imm5 Rm Rd
  .byte 'R, 0x00 ; .hword 0x0000 ; .word 0xE3E0A288 // LSLSR (register)    T1  01000 00010 Rm Rdn
  .word 0x00000000, 0x00000000

TR:
  .byte 'I, 0x00 ; .hword 0x0000 ; .word 0xD5E3E081 // LSRSI (immediate)   T1  00001 imm5 Rm Rd
  .byte 'R, 0x00 ; .hword 0x0000 ; .word 0xE3E0A388 // LSRSR (register)    T1  01000 00011 Rm Rdn
  .word 0x00000000, 0x00000000
