bits 16

org 0x00

jmp start

%include "src/util/a20.asm"

start:
	mov ax, cs
	mov ds, ax

	mov ax, 0x0
	mov es, ax

	call enable_a20_line_16

	cli

	call gdt_init_16

	xchg bx, bx

	mov eax, cr0
	or eax, 0x1
	mov cr0, eax

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

;fetch_raw_descriptor: GDT: index (f) 1 > limit (0)

; Moving location of GDT changes errors??
[section .data]
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