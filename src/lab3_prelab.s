#---------------------------------------------------------------------------------------------------
#	ELEC 274 Lab 3 Pre-lab
#	lab3.s
#	Kin Yee Ho
# 	11kyh1
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
		movia 	r3, MSG1
		call 	PrintString
		movia 	r3, MSG2
		call 	PrintString
		movia 	r3, BUFFER
		movi 	r4, 0
		call 	GetString
		movia 	r3, BUFFER
		call	PrintString
		movi 	r2, '\n'
		call 	PrintChar

_end:
		br 		_end
		
		
#---------------------------------------------------------------------------------------------------
#takes r3 as input

PrintString:
		subi	sp, sp, 4
		stw 	ra, 0(sp)
ps_loop:
		ldb		r2, 0(r3)
		beq 	r2, r0, ps_done
		call 	PrintChar
		addi 	r3, r3, 1
		br 		ps_loop
ps_done:
		ldw 	ra, 0(sp)
		addi 	sp, sp, 4
		ret

#---------------------------------------------------------------------------------------------------

GetString:
		subi 	sp, sp, 8
		stw 	r5, 4(sp)
		stw 	ra, 0(sp)
		
gs_loop:
		call 	GetChar
		movi 	r5, '\n'
		beq 	r2, r5, gs_done
		movi 	r5, '\r'
		beq 	r2, r5, gs_done
		beq 	r4, r0, gs_alpha
		movi 	r5, 'A'
		blt 	r2, r5, gs_loop
		movi 	r5, 'Z'
		bgt 	r2, r5, gs_lower
		br 		gs_alpha

gs_lower:
		movi 	r5, 'a'
		blt 	r2, r5, gs_loop
		movi 	r5, 'z'
		bgt 	r2, r5, gs_loop
		subi 	r2, r2, 32
		br 		gs_alpha

gs_alpha:
		call 	PrintChar
		stw 	r2, 0(r3)
		addi 	r3, r3, 1
		br 		gs_loop

gs_done:
		stw 	r0, 0(r3)
		movi 	r2, '\n'
		call 	PrintChar
		
		ldw 	ra, 0(sp)
		ldw 	r5, 4(sp)
		addi 	sp, sp, 8
		ret
		
		
#---------------------------------------------------------------------------------------------------
#takes r2 as input for ch

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
		ldw		r3, 0(sp)
		ldw 	r4, 4(sp)
		addi 	sp, sp, 8
		ret
		
#---------------------------------------------------------------------------------------------------
#		
#GetChar:
#		movia 	r6, 0x10001000
#gc_loop:
#		ldwio 	r2, 0(r6)
#		addi 	r7, r2, 0x8000
#		beq 	r7, r0, gc_loop
#		
#		andi 	r2, r2, 0xFF
#		ret		
#		
#---------------------------------------------------------------------------------------------------		

GetChar:
		subi 	sp, sp, 8
		stw 	r3, 4(sp)
		stw 	r4, 0(sp)
		
		movia 	r3, 0x10001000
gc_loop:
		ldwio 	r2, 0(r3)
		andi 	r4, r2, 0x8000
		beq 	r4, r0, gc_loop
		
		andi 	r2, r2, 0xFF

		ldw 	r4, 0(sp)
		ldw 	r3, 4(sp)
		addi 	sp, sp, 8
		ret		
				
#---------------------------------------------------------------------------------------------------		
		.org 	0x00001000
		
N:		.word 	8
BUFFER: .skip	20*4
MSG1:	.asciz 	"ELEC 274 Lab 3\n"
MSG2:	.asciz 	"enter characters and press Enter: "		

		.end


		