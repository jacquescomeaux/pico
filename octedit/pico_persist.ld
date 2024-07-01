MEMORY {
  FLASH(rx) : ORIGIN = 0x10000000, LENGTH = 2M
  SRAM(rx) : ORIGIN = 0x20041f00, LENGTH = 252
}

SECTIONS {
  .text : {
    setup.o(.text);
    octedit.o(.text);
    uart.o(.text);
    . = LENGTH(SRAM);
  } >SRAM AT>FLASH
}
