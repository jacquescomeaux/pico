.syntax unified
.cpu cortex-m0plus
.thumb

.type whitespace, %function
.global whitespace

// 1 unexpected char

// R4 input buffer

whitespace:
          LDRB    R0, [R4]    // get a char
          CMP     R0, '       // space
          BEQ     1f
          MOVS    R0, #1      // return code 1 (unexpected char)
          BX      LR
1:        ADDS    R4, 1       // consume the character
          LDRB    R0, [R4]    // get another character
          CMP     R0, '       // check if space
          BEQ     1b          // if so keep getting chars
          MOVS    R0, #0      // return code 0 (success)
          BX      LR
