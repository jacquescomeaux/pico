.syntax unified
.cpu cortex-m0plus
.thumb

.type statement, %function
.global statement

// 1 reported an error

// R1 input buffer
// R2 output buffer

statement:PUSH    {LR}
          BL      whitespace
          BL      label
          CMP     R0, #2        // check for error code 2 (no colon)
          BNE     1f
          ADR     R0, no_colon
          B       err_exit
1:        BL      whitespace
          BL      opcode
          BEQ     2f
          ADR     R0, no_opcode
          B       err_exit
2:        MOVS    R0, #0
          POP     {PC}

err_exit: BL      putstrln
          MOVS    R0, #1        // return code 1 (there was an error)
          POP     {PC}

            .align  4
no_colon:   .asciz  "Error: Expected colon at end of label"
            .align  4
no_opcode:  .asciz  "Error: Expected an opcode"
