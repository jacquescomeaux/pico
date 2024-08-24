.syntax unified
.cpu cortex-m0plus
.thumb

.type regreg, %function
.global regreg

// R1 instruction under construction
// R2 output buffer
// R4 input buffer

regreg:   PUSH    {LR}
          BL      register    // parse a register
          BNE     exit        // exit if failure
          CMP     R2, 7       // check that it's R0-R7
          BHI     bad_reg
          ORRS    R1, R2      // fill in Rdn
          BL      whitespace  // mandatory whitespace
          BNE     exit        // exit if failure
          BL      register    // parse a register
          BNE     exit
          CMP     R2, 7       // check that it's R0-R7
          BHI     bad_reg
          LSLS    R2, 3       // shift by 3
          ORRS    R1, R2      // fill in Rm
          MOVS    R0, 0       // return code 0 (success)
exit:     POP     {PC}
bad_reg:  MOVS    R0, 8       // return code 8 (invalid register for this register position)
          POP     {PC}
