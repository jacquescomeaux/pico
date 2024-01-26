// R0 : string1 address
// R1 : string2 address
// Result in R0
string_compare:
  MOVS R4, 0
loop:
  LDRB R2, [R0, R4]
  LDRB R3, [R1, R4]
  CMP R2, R3
  BNE done
  CMP R2, 0
  BEQ done
  ADDS R4, 1
  B loop
done:
  BX LR
