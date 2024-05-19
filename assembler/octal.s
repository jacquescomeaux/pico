.syntax unified
.cpu cortex-m0plus
.thumb

.type octal, %function
.global octal

octal:
  PUSH {LR}
  MOVS R5, R0

  // Handle bit-width = 0
  BNE 30f
10:
  BL get_char
  CMP R0, '0
  BNE 10b
  BL uart_send
  MOVS R4, 0
20:
  BL get_char
  BNE 20b
  POP {PC}
30:

  // R4 will become '1 or '3 or '7
  MOVS R0, 3
  CMP R5, 3
  BHS 40f
  MOVS R0, R5
40:
  MOVS R4, 1
  LSLS R4, R0
  ADDS R4, ('0 - 1)

  // Get first char
50:
  BL get_char
  CMP R0, '0
  BLO 50b
  CMP R0, R4
  BHI 50b
  BL uart_send
  SUBS R0, '0
  MOVS R4, R0

  // Subtract 1, 2, or 3 from bit-width
  MOVS R1, 0
60:
  ADDS R1, 1
  LSRS R0, 1
  BNE 60b
  SUBS R5, R1

  // Loop for remaining chars
70:
  CMP R5, 3
  BLO 80f
  BL get_char
  BEQ 90f
  CMP R0, '0
  BLO 70b
  CMP R0, '7
  BHI 70b
  BL uart_send
  SUBS R0, '0
  LSLS R4, 3
  ADDS R4, R0
  SUBS R5, 3
  B 70b
80:
  BL get_char
  BNE 80b
90:
  POP {PC}
