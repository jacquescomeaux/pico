.syntax unified
.cpu cortex-m0plus
.thumb

.type SETUP, %function
.global SETUP

.type UARTTX, %function
.type UARTRX, %function
.type SENDHEX, %function

.align 4

SETUP:      LDR     R0, [PC, #16] // 000000 044004  UARTRX
            LDR     R1, [PC, #20] // 000002 044405  UARTTX
            LDR     R2, [PC, #20] // 000004 045005  SENDHEX
            MOV     R9, R0        // 000006 043201
            MOV     R10, R1       // 000010 043212
            MOV     R11, R2       // 000012 043223
            LDR     R7, [PC, #4]  // 000014 047401  START ADDRESS
            ADDS    R6, R7, 1     // 000016 016176
            B       MAINLOOP      // 000020 160010
            .HWORD  0x0000        // 000022 000000
            .WORD   UARTRX        // 000024 010243  0x200010A3
                                  // 000026 040000
            .WORD   UARTTX        // 000030 010225  0x20001095
                                  // 000032 040000
            .WORD   SENDHEX       // 000034 010264  0x200010B5
                                  // 000036 040000
            .WORD   0x20001000    // 000040 010000  START ADDRESS
                                  // 000042 020000
MAINLOOP:   MOVS    R0, R7        // 000044 000070  PROMPT
            BLX     R11           // 000046 043730  SENDHEX
            MOVS    R0, 0x20      // 000050 020040  SPACE
            BLX     R10           // 000052 043720  UARTTX
            LDRH    R0, [R7]      // 000054 104070
            BLX     R11           // 000056 043730  SENDHEX
            MOVS    R0, 0x0D      // 000060 020015  CARRIAGE RETURN
            BLX     R10           // 000062 043720  UARTTX
            MOVS    R0, R7        // 000064 000070
            BLX     R11           // 000066 043730  SENDHEX
            MOVS    R0, 0x20      // 000070 020040  SPACE
            BLX     R10           // 000072 043720  UARTTX
10:         BLX     R9            // 000074 043710  COMMAND LOOP, UARTRX
            CMP     R0, 0x47      // 000076 024107  ASCII G
            BNE     20f           // 000100 150400
            BX      R6            // 000102 043460
20:         CMP     R0, 0x0D      // 000104 024015  CARRIAGE RETURN
            BNE     30f           // 000106 150401
            ADDS    R7, 0x2       // 000110 033402
            B       MAINLOOP      // 000112 163753
30:         CMP     R0, 0x30      // 000114 024060  ASCII 0
            BNE     MAINLOOP      // 000116 150751
            BLX     R10           // 000120 043720  UARTTX
40:         BLX     R9            // 000122 043710  UARTRX
            CMP     R0, 0x78      // 000124 024170  ASCII x
            BNE     40b           // 000126 150774
            BLX     R10           // 000130 043720  UARTTX
            MOVS    R4, 0         // 000132 022000
            MOVS    R5, 4         // 000134 022404
50:         BLX     R9            // 000136 043710  HEX LOOP, UARTRX
            CMP     R0, 0x30      // 000140 024060  ASCII 0
            BLO     50b           // 000142 151774
            CMP     R0, 0x39      // 000144 024071  ASCII 9
            BLS     60f           // 000146 154406
            CMP     R0, 0x41      // 000150 024101  ASCII A
            BLO     50b           // 000152 151770
            CMP     R0, 0x46      // 000154 024106  ASCII F
            BHI     50b           // 000156 154366
            BLX     R10           // 000160 043720  UARTTX
            SUBS    R0, 0x37      // 000162 034067  ASCII A MINUS 10
            B       70f           // 000164 160001
60:         BLX     R10           // 000166 043720  UARTTX
            SUBS    R0, 0x30      // 000170 034060  ASCII 0
70:         LSLS    R4, 4         // 000172 000444
            ADDS    R4, R0        // 000174 014044
            SUBS    R5, 1         // 000176 036401
            BNE     50b           // 000200 150755
80:         BLX     R9            // 000202 043710  UARTRX
            CMP     R0, 0x0D      // 000204 024015  CARRIAGE RETURN
            BNE     80b           // 000206 150774
            BLX     R10           // 000210 043720  UARTTX
            STRH    R4, [R7]      // 000212 100074
            ADDS    R7, 0x2       // 000214 033402
            MOVS    R0, 0x0A      // 000216 020012  NEW LINE
            BLX     R10           // 000220 043720  UARTTX
            B       MAINLOOP      // 000222 163707
UARTTX:     LDR     R1, [PC, #24] // 000224 044406  UART0_BASE
            MOVS    R3, 0x20      // 000226 021440  TX FIFO FULL
1:          LDR     R2, [R1, 0x18]// 000230 067012  UARTFR_OFST
            TST     R2, R3        // 000232 041032
            BNE     1b            // 000234 150774
            STRB    R0, [R1]      // 000236 070010  UARTDR_OFST
            BX      LR            // 000240 043560
UARTRX:     LDR     R1, [PC, #12] // 000242 044403
            MOVS    R3, 0x10      // 000244 021420  RX FIFO EMPTY
1:          LDR     R2, [R1, 0x18]// 000246 067012  UARTFR_OFST
            TST     R2, R3        // 000250 041032
            BNE     1b            // 000252 150774
            LDRB    R0, [R1]      // 000254 074010  UARTDR_OFST
            BX      LR            // 000256 043560
            .WORD   0x40034000    // 000260 040000
                                  // 000262 040003
SENDHEX:    PUSH    {LR}          // 000264 132400
            LSLS    R4, R0, 0x10  // 000266 002004  16 BITS
            MOVS    R0, 0x30      // 000270 020060  ASCII 0
            BLX     R10           // 000272 043720  UARTTX
            MOVS    R0, 0x78      // 000274 020170  ASCII x
            BLX     R10           // 000276 043720
            MOVS    R5, 0x4       // 000300 022404
0:          MOVS    R0, 0x1C      // 000302 020034
            RORS    R4, R0        // 000304 040704
            UXTB    R0, R4        // 000306 131340
            CMP     R0, 0x9       // 000310 024011
            BHI     1f            // 000312 154001
            ADDS    R0, 0x30      // 000314 030060  ASCII 0
            B       2f            // 000316 160000
1:          ADDS    R0, 0x37      // 000320 030067  ASCII A MINUS 10
2:          BLX     R10           // 000322 043720  UARTTX
            SUBS    R5, 1         // 000324 036401
            BNE     0b            // 000326 150764
            POP     {PC}          // 000330 136400
