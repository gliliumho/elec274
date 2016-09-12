#;---------------------------------------------------------------------------------------------------
#;	ELEC 274 Lab 5 Lab
#;	lab5.s
#;	Kin Yee Ho
#; 	11kyh1
#;---------------------------------------------------------------------------------------------------
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

loop:		
		movia 	r3, MSG2
		call 	PrintString
		
		movia 	r3, BUFFER
		movi 	r4, 0
		call 	GetString
		
		movia 	r3, BUFFER
		movia 	r4, EXIT
		call 	strcmp
		beq 	r2, r0, end_loop
		
else_if:
		movia 	r3, BUFFER
		movia	r4, FINDMATCH
		call	strcmp
		bne 	r2, r0, else
		movia 	r2, LIST
		ldw		r3, N(r0)
		ldw 	r4, VAL(r0)
		call	FindMatch
		br 		end_loop
		
else:
		movia	r3, MSG6
		call 	PrintString
		movia	r3, BUFFER
		call 	PrintString
		movia 	r3, MSG7
		call 	PrintString
		br 		end_loop
		
end_loop:
		movia 	r3, MSG3
		call	PrintString
		
_end:
		br 		_end
		
		
#;---------------------------------------------------------------------------------------------------
#;takes r3 as input
#;r2 is reserved for printChar

PrintString:
		subi	sp, sp, 8
		stw 	ra, 4(sp)
		stw 	r2, 0(sp)
ps_loop:
		ldb		r2, 0(r3)
		beq 	r2, r0, ps_done
		call 	PrintChar
		addi 	r3, r3, 1
		br 		ps_loop
ps_done:
		ldw 	r2,	0(sp)
		ldw 	ra, 4(sp)
		addi 	sp, sp, 8
		ret

#;---------------------------------------------------------------------------------------------------
#;r3 as pointer to str
#;r4 as flag, 1 to take input normally, 0 to ignore anything other than uppercase


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
		
		
#;---------------------------------------------------------------------------------------------------
#;takes r2 as input for ch

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
		
		ldw		r4, 0(sp)
		ldw 	r3, 4(sp)
		addi 	sp, sp, 8
		ret
		
#;---------------------------------------------------------------------------------------------------
#;takes r2 as input

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

#;---------------------------------------------------------------------------------------------------
#;r2 as output (returns 1 if different, 0 is same)
#;r3 & r4 as input str_ptr

strcmp:
		subi 	sp, sp, 8
		stw 	r5, 4(sp)
		stw 	r6, 0(sp)
				
		movi 	r2, 0
		
strcmp_loop:
		ldb 	r5, 0(r3)
		ldb 	r6, 0(r4)
		bne		r5, r6, not_eq
		beq 	r5, r0, strcmp_done
		addi 	r3, r3, 1
		addi 	r4, r4, 1
		br 		strcmp_loop
		
not_eq:
		movi 	r2, 1
		br 		strcmp_done

strcmp_done:
		ldw 	r6, 0(sp)
		ldw 	r5, 4(sp)
		addi 	sp, sp, 8
		ret

#;---------------------------------------------------------------------------------------------------

FindMatch:
		subi 	sp, sp, 12
		stw 	ra, 8(sp)
		stw 	r5, 4(sp)
		stw 	r6, 0(sp)
		
		movi 	r5, 0
		
fm_loop:
		ldw 	r6, 0(r2)
		beq 	r6, r4, fm_match
		subi 	r3, r3, 1
		beq 	r3, r0, fm_no_match
		addi 	r2, r2, 4
		br 		fm_loop
		
fm_match:
		movia 	r3, MSG4
		call 	PrintString
		br 		fm_end

fm_no_match:
		movia 	r3, MSG5
		call 	PrintString
		br 		fm_end

fm_end:
		ldw 	r6, 0(sp)
		ldw 	r5, 4(sp)
		ldw 	ra, 8(sp)
		addi 	sp, sp, 12
		ret

#;---------------------------------------------------------------------------------------------------		
		.org 	0x00001000
		
N:		.word 	5
LIST: 	.word 	1, 2, 9, 4, 5
VAL: 	.word 	3
MSG1:	.asciz 	"ELEC 274 Lab 5\n"
MSG2:	.asciz 	"> "		
MSG3: 	.asciz 	"goodbye\n"
MSG4: 	.asciz 	"matching value found\n"
MSG5: 	.asciz 	"no match\n"
MSG6: 	.asciz 	"Your command \""
MSG7: 	.asciz 	"\" is not valid.\n"
FINDMATCH: .asciz "findmatch"
EXIT: 	.asciz 	"exit"
BUFFER: .skip	20*4

		.end


		