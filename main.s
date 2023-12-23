.syntax unified
.cpu cortex-m0plus
.thumb

.type main, %function
.global main

main:
  bl start_xosc
  bl start_pll
  bl setup_clocks
  bl setup_gpio
  b blink
