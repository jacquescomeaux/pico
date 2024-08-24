.syntax unified
.cpu cortex-m0plus
.thumb

.type regregimm, %function
.global regregimm

// R1 instruction under construction
// R3 immediate width
// R4 input buffer

regregimm:PUSH    {LR}
          PUSH    {R3}
          BL      register    // parse a register
          POP    {R3}
          BNE     exit        // exit if failure
          CMP     R2, 7       // check that it's R0-R7
          BHI     bad_reg
          ORRS    R1, R2      // fill in Rd
          BL      whitespace  // mandatory whitespace
          BNE     exit        // exit if failure
          PUSH    {R3}
          BL      register    // parse a register
          POP     {R3}
          BNE     exit
          CMP     R2, 7       // check that it's R0-R7
          BHI     bad_reg
          LSLS    R2, 3       // shift by 3
          ORRS    R1, R2      // fill in Rn
          BL      whitespace  // mandatory whitespace
          BNE     exit        // exit if failure
          PUSH    {R3}
          BL      immediate
          POP     {R3}
          BNE     exit
          MOVS    R0, 1
          LSLS    R0, R3
          CMP     R2, R0
          BLO     fine
          MOVS    R0, 0x0A    // returun code 0A (immediate value too large)
          POP     {PC}
fine:     LSLS    R2, 6       // shift by 6
          ORRS    R1, R2      // fill in imm
          MOVS    R0, 0       // return code 0 (success)
exit:     POP     {PC}
bad_reg:  MOVS    R0, 8       // return code 8 (invalid register for this register position)
          POP     {PC}
