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

.type setup_led, %function
.global setup_led

setup_led:
  ldr r1, =GPIO25_CTRL
  movs r0, 5 // SIO function = 5
  str r0, [r1, 0]
  ldr r1, =SIO_BASE
  movs r0, 1
  lsls r0, r0, 25 // GPIO 25 (LED) output enable
  str r0, [r1, GPIO_OE_SET_OFST]
  bx lr

.type blink, %function
.global blink

blink:
  movs r0, 1
  lsls r0, 25
1:
  str r0, [r1, GPIO_OUT_XOR_OFST]
  bl delay_1s
  b 1b

.type blinkN, %function
.global blinkN

blinkN:
  push {lr}
  movs r2, 1
  lsls r2, 25
  tst r0, r0
  beq done
on_then_off:
  str r2, [r1, GPIO_OUT_XOR_OFST]
  bl delay_1s
  str r2, [r1, GPIO_OUT_XOR_OFST]
  bl delay_1s
  subs r0, r0, 1
  bne on_then_off
done:
  pop {pc}
