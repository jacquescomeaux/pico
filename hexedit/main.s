.syntax unified
.cpu cortex-m0plus
.thumb

.section .entry, "ax"

.type main, %function
.global main

main:
  bl start_xosc
  bl setup_clocks
  bl setup_gpio
  bl setup_uart
  b hexedit
