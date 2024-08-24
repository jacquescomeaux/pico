.syntax unified
.cpu cortex-m0plus
.thumb

.type label, %function
.global label

// R4 input buffer
// R2 output buffer

label:    PUSH    {LR}
          LDRB    R0, [R4]    // get a char
          CMP     R0, 0x61    // a
          BLO     1f
          CMP     R0, 0x7A    // z
          BLS     2f
1:        MOVS    R0, #1      // return code 1 (expected lowercase)
          POP     {PC}
2:        BL      symbol
          LDRB    R0, [R4]    // get a char
          CMP     R0, ':      // colon
          BEQ     3f
          MOVS    R0, #3      // return code 3 (expected colon)
          POP     {PC}
3:        ADDS    R4, 1       // consume the colon
          MOVS    R0, #0      // return code 0 (success)
          POP     {PC}
