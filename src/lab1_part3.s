#---------------------------------------------------------------------------------------------------
#	lab1_part3.s
#---------------------------------------------------------------------------------------------------
	.equ	LAST_RAM_WORD, 	0x007FFFFC
	.equ	JTAG_UART_BASE, 0x10001000
	.equ	DATA_OFFSET,	0
	.equ	STATUS_OFFSET, 	4
	.equ	WSPACE_MASK, 	0XFFFF
	
	.text
	.global	_start
	.org	0x00000000
	
_start:
	movia	sp, LAST_RAM_WORD
	movia	r3, MSG
loop:
	ldb		r2, 0(r3)
	beq 	r2, r0, done
	call 	PrintChar
	addi 	r3, r3, 1
	br 		loop
done:
	ldw 	r2, A(r0)
	ldw		r3, B(r0)
	call 	AddValues
	stw 	r2, C(r0)
	addi 	r2, r2, 0x30
	call 	PrintChar
	movi 	r2, '\n'
	call 	PrintChar
_end:
	br 		_end



#---------------------------------------------------------------------------------------------------

AddValues:
	subi	sp, sp, 4
	stw		r16, 0(sp)
	add 	r16, r2, r3
	mov		r2, r16
	ldw		r16, 0(sp)
	addi	sp, sp, 4
	ret
	
#---------------------------------------------------------------------------------------------------

PrintChar:
	subi	sp, sp, 8
	stw		r3, 4(sp)
	stw 	r4, 0(sp)
	movia 	r3, JTAG_UART_BASE
pc_loop:
	ldwio 	r4, STATUS_OFFSET(r3)
	andhi	r4, r4, WSPACE_MASK
	beq 	r4, r0, pc_loop
	stwio	r2, DATA_OFFSET(r3)
	ldw		r3, 4(sp)
	ldw 	r4, 0(sp)
	addi 	sp, sp, 8
	ret
	
#---------------------------------------------------------------------------------------------------

	.org 	0x00001000
	
A:	.word	3
B:	.word	6
C:	.skip	4

MSG:.asciz "sum: "

	.end