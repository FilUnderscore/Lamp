[bits 16]

gdt_basic_flat_model_start:

gdt_basic_flat_model_null_descriptor:
	dd 0x0
	dd 0x0

gdt_basic_flat_model_code_segment_descriptor:
	dw 0xffff

	dw 0x0

	db 0x0

	db 10011010b

	db 11001111b

	db 0x0

gdt_basic_flat_model_data_segment_descriptor:
	dw 0xffff
	
	dw 0x0
	
	db 0x0

	db 10010010b

	db 11001111b

	db 0x0

gdt_basic_flat_model_end:

gdt_basic_flat_model_descriptor:
	dw gdt_basic_flat_model_end - gdt_basic_flat_model_start - 1

	dd gdt_basic_flat_model_start

CODE_SEGMENT equ gdt_basic_flat_model_code_segment_descriptor - gdt_basic_flat_model_start
DATA_SEGMENT equ gdt_basic_flat_model_data_segment_descriptor - gdt_basic_flat_model_start