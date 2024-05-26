.syntax unified
.cpu cortex-m0plus
.thumb

.type assemble, %function
.global assemble

// TODO:
// - test each instruction
// - decide on additional push or pops
// - redo_line is problematic
// - PP and PL are broken (end char)

assemble:
  PUSH {LR}
  MOVS R6, 0
  MOVS R0, ' 
  MOV R8, R0
  BL opcode
  MOV R0, R8
  BL uart_send
  MOVS R7, R4
main_loop:
  LSRS R0, R7, 8    // just peek
  BNE skip          // if more stuff then skip
  MOVS R0, '\r
  MOV R8, R0        //set end char to carriage return
skip:
  UXTB R0, R7       // store lsb in R0
  LSRS R1, R0, 4    // upper nibble
  CMP R1, 0xC       // if 0xxxxxxx or 10xxxxxx
  BLO handle_opcode
  CMP R1, 0xE       // if 110xyyyy
  BLO handle_imm
handle_reg:         // if 111xyyyy
  MOVS R1, (1<<4)   // bit 4 mask
  ANDS R0, R1       // get bit 4
  ADDS R0, 3        // add 3 to it (now 3 or 4)
  BL register       // result is put in R4
  MOVS R0, 0x0F     // lower nibble mask
  ANDS R0, R7       // store shift amount in R0
  LSLS R4, R0       // shift the result by the shift amount
  ORRS R6, R4       // OR the register code into the word under construction
  B done_stuff
handle_opcode:
  MOVS R2, 9        // shift amount for 7-bit opcode
  MOVS R1, (1<<7)   // bit 7 mask
  TST R0, R1        // check bit 7
  BEQ fin           // if zero done
  BICS R0, R1       // clear bit 7
  MOVS R2, 11       // shift amount for 5-bit opcode high
  MOVS R1, (1<<5)   // bit 5 mask
  TST R0, R1        // check bit 5
  BEQ fin           // if zero done
  BICS R0, R1       // clear bit 5
  MOVS R2, 6        // shift amount for 5-bit opcode low
fin:
  LSLS R0, R2
  ORRS R6, R0
  B here
handle_imm:
  MOVS R1, 0x0F  // lower nibble mask
  ANDS R0, R1    // store immediate width in R0
  BL octal       // result is put in R4
  LSLS R0, R7, 27
  LSRS R0, 31
  MOVS R2, 6
  MULS R0, R2    // R0 has shift amount (0 or 6)
  LSLS R4, R0    // shift the result by the shift amount
  ORRS R6, R4    // OR the immediate into the word under construction
done_stuff:
  MOV R0, R8     // copy the end_char into R0
  BL uart_send   // echo the space (or carriage return)
here:
  LSRS R7, 0x8   // get next parse instruction
  BNE main_loop  // if it's nonzero there are more things to parse
done:
  MOVS R0, '\n  // send newline
  BL uart_send
  POP {PC}

.type get_char, %function
.global get_char

// R8: end_char
get_char:
  PUSH {LR}
  BL uart_recv
  CMP R0, 025 // ^U (NAK)
  BEQ redo_line
  // CMP R0, 004 // ^D (EOT)
  // BEQ done_for_real
  CMP R0, R8
  POP {PC}
redo_line:
  POP {R0}
  B done
