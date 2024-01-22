octal:
  PUSH {LR}
10:
  BL get_char
  MOVS R1, '0
  CMP R0, R1
  BNE 10b
  BL uart_send
  MOVS R4, 0
20:
  BL get_char
  BEQ 30f
  MOVS R1, '0
  CMP R0, R1
  BLO 20b
  MOVS R1, '7
  CMP R0, R1
  BHI 20b
  BL uart_send
  SUBS R0, '0
  LSLS R4, 3
  ADDS R4, R0
  B 20b
30:
  POP {PC}
