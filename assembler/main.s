.syntax unified
.cpu cortex-m0plus
.thumb

.type main, %function
.global main

main:
  bl start_xosc
  bl setup_clocks
  bl setup_gpio
  bl setup_uart
1:
  bl assemble
  movs r0, r6
  bl send_hex
  b 1b
