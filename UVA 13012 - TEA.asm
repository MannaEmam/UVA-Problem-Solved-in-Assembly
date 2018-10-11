;UVA 13012 - TEA        
ORG 100H 
.DATA
A DW ?
B DW ?
C DW ?
D DW ?
E DW ?
T DW ?
COUNT DW ?
.CODE
MAIN PROC
    ;GETTING DATA SEGMENT
MOV AX,@DATA
MOV DS,AX  
 TOP:
 CALL INPUT;TAKING T
 MOV COUNT,0;COUNT = 0
 MOV T,AX;STORING AX IN T
CALL INPUT;TAKING FIRST INPUT
MOV A,AX;STORING 1ST INPUT IN A
CALL INPUT;TAKING 2ND INPUT
MOV B,AX;STORING 2ND INPUT IN B
CALL INPUT;TAKING 3RD INPUT
MOV C,AX;STORING 3RD INPUT IN C
CALL INPUT;TAKING 2ND INPUT
MOV D,AX;STORING 4TH INPUT IN D
CALL INPUT;TAKING 5TH INPUT IN E
MOV E,AX;STORING 5TH INPUT IN E
MOV BX,A; A IN BX
CMP BX,T; IF A==T?
JE COUNT1;YES
;ELSE
BACK1:
MOV BX,B;B IN BX
CMP BX,T;IF B==T?
JE COUNT2;YES
;ELSE
BACK2:
 MOV BX,C;C IN BX
CMP BX,T;IF C==T?
JE COUNT3;YES
;ELSE
BACK3:
 MOV BX,D;C IN BX
CMP BX,T;IF D==T?
JE COUNT4;YES
;ELSE
BACK4:
 MOV BX,E;E IN BX
CMP BX,T;IF E==T?
JE COUNT5;YES
;ELSE
JMP PRINT
COUNT1:
INC COUNT;COUNT += 1
JMP BACK1
COUNT2:
INC COUNT;COUNT += 1
JMP BACK2
COUNT3:
INC COUNT;COUNT += 1
JMP BACK3
COUNT4:
INC COUNT;COUNT += 1
JMP BACK4
COUNT5:
INC COUNT;COUNT += 1
PRINT:
    MOV AX,COUNT
    CALL OUTPUT
JMP TOP
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
       ;PRINTING NEW LINE
   MOV DL,13
   MOV AH,2
   INT 21H
   MOV DL,10
   MOV AH,2
   INT 21H
    
    ;Restore register values from stack
    POP DX
    POP CX
    POP BX
    POP AX
    RET
ENDP