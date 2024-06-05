# ARM assembly for fun and profit

I'm starting over.

## Octedit

This is a bare-minimum memory editor
which fits entirely within the 256-byte boot sector
of the Raspberry Pi Pico's on-board flash.
Most of the space is dedicated
to setting up the clocks, GPIO, and UART.

To use, enter a series of octal halfwords over UART
then press G to jump to the beginning of SRAM
and begin executing them as instructions.
This is the first step in bootstrapping the whole system.

## Hexedit

A more robust and user-friendly memory editor,
which uses hexadecimal instead of octal,
validates input characters,
and displays the address and contents
of the halfword currently being edited.

The machine code for this editor
can be keyed in using octedit
as a series of 16-bit octal halfwords.

## Assembler

This is a single-pass assembler
supporting most of the ARMv6-M instruction set
using a simplified instruction syntax
in which there are
no labels,
only octal literals,
and unambiguous instruction mnemonics.

It does not allow the user to type invalid instructions.

## Better Assembler

Goals:
- A subset of GNU `as` syntax
- Reasonably extensible
- Small code size

## LISP Interpreter

A LISP interpreter for the Raspberry Pi Pico.
