# ARM assembly for fun and profit

I'm starting over.

## Hexedit

This is a bare-minimum hex editor
which fits entirely within the 252-byte boot sector
of the Raspberry Pi Pico's on-board flash.

Most of the space is dedicated
to setting up the clocks, GPIO, and UART.

Enter a series of octal halfwords
then press G to jump to the beginning of SRAM
and begin executing them as instructions.

This is the first step in bootstrapping the whole system.

## Better editor

A more robust and user-friendly hex editor.

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
