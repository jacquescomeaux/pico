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
  CMP R0, 'R
  BNE 10b
  BL uart_send
20:
  BL get_char
  CMP R0, '0
  BLO 20b
  CMP R0, R4
  BHI 20b
  BL uart_send
  CMP R0, '1
  BNE 30f
  CMP R4, '7
  BEQ 30f
50:
  BL get_char
  BEQ 60f
  CMP R0, '0
  BLO 50b
  CMP R0, '5
  BHI 50b
  BL uart_send
  ADDS R0, 10
30:
  SUBS R0, '0
  MOV R4, R0
40:
  BL get_char
  BNE 40b
  POP {PC}
60:
  MOVS R4, 1
  POP {PC}
