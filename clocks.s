.syntax unified
.cpu cortex-m0plus
.thumb

.equ CLOCKS_BASE, 0x40008000
.equ CLK_REF_CTRL_OFST, 0x30
.equ CLK_SYS_CTRL_OFST, 0x3c

.type setup_clocks, %function
.global setup_clocks

setup_clocks:
  ldr r1, =CLOCKS_BASE
  movs r0, 2 // use xosc (=0x2) as clk_ref source
  str r0, [r1, CLK_REF_CTRL_OFST]
  movs r0, 1 // use auxsrc (default pll_sys, =0x1) as clk_sys source
  str r0, [r1, CLK_SYS_CTRL_OFST]
  mov pc, lr
