;UVA 11877 - THE COCO-COLA STORE
ORG 100H 
.DATA
N DW ?
S DW ?
TEMP DW ?
.CODE
MAIN PROC 
TOP1:
CALL INPUT;TAKING N
MOV N,AX
CMP N,0;IF N == 0
JZ EXIT;YES
;ELSE
MOV N,AX;STORING N
MOV CX,0;STORING 0 IN S
MOV S,CX
MOV BX,3;STORING 3 IN BX
XOR AX,AX;CLEARING
TOP2:
     MOV AX,N;
    CMP AX,1;IF N <= 1
    JLE PRINT
    ;ELSE
    CWD
    DIV BX
    MOV TEMP,DX
    ADD S,AX;S += QUOTIENT
    ADD AX,TEMP;ADDING  QUOTIENT + REMAINDER
    MOV N,AX
    CMP N,2;IF N == 2?
    JE NEXT
    ;ELSE
    JMP TOP2
    NEXT:
    MOV N,3;STORING 3 IF N==2
    JMP TOP2
    PRINT:
    MOV AX,S;STORE RESULT IN AX
    CALL OUTPUT
    JMP TOP1
    EXIT:
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