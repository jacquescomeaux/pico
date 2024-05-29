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

.global uart_send
.global uart_recv
.global get_char
.global send_hex

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
            BNE     1b                      // 0x0016 0xF1FC
            LDRB    R0, [R1, UARTDR_OFST]   // 0x0018 0x7808
            BX      LR                      // 0x001A 0x4770
get_char:   PUSH    {LR}                    // 0x001C 0xB500
            BL      uart_recv               // 0x001E 0xF7FF
                                            // 0x0020 0xFFF6
            CMP     R0, R8                  // 0x0022 0x4540
            POP     {PC}                    // 0x0024 0xBD00
send_hex:   PUSH    {LR}                    // 0x0026 0xB500
            MOVS    R4, R0                  // 0x0028 0x0004
            MOVS    R0, '0                  // 0x002A 0x2030
            BL      uart_send               // 0x002C 0xF7FF
                                            // 0x002E 0xFFE8
            MOVS    R0, 'x                  // 0x0030 0x2078
            BL      uart_send               // 0x0032 0xF7FF
                                            // 0x0034 0xFFE5
            MOVS    R5, 8                   // 0x0036 0x2508 ; EIGHT NIBBLES IN A WORD
0:          MOVS    R0, 28                  // 0x0038 0x201C ; ROTATE LEFT 4
            RORS    R4, R0                  // 0x003A 0x41C4
            MOVS    R0, 0xF                 // 0x003C 0x200F ; LOWEST NIBBLE MASK
            ANDS    R0, R4                  // 0x003E 0x4020
            CMP     R0, 0x9                 // 0x0040 0x0000 ; NUMBER OR LETTER?
            BHI     1f                      // 0x0042 0xD801
            ADDS    R0, '0                  // 0x0044 0x3030
            B       2f                      // 0x0046 0xE000
1:          ADDS    R0, ('A - 0xA)          // 0x0048 0x3037
2:          BL      uart_send               // 0x004A 0xF7FF
                                            // 0x004C 0xFFD9
            SUBS    R5, 1                   // 0x004E 0x3D01
            BNE     0b                      // 0x0050 0xD1F9
            MOVS    R0, '\r                 // 0x0052 0x200D
            BL      uart_send               // 0x0054 0xF7FF
                                            // 0x0056 0xFFD4
            MOVS    R0, '\n                 // 0x0058 0x200A
            BL      uart_send               // 0x005A 0xF7FF
                                            // 0x005C 0xFFD1
            POP     {PC}                    // 0x005E 0xBD00
                                            // 0x0060 0x4000 ; UART0_BASE
                                            // 0x0062 0x4003
