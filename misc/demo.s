.syntax unified
.cpu cortex-m0plus
.thumb

.align 4

ECHO:   LDR     R1, [PC, #20]   // 00 044405 0x00 0x4905 UART0_BASE
        MOVS    R3, 0x10        // 02 021420 0x02 0x2310 RX FIFO EMPTY
1:      LDR     R2, [R1, 0x18]  // 04 064612 0x04 0x698A UARTFR_OFST
        TST     R2, R3          // 06 041032 0x06 0x421A
        BNE     1b              // 10 150774 0x08 0xD1FC
        LDRB    R0, [R1]        // 12 074010 0x0A 0x7808 UARTDR_OFST
        MOVS    R3, 0x20        // 14 021440 0x0C 0x2320 TX FIFO FULL
1:      LDR     R2, [R1, 0x18]  // 16 064612 0x0E 0x698A UARTFR_OFST
        TST     R2, R3          // 20 041032 0x10 0x421A
        BNE     1b              // 22 150774 0x12 0xD1FC
        STRB    R0, [R1]        // 24 070010 0x14 0x7008 UARTDR_OFST
        B       ECHO            // 26 163763 0x16 0xE7F3
        .WORD   0x40034000      // 30 040000 0x18 0x4000
                                // 32 040003 0x1A 0x4003
