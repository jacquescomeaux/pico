.syntax unified
.cpu cortex-m0plus
.thumb

.type main, %function
.global main, strbuf

main:     LDR     R6, =0x20002000
          BL      uart_recv
loop:     BL      prompt
          LDR     R0, strbuf
          BL      getline
          LDR     R0, strbuf
          BL      putstr
          LDR     R0, =crlf
          BL      putstr
          B       loop
          BL      uart_recv
          LDR     R0, =0x20000001
          BX      R0

          .align  4
strbuf:   .word   0x20001F00

prompt:   PUSH    {LR}
          MOVS    R0, R6
          BL      send_hex
          MOVS    R0, ' 
          BL      uart_send
          LDR     R0, [R6]
          BL      send_hex
          MOVS    R0, ' 
          BL      uart_send
          POP     {PC}
