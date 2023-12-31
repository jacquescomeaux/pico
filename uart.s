.syntax unified
.cpu cortex-m0plus
.thumb

.equ RESETS_BASE,     0x4000c000
.equ RESET_OFST,      0x0
.equ RESET_DONE_OFST, 0x8

.equ CLOCKS_BASE, 0x40008000
.equ CLK_REF_CTRL_OFST, 0x30
.equ CLK_SYS_CTRL_OFST, 0x3c
.equ CLK_PERI_CTRL_OFST, 0x48

.equ UART0_BASE, 0x40034000
.equ UARTDR_OFST, 0x00
.equ UARTFR_OFST, 0x18
.equ UARTIBRD_OFST, 0x24
.equ UARTFBRD_OFST, 0x28
.equ UARTLCR_H_OFST, 0x2c
.equ UARTCR_OFST, 0x30

.equ IO_BANK0_BASE, 0x40014000
.equ GPIO0_CTRL_OFST, 0x04
.equ GPIO1_CTRL_OFST, 0x0c

.equ ATOMIC_SET,    0x2000
.equ ATOMIC_CLEAR,    0x3000

.type setup_uart, %function
.global setup_uart

setup_uart:

  // Enable clk_peri
  movs r0, 0x1 // set enable bit (0x1 << 11)
  lsls r0, 11
  movs r1, 0x4 // use xosc (=0x4 << 5) as clk_ref source
  lsls r1, 5
  orrs r0, r1
  ldr r1, =CLOCKS_BASE
  str r0, [r1, CLK_PERI_CTRL_OFST]

  // Reset UART0
  movs r0, 1
  lsls r0, r0, 22 // UART0 is bit 22

  // Assert the reset
  ldr r1, =(RESETS_BASE + ATOMIC_SET)
  str r0, [r1, RESET_OFST]

  // Deassert the reset
  ldr r1, =(RESETS_BASE + ATOMIC_CLEAR)
  str r0, [r1, RESET_OFST]

  // Check if reset done
  ldr r1, =RESETS_BASE
1:
  ldr r2, [r1, RESET_DONE_OFST]
  tst r0, r2
  beq 1b

  // Configure GPIO 0 and 1 as UART0
  ldr r1, =IO_BANK0_BASE
  movs r0, 2 // UART function = 2
  str r0, [r1, GPIO0_CTRL_OFST]
  str r0, [r1, GPIO1_CTRL_OFST]

  // Set the baud rate divisors
  movs r0, 6 // integer baud rate = 6
  ldr r0, [r1, UARTIBRD_OFST]
  movs r0, 33 // fractional baud rate = 33
  ldr r0, [r1, UARTFBRD_OFST]

  // Enable the FIFOs and set the format
  movs r0, 0x70 // word len 8 bits (bits 6:5 = 0b11), bit 4 (FIFO en)
  str r0, [r1, UARTLCR_H_OFST]

  // Set enable bits in the control register
  ldr r1, =UART0_BASE
  movs r0, 0x3
  lsls r0, 8 // set bits 8 and 9 (TX and RX enable)
  adds r0, 0x1 // set bit 0 (UART enable)
  str r0, [r1, UARTCR_OFST]

  bx lr

.type uart_send, %function
.global uart_send

uart_send:
  ldr r1, =UART0_BASE
poll_TXFF:
  ldr r2, [r1, UARTFR_OFST]
  movs r3, 0x20 // bit 5 (TX FIFO full)
  tst r2, r3
  bne poll_TXFF
  movs r2, 0xff
  ands r0, r2
  str r0, [r1, UARTDR_OFST]
  bx lr

.type uart_recv, %function
.global uart_recv

uart_recv:
  ldr r1, =UART0_BASE
poll_RXFE:
  ldr r2, [r1, UARTFR_OFST]
  movs r3, 0x10 // bit 4 (RX FIFO empty)
  tst r2, r3
  bne poll_RXFE
  ldr r0, [r1, UARTDR_OFST]
  bx lr
