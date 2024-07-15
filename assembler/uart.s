.syntax unified
.cpu cortex-m0plus
.thumb

.equ UART0_BASE, 0x40034000
.equ UARTDR_OFST,     0x00
.equ UARTFR_OFST,     0x18

.type uart_send, %function
.type uart_recv, %function
.type get_char, %function
.type send_hex, %function
.type get_hex, %function

.global uart_send
.global uart_recv
.global get_char
.global send_hex
.global get_hex

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
send_hex:   PUSH    {LR}          // 000350 132400 B500
            MOVS    R4, R0        // 000352 000004 0004
            MOVS    R5, R1        // 000354 000015 000D
            LSLS    R1, 0x2       // 000356 000211 0049
            RORS    R4, R1        // 000360 040714 41CC
            MOVS    R0, 0x30      // 000362 020060 2030 ASCII 0
            BL      uart_send     // 000364 043710  UARTTX
            MOVS    R0, 0x78      // 000366 020170  ASCII x
            BL      uart_send     // 000370 043710  UARTTX
0:          MOVS    R0, 0x1C      // 000372 020034
            RORS    R4, R0        // 000374 040704
            MOVS    R0, 0x0F      // 000376 020017
            ANDS    R0, R4        // 000400 040040
            CMP     R0, 0x9       // 000402 024011
            BHI     1f            // 000404 154001
            ADDS    R0, 0x30      // 000406 030060  ASCII 0
            B       2f            // 000410 160000
1:          ADDS    R0, 0x37      // 000412 030067  ASCII A MINUS 10
2:          BL      uart_send     // 000414 043710  UARTTX
            SUBS    R5, 1         // 000416 036401
            BNE     0b            // 000420 150763
            POP     {PC}          // 000422 136400
get_hex:    PUSH    {LR}          // 000224 132400
            MOVS    R4, 0x0       // 000226 022000
            MOVS    R5, 0x4       // 000230 022404
10:         BL      uart_recv     // 000232 043700  HEX LOOP, UARTRX
            CMP     R0, 0x30      // 000234 024060  ASCII 0
            BLO     10b           // 000236 151774
            CMP     R0, 0x39      // 000240 024071  ASCII 9
            BLS     20f           // 000242 154406
            CMP     R0, 0x41      // 000244 024101  ASCII A
            BLO     10b           // 000246 151770
            CMP     R0, 0x46      // 000250 024106  ASCII F
            BHI     10b           // 000252 154366
            BL      uart_send     // 000254 043710  UARTTX
            SUBS    R0, 0x37      // 000256 034067  ASCII A MINUS 10
            B       30f           // 000260 160001
20:         BL      uart_send     // 000262 043710  UARTTX
            SUBS    R0, 0x30      // 000264 034060  ASCII 0
30:         LSLS    R4, 0x4       // 000266 000444
            ADDS    R4, R0        // 000270 014044
            SUBS    R5, 0x1       // 000272 036401
            BNE     10b           // 000274 150755
40:         BL      uart_recv     // 000276 043700  UARTRX
            CMP     R0, '\r       // 000300 024015  CARRIAGE RETURN
            BNE     40b           // 000302 150774
            BL      uart_send     // 000304 043710  UARTTX
            POP     {PC}          // 000306 136400
