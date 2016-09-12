		.text
		.global _start
		.org 0x00000000
		
_start:
		movia 	sp, 0x7FFFFC
		
		movia 	r2, LIST1
		movia 	r3, LIST2
		ldw 	r4, N(r0)
		muli 	r5, r4, 4
		add 	r2, r2, r5
		subi 	r2, r2, 4
		
loop:
		ldw 	r5, 0(r2)
		stw 	r5, 0(r3)
		subi 	r2, r2, 4
		addi 	r3, r3, 4
		subi 	r4, r4, 1
		bgt 	r4, r0, loop
		
_end:
		br 		_end
		
		.org 	0x00001000
		
N: 		.word 	6
LIST1: 	.word 	27, 192, -35, 0xFF2, 0, 1
LIST2: 	.skip 	6*4
		
		.end