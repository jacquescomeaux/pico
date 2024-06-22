.syntax unified
.cpu cortex-m0plus
.thumb

.equ SRAM_BASE, 0x20000000

.type octedit, %function
.global octedit

octedit:
  ldr r6, =SRAM_BASE
  adds r5, r6, 1
10:
  movs r4, 11
  movs r0, 0x1E
  rors r6, r0
  movs r0, 0x01
  b 1f
0:
  movs r0, 0x1D
  rors r6, r0
  movs r0, 0x07
1:
  ands r0, r6
  adds r0, 0x30
  bl uart_send
  subs r4, 1
  bne 0b
  movs r0, ' 
  bl uart_send
20:
  bl uart_recv
  cmp r0, '\r
  bne 30f
  bl uart_send
  movs r0, '\n
  bl uart_send
  strh r4, [r6]
  adds r6, 2
  b 10b
30:
  cmp r0, 'G
  bne 40f
  bx r5
40:
  cmp r0, 'B
  bne 50f
  movs r0, '\r
  bl uart_send
  subs r6, 2
  b 10b
50:
  bl uart_send
  subs r0, '0
  lsls r4, 3
  adds r4, r0
  b 20b
