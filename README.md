# ARM assembly for fun and profit

I'm starting over.

## Hexedit

This is a bare-minimum hex editor
which fits entirely within the 252-byte boot sector
of the Raspberry Pi Pico's on-board flash.

Most of the space is dedicated
to setting up the clocks, GPIO, and UART.

Current status: almost complete.
Right now it simply echos characters received over UART.

## Assembler

An assembler that can assemble itself (WIP)

Goals:
- A subset of GNU `as` syntax
- Reasonably extensible
- Small code size
