.syntax unified
.cpu cortex-m0plus
.thumb

.equ RESETS_BASE, 0x4000c000
.equ RESET_OFST,      0x0
.equ RESET_DONE_OFST, 0x8

.equ IO_BANK0_BASE, 0x40014000
.equ GPIO0_CTRL_OFST, 0x04
.equ GPIO1_CTRL_OFST, 0x0c

.equ UART0_BASE, 0x40034000
.equ UARTDR_OFST,     0x00
.equ UARTFR_OFST,     0x18
.equ UARTIBRD_OFST,   0x24
.equ UARTFBRD_OFST,   0x28
.equ UARTLCR_H_OFST,  0x2c
.equ UARTCR_OFST,     0x30

.equ ATOMIC_SET,    0x2000
.equ ATOMIC_CLEAR,  0x3000

.type setup_uart, %function
.global setup_uart

setup_uart:

  // Deassert reset
  ldr r1, =(RESETS_BASE + ATOMIC_CLEAR)
  movs r0, 0b1 // UART0
  lsls r0, 22
  str r0, [r1, RESET_OFST]
  ldr r1, =RESETS_BASE
1:
  ldr r2, [r1, RESET_DONE_OFST]
  tst r2, r0
  beq 1b

  // Configure and enable
  ldr r1, =UART0_BASE
  movs r0, 6
  str r0, [r1, UARTIBRD_OFST]
  movs r0, 33
  str r0, [r1, UARTFBRD_OFST]
  movs r0, 0b111 << 4 // 0b11 = word len 8 bits, 0b1 = FIFO enabled
  str r0, [r1, UARTLCR_H_OFST]
  ldr r1, =(UART0_BASE + ATOMIC_SET)
  movs r0, 0b1 // UART enable
  str r0, [r1, UARTCR_OFST]

  // Configure GPIO 0 and 1 as TX and RX
  ldr r1, =IO_BANK0_BASE
  movs r0, 2 // UART function
  str r0, [r1, GPIO0_CTRL_OFST]
  str r0, [r1, GPIO1_CTRL_OFST]

  bx lr
