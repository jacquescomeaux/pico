.syntax unified
.cpu cortex-m0plus
.thumb

.type getline, %function
.global getline

getline:
        PUSH    {R4, R5, LR}    // save registers
        MOVS    R4, R0          // copy buffer start address
        MOVS    R5, 0           // beginning offset
next:   BL      uart_recv       // get a char
        CMP     R0, 0x03        // end of text (^C)
        BEQ     cancel          // don't submit, start on next line
        CMP     R0, 0x04        // end of transmission (^D)
        BEQ     done            // begin of line done, in a line submit the line
        CMP     R0, 0x7F        // delete (backspace)
        BEQ     back            // in a line go back a space, begin of line do nothing
        CMP     R0, 0x0D        // carriage return (Enter)
        BEQ     submit          // submit the line
        CMP     R0, 0x15        // NAK (^U)
        BEQ     retry           // restart the line
        // CMP     R0, 0x1B        // Escape (ESC)
        // BEQ     address         // enter a new address to edit at
        CMP     R0, 0x20        // start of printable range
        BLO     next
        CMP     R0, 0x7E        // end of printable range
        BHI     next
good:   BL      uart_send       // echo the printable char
        STRB    R0, [R4, R5]    // write the printable char
        ADDS    R5, 1           // increment buffer offset
        B       next            // get another char
cancel: MOVS    R5, 0           // reset offset
        STRB    R5, [R4, R5]    // write empty string
        LDR     R0, =crlf       // newline
        BL      putstr
        MOVS    R0, 1           // error code 1 (line canceled)
        POP     {R4, R5, PC}    // return
done:   TST     R5, R5          // check if offset is zero
        BNE     submit          // if not zero submit line
        STRB    R5, [R4, R5]    // clear input buffer
        LDR     R0, =crlf       // newline
        BL      putstr
        MOVS    R0, 2           // error code 2 (end of input)
        POP     {R4, R5, PC}    // return
back:   TST     R5, R5          // check if offset is zero
        BEQ     next            // if so get another char
        SUBS    R5, 1           // push back offset
        MOVS    R0, 0           // null byte
        STRB    R0, [R4, R5]    // delete character
        MOVS    R0, 0x08        // backspace
        BL      uart_send       // move cursor back
        MOVS    R0, '           // space
        BL      uart_send       // overwrite
        MOVS    R0, 0x08        // backspace
        BL      uart_send       // move cursor back again
        B       next            // get another char
submit: MOVS    R0, 0           // null byte
        STRB    R0, [R4, R5]    // terminate string
        MOVS    R0, 0x0D        // carriage return
        BL      uart_send
        MOVS    R0, 0x0A        // line feed
        BL      uart_send
        MOVS    R0, 0           // return code 0 (success)
        POP     {R4, R5, PC}
retry:  MOVS    R0, 0x08        // backspace
        MOVS    R1, '           // space
        MOVS    R2, R5          // repeat once per character
        MOVS    R5, 0           // reset offset
        TST     R2, R2          // check if already zero
1:      BEQ     2f              // while not zero
        STRB    R0, [R4, R5]    // write backspace
        ADDS    R5, 1
        STRB    R1, [R4, R5]    // write space
        ADDS    R5, 1
        STRB    R0, [R4, R5]    // write backspace
        ADDS    R5, 1
        SUBS    R2, 1           // decrement amount
        B       1b              // repeat
2:      STRB    R2, [R4, R5]    // terminate string
        MOVS    R0, R4          // copy buffer start address
        BL      putstr          // print backspace sequence
        MOVS    R5, 0           // null byte and reset offset
        STRB    R5, [R4]        // write empty string
        B       next            // get new chars
