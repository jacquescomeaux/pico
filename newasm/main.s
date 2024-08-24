.syntax unified
.cpu cortex-m0plus
.thumb

.type main, %function
.global main, strbuf

main:     LDR     R5, =0x20002000
          BL      uart_recv           // wait for keypress
loop:     BL      prompt              // display address and data
          LDR     R0, inpbuf          // get a line of input
          BL      getline
          LDR     R4, inpbuf          // prepare input buffer
          LDR     R2, strbuf          // prepare output buffer
          MOVS    R0, 0               // clear output buffer
          STRB    R0, [R2]
          BL      statement           // call statement parser
          BNE     bad                 // print message if failure
          MOVS    R0, R1              // show assembled instruction
          BL      send_hex
          LDR     R0, =crlf
          BL      putstr
          B       loop                // repeat
bad:      PUSH    {R0}
          ADR     R0, fail
          BL      putstr
          POP    {R0}
          BL      send_hex
          LDR     R0, =crlf
          BL      putstr
          MOVS     R0, R4
          BL      putstrln
          B       loop

prompt:   PUSH    {LR}
          MOVS    R0, R5
          BL      send_hex
          MOVS    R0, ' 
          BL      uart_send
          LDR     R0, [R5]
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
fail:     .asciz  "The parser failed: "
