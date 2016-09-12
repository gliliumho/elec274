		.text
		.global _start
		.org 	0x00000000
	
_start:
		movia 	sp, 0x7FFFFC
		
		movia 	r2, LIST
		ldw 	r3, N(r0)
		ldw		r4, MAX(r0)
		call 	ProcessList
		
_end:
		br 		_end	
		
#;-------------------------------------------------------------------------------------------------------------------------
#;-------------------------------------------------------------------------------------------------------------------------
		
LimitValue:
		ble 	r2, r3, lv_done
		mov 	r2, r3
lv_done:
		ret
		
#;-------------------------------------------------------------------------------------------------------------------------
#;-------------------------------------------------------------------------------------------------------------------------

ProcessList:
		subi 	sp, sp, 12
		stw 	ra, 0(sp)
		stw		r5, 4(sp)
		stw 	r6, 8(sp)
		
		mov 	r5, r2
		mov 	r6, r3
		mov 	r3, r4
		
pl_loop:
		ldw 	r2, 0(r5)
		call 	LimitValue
		stw 	r2, 0(r5)
		subi 	r6, r6, 1
		ble 	r6, r0, pl_done
		addi 	r5, r5, 4
		br 		pl_loop

pl_done:
		ldw 	r6, 8(sp)
		ldw 	r5, 4(sp)
		ldw 	ra, 0(sp)
		addi 	sp, sp, 12
		ret

		
		.org 	0x00001000

MAX: 	.word 	128
LIST: 	.word 	-34, 129, 0, 333
N: 		.word 	4

		.end

		