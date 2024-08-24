.syntax unified
.cpu cortex-m0plus
.thumb

.type lookup, %function
.global lookup

// input:
// R0 input string (unboxed)

// output:
// R0 return code
// R1 instruction template
// R2 instruction type
// R3 special code

lookup:   PUSH    {R4, R5, R6}
          ADR     R4, op_table// op table base address
          MOVS    R5, 0       // begin pointer
          MOVS    R6, 7       // end pointer
loop:     CMP     R5, R6      // if begin == end then range = 0
          BEQ     error
          ADDS    R2, R5, R6  // get sum
          LSRS    R2, 1       // divide by two
          LSLS    R3, R2, 3   // times 8 (index to offset)
          LDR     R1, [R4, R3]// read opcode from optable
          CMP     R0, R1      // compare opcode to input
          BLO     lower       // if lower
          BHI     higher      // if higher
found:    LSLS    R2, 3       // times 8 (index to offset)
          ADDS    R4, R2      // select row
          MOVS    R0, 0       // success return code
          LDRH    R1, [R4, 4] // get machine code template
          LDRB    R2, [R4, 6] // get instruction type
          LDRB    R3, [R4, 7] // get special code
          POP     {R4, R5, R6}
          BX      LR          // result in R2
lower:    MOVS    R6, R2      // update end pointer
          B       loop
higher:   ADDS    R5, R2, 1   // update begin pointer
          B     loop
error:    MOVS    R0, 4       // return code 4 (opcode not found)
          POP     {R4, R5, R6}
          BX      LR

          .align  8
op_table:
          .ascii  "ADD3"; .hword 0x1C00;  .byte 0x01, 0x03  // instr type 1, special code 3 (imm width)
          .ascii  "ADD8"; .hword 0x3000;  .byte 0x02, 0x08  // instr type 2, special code 8 (imm width)
          .ascii  "ASPI"; .hword 0xB000;  .byte 0x04, 0x07  // instr type 4, special code 7
          .ascii  "ASRI"; .hword 0x1000;  .byte 0x01, 0x05  // instr type 1, special code 5 (imm width)
          .ascii  "ADCS"; .hword 0x4140;  .byte 0x00, 0x00  // instr type 0, special code 0
          .ascii  "ADDS"; .hword 0x1800;  .byte 0x03, 0x00  // instr type 3, special code 0
          .ascii  "BKPT"; .hword 0xBE00;  .byte 0x04, 0x08  // instr type 4, special code 8
