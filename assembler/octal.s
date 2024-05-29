.syntax unified
.cpu cortex-m0plus
.thumb

.type octal, %function
.global octal

octal:  PUSH    {LR}            // 0c0000 0xB500  ; SAVE LINK REGISTER
        MOVS    R5, R0          // 0x0002 0x0005  ; SAVE BIT WIDTH
        BNE     30f             // 0x0004 0xD1    ; SKIP IF BIT WIDTH != 0
10:     BLX     R10             // 0x0006 0x      ; GET CHAR
        CMP     R0, '0          // 0x000A 0x2830  ; COMPARE TO '0 CHAR
        BNE     10b             // 0x000C 0xD1    ; GET ANOTHER CHAR IF NOT '0
        BLX     R9              // 0x000E 0x      ; OTHERWISE ECHO '0 CHAR
        MOVS    R4, 0           // 0x0012 0x2400  ; SET RESULT TO 0
20:     BLX     R10             // 0x0014 0x      ; GET CHAR
        BNE     20b             // 0x0018 0xD1    ; LOOP IF NOT END CHAR
        POP     {PC}            // 0x001A 0xBD00  ; RETURN IF END CHAR
30:     MOVS    R0, 3           // 0x001C 0x2003  ; DEFAULT TO 3
        CMP     R5, 3           // 0x001E 0x2D03  ; CHECK BIT WIDTH
        BHS     40f             // 0x0020 0xD2    ; IF BIT WIDTH >= 3 KEEP R0 == 3
        MOVS    R0, R5          // 0x0022 0x0028  ; IF BIT WIDTH < 3 COPY TO R0
40:     MOVS    R4, 1           // 0x0024 0x2401  ; 2^0
        LSLS    R4, R0          // 0x0026 0x4084  ; 2^(MAX(BIT WIDTH, 3))
        ADDS    R4, ('0 - 1)    // 0x0028 0x342F  ; '1 OR '3 or '7
50:     BLX     R10             // 0x002A 0x      ; GET FIRST CHAR
        CMP     R0, '0          // 0x002E 0x2830  ; COMPARE WITH '0
        BLO     50b             // 0x0030 0xD3    ; RETRY IF BELOW OCTAL RANGE
        CMP     R0, R4          // 0x0032 0x42A0  ; COMPARE WITH END CHAR
        BHI     50b             // 0x0034 0xD8    ; RETRY IF ABOVE RANGE
        BLX     R9              // 0x0036 0x      ; ECHO IF IN RANGE
        SUBS    R0, '0          // 0x003A 0x3830  ; GET VALUE FROM CHAR
        MOVS    R4, R0          // 0x003C 0x0004  ; STORE VALUE IN RESULT
        MOVS    R1, 0           // 0x003E 0x2100  ; BIT WIDTH FOR FIRST CHAR
60:     ADDS    R1, 1           // 0x0040 0x3101  ; INCREMENT FIRST CHAR WIDTH
        LSRS    R0, 1           // 0x0042 0x0840  ; SHIFT RIGHT ONE BIT
        BNE     60b             // 0x0044 0x      ; IF NONZERO STAY IN LOOP
        SUBS    R5, R1          // 0x0046 0x1A6D  ; SUBTRACT FIRST CHAR WIDTH FROM TOTAL
70:     CMP     R5, 3           // 0x0048 0x2D03  ; COMPARE BIT WIDTH TO 3
        BLO     80f             // 0x004A 0xD3    ; EXIT LOOP IF LESS THAN 3
        BLX     R10             // 0x004C 0x      ; GET ANOTHER CHAR
        BEQ     90f             // 0x0050 0xD0    ; IF END CHAR EXIT LOOP
        CMP     R0, '0          // 0x0052 0x2830  ; BOTTOM OF OCTAL RANGE
        BLO     70b             // 0x0054 0xD3    ; RETRY IF BELOW
        CMP     R0, '7          // 0x0056 0x2837  ; TOP OF OCTAL RANGE
        BHI     70b             // 0x0058 0xD8    ; RETRY IF ABOVE
        BLX     R9              // 0x005A 0x      ; ECHO IF IN RANGE
        SUBS    R0, '0          // 0x005E 0x3830  ; GET VALUE FROM CHAR
        LSLS    R4, 3           // 0x0060 0x00E4  ; SHIFT OLD VALUE BY ONE DIGIT
        ADDS    R4, R0          // 0x0062 0x1824  ; ACCUMULATE INTO VALUE
        SUBS    R5, 3           // 0x0064 0x3D03  ; DECREMENT BIT WIDTH BY 3
        B       70b             // 0x0066 0xD0    ; LOOP FOR ANOTHER DIGIT
80:     BLX     R10             // 0x0068 0x      ; GET A CHAR
        BNE     80b             // 0x006C 0xD1    ; LOOP UNTIL END CHAR
90:     POP     {PC}            // 0x006E 0xBD00  ; RETURN
