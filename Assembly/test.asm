.386
STACK	SEGMENT	USE16	STACK
	DB	200	DUP(0)
STACK	ENDS
DATA	SEGMENT	USE16
BUF1	DW	0,1,2,3,4,5,6,7,8,9
BUF2	DW	2	DUP(0)
DATA	ENDS
CODE	SEGMENT	USE16
	ASSUME	CS:CODE,DS:DATA,SS:STACK
START:	MOV	AX,DATA
	MOV	DS,AX
	MOV	BUF2+2,OFFSET BUF1+1
	MOV	AH,4CH
	INT	21H
CODE	ENDS
	END	START