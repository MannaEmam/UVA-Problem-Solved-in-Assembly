;UVA 12646 - ZERO OR ONE        
ORG 100H 
.DATA
MSG1 DB '*$'
MSG2 DB 'A$'
MSG3 DB 'B$'
MSG4 DB 'C$'
A DW ?
B DW ?
C DW ?
.CODE
MAIN PROC
    ;GETTING DATA SEGMENT
MOV AX,@DATA
MOV DS,AX  
 TOP:
CALL INPUT;TAKING FIRST INPUT
MOV A,AX;STORING 1ST INPUT IN A
CALL INPUT;TAKING 2ND INPUT
MOV B,AX;STORING 2ND INPUT IN B
CALL INPUT;TAKING 2ND INPUT
MOV C,AX;STORING 3RD INPUT IN C
MOV BX,B;STORING B IN BX
CMP BX,C;IF B==C ?
JE NEXT; IF  EQUAL THEN GO NEXT
;ELSE
MOV AX,A;STORING A IN AX
CMP AX,C;IF A==C?
JE MESSAGE3;YES THEN SHOW MESSAGE3
;ELSE
CMP AX,BX;IF A==B?
JE MESSAGE4;YES SHOW MESSAGEG4
;ELSE
JMP MESSAGE1 
NEXT:
CMP BX,A;IF B == A?
JE MESSAGE1;YES THEN GO TO MESSAGE1
;ELSE 
JMP MESSAGE2;THEN GO TO MESSAGE2
MESSAGE1:
LEA DX,MSG1
MOV AH,9
INT 21H
JMP NEWLINE
MESSAGE2:
LEA DX,MSG2
MOV AH,9
INT 21H
JMP NEWLINE
MESSAGE3:
LEA DX,MSG3
MOV AH,9
INT 21H
JMP NEWLINE
MESSAGE4:
LEA DX,MSG4
MOV AH,9
INT 21H
NEWLINE:
       ;PRINTING NEW LINE
   MOV DL,13
   MOV AH,2
   INT 21H
   MOV DL,10
   MOV AH,2
   INT 21H
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