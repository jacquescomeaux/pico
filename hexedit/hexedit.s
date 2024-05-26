.syntax unified
.cpu cortex-m0plus
.thumb

.equ SRAM_BASE, 0x20000000

.type hexedit, %function
.global hexedit

hexedit:
  ldr r6, =SRAM_BASE
  adds r5, r6, 1
10:
  movs r4, 0
20:
  bl uart_recv
  cmp r0, '\r
  beq 30f
  cmp r0, 'G
  beq 40f
  bl uart_send
  subs r0, '0
  lsls r4, 3
  adds r4, r0
  b 20b
30:
  movs r0, '\r
  bl uart_send
  movs r0, '\n
  bl uart_send
  strh r4, [r6]
  adds r6, 2
  b 10b
40:
  bx r5
