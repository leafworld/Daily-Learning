;程序名：THIRD
;功能：观察多重循环对CPU计算能力消耗的影响
;所用寄存器：SI、AX、DI：偏移量。
;	           DX：已查找学生人数。
;	           CL：每个姓名已比较字符数
;	          AH、AL、BL：中间寄存器
;	          CX：循环计算平均成绩的计数器

.386
STACK   SEGMENT USE16   STACK
        DB      200     DUP(0)
STACK   ENDS
EXTRN	F10T2:FAR
DATA    SEGMENT USE16		PUBLIC
N	EQU 	5
BUF	DB	5 	DUP( 0,0,0,0,0,0,0,0,0,0,0,0,0,0)
IN_NAME	DB	13
		DB	?
		DB	13	DUP(0)
IN_SCORE	DB	6
		DB	?
		DB	6	DUP(0)
POIN	DW	0
NUM	DB	1
MENU	DB	'1=Enter the student',27H,' name and score',0AH,'2=Calculation of average',0AH,'3=Sort the score',0AH,'4=Print the list of score',0AH,'5=exit',0AH,'$'
CERR	DB	'Error chose,please chose again:&'
TIPN1	DB	'请输入第 $'
TIPN2	DB	'个学生的姓名：$'
TIPN3	DB	'个学生的成绩：$'
TIPF	DB	'学生已满$'
DATA	ENDS
CODE	SEGMENT	USE16
	ASSUME  CS:CODE,DS:DATA,SS:STACK

;一号功能
ONE	MACRO
	MOV	AH,1
	INT	21H
	ENDM

;二号功能
TWO	MACRO
	MOV	DL,NUM
	MOV	AH,2
	INT	21H
	ENDM

;九号功能
NINE	MACRO	TIP
	LEA	DX,TIP
	MOV	AH,9
	INT	21H
	ENDM

;十号功能
TEN	MACRO	IN_S
	LEA	DX,IN_S
	MOV	AH,10
	INT	21H
	ENDM
START:  MOV	AX,DATA
	MOV	DS,AX
CHOSE:	NINE	MENU
	ONE
	CMP	AL,'1'
	JNE	AVG1
	CALL	ENTRY
	JMP	CHOSE
AVG1:	CMP	AL,'2'
	JNE	SORT
	CALL	AVER
	JMP	CHOSE
SORT:	CMP	AL,'3'
	JNE	PRINT
	CALL	SORT
	JMP	CHOSE
PRINT:	CMP	AL,'4'
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
	CMP	NUM,5
	JNG	IN_N
	NINE	TIPF
IN_N:	NINE	TIPN1
	TWO
	NINE	TIPN2	
	TEN	IN_NAME
	MOV	DI,POIN
	MOV	BX,0
I_NAME:	MOV	CL,IN_NAME[BX+2]
	MOV 	BUF[DI],CL
	CMP	BL,IN_NAME[1]
	INC	BX
	INC	DI
	JNE	I_NAME
	NINE	TIPN1
	TWO
	NINE	TIPN3
	TEN	IN_SCORE
	LEA	DI,[POIN+10]
	MOV	BX,0
I_SCORE:	MOV	AL,IN_SCORE[BX+2]
	CALL	FAR	PTR 	F10T2
	MOV 	BUF[DI],AL
	CMP	BX,3
	INC 	BX
	INC 	DI
	JNE	I_SCORE
ENTRY	ENDP

AVER	PROC
;计算平均成绩
	MOV 	CX,N
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
AVER	ENDP

CODE	ENDS
	END	START