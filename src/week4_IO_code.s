		.text
		.global _start
		.org 0x00000000

_start:
		movia 	r3, 0x10001000 
	
input_poll:
		ldwio 	r4, 0(r3)  
		andi 	r5, r4, 0x8000
		beq 	r5, r0, input_poll
		
		andi 	r4, r4, 0xFF 
		
output_poll:
		
		ldwio 	r5, 4(r3) 
		andhi 	r5, r5, 0xFFFF
		beq 	r5, r0, output_poll 
			
		stwio 	r4, 0(r3)
		
		br 		input_poll
	
	

