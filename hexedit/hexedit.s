.syntax unified
.cpu cortex-m0plus
.thumb

.type hexedit, %function
.global hexedit

hexedit:
  ldr r2, =0x20000100
  movs r1, 0
getchar:
  bl uart_recv
  cmp r0, 'g
  beq stop
  subs r0, '0 // The ASCII char '0'
  bmi next
  lsls r1, 4
  adds r1, r0
  b getchar
next:
  ldr r0, [r2, 0]
  adds r2, 4
  b hexedit
stop:
  b 0x20000100
