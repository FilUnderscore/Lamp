bits 16

push cs
pop ds

xor ax, ax
mov ds, ax

jmp start

start:
	cli

	xchg bx, bx

	call gdt_init_16

	xchg bx, bx

	mov eax, cr0
	or eax, 0x1
	mov cr0, eax

	xchg bx, bx

	jmp code_16:pmode

	;xchg bx, bx

bits 32
pmode:
	;jmp $

	mov ax, data_16
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov esp, 0xFFFF

	hlt

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
	dd gdt_start_16

gdt_init_16:
	cli
	pusha
	lgdt [gdt_table_16]
	popa
	sti
	ret