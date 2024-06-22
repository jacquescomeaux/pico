.syntax unified
.cpu cortex-m0plus
.thumb

.equ XOSC_BASE, 0x40024000
.equ CTRL_OFST, 0x0
.equ STATUS_OFST, 0x4
.equ STARTUP_OFST, 0xc

.equ CLOCKS_BASE, 0x40008000
.equ CLK_REF_CTRL_OFST,  0x30
.equ CLK_SYS_CTRL_OFST,  0x3c
.equ CLK_PERI_CTRL_OFST, 0x48

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

.type setup, %function
.global setup

setup:

  // XOSC
  ldr r1, =XOSC_BASE
  movs r0, 47 // startup delay for 12Mhz crystal
  str r0, [r1, STARTUP_OFST]
  ldr r0, =0x00fabaa0 // enable
  str r0, [r1, CTRL_OFST]
1:
  ldr r0, [r1, STATUS_OFST]
  lsrs r0, 31 // stable bit
  beq 1b

  // Clocks
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

  // Deassert resets for GPIO and UART
  movs r0, 0b1 << 5 // IO_BANK0 (bit 5)
  movs r1, 0b1 // UART0 (bit 22)
  lsls r1, 22
  orrs r0, r1
  ldr r1, =(RESETS_BASE + ATOMIC_CLEAR)
  str r0, [r1, RESET_OFST]
  ldr r1, =RESETS_BASE
1:
  ldr r2, [r1, RESET_DONE_OFST]
  tst r2, r0
  beq 1b

  // Configure and enable UART
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

  b octedit
