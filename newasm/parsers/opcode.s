.syntax unified
.cpu cortex-m0plus
.thumb

.type opcode, %function
.global opcode

// 1 unexpected first char

// R4 input buffer
// R2 output buffer

opcode:   PUSH    {LR}
          LDRB    R0, [R4]    // get a char
          CMP     R0, 0x41    // A
          BLO     1f
          CMP     R0, 0x5A    // Z
          BLS     2f
1:        MOVS    R0, #1      // unexpected char
          POP     {PC}
2:        ADDS    R4, 1       // consume the character
          STRB    R0, [R2]    // store in temp buffer
          ADDS    R2, 1       // advance temp buffer pointer
          LDRB    R0, [R4]    // get another character
          BL      goodchar    // check if valid symbol char
          BEQ     2b          // if so keep getting chars
          MOVS    R0, #0      // return code success
          STRB    R0, [R2]    // write null byte
          POP     {PC}

goodchar: CMP     R0, '0
          BLO     bad
          CMP     R0, '9
          BLS     good
          CMP     R0, 'A
          BLO     bad
          CMP     R0, 'Z
          BHI     bad
good:     CMP     R0, R0
bad:      BX      LR
