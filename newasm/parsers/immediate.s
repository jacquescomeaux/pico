.syntax unified
.cpu cortex-m0plus
.thumb

.type immediate, %function
.global immediate

// R4 input buffer
// R2 output buffer

immediate:PUSH    {LR}
          BL      decimal
          POP     {PC}
