.syntax unified
.cpu cortex-m0plus
.thumb

.type register, %function
.global register

// R4 input buffer
// R2 output buffer

register: PUSH    {LR}
          LDRB    R0, [R4]
r_test:   CMP     R0, 'R
          BNE     special
          ADDS    R4, 1       // consume R
          BL      decimal     // consume a decimal number (result in R2)
          BEQ     validate
          POP     {PC}        // error code already in R0
validate: CMP     R2, #12     // general purpose registers 0-12
          BLS     success
          MOVS    R0, #7      // invalid register number error code
          POP     {PC}
special:  LDRB    R0, [R4]      // get two bytes from input stream
          LDRB    R1, [R4, 1]
          LSLS    R1, 8
          ORRS    R0, R1
          ADR     R2, table     // get address of table
          MOVS    R3, 0         // set table offset to 0
loop:     LDRH    R1, [R2, R3]  // get two bytes from table at current offset
          CMP     R0, R1        // compare input to table row
          BEQ     done          // if equal then done
          ADDS    R3, 2         // increment table offset
          CMP     R3, 6         // compare offset to table size
          BLO     loop          // loop until end of table
          MOVS    R0, #6        // return code 6 (expected register)
          POP     {PC}
done:     ADDS    R4, 2         // consume two chars
          LSRS    R3, 1         // divide table offset by two to row
          ADDS    R3, 13        // add 13 to get register number
          MOVS    R2, R3
success:  MOVS    R0, #0        // return code 0 (success)
          POP     {PC}

          .align  4
table:    .ascii  "SP"
          .ascii  "LR"
          .ascii  "PC"
