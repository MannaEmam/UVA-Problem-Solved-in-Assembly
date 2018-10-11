;UVA 10812 - BEAT THE SPREAD
ORG 100H 
.DATA
T DW ?
S DW ? 
F DW ?  
MSG1 DB 'impossible $'
.CODE
MAIN PROC
    ;GETTING DATA SEGMENT
MOV AX,@DATA
MOV DS,AX
START: 
   CALL INPUT;TAKING TEST CASE
   MOV T,AX;STORING AX IN T
   TOP:
CALL INPUT
MOV S,AX;STORING 1ST INPUT IN S
CALL INPUT
MOV F,AX;STORING 2ND INPUT IN B
CMP S,AX;IF S < F
JL MESSAGE
;ELSE
MOV AX,S;AX = S
ADD AX,F;ADDING S = S+ F
MOV BX,2;STORING 2 IN BX
CWD
DIV BX ;AX / 2
CMP DX,0;IF REMAINDER 0?
JNZ MESSAGE;THEN GO TO MESSAGE
;ELSE
MOV AX,S;STORING S IN AX
ADD AX,F;AX = S+F
CWD
DIV BX
CALL OUTPUT;AX HAVE THE VALUE OF S+F/2
;SHOWING SPACE
MOV AH,2
MOV DL,32
INT 21H
MOV AX,S;STORING S IN AX
SUB AX,F;AX = S-F
CWD
DIV BX
CALL OUTPUT;AX HAVE THE VALUE OF S-F/2
JMP CHECK;NOW PRINT NEWLINE AND CHECK FOR TEST CASE 
MESSAGE:
;ELSE SHOWING MESSAGE
LEA DX,MSG1
MOV AH,9
INT 21H
CHECK:    
;PRINTING NEWLINE
MOV DL,13
MOV AH,2
INT 21H
MOV DL,10
MOV AH,2
INT 21H
CMP T,0;T >=0
JGE TOP;RUNNING T TIMES
JMP START;ELSE TAKING TEST CASE AGAIN
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