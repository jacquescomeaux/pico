.syntax unified
.cpu cortex-m0plus
.thumb

.equ RESETS_BASE, 0x4000c000
.equ RESET_OFST,      0x0
.equ RESET_DONE_OFST, 0x8

.equ ATOMIC_CLEAR,    0x3000

.type setup_gpio, %function
.global setup_gpio

setup_gpio:
  ldr r1, =(RESETS_BASE + ATOMIC_CLEAR)
  movs r0, 0b1 << 5 // IO_BANK0
  str r0, [r1, RESET_OFST]
  ldr r1, =RESETS_BASE
1:
  ldr r2, [r1, RESET_DONE_OFST]
  tst r2, r0
  beq 1b
  bx lr
