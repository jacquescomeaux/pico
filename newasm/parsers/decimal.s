.syntax unified
.cpu cortex-m0plus
.thumb

.type decimal, %function
.global decimal

// 1 not a digit

// R4 input stream
// R2 output value

decimal:  LDRB    R0, [R4]    // get a char
          CMP     R0, '0      // check if zero
          BNE     notzero
          ADDS    R4, 1       // consume the char
          MOVS    R2, 0       // return value of zero
success:  MOVS    R0, #0      // return code zero (success)
          BX      LR
notzero:  CMP     R0, '1      // if not [1-9] then error
          BLO     bad
          CMP     R0, '9
          BHI     bad
          ADDS    R4, 1       // consume the first digit
          SUBS    R0, '0      // calculate the value
          MOVS    R2, R0      // store it in R2
loop:     LDRB    R0, [R4]    // get another char
          CMP     R0, '0      // if not [0-9] then done
          BLO     success
          CMP     R0, '9
          BHI     success
          ADDS    R4, 1       // consume the additional digit
          SUBS    R0, '0      // calculate the value
          MOVS    R3, 10      // base 10
          MULS    R2, R3      // shift result by one decimal place
          ADDS    R2, R0      // accumulate into R2
          B       loop        // keep getting digits
bad:      MOVS    R0, #1      // return code 1 (not a digit)
          BX      LR
