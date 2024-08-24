.syntax unified
.cpu cortex-m0plus
.thumb

.type symbol, %function
.global symbol

// 1 unexpected begin char

// R4 input buffer
// R2 output buffer

symbol:   PUSH    {LR}
          LDRB    R0, [R4]    // get a char
          BL      goodchar    // check if valid symbol char
          BEQ     loop
          MOVS    R0, #1      // unexpected begin char
          POP     {PC}
loop:     ADDS    R4, 1       // consume the character
          STRB    R0, [R2]    // store in temp buffer
          ADDS    R2, 1       // advance temp buffer pointer
          LDRB    R0, [R4]    // get another character
          BL      goodchar    // check if valid symbol char
          BEQ     loop        // if so keep getting chars
          MOVS    R0, #0      // return code success
          STRB    R0, [R2]    // write null byte
          POP     {PC}

goodchar: CMP     R0, '$
          BEQ     good
          CMP     R0, '.
          BEQ     good
          CMP     R0, '0
          BLO     bad
          CMP     R0, '9
          BLS     good
          CMP     R0, 'A
          BLO     bad
          CMP     R0, 'Z
          BLS     good
          CMP     R0, '_
          BEQ     good
          CMP     R0, 'a
          BLO     bad
          CMP     R0, 'z
          BHI     bad
good:     CMP     R0, R0
bad:      BX      LR
