# Tutorial 4
# DoubleListValues(list_ptr, n)::
# 	for i=0 to n-1 do
# 		list_ptr[i]=list_ptr[i]+list_ptr[i]
# 	end for
	
DoubleListValues:
	subi 	sp, sp, 12
	stw 	r2, 8(sp)
	stw 	r3, 4(sp)
	stw 	r4, 0(sp)
double_loop:
	ldw 	r4, 0(r2)
	add 	r4, r4, r4
	stw 	r4, 0(r2)
	addi 	r2, r2, 4
	subi 	r3, r3, 1
	bgt 	r3, r0, double_loop
	
	ldw		r2, 8(sp)
	ldw 	r3, 4(sp)
	ldw 	r4, 0(sp)
	addi 	sp, sp, 12
	ret

