;UVA 11727 COST CUTTING
ORG 100H 
.DATA
T DW ?
C DW ?
MSG1 DB 'Case $'
MSG2 DB ': $'
.CODE
MAIN PROC
    ;GETTING DATA SEGMENT
MOV AX,@DATA
MOV DS,AX  
   CALL INPUT;TAKING TEST CASE
   MOV T,AX;STORING AX IN T
   MOV C,0;STORING C = 0
 TOP:
 XOR CX,CX;CLEARING CX
 INC C;INCREMENTING C
CALL INPUT;TAKING 1ST INPUT
MOV CX,AX;STORING  1ST INPUT IN CX
CALL INPUT;TAKING 2ND INPUT
MOV BX,AX;STORING 2ND INPUT IN BX
CMP CX,BX;IF CX > BX JUMP TO THIRD
JGE  THIRD;THEN JUMP TO THIRD
XCHG CX,BX;ELSE SORT
THIRD:
CALL INPUT;TAKING 3RD INPUT
CMP BX,AX;IF BX > AX
JGE OK;THEN JUMP TO OK
XCHG BX,AX;ELSE SORT
CMP CX,BX;IF CX > BX JUMP TO OK
JGE OK;THEN JUMP TO OK
XCHG CX,BX;ELSE SORT
OK:
;SHOWING FIRST MESSAGE
LEA DX,MSG1
MOV AH,9
INT 21H
;SHOWING CASE NUMBER
MOV AX,C
CALL OUTPUT
;SHOWING SECOND MESSAGE
LEA DX,MSG2
MOV AH,9
INT 21H
;SHOWING RESULT
MOV AX,BX
CALL OUTPUT
       ;PRINTING NEW LINE
   MOV DL,13
   MOV AH,2
   INT 21H
   MOV DL,10
   MOV AH,2
   INT 21H
    
MOV CX,C;STORING C IN CX
CMP CX,T;C<=T
JL TOP;RUNNING T TIMES
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