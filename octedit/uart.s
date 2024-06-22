.syntax unified
.cpu cortex-m0plus
.thumb

.equ UART0_BASE, 0x40034000
.equ UARTDR_OFST, 0x00
.equ UARTFR_OFST, 0x18

.type uart_send, %function
.global uart_send

uart_send:
  ldr r1, =UART0_BASE
  movs r3, 0b1 << 5 // TX FIFO full
1:
  ldr r2, [r1, UARTFR_OFST]
  tst r2, r3
  bne 1b
  strb r0, [r1, UARTDR_OFST]
  bx lr

.type uart_recv, %function
.global uart_recv

uart_recv:
  ldr r1, =UART0_BASE
  movs r3, 0b1 << 4 // RX FIFO empty
1:
  ldr r2, [r1, UARTFR_OFST]
  tst r2, r3
  bne 1b
  ldrb r0, [r1, UARTDR_OFST]
  bx lr
