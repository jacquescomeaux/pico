.syntax unified
.cpu cortex-m0plus
.thumb

.equ UART0_BASE, 0x40034000
.equ UARTDR_OFST,     0x00
.equ UARTFR_OFST,     0x18

.type uart_send, %function
.type uart_recv, %function
.type get_char, %function
.type send_oct, %function
.type get_oct, %function

.global uart_send
.global uart_recv
.global get_char
.global send_oct
.global get_oct

uart_send:  LDR     R1, =UART0_BASE         // 0x0000 0x4917
            MOVS    R3, 0b1 << 5            // 0x0002 0x2320  ; TX FIFO FULL
1:          LDR     R2, [R1, UARTFR_OFST]   // 0x0004 0x670A
            TST     R2, R3                  // 0x0006 0x421A
            BNE     1b                      // 0x0008 0xD1FC
            STRB    R0, [R1, UARTDR_OFST]   // 0x000A 0x7008
            BX      LR                      // 0x000C 0x4770
uart_recv:  LDR     R1, =UART0_BASE         // 0x000E 0x4914
            MOVS    R3, 0b1 << 4            // 0x0010 0x2310  ; RX FIFO EMPTY
1:          LDR     R2, [R1, UARTFR_OFST]   // 0x0012 0x670A
            TST     R2, R3                  // 0x0014 0x421A
            BNE     1b                      // 0x0016 0xD1FC
            LDRB    R0, [R1, UARTDR_OFST]   // 0x0018 0x7808
            BX      LR                      // 0x001A 0x4770
get_char:   PUSH    {LR}                    // 0x001C 0xB500
            BL      uart_recv               // 0x001E 0xF7FF
                                            // 0x0020 0xFFF6
            CMP     R0, '<
            BNE     1f
            MOVS    R0, 1
            B       2f
1:          CMP     R0, '>
            BNE     3f
            MOVS    R0, 2
2:          POP     {R1}
            POP     {R1}
3:          CMP     R0, R8                  // 0x0022 0x4540
            POP     {PC}                    // 0x0024 0xBD00
send_oct:   PUSH    {LR}
            MOVS    R4, R0
            MOVS    R0, R1
            MOVS    R1, 32
            SUBS    R1, R0
            LSLS    R4, R1
            MOVS    R5, 0
loop1:      CMP     R0, 3
            BLO     done
            SUBS    R0, 3
            ADDS    R5, 1
            B       loop1
done:       TST     R0, R0
            BEQ     loop2
            RSBS    R0, 0
            ADDS    R0, 32
            RORS    R4, R0
            ADDS    R5, 1
loop2:      MOVS    R0, 0x07
            ANDS    R0, R4
            ADDS    R0, 0x30
            BL      uart_send
            MOVS    R0, 0x1D
            RORS    R4, R0
            SUBS    R5, 1
            BNE     loop2
            POP     {PC}
get_oct:    PUSH    {LR}          // 000224 132400
            MOVS    R4, 0x0       // 000226 022000
            MOVS    R5, 0x4       // 000230 022404
10:         BL      uart_recv     // 000232 043700  HEX LOOP, UARTRX
            CMP     R0, 0x30      // 000234 024060  ASCII 0
            BLO     10b           // 000236 151774
            CMP     R0, 0x37      // 000240 024071  ASCII 7
            BHI     10b           // 000242 154406
            BL      uart_send     // 000262 043710  UARTTX
            SUBS    R0, 0x30      // 000264 034060  ASCII 0
30:         LSLS    R4, 0x3       // 000266 000444
            ADDS    R4, R0        // 000270 014044
            SUBS    R5, 0x1       // 000272 036401
            BNE     10b           // 000274 150755
40:         BL      uart_recv     // 000276 043700  UARTRX
            CMP     R0, '\r       // 000300 024015  CARRIAGE RETURN
            BNE     40b           // 000302 150774
            BL      uart_send     // 000304 043710  UARTTX
            POP     {PC}          // 000306 136400
