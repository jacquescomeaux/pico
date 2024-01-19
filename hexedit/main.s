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
  bl uart_recv
  bl uart_send
  b 1b
