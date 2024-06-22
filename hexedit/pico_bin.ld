ENTRY(SETUP)

MEMORY {
  FLASH(rx) : ORIGIN = 0x10000000, LENGTH = 2M
  SRAM(rwx) : ORIGIN = 0x20000000, LENGTH = 264K
}

SECTIONS {
  .text : {
    *(.text);
    . = ALIGN(4);
  } > SRAM
}
