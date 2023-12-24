.syntax unified
.cpu cortex-m0plus
.thumb

.equ XOSC_BASE, 0x40024000
.equ CTRL_OFST, 0x0
.equ STATUS_OFST, 0x4
.equ STARTUP_OFST, 0xc

.type start_xosc, %function
.global start_xosc

start_xosc:
  ldr r1, =XOSC_BASE
  movs r0, 47 // startup delay = 47 for 12Mhz crystal
  str r0, [r1, STARTUP_OFST]
  ldr r0, =0x00fabaa0 // enable
  str r0, [r1, CTRL_OFST]
1:
  ldr r0, [r1, STATUS_OFST]
  lsrs r0, r0, 31 // poll status bit
  beq 1b
  bx lr
