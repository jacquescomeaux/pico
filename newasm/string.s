.syntax unified
.cpu cortex-m0plus
.thumb

.type putstr, %function
.type cmpstr, %function

.global putstr, cmpstr

putstr: LDR     R3, =0x40034000
        MOVS    R2, 0x20
1:      LDR     R1, [R3, 0x18]
        TST     R1, R2
        BNE     1b
        LDRB    R1, [R0]
        TST     R1, R1
        BEQ     2f
        STRB    R1, [R3]
        ADDS    R0, 1
        B       1b
2:      BX      LR

cmpstr: MOVS    R4, 0
1:      LDRB    R2, [R0, R4]
        LDRB    R3, [R1, R4]
        CMP     R2, R3
        BNE     2f
        CMP     R2, 0
        BEQ     2f
        ADDS    R4, 1
        B       1b
2:      BX      LR
