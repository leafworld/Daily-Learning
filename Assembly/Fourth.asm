;程序名：THIRD
;功能：观察多重循环对CPU计算能力消耗的影响
;所用寄存器：SI、AX、DI：偏移量。
;	           DX：已查找学生人数。
;	           CL：每个姓名已比较字符数
;	          AH、AL、BL：中间寄存器
;	          CX：循环计算平均成绩的计数器

PUBLIC	NUM, BUF
EXTRN	SORT:NEAR, PRINT:NEAR, F10T2:NEAR
.386
INCLUDE	MACRO.LIB
STACK   SEGMENT USE16   STACK
        DB      200     DUP(0)
STACK   ENDS
DATA    SEGMENT USE16		PUBLIC
BUF	DB	5 	DUP(0,0,0,0,0,0,0,0,0,0,0,0,0,0)
IN_NAME	DB	13
		DB	?
		DB	11	DUP(0)
IN_SCORE	DB	6
		DB	?
		DB	4	DUP(0)
POIN	DW	0
NUM	DW	1
N 		EQU		5
MENU	DB	'1=Enter the student',27H,' name and score',0AH,0DH,'2=Calculation of average',0AH,0DH,'3=Sort the score',0AH,0DH,'4=Print the list of score',0AH,0DH,'5=exit',0AH,0DH,'$'
CERR	DB	'Error chose,please chose again:',0AH,0DH,'$'
TIPN1	DB	'The student',27H,'number is $'
TIPN2	DB	0AH,0DH,'Please enter the name:$'
TIPN3	DB	'Please enter the score:$'
TIPF	DB	'Can',27H,'t enter more student!',0AH,0DH,'$'
DATA	ENDS
CODE	SEGMENT	USE16	PUBLIC
	ASSUME  CS:CODE,DS:DATA,SS:STACK
	
START:  MOV	AX,DATA
	MOV	DS,AX
CHOSE:	NINE	MENU
	ONE
	TWO	0AH
	TWO	0DH
	CMP	AL,'1'
	JNE	AVG1
	CALL	ENTRY
	JMP	CHOSE
AVG1:	CMP	AL,'2'
	JNE	SORT1
	CALL	AVER
	JMP	CHOSE
SORT1:	CMP	AL,'3'
	JNE	PRINT1
	CALL	SORT
	JMP	CHOSE
PRINT1:	CMP	AL,'4'
	JNE	EXIT
	CALL	PRINT
	JMP	CHOSE
EXIT:	CMP	AL,'5'
	JE	E 
	NINE	CERR
	JMP	CHOSE
E:	MOV	AH,4CH
	INT	21H

;录入学生信息
ENTRY	PROC
	PUSH	BX
	PUSH	DI
	PUSH	CX
	PUSH	SI
	CMP	NUM,5
	JNG	IN_N
	NINE	TIPF
	JMP	EX
IN_N:	NINE	TIPN1
	MOV	BX,NUM
	ADD	BX,30H
	TWO	BL
	NINE	TIPN2
	TEN	IN_NAME
	MOV	DI,POIN
	DEC	DI
	MOV	BX,0
I_NAME:	INC	BX
	INC	DI
	MOV	CL,IN_NAME[BX+1]
	MOV 	BUF[DI],CL
	CMP	BL,IN_NAME[1]
	JNE	I_NAME
	MOV	DI,POIN
	ADD	DI,9
	MOV	BX,0
	TWO	0AH
	TWO	0DH
I_SCORE:	NINE	TIPN3 
	TEN	IN_SCORE
	TWO	0AH
	TWO	0DH
	INC BX
	INC DI
	LEA	SI,IN_SCORE[2]
	MOV	DX,16
	MOV	CL,IN_SCORE[1]
	CALL	F10T2
	MOV 	BUF[DI],AL
	CMP	BX,3
	JNE	I_SCORE
	INC	NUM
	ADD	POIN,14
	POP	SI
	POP	CX
	POP	DI
	POP	BX
EX:	RET
ENTRY	ENDP

AVER	PROC
;计算平均成绩
	PUSH	CX
	PUSH	DI
	PUSH	BX
	PUSH	SI
	PUSH	DX
	MOV 	CX,N
	LEA	DI,BUF+10
AVG:	MOVSX	BX,BUF[DI]
;优化：平均成绩计算过程,去掉乘法和除法过程
	MOVSX	AX,BUF[DI+1]
	LEA	AX,[EAX+EBX*2]
	MOV	BL,BUF[DI+2]
	LEA	ESI,[EBX+EAX*2]
	MOV	EAX,92492493H
	IMUL	ESI
	ADD	EDX,ESI
	SAR 	EDX,2
	MOV	EAX,EDX
	SHR	EAX,1FH
	ADD	EDX,EAX
	MOV	BUF[DI+3],DL
	ADD	DI,14
	LOOP	AVG
	POP	DX
	POP	SI
	POP	BX
	POP	DI
	POP	CX
	RET
AVER	ENDP

CODE	ENDS
	END	START