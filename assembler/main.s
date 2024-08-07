.syntax unified
.cpu cortex-m0plus
.thumb

.type main, %function
.global main

main:       LDR     R0, =0x20000000         // SRAM_BASE
0:          MOV     R11, R0
            ADDS    R1, R0, 1               // JUMP ADDRESS
            MOV     R12, R1
1:          BL      PROMPT                  // SHOW PROMPT
            BL      assemble
            CMP     R0, 1                   // SET NEW ADDRESS
            BNE     2f
            MOVS    R0, '\r                 // SEND CR
            BL      uart_send
            MOV     R1, R11                 // GET ADDRESS
            LSRS    R1, 12                  // SHIFT OUT LOWER 12 BITS
            MOVS    R0, R1                  // SAVE IN R0
            LSLS    R1, 12                  // SHIFT BACK
            MOV     R11, R1                 // SAVE ALTERRED ADDRESS
            MOVS    R1, 20                  // SEND OCTAL WITH WIDTH 20
            BL      send_oct
            BL      get_oct                 // GET OCTAL INPUT FOR OFFSET
            MOVS    R0, 0x1
            BICS    R4, R0
            MOV     R0, R11                 // ADD OFFSET TO ADDRESS
            ADDS    R0, R4
            B       0b
2:          CMP     R0, 2                   // JUMP TO NEW CODE
            BNE     3f
            BX      R12
3:          MOV     R7, R11                 // STORE INSTRUCTION WORD
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
            MOVS    R1, 32
            BL      send_oct
            MOVS    R0, '                   // SPACE
            BL      uart_send
            MOV     R1, R11                 // CURRENT CONTENTS
            LDRH    R0, [R1]
            MOVS    R1, 16
            BL      send_oct
            MOVS    R0, '                   // SPACE
            BL      uart_send
            POP     {PC}                    // RETURN
