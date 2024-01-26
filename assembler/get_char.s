// R9: end_char
get_char:
  PUSH {LR}
  BL uart_recv
  MOVS R1, 025 // ^U (NAK)
  CMP R0, R1
  BEQ redo_line
  MOVS R1, 004 // ^D (EOT)
  CMP R0, R1
  BEQ done_for_real
  CMP R0, R9
  POP {PC}

get_line:
  BL get_char
  ...
  B get_line

redo_line:
  ...
  B get_line
