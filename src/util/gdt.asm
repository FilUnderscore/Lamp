jmp gdt_class

gdt_start:
	dd 0x0
	dd 0x0

gdt_code:
	dw 0xFFFF
	dw 0x0
	dw 0x0
	db 10011010b
	db 11001111b
	db 0x0

gdt_data:
	dw 0xFFFF
	dw 0x0
	db 0x0
	db 10010010b
	db 11001111b
	db 0x0

gdt_end:

gdt_descriptor:
	dw gdt_end - gdt_start - 1 ; size (16 bit), always one less of its true size
	dd gdt_start ; address (32 bit)

gdt_class:

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_code - gdt_start