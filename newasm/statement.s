.syntax unified
.cpu cortex-m0plus
.thumb

.type statement, %function
.global statement

// 1 reported an error

// R4 input buffer
// R2 output buffer

statement:PUSH    {LR}
          BL      whitespace
          PUSH    {R2}
          BL      label
          POP     {R2}
          CMP     R0, #2        // check for error code 2 (no colon)
          BNE     1f
          ADR     R0, no_colon
          B       err_exit
1:        BL      whitespace
          PUSH    {R2}
          BL      opcode
          POP     {R2}
          BEQ     2f
          ADR     R0, no_opcode
          B       err_exit
2:        LDR     R0, [R2]
          BL      lookup
          BEQ     3f
          ADR     R0, not_found
          B       err_exit
3:        POP     {PC}          // success code already in R0
err_exit: BL      putstrln
          MOVS    R0, #1        // return code 1 (there was an error)
          POP     {PC}

            .align  4
no_colon:   .asciz  "Error: Expected colon at end of label"
            .align  4
no_opcode:  .asciz  "Error: Expected an opcode"
            .align  4
not_found:  .asciz  "Error: Opcode not found"
