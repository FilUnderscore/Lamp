;; GDT

gdt_start_16:
	dd 0
	dd 0
code_16 equ $-gdt_start_16
	dw 0xFFFF
	dw 0
	db 0
	db 10011010b
	db 11001111b
	db 0
data_16 equ $-gdt_start_16
	dw 0xFFFF
	dw 0
	db 0
	db 10010010b
	db 11001111b
	db 0
gdt_table_16:
	dw gdt_table_16 - gdt_start_16 - 1
	dw gdt_start_16

gdt_init_16:
	cli
	pusha
	lgdt [gdt_table_16]
	popa
	sti
	ret