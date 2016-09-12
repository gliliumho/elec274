#---------------------------------------------------------------------------------------------------
#	lab2.s
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
		movia 	r3, MSG1			#prepare input for PrintString
		movi  	r4, 1
		call 	PrintString			#call PrintString to print ("ELEC 274 Lab 2\n")
		movia 	r3, MSG2			#prepare input for PrintSring
		call 	PrintString			#print ("result from list processing is ")
		ldw 	r2, N(r0)			#prepare number of elements in list
		movi 	r3, LIST 			#load list to be processed
		#movi 	r4, 0 				#prepare r4 as the output register
		call 	ProcessData			
		call 	PrintHexDigit		
		movi 	r2, '\n'			#prepare for printing new line
		call 	PrintChar

_end:
		br 		_end


#---------------------------------------------------------------------------------------------------


PrintString:
		subi	sp, sp, 4
		stw 	ra, 0(sp)
loop:
		ldb		r2, 0(r3)
		beq 	r2, r0, done
		call 	PrintChar
		beq 	r4, r0, no_vert
		movi 	r2, '\n'
		call 	PrintChar
no_vert:
		addi 	r3, r3, 1
		br 		loop
done:
		ldw 	ra, 0(sp)
		addi 	sp, sp, 4
		ret

#---------------------------------------------------------------------------------------------------

ProcessData:
		subi 	sp,sp,8
		stw     r4, 4(sp)
		stw     r5, 0(sp)
		ldw 	r4, 0(r3)
		
pd_loop:
		ldw 	r5, 0(r3)
		bge 	r5, r4, pd_diff
		mov	 	r4, r5
			
pd_diff:
		subi 	r2, r2, 1
		addi	r3, r3, 4
		beq 	r2, r0, pd_done
		br	 	pd_loop
			
pd_done:
		mov 	r2, r4
		ldw 	r5, 0(sp)
		ldw 	r4, 4(sp)
		addi 	sp,sp,8
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

PrintHexDigit:
		subi	sp, sp, 4
		stw 	ra, 0(sp)
		movi	r3, 10
		bge 	r2, r3, if_higher
		addi 	r2, r2, '0'
		br 		done_hex
if_higher:
		subi 	r2, r2, 10
		addi 	r2, r2, 'A'
done_hex:
		call 	PrintChar
		ldw 	ra, 0(sp)
		addi 	sp, sp, 4
		ret

	
#---------------------------------------------------------------------------------------------------

		.org 	0x00001000

N:		.word 	8
##FLAG: .word 	1
LIST: 	.word	15, 14, 15, 11, 15, 13, 15, 12
MSG1:	.asciz 	"ELEC 274 Lab 2\n"
MSG2:	.asciz 	"result from list processing is "

		.end