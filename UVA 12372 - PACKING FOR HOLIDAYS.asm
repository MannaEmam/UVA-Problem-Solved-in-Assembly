;UVA 12372 - PACKING FOR HOLIDAYS
ORG 100H 
.DATA
T DW ? 
A DW ?  
B DW ?
R DW ?
C DW ?
MSG1 DB 'Case $'
MSG2 DB ': $'
MSG3 DB 'good$'
MSG4 DB 'bad$'
.CODE
MAIN PROC
    ;GETTING DATA SEGMENT
MOV AX,@DATA
MOV DS,AX
START:
MOV C,1;STORING 1 IN C 
   CALL INPUT;TAKING TEST CASE
   MOV T,AX;STORING AX IN T
   TOP:
CALL INPUT
MOV A,AX;STORING 1ST INPUT IN A
CALL INPUT
MOV B,AX;STORING 2ND INPUT IN B
CALL INPUT
MOV R,AX;STORING 3RD INPUT IN R
;SHOWING FIRST MESSAGE
LEA DX,MSG1
MOV AH,9
INT 21H
;SHOWING CASE NUMBER
MOV AX,C
CALL OUTPUT
;SHOWING 2ND MESSAGE
LEA DX,MSG2
MOV AH,9
INT 21H
;CHECKING
MOV BX,A
CMP BX,20
JG MESSAGE4;YES
MOV BX,B
CMP BX,20
JG MESSAGE4;YES
MOV BX,R
CMP BX,20
JG MESSAGE4;YES
 ;SHOWING 3RD MESSAGE
LEA DX,MSG3
MOV AH,9
INT 21H
JMP NEWLINE
MESSAGE4:
;SHOWING 4TH MESSAGE
LEA DX,MSG4
MOV AH,9
INT 21H
NEWLINE:
;PRINTING NEWLINE
MOV DL,13
MOV AH,2
INT 21H
MOV DL,10
MOV AH,2
INT 21H
 INC C;INCREMENTING C    
MOV CX,C;STORING C IN CX
CMP CX,T;C<=T
JLE TOP;RUNNING T TIMES
JMP START
    RET
ENDP
;A procedure that reads a 16 bit signed input
;and store that in AX
INPUT PROC
    ;Backup register values in stack
    PUSH BX
    PUSH CX
    PUSH DX
    
    ;Clear register values
    XOR BX, BX
    XOR CX, CX
    
    ;Read first character
    MOV AH, 1
    INT 21H
    
    ;Check if it is a sign or digit
    CMP AL, '-'
    JE NEGATIVE
    CMP AL, '+'
    JE POSITIVE
    JMP INPUTSCAN
    
    NEGATIVE:
    ;Store that it is negative number in CX
    MOV CX, 1
    
    POSITIVE:
    ;Take a digit input if first input is sign
    INT 21H
    
    INPUTSCAN:
    ;Convert the digit ASCII to number
    AND AX, 000FH
    ;As multiplication erases value in AX
    ;backup the digit to stack
    PUSH AX
    ;Multiply previous value by 10 and add new value
    MOV AX, 10
    MUL BX
    ;Pop new digit from stack
    POP BX
    ADD BX, AX 
    ;Read digit repeatedly until space or carriage return read
    MOV AH, 1
    INT 21H
    CMP AL, ' '
    JE ENDINPUT
	CMP AL, -1
	JE ENDFILE
    CMP AL, 13
    JE CARRIAGERETURN
    JMP INPUTSCAN
    
    CARRIAGERETURN:
    ;If last input is carriage return, print a new line
    MOV AH, 2
    MOV DL, 10
    INT 21H
    
    ;Store the positive input to AX
    ENDINPUT:
    MOV AX, BX   
    
    ;Check if the value is negative
    CMP CX, 0
    JE ENDSCAN
    NEG AX
    
    ENDFILE:
    MOV AX, -1
    
    ENDSCAN:
    ;Restore register values from stack
    POP DX
    POP CX
    POP BX
    RET
ENDP
  
OUTPUT PROC
    ;Backup register values in stack
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    ;Check if Ax is positive or negative
    CMP AX, 0
    JGE INIT
    
    PUSH AX
    MOV DL, '-'
    MOV AH, 2
    INT 21H
    POP AX
    NEG AX
    
    INIT:
    XOR CX, CX  ;Clear CX. Holds number of digits
    MOV BX, 10  ;Holds divisor
    
    DIGITIFY:
    CWD         ;Clear DX
    DIV BX
    PUSH DX     ;Push last digit to stack
    INC CX
    
    ;Check if the quotient is zero
    CMP AX, 0
    JNZ DIGITIFY
    
    ;Pop and print
    MOV AH, 2
    PRINTLOOP:
    POP DX
    OR DL, 30H  ;Convert to ASCII
    INT 21H
    LOOP PRINTLOOP
    ;Restore register values from stack
    POP DX
    POP CX
    POP BX
    POP AX
    RET
ENDP