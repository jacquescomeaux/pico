.syntax unified
.cpu cortex-m0plus
.thumb

.type label, %function
.global label

// 1 unexpected begin char
// 2 doesn't end with colon

// R1 input buffer
// R2 output buffer

label:    PUSH    {LR}
          LDRB    R0, [R1]    // get a char
          CMP     R0, 0x61    // a
          BLO     1f
          CMP     R0, 0x7A    // z
          BLS     2f
1:        MOVS    R0, #1      // return code 1 (expected lowercase)
          POP     {PC}
2:        BL      symbol
          LDRB    R0, [R1]    // get a char
          CMP     R0, ':      // colon
          BEQ     3f
          MOVS    R0, #2      // return code 2 (expected colon)
          POP     {PC}
3:        ADDS    R1, 1       // consume the colon
          MOVS    R0, #0      // return code 0 (success)
          POP     {PC}
