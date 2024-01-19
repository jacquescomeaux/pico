.syntax unified
.cpu cortex-m0plus
.thumb

.equ CLOCKS_BASE, 0x40008000
.equ CLK_REF_CTRL_OFST,  0x30
.equ CLK_SYS_CTRL_OFST,  0x3c
.equ CLK_PERI_CTRL_OFST, 0x48

.type setup_clocks, %function
.global setup_clocks

setup_clocks:

  ldr r1, =CLOCKS_BASE

  // Reference clock
  movs r0, 0x2 // src = xosc
  str r0, [r1, CLK_REF_CTRL_OFST]

  // System clock
  movs r0, 0x0 // src = clk_ref
  str r0, [r1, CLK_SYS_CTRL_OFST]

  // Peripheral clock
  movs r0, 1 // set enable
  lsls r0, 11
  adds r0, 0x4 << 5 // src = xosc
  str r0, [r1, CLK_PERI_CTRL_OFST]

  bx lr
