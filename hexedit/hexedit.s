.syntax unified
.cpu cortex-m0plus
.thumb

.type SETUP, %function
.global SETUP

.type UARTTX, %function
.type UARTRX, %function
.type GETHEX, %function
.type SENDHEX, %function

.align 4

// UARTRX 000326 0x200000D6
// UARTTX 000310 0x200000C8
// GETHEX 000224 0x20000094
// SNDHEX 000350 0x200000E8

SETUP:      LDR     R0, [PC, #20] // 000000 044005  UARTRX
            LDR     R1, [PC, #24] // 000002 044406  UARTTX
            LDR     R2, [PC, #24] // 000004 045006  GETHEX
            LDR     R3, [PC, #28] // 000006 045407  SENDHEX
            MOV     R8, R0        // 000010 043200
            MOV     R9, R1        // 000012 043211
            MOV     R10, R2       // 000014 043222
            MOV     R11, R3       // 000016 043233
            LDR     R7, [PC, #20] // 000020 047405  START ADDRESS
            ADDS    R6, R7, 1     // 000022 016176
            B       MAINLOOP      // 000024 160012
            .HWORD  0x0000        // 000026 000000
            .WORD   UARTRX        // 000030 000327  0x200000D6 | 0x1
                                  // 000032 020000
            .WORD   UARTTX        // 000034 000311  0x200000C8 | 0x1
                                  // 000036 020000
            .WORD   GETHEX        // 000040 000225  0x20000094 | 0x1
                                  // 000042 020000
            .WORD   SENDHEX       // 000044 000351  0x200000E8 | 0x1
                                  // 000046 020000
            .WORD   0x20001000    // 000050 010000  START ADDRESS
                                  // 000052 020000
MAINLOOP:   MOVS    R0, R7        // 000054 000070  PROMPT
            MOVS    R1, 0x8       // 000056 020410
            BLX     R11           // 000060 043730  SENDHEX
            MOVS    R0, 0x20      // 000062 020040  SPACE
            BLX     R9            // 000064 043710  UARTTX
            LDRH    R0, [R7]      // 000066 104070
            MOVS    R1, 0x4       // 000070 020404
            BLX     R11           // 000072 043730  SENDHEX
            MOVS    R0, 0x0D      // 000074 020015  CARRIAGE RETURN
            BLX     R9            // 000076 043710  UARTTX
            MOVS    R0, R7        // 000100 000070
            MOVS    R1, 0x8       // 000102 020410
            BLX     R11           // 000104 043730  SENDHEX
            MOVS    R0, 0x20      // 000106 020040  SPACE
            BLX     R9            // 000110 043710  UARTTX
10:         BLX     R8            // 000112 043700  COMMAND LOOP, UARTRX
            CMP     R0, 0x47      // 000114 024107  ASCII G
            BNE     20f           // 000116 150400
            BX      R6            // 000120 043460
20:         CMP     R0, 0x52      // 000122 024122  ASCII R
            BNE     30f           // 000124 150412
            MOVS    R0, 0x0D      // 000126 020015
            BLX     R9            // 000130 043710  UARTTX
            LSRS    R7, 0x10      // 000132 006077
            MOVS    R0, R7        // 000134 000070
            LSLS    R7, 0x10      // 000136 002077
            MOVS    R1, 0x4       // 000140 020404
            BLX     R11           // 000142 043730  SENDHEX
            BLX     R10           // 000144 043720  GETHEX
            ADDS    R7, R4        // 000146 014477
            ADDS    R6, R7, 1     // 000150 016176
            B       MAINLOOP      // 000152 163737
30:         CMP     R0, 0x0D      // 000154 024015  CARRIAGE RETURN
            BNE     40f           // 000156 150404
            ADDS    R7, 0x2       // 000160 033402
            BLX     R9            // 000162 043710  UARTTX (ECHO CR)
            MOVS    R0, 0x0A      // 000164 020012  LINE FEED
            BLX     R9            // 000166 043710  UARTTX
            B       MAINLOOP      // 000170 163730
40:         CMP     R0, 0x30      // 000172 024060  ASCII 0
            BNE     10b           // 000174 150745
            BLX     R9            // 000176 043710  UARTTX
50:         BLX     R8            // 000200 043700  UARTRX
            CMP     R0, 0x78      // 000202 024170  ASCII x
            BNE     50b           // 000204 150774
            BLX     R9            // 000206 043710  UARTTX
            BLX     R10           // 000210 043720  GETHEX
            STRH    R4, [R7]      // 000212 100074
            ADDS    R7, 0x2       // 000214 033402
            MOVS    R0, 0x0A      // 000216 020012  NEW LINE
            BLX     R9            // 000220 043710  UARTTX
            B       MAINLOOP      // 000222 163713
GETHEX:     PUSH    {LR}          // 000224 132400
            MOVS    R4, 0x0       // 000226 022000
            MOVS    R5, 0x4       // 000230 022404
10:         BLX     R8            // 000232 043700  HEX LOOP, UARTRX
            CMP     R0, 0x30      // 000234 024060  ASCII 0
            BLO     10b           // 000236 151774
            CMP     R0, 0x39      // 000240 024071  ASCII 9
            BLS     20f           // 000242 154406
            CMP     R0, 0x41      // 000244 024101  ASCII A
            BLO     10b           // 000246 151770
            CMP     R0, 0x46      // 000250 024106  ASCII F
            BHI     10b           // 000252 154366
            BLX     R9            // 000254 043710  UARTTX
            SUBS    R0, 0x37      // 000256 034067  ASCII A MINUS 10
            B       30f           // 000260 160001
20:         BLX     R9            // 000262 043710  UARTTX
            SUBS    R0, 0x30      // 000264 034060  ASCII 0
30:         LSLS    R4, 0x4       // 000266 000444
            ADDS    R4, R0        // 000270 014044
            SUBS    R5, 0x1       // 000272 036401
            BNE     10b           // 000274 150755
40:         BLX     R8            // 000276 043700  UARTRX
            CMP     R0, 0x0D      // 000300 024015  CARRIAGE RETURN
            BNE     40b           // 000302 150774
            BLX     R9            // 000304 043710  UARTTX
            POP     {PC}          // 000306 136400
UARTTX:     LDR     R1, [PC, #24] // 000310 044406  UART0_BASE
            MOVS    R3, 0x20      // 000312 021440  TX FIFO FULL
1:          LDR     R2, [R1, 0x18]// 000314 064612  UARTFR_OFST
            TST     R2, R3        // 000316 041032
            BNE     1b            // 000320 150774
            STRB    R0, [R1]      // 000322 070010  UARTDR_OFST
            BX      LR            // 000324 043560
UARTRX:     LDR     R1, [PC, #12] // 000326 044403
            MOVS    R3, 0x10      // 000330 021420  RX FIFO EMPTY
1:          LDR     R2, [R1, 0x18]// 000332 064612  UARTFR_OFST
            TST     R2, R3        // 000334 041032
            BNE     1b            // 000336 150774
            LDRB    R0, [R1]      // 000340 074010  UARTDR_OFST
            BX      LR            // 000342 043560
            .WORD   0x40034000    // 000344 040000
                                  // 000346 040003
SENDHEX:    PUSH    {LR}          // 000350 132400
            MOVS    R4, R0        // 000352 000004
            MOVS    R5, R1        // 000354 000015
            LSLS    R1, 0x2       // 000356 000211
            RORS    R4, R1        // 000360 040714
            MOVS    R0, 0x30      // 000362 020060  ASCII 0
            BLX     R9            // 000364 043710  UARTTX
            MOVS    R0, 0x78      // 000366 020170  ASCII x
            BLX     R9            // 000370 043710  UARTTX
0:          MOVS    R0, 0x1C      // 000372 020034
            RORS    R4, R0        // 000374 040704
            MOVS    R0, 0x0F      // 000376 020017
            ANDS    R0, R4        // 000400 040040
            CMP     R0, 0x9       // 000402 024011
            BHI     1f            // 000404 154001
            ADDS    R0, 0x30      // 000406 030060  ASCII 0
            B       2f            // 000410 160000
1:          ADDS    R0, 0x37      // 000412 030067  ASCII A MINUS 10
2:          BLX     R9            // 000414 043710  UARTTX
            SUBS    R5, 1         // 000416 036401
            BNE     0b            // 000420 150763
            POP     {PC}          // 000422 136400
