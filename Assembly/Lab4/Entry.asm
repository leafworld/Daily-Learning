ENTRY	PROC
	TEN	OFFSET	IN_NAME
	MOV	CX,POIN
	MOV	DI,0
I_NAME:	MOV	BUF[CX],IN_NAME[DI+2]
	CMP	DI,IN_NAME[1]
	INC	DI
	INC	CX
	JNE	I_NAME
SCORE:	TEN	OFFSET	IN_SCORE
	LEA	CX,[POIN+10]
	MOV	DI,0
I_SCORE:	MOV	BUF[CX],IN_SCORE[DI+2]
	CMP	DI,3
	INC 	DI
	INC 	CX
	JNE	I_SCORE
ENTRY	ENDP

AVER	PROC	FAR
;计算平均成绩
AVG:	LEA	DI,BUF+10
	MOV	BL,BUF[DI]
;优化：平均成绩计算过程,去掉乘法和除法过程
	MOV	AL,BUF[DI+1]
	LEA	EAX,[EAX+EBX*2]
	MOV	BL,BUF[DI+2]
	LEA	ESI,[EBX+EAX*2]
	MOV	EAX,92492493H
	IMUL	ESI
	ADD	EDX,ESI
	SAR 	EDX,2
	MOV	EAX,EDX
	SHR	EAX,1FH
	ADD	EAX,EDX
	MOV	BUF[DI+3],AL
	ADD	DI,14
	LOOP	AVG
	DEC	COUNT
	JNZ	LOPA
AVER	ENDP

TEN	MACRO	IN_S
	MOV	DX,IN_S
	MOV	AH,10
	INT	21H
	ENDM

PUBLIC	F10T2
.386
DATA	SEGMENT	USE16
SIGN	DB	?
DATA	ENDS
CODE	SEGMENT	USE16
	ASSUME	CS:CODE,DS:DATA
F10T2	PROC	FAR
	PUSH	EBX
	MOV	EAX,0
	MOV	SIGN,0
	MOV	BL,[SI]
	CMP	BL,'+'
	JE	F10 
	CMP	BL,'-'
	JNE	NEXT2
	MOV	SIGN,1
F10:	DEC	CX
	JZ	ERR
NEXT1:	INC	SI
	MOV	BL,[SI]
NEXT2:	CMP	BL,'0'
	JB	ERR
	CMP	BL,9
	JA	ERR
	SUB	BL,30H
	MOVZX	EBX,BL
	IMUL	EAX,10
	JO	ERR
	ADD	EAX,EBX
	JO	ERR
	JS	ERR
	JC	ERR
	DEC	CX
	JNZ	NEXT1
	CMP	DX,16
	JNE	PP0
	CMP	EAX,7FFFH
	JA	ERR
PP0:	CMP	SIGN,1
	JNE	QQ
	NEG	EAX
QQ:	POP	EBX
	RET
ERR:	MOV 	SI,-1
	JMP	QQ
F10T2	ENDP