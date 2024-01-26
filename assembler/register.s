register4:
  PUSH {LR}
10:
  BL get_char
  MOVS R1, 'R
  CMPS R0, R1
  BNE 10b
20:
  BL get_char
  MOVS R1, '0
  CMPS R0, R1
  BLO 20b
  MOVS R1, '9
  CMPS R0, R1
  BHI 20b
  MOVS R1, '1
  CMPS R0, R1
  BNE 30f
50:
  BL get_char
  BEQ 60f
  MOVS R1, '0
  CMPS R0, R1
  BLO 50b
  MOVS R1, '5
  CMPS R0, R1
  BHI 50b
  ADDS R0, 10
30:
  SUBS R0, '0
  MOVS R4, 0
  ORRS R4, R0
40:
  BL get_char
  BNE 40b
  POP {PC}
60:
  MOVS R4, 1
  POP {PC}

register3:
  PUSH {LR}
10:
  BL get_char
  MOVS R1, 'R
  CMPS R0, R1
  BNE 10b
20:
  BL get_char
  MOVS R1, '0
  CMPS R0, R1
  BLO 20b
  MOVS R1, '7
  CMPS R0, R1
  BHI 20b
30:
  SUBS R0, '0
  MOVS R4, 0
  ORRS R4, R0
  BL get_char
  BNE 40b
  POP {PC}
