.syntax unified
.cpu cortex-m0plus
.thumb

.type main, %function
.global main

main:
  bl start_xosc
  bl setup_clocks
  bl setup_gpio
  bl setup_uart
  b assembler

assembler:  LDR     R0, =0x20001000         // SRAM_BASE
            MOV     R11, R0
            ADDS    R1, R0, 1               // JUMP ADDRESS
            MOV     R12, R1
1:          BL      PROMPT                  // SHOW PROMPT
            BL      assemble
            B       2f                      // TODO condition
            BX      R12
2:          MOV     R7, R11                 // STORE INSTRUCTION WORD
            STRH    R6, [R7]
            MOVS    R0, '\r                 // NEW LINE
            BL      uart_send
            BL      PROMPT                  // REWRITE PROMPT
            ADDS    R7, 2                   // INCREMENT POINTER
            MOV     R11, R7
            MOVS    R0, '\r
            BL      uart_send
            MOVS    R0, '\n
            BL      uart_send
            B 1b

PROMPT:     PUSH    {LR}
            MOV     R0, R11                 // CURRENT ADDRESS
            BL      send_hex
            MOVS    R0, '                   // SPACE
            BL      uart_send
            MOV     R1, R11                 // CURRENT CONTENTS
            LDRH    R0, [R1]
            BL      send_hex
            MOVS    R0, '                   // SPACE
            BL      uart_send
            POP     {PC}                    // RETURN
