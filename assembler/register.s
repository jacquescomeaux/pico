.syntax unified
.cpu cortex-m0plus
.thumb

.type register, %function
.global register

register:
  PUSH {LR}
  MOV R4, R0
  LSLS R4, 1
  ADDS R4, ('0 + 1)
10:
  BL get_char
  MOVS R1, 'R
  CMP R0, R1
  BNE 10b
  BL uart_send
20:
  BL get_char
  MOVS R1, '0
  CMP R0, R1
  BLO 20b
  CMP R0, R4
  BHI 20b
  BL uart_send
  MOVS R1, '1
  CMP R0, R1
  BNE 30f
  MOVS R1, '7
  CMP R4, R1
  BEQ 30f
50:
  BL get_char
  // CMP R0, '  // space is stop char
  BEQ 60f
  MOVS R1, '0
  CMP R0, R1
  BLO 50b
  MOVS R1, '5
  CMP R0, R1
  BHI 50b
  BL uart_send
  ADDS R0, 10
30:
  SUBS R0, '0
  MOV R4, R0
40:
  BL get_char
  // CMP R0, '  // space is stop char
  BNE 40b
  POP {PC}
60:
  MOVS R4, 1
  POP {PC}
