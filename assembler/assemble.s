.syntax unified
.cpu cortex-m0plus
.thumb

.type assemble, %function
.global assemble

// TODO:
// - make subroutine addresses explicit
// - test each instruction
// - decide on additional push or pops
// - add GO to get_char

assemble:   PUSH    {LR}
            LDR     R0, =uart_send
            LDR     R1, =get_char
            // ADDS    R0, 1
            // ADDS    R1, 1
            MOV     R9, R0
            MOV     R10, R1
            MOVS    R6, 0
            MOVS    R0, ' 
            MOV     R8, R0
            LDR     R1, =opcode
            // ADDS    R1, 1
            BLX     R1
            MOV     R0, R8
            BLX     R9
            MOVS    R7, R4
main_loop:  LSRS    R0, R7, 8       // just peek
            BNE     skip            // if more stuff then skip
            MOVS    R0, '\r
            MOV     R8, R0          // set end char to carriage return
skip:       UXTB    R0, R7          // store lsb in R0
            LSRS    R1, R0, 4       // upper nibble
            CMP     R1, 0xC         // if 0xxxxxxx or 10xxxxxx
            BLO     handle_op
            CMP     R1, 0xE         // if 110xyyyy
            BLO     handle_imm
handle_reg: MOVS    R1, (1<<4)      // bit 4 mask // if 111xyyyy
            ANDS    R0, R1          // get bit 4
            ADDS    R0, 3           // add 3 to it (now 3 or 4)
            LDR     R1, =register
            // ADDS    R1, 1
            BLX     R1
            MOVS    R0, 0x0F        // lower nibble mask
            ANDS    R0, R7          // store shift amount in R0
            LSLS    R4, R0          // shift the result by the shift amount
            ORRS    R6, R4          // OR the register code into the word under construction
            B       done_stuff
handle_op:  MOVS    R2, 9           // shift amount for 7-bit opcode
            MOVS    R1, (1<<7)      // bit 7 mask
            TST     R0, R1          // check bit 7
            BEQ     fin             // if zero done
            BICS    R0, R1          // clear bit 7
            MOVS    R2, 11          // shift amount for 5-bit opcode high
            MOVS    R1, (1<<5)      // bit 5 mask
            TST     R0, R1          // check bit 5
            BEQ     fin             // if zero done
            BICS    R0, R1          // clear bit 5
            MOVS    R2, 6           // shift amount for 5-bit opcode low
fin:        LSLS    R0, R2
            ORRS    R6, R0
            B       here
handle_imm: MOVS    R1, 0x0F        // lower nibble mask
            ANDS    R0, R1          // store immediate width in R0
            LDR     R1, =octal
            // ADDS    R1, 1
            BLX     R1              // result is put in R4
            LSLS    R0, R7, 27
            LSRS    R0, 31
            MOVS    R2, 6
            MULS    R0, R2          // R0 has shift amount (0 or 6)
            LSLS    R4, R0          // shift the result by the shift amount
            ORRS    R6, R4          // OR the immediate into the word under construction
done_stuff: MOV     R0, R8          // copy the end_char into R0
            BLX     R9              // echo the space (or carriage return)
here:       LSRS    R7, 0x8         // get next parse instruction
            BNE     main_loop       // if it's nonzero there are more things to parse
done:       MOVS    R0, '\n         // send newline
            BLX     R9
            POP     {PC}
