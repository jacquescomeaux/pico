.syntax unified
.cpu cortex-m0plus
.thumb

.align 4

ECHO:   LDR     R1, [PC, #12]   // 00 044405 0x00 0x4903  LL    R1 3        UART0_BASE
        MOVS    R3, 0x30        // 02 021420 0x02 0x2310  DI    R3 60       RX FIFO EMPTY or TX FIFO FULL
1:      LDR     R2, [R1, 0x18]  // 04 064612 0x04 0x698A  LI5   R2 R1 6     UARTFR_OFST
        TST     R2, R3          // 06 041032 0x06 0x421A  BT    R2 R3
        BNE     1b              // 10 150774 0x08 0xD1FC  JN    374
        LDRB    R0, [R1]        // 12 074010 0x0A 0x7808  LBI   R0 R1 0     UARTDR_OFST
        STRB    R0, [R1]        // 14 070010 0x0C 0x7008  SBI   R0 R1 0     UARTDR_OFST
        B       1b              // 16 163763 0x0E 0xE7F9  JA    3771
        .WORD   0x40034000      // 20 040000 0x10 0x4000  Q     0400 00
                                // 22 040003 0x12 0x4003  Q     0400 03
