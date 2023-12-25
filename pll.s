.syntax unified
.cpu cortex-m0plus
.thumb

.equ RESETS_BASE,     0x4000c000
.equ RESET_OFST,      0x0
.equ RESET_DONE_OFST, 0x8

.equ PLL_SYS_BASE, 0x40028000
.equ CS_OFST, 0x0
.equ PWR_OFST, 0x4
.equ FBDIV_INT_OFST, 0x8
.equ PRIM_OFST, 0xc

.equ ATOMIC_CLEAR,    0x3000

.type start_pll, %function
.global start_pll

// configure pll_sys for 100MHz
start_pll:
  // clear reset
  ldr r1, =(RESETS_BASE + ATOMIC_CLEAR)
  movs r0, 1
  lsls r0, 12 // pll_sys is bit 12
  str r0, [r1, RESET_OFST]
  ldr r1, =RESETS_BASE
1:
  ldr r2, [r1, RESET_DONE_OFST]
  tst r0, r2 // pll_sys is still bit 12
  // wait for reset done
  beq 1b
  // set pls_sys feedback divider to 100
  ldr r1, =PLL_SYS_BASE
  movs r0, 100 // FBDIV = 100
  str r0, [r1, FBDIV_INT_OFST]
  // set pl_sys post dividers to 12 (6 * 2)
  ldr r1, =PLL_SYS_BASE
  movs r0, 6 // POSTDIV1 = 6
  lsls r0, r0, 4
  adds r0, r0, 2 // POSTDIV2 = 2
  lsls r0, r0, 12
  str r0, [r1, PRIM_OFST]
  // turn on main power and VCO
  ldr r1, =(PLL_SYS_BASE + ATOMIC_CLEAR)
  movs r0, 0x21 // power and VCO (bits 0 and 5)
  str r0, [r1, PWR_OFST]
  // wait for VCO to lock
  ldr r1, =PLL_SYS_BASE
vco_lock:
  ldr r2, [r1, CS_OFST]
  lsrs r2, r2, 31
  beq vco_lock
  // turn on post divider power
  ldr r1, =(PLL_SYS_BASE + ATOMIC_CLEAR)
  movs r0, 0x8 // postdiv (bit 3)
  str r0, [r1, PWR_OFST]
  bx lr

.type delay_1s, %function
.global delay_1s

delay_1s:
  ldr r3, =0x1fca055 // 33.3 * 10^6 (one-third of a second at 100MHz)
1: // 3 clock cycle loop
  subs r3, r3, 1 // 1 clock cycle
  bne 1b // 2 clock cycles when taken
  mov pc, lr
