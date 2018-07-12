;
; Global Descriptor Table (GDT)
;
; This table tells the CPU where to find certain memory addresses for
; programs that need them.
;
gdt:

gdt_null:	; null segment
	dd 0
	dd 0

gdt_code:
	dw 0FFFFh
	dw 0
	db 0
	db 10011010b
	db 11001111b
	db 0

gdt_data:
	dw 0FFFFh
	dw 0
	db 0
	db 10010010b
	db 11001111b
	db 0

gdt_end:

gdt_desc:
	dw gdt_end - gdt - 1
	dd gdt

code_segment equ gdt_code - gdt
data_segment equ gdt_data - gdt