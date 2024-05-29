.syntax unified
.cpu cortex-m0plus
.thumb

.type register, %function
.global register

register: PUSH    {LR}
          MOV     R4, R0
          LSLS    R4, 1
          ADDS    R4, ('0 + 1)
10:       BLX     R10
          CMP     R0, 'R
          BNE     10b
          BLX     R9
20:       BLX     R10
          CMP     R0, '0
          BLO     20b
          CMP     R0, R4
          BHI     20b
          BLX     R9
          CMP     R0, '1
          BNE     30f
          CMP     R4, '7
          BEQ     30f
50:       BLX     R10
          BEQ     60f
          CMP     R0, '0
          BLO     50b
          CMP     R0, '5
          BHI     50b
          BLX     R9
          ADDS    R0, 10
30:       SUBS    R0, '0
          MOV     R4, R0
40:       BLX     R10
          BNE     40b
          POP     {PC}
60:       MOVS    R4, 1
          POP     {PC}
