1yyyxxxx Imm         yyy = shift amount xxxx = bit-width
00000001 Brackets
0011yyyy Reg        yyyy = shift amount
0100yyyy Reg

MOVS 0x 00 00 88 38
ADDS 0x 00 00 88 38
SUBS 0x 00 00 88 38
CMP  0x 00 00 33 30
ANDS 0x 00 00 33 30
ORRS 0x 00 00 33 30
TST  0x 00 00 33 30
LSLS 0x 00 E5 33 30
LSRS 0x 00 E5 33 30
RORS 0x 00 00 33 30
LDR  0x E5 33 01 30
LDRB 0x 36 33 01 30
STR  0x E5 33 01 30
STRB 0x 36 33 01 30
B<c> 0x 00 00 00 88
B    0x 00 00 00 8B
BX   0x 00 00 00 43

// R2 holds the whole word
// R0 holds just the byte
// R1 holds either 3 or 4
more:
  MOVS R0, 0xFF
  ANDS R0, R2
  MOVS R1, 0x80
  TST R0, R1
  BNE handle_imm // if IMM
  MOVS R1, 0xF0
  ANDS R1, R0
  BEQ handle_brackets // if BRACKETS
handle_reg:
  LSRS R1, 4
  MOVS R3, 0x0F
  ANDS R0, R3
  // R1 = 3 or 4
  // R0 = shift amount
  BL register
  B done_stuff

handle_imm:
  BL octal
  B done_stuff

handle_brackets:
  // expect bracket
  // echo bracket
  LSRS R2, 0x8
  BEQ next_instr
  Back
  ...

done_stuff:
  LSRS R2, 0x4
  BEQ done
  MOVS R0, 0
  ORRS R0, R9
  BL uart_send // echo the comma (or bracket)
expect:
  BL get_char
  MOVS R1, '  // space char
  CMP R0, R1
  BNE expect // keep trying if not space
  BL uart_send // echo the space
  B more
done:
  TST R8, R8 // R8 == whether we are in bracket or not
  BEQ no_brackets
  MOVS R0, ']
  BL uart_send
no_bracket:
  // echo carriage return + newline
  B next_instr
