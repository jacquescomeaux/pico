.syntax unified
.cpu cortex-m0plus
.thumb

.type CRC32, %function
.global CRC32

// R0 = input addr
// R1 = length
CRC32:  LDR R5, =0x04C11DB7
        LDR R4, =0xFFFFFFFF
10:     LDR R2, [R0]
        REV R2, R2
        EORS R4, R2
        MOVS R3, 32
20:     LSLS R4, 1
        BCC 30f
        EORS R4, R5
30:     SUBS R3, 1
        BNE 20b
        ADDS R0, 4
        SUBS R1, 1
        BNE 10b
        BX LR
