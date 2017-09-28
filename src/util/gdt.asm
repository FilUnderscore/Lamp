jmp gdt_class

%define SEG_CS 0x08
%define SEG_DS 0x10

gdt:
	; Null Entry
	dw 0x0000
	dw 0x0000
	db 0x00
	db 0x00
	db 0x00
	db 0x00
	; CS ring0 Entry
	dw 0xFFFF
	dw 0x0000
	db 0x00
	db 0x9B
	db 0xDF
	db 0x00
	; DS ES FS GS ring0 Entry
	dw 0xFFFF
	dw 0x0000
	db 0x00
	db 0x93
	db 0xDF
	db 0x00
	; SS ring0 Entry
	dw 0x0000
	dw 0x0000
	db 0x00
	db 0x97
	db 0xDF
	db 0x00
gdtend:

gdtr:
	dw 0x0000
	dd 0x00000000

calc_gdt_base:
	mov ax, gdtend
	mov bx, gdt
	sub ax, bx
	mov word [gdtr], ax

	xor eax, eax
	mov ax, ds
	mov bx, gdt
	xor ecx, ecx
	mov cx, ax
	shl ecx, 4
	and ebx, 0x0000FFFF
	add ecx, ebx
	mov dword [gdtr + 2], ecx
	ret

gdt_class: