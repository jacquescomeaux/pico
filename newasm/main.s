.syntax unified
.cpu cortex-m0plus
.thumb

.type main, %function
.global main, strbuf

main:     LDR     R4, =0x20002000
          BL      uart_recv
loop:     BL      prompt
          LDR     R0, inpbuf
          BL      getline
          LDR     R0, inpbuf
          BL      putstrln
          LDR     R1, inpbuf
          LDR     R2, strbuf
          MOVS    R0, 0
          STRB    R0, [R2]
          BL      statement
          BNE     bad
good:     ADR     R0, success
          PUSH    {R1}
          BL      putstrln
          POP     {R0}
          BL      putstrln
          LDR     R0, strbuf
          BL      putstrln
          B       loop
bad:      ADR     R0, fail
          PUSH    {R1}
          BL      putstrln
          POP     {R0}
          BL      putstrln
          LDR     R0, strbuf
          BL      putstrln
          B       loop
never:    BL      uart_recv
          LDR     R0, =0x20000001
          BX      R0

prompt:   PUSH    {LR}
          MOVS    R0, R4
          BL      send_hex
          MOVS    R0, ' 
          BL      uart_send
          LDR     R0, [R4]
          BL      send_hex
          MOVS    R0, ' 
          BL      uart_send
          POP     {PC}

          .align  4
inpbuf:   .word   0x20001F00        // TODO getline buffer overflow
strbuf:   .word   0x20001F80

          .align  4
success:  .asciz  "The parser suceeded"
          .align  4
fail:     .asciz  "The parser failed"
