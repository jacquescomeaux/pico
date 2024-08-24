.syntax unified
.cpu cortex-m0plus
.thumb

.type statement, %function
.global statement

// R4 input buffer
// R2 output buffer

statement:PUSH    {LR}
          MOVS    R3, R2        // save output buffer
          BL      whitespace    // skip leading whitespace
          BL      label
          CMP     R0, 3         // only exit for code 3 (no colon at end of label)
          BEQ     exit
          MOVS    R1, R0
1:        BL      whitespace
          MOVS    R2, 0         // reset output buffer
          STRB    R2, [R3]
          MOVS    R2, R3
          BL      opcode        // TODO opcodes longer than 4
          ADD     R0, R1
          BNE     exit
2:        MOVS    R0, R3
          PUSH    {R3}
          BL      putstrln
          POP     {R3}
          LDR     R0, [R3]
          BL      lookup
          BNE     exit
          BL      whitespace    // TODO new return code for expected whitespace
          BNE     exit
          ADR     R0, parsers
          LSLS    R2, 2         // multiply by 4 to get byte offset
          LDR     R2, [R0, R2]  // get address of parser
          BLX     R2
          BNE     exit
          BL      whitespace
          LDRB    R0, [R4]      // get a byte from the input stream
          TST     R0, R0        // check if zero
          BEQ     exit          // if it's zero then success
          MOVS    R0, 0x0B      // return code 0B (extra input at end)
exit:     POP     {PC}

          .align  4
parsers:  .word   regreg
          .word   regregimm
          .word   regimm
          .word   regregreg
          .word   imm
