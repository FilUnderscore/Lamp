;
; Third stage of Bootloader (32-bit Kernel)
;
; The job of this stage is to load the filesystem so that it can locate ".kbin" (Kernel binary file) and load it.
;

bits 32

;[section .text]

extern bkmain
global start
start:
	lea esp, [sys_stack]
	call bkmain

;[section .bss]
;	buff resb 0x1000

sys_stack:

;[section .data]
;	sec_id: db "DATA SECTION", 0