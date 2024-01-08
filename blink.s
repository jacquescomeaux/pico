.syntax unified
.cpu cortex-m0plus
.thumb

.equ IO_BANK0_BASE,   0x40014000
.equ GPIO25_STATUS,   (IO_BANK0_BASE + 0x0c8)
.equ GPIO25_CTRL,     (IO_BANK0_BASE + 0x0cc)

.equ SIO_BASE,          0xd0000000
.equ GPIO_OUT_SET_OFST, 0x014
.equ GPIO_OUT_XOR_OFST, 0x01c
.equ GPIO_OE_SET_OFST,  0x024

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

.type led_on, %function
.global led_on

led_on:
  ldr r1, =SIO_BASE
  movs r0, 1
  lsls r0, 25
  str r0, [r1, GPIO_OUT_SET_OFST]
1:
  b 1b

.type blink, %function
.global blink

blink:
  ldr r1, =SIO_BASE
  movs r0, 1
  lsls r0, 25
1:
  str r0, [r1, GPIO_OUT_XOR_OFST]
  bl delay_1s
  b 1b

.type long_blink, %function
.global long_blink

long_blink:
  push {lr}
  ldr r1, =SIO_BASE
  movs r0, 1
  lsls r0, 25
  bl delay_1s
  str r0, [r1, GPIO_OUT_XOR_OFST]
  bl delay_1s
  str r0, [r1, GPIO_OUT_XOR_OFST]
  bl delay_1s
  pop {pc}

.type blinkN, %function
.global blinkN

blinkN:
  push {lr}
  ldr r1, =SIO_BASE
  movs r2, 1
  lsls r2, 25
  tst r0, r0
  beq done
on_then_off:
  str r2, [r1, GPIO_OUT_XOR_OFST]
  bl delay_quick
  str r2, [r1, GPIO_OUT_XOR_OFST]
  bl delay_quick
  subs r0, r0, 1
  bne on_then_off
done:
  pop {pc}

.type blink_hex, %function
.global blink_hex

blink_hex:
  push {lr}
  movs r4, r0
  movs r5, 0xf
1:
  ands r0, r5
  bl blinkN
  lsrs r4, 4
  beq 2f
  bl long_blink
  movs r0, r4
  b 1b
2:
  pop {pc}
