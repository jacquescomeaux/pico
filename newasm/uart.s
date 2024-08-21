.syntax unified
.cpu cortex-m0plus
.thumb

.type uart_send, %function
.type uart_recv, %function
.type send_hex, %function

.global uart_send
.global uart_recv
.global send_hex

uart_send:  LDR     R1, =0x40034000
            MOVS    R3, 0x20
1:          LDR     R2, [R1, 0x18]
            TST     R2, R3
            BNE     1b
            STRB    R0, [R1]
            BX      LR

uart_recv:  LDR     R1, =0x40034000
            MOVS    R3, 0x10
1:          LDR     R2, [R1, 0x18]
            TST     R2, R3
            BNE     1b
            LDRB    R0, [R1]
            BX      LR

send_hex:   PUSH    {R4, R5, LR}
            MOVS    R4, R0
            MOVS    R5, 8
0:          MOVS    R0, 0x1C
            RORS    R4, R0
            MOVS    R0, 0x0F
            ANDS    R0, R4
            CMP     R0, 0x9
            BHI     1f
            ADDS    R0, 0x30
            B       2f
1:          ADDS    R0, 0x37
2:          BL      uart_send
            SUBS    R5, 1
            BNE     0b
            POP     {R4, R5, PC}
