.syntax unified
.cpu cortex-m0plus
.thumb

.equ UART0_BASE, 0x40034000
.equ UARTDR_OFST,     0x00
.equ UARTFR_OFST,     0x18

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

.type send_hex, %function
.global send_hex

send_hex:
  push {lr}
  movs r4, r0
  movs r0, '0
  bl uart_send
  movs r0, 'x
  bl uart_send
  movs r5, 8 // eight nibbles in a word
0:
  movs r0, 28 // rotate left 4
  rors r4, r0
  movs r0, 0xF // lowest nibble mask
  ands r0, r4
  cmp r0, 0x9 // number or letter?
  bhi 1f
  adds r0, '0
  b 2f
1:
  adds r0, ('A - 0xA)
2:
  bl uart_send
  subs r5, 1
  bne 0b
  movs r0, '\r
  bl uart_send
  movs r0, '\n
  bl uart_send
  pop {pc}
