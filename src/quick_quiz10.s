VectorSum:
		subi 	sp, sp, 24
		stw 	r2, 0(sp)
		stw 	r3, 4(sp)
		stw 	r4, 8(sp)
		stw 	r5, 12(sp)
		
		stw 	r6, 16(sp)
		stw 	r7, 20(sp)
		
vs_loop:
		ldw 	r6, 0(r2)
		ldw 	r7, 0(r3)
		add 	r6, r6, r7
		stw 	r6, 0(r4)
		
		addi 	r2, r2, 4
		addi 	r3, r3, 4
		addi 	r4, r4, 4
		subi 	r5, r5, 1
		bgt		r5, r0, vs_loop

vs_done:
		ldw 	r7, 20(sp)
		ldw 	r6, 16(sp)
		
		ldw 	r5, 12(sp)
		ldw 	r4, 8(sp)
		ldw 	r3, 4(sp)
		ldw 	r2, 0(sp)
		addi 	sp, sp, 24
		ret