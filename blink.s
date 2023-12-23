.syntax unified
.cpu cortex-m0plus
.thumb

.equ IO_BANK0_BASE,   0x40014000
.equ GPIO25_STATUS,   (IO_BANK0_BASE + 0x0c8)
.equ GPIO25_CTRL,     (IO_BANK0_BASE + 0x0cc)

.equ SIO_BASE,          0xd0000000
.equ GPIO_OE_SET_OFST,  0x024
.equ GPIO_OUT_XOR_OFST, 0x01c

.equ ATOMIC_CLEAR,    0x3000

.type blink, %function
.global blink

blink:
  ldr r1, =GPIO25_CTRL
  movs r0, 5 // SIO function = 5
  str r0, [r1, 0]
  ldr r1, =SIO_BASE
  movs r0, 1
  lsls r0, r0, 25 // GPIO 25 (LED) output enable
  str r0, [r1, GPIO_OE_SET_OFST]
toggle_one_second:
  str r0, [r1, GPIO_OUT_XOR_OFST] // toggle GPIO 25 output level
  ldr r2, =0x1fca055 // 33.3 * 10^6 (one-third of a second at 100MHz)
1: // 3 clock cycle loop
  subs r2, r2, 1 // 1 clock cycle
  bne 1b // 2 clock cycles when taken
  b toggle_one_second
