ENTRY(main)

MEMORY {
  FLASH(rx) : ORIGIN = 0x10000000, LENGTH = 2M
  SRAM(rwx) : ORIGIN = 0x20001000, LENGTH = 260K
}

SECTIONS {
  .text : {
    *(.text);
    . = ALIGN(4);
  } > SRAM
}
