.syntax unified
.cpu cortex-m0plus
.thumb

.type imm, %function
.global imm

// R1 instruction under construction
// R3 immediate width
// R4 input buffer

imm:      PUSH    {LR}
          PUSH    {R3}
          BL      immediate
          POP     {R3}
          BNE     exit
          MOVS    R0, 1
          LSLS    R0, R3
          CMP     R2, R0
          BLO     fine
          MOVS    R0, 0x0A    // return code 0A (immediate value too large)
          POP     {PC}
fine:     ORRS    R1, R2      // fill in imm
          MOVS    R0, 0       // return code 0 (success)
exit:     POP     {PC}
bad_reg:  MOVS    R0, 8       // return code 8 (invalid register for this register position)
          POP     {PC}
