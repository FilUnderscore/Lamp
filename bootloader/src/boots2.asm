BITS 16

org 0x0000

jmp start

start:
	hlt

times 512 - ($-$$) db 0 ; Fill sector with empty data.