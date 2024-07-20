<0100 putstr
register zero  : string offset
register one   : current character, uart status
register two   : tx fifo full bitmask
register three : uart zero base
LL      R3 5            load uart zero base
DI      R2 40           tx fifo full bitmask
LI5     R1 R3 6         get uart status
BT      R1 R2           check if ready to send
JN      374             loop if not ready
LBI     R1 R0 0         load one char from memory
BT      R1 R1           test byte
JE      2               done if zero
SBI     R1 R3 0         send one byte
AAI8    R0 1            increment string pointer
JA      3766            next char
JR      R14             jump to link register
Q       0400 00         uart zero base
Q       0400 03
<0180 getstr
register zero  : string offset
register one   : current character, uart status
register two   : rx fifo empty bitmask
register three : uart zero base
LL      R3 12           load uart zero base
DI      R2 60           rx fifo empty or tx fifo full bitmask
LI5     R1 R3 6         get uart status
BT      R1 R2           check if ready to receive and transmit
JN      374             loop if not ready
LBI     R1 R3 0         get one char
SBI     R1 R3 0         echo the char
CI      R1 015          compare to carriage return
JE      2               done if equal
SBI     R1 R0 0         write one char to memory
AAI8    R0 1            increment string pointer
JA      3764            next char
DI      R1 000          null byte
SBI     R1 R0 0         store null byte
DI      R2 40           tx fifo full bitmask
LI5     R1 R3 6         get uart status
BT      R1 R2           check if ready to transmit
JN      374             loop if not ready
DI      R1 012          newline
SBI     R1 R3 0         send newline
JR      R14             jump to link register
Q       0000 00         alignment
Q       0400 00         uart zero base
Q       0400 03
<0200 cmpstr
DI      R4 0
LBR     R2 R0 R4
LBR     R3 R1 R4
CR3     R2 R3
JN      3
CI      R2 0
JE      1
AAI8    R4 1
JA      3767
JR      R14
