.syntax unified
.cpu cortex-m0plus
.thumb

.equ RESETS_BASE,     0x4000c000
.equ RESET_OFST,      0x0
.equ RESET_DONE_OFST, 0x8

.equ IO_BANK0_BASE,   0x40014000
.equ GPIO25_STATUS,   (IO_BANK0_BASE + 0x0c8)
.equ GPIO25_CTRL,     (IO_BANK0_BASE + 0x0cc)

.equ SIO_BASE,          0xd0000000
.equ GPIO_OE_SET_OFST,  0x024
.equ GPIO_OUT_XOR_OFST, 0x01c

.equ ATOMIC_CLEAR,    0x3000

.type main, %function
.global main
main:

  // Deassert GPIO reset
  ldr r1, =(RESETS_BASE + ATOMIC_CLEAR)
  movs r0, 0x20                           // IO_BANK0 is bit 5
  str r0, [r1, RESET_OFST]

  // Wait for GPIO reset to finish
  ldr r1, =RESETS_BASE
1:
  ldr r2, [r1, RESET_DONE_OFST]
  tst r0, r2
  beq 1b

  // Set GPIO25 function to SIO
  ldr r1, =GPIO25_CTRL
  movs r0, #5
  str r0, [r1, #0]

  ldr r1, =SIO_BASE

  // Set output enable for GPIO 25
  movs r0, #1
  lsls r0, r0, #25
  str r0, [r1, GPIO_OE_SET_OFST]

loop:

  // Toggle output level for GPIO 25
  str r0, [r1, GPIO_OUT_XOR_OFST]

  // Delay
  ldr r2, =400000
1:
  subs r2, r2, #1
  bne 1b

  b loop
