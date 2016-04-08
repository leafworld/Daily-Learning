PUBLIC	F2T10
.386
DATA	SEGMENT	USE16
BUF	DB	12	DUP(?)
DATA	ENDS
CODE	SEGMENT	USE16
	ASSUME	CS:CODE,DS:DATA
F2T10	PROC
	PUSH	EBX
	PUSH	SI
	LEA	SI,BUF
	CMP	DX,32
	JNE	B
	MOVSX	EAX,AX
B:	OR	EAX,EAX
	JNS	PLUS
	NEG	EAX
	MOV 	BYTE	PTR	[SI],'-'
	INC	SI
PLUS:	MOV 	EBX,10
	CALL	RADIX
	MOV 	BYTE	PTR	[SI],'$'
	LEA	DX,BUF
	MOV 	AX,9
	INT	21H
	POP	SI
	POP	EBX
	RET
F2T10	ENDP

RADIX	PROC
	PUSH	CX
	PUSH	EDX
	XOR	CX,CX
LOP1:	XOR	EDX,EDX
	DIV	EBX
	PUSH	DX
	INC	CX
	OR	EAX,EAX
	JNZ	LOP1
LOP2:	POP	AX
	CMP	AL,10
	JB	L1
	ADD	AL,7
L1:	ADD	AL,30H
	MOV 	[SI],AL
	INC	SI
	LOOP	LOP2
	POP	EDX
	POP	CX
	RET
RADIX	ENDP
CODE	ENDS
	END