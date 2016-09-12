AbsVal:
		bge 	r2, r0, av_done
		sub 	r2, r0, r2
av_done:
		ret
		
#;------------------------------------------------------------------------------------------

ArrayAbsVal:
		subi 	sp, sp, 8
		stw 	ra, 0(sp)
		stw 	r4, 4(sp)
		
		mov 	r4, r2
		
aav_loop:
		ldw 	r2, 0(r4)
		call 	AbsVal
		stw 	r2, 0(r4)
		addi 	r4, r4, 4
		subi 	r3, r3, 1
		bgt 	r3, r0, aav_loop

		ldw 	r4, 4(sp)
		ldw 	ra, 0(sp)
		addi 	sp, sp, 8
		ret