.syntax unified
.cpu cortex-m0plus
.thumb

// .type print_error, %function
// .global print_error

// 00 success
// 01 expected an opcode (or unexpected character)
// 02 expected label or opcode
// 03 expected colon at end of label
// 04 opcode not found

// 05 expected digit

// 06 expected register
// 07 invalid general-purpose register number
// 08 invalid register for this register position
// 09 invalid register combo for this instruction

// 0A immediate value too large

// 0B extra input at end of statement

            .align  4
no_colon:   .asciz  "Error: Expected colon at end of label"
            .align  4
no_opcode:  .asciz  "Error: Expected an opcode"
            .align  4
not_found:  .asciz  "Error: Opcode not found"
