assemble:
  BL receive_op
  LDR R5, =0x20002000 // opcode table
  LDR R1, =0x20001000 // opcode buffer base addr
loop:
  LDR R0, [R5, 0]     // load the string addr
  BL string_compare
  BEQ match
  ADDS R5, 8          // next row of table
  LDR R0, =0x20002080 // opcode table end
  CMP R5, R0
  BLO loop            // Keep going if lower than end
  B redo_line         // redo line if opcode was not found
match:
  LDR R6, [R5, 4]     // load the parse instructions
main_loop:
  MOVS R0, 0xFF   // lsb mask
  ANDS R0, R6     // store in R0
  MOVS R1, 0x80   // bit 7 mask
  TST R0, R1      // compare (AND) to R0 byte
  BNE handle_imm  // if IMM (== 1)
  LSRS R0, 4      // R0 hold 3 or 4 (or 0)
  BEQ handle_brackets // if BRACKETS (== 0)
handle_reg:
  BL register    // result is put in R4
  MOVS R0, 0x0F  // lower nibble mask
  ANDS R0, R6    // store shift amount in R0
  LSLS R4, R0    // shift the result by the shift amount
  ORRS R5, R4    // OR the register code into the word under construction
  B done_stuff
handle_imm:
  MOVS R1, 0x0F  // lower nibble mask
  ANDS R0, R1    // store immediate width in R0
  BL octal       // result is put in R4
  MOVS R0, 0x7F  // least significant 7 bits mask
  ANDS R0, R6    // store ls 7 bits in R0
  LSRS R0, 4     // shift right to get shift amount
  LSLS R4, R0    // shift the result by the shift amount
done_stuff:
  LSRS R6, 0x8 // get next parse instruction
  BEQ done     // if it's zero there are no more things to parse
  MOVS R0, 0   // copy the end_char into R0
  ORRS R0, R9
  BL uart_send // echo the comma (or bracket)
10:
  BL get_char
  MOVS R1, '  // space char
  CMP R0, R1
  BNE 10b // keep trying if not space
  BL uart_send // echo the space
  B main_loop
handle_brackets:
  BL get_char    // char in R0
  MOVS R1, '[    // open bracket
  CMP R0, R1
  BNE handle_brackets // keep trying if not bracket
  BL uart_send   // echo bracket
  MOVS R8, 1     // 1 means we are now in brackets
  LSRS R6, 0x8   // get next parse instruction
  BNE main_loop
done:
  TST R8, R8 // R8 == whether we are in bracket or not
  BEQ no_brackets
  MOVS R0, ']  // echo bracket
  BL uart_send
no_bracket:
  MOVS R0, '\r  // send carriage return
  BL uart_send
  MOVS R0, '\n  // send newline
  BL uart_send
  B next_instr
