<0000
LL      R4 3            load string address
DRF     R0 R4
JIH     0000            print string
JIL     0174
DRF     R0 R4
JIH     0000            read string
JIL     0271
JA      3770            infinite loop
Q       0014 00
Q       0200 00
