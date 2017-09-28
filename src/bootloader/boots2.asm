;
; Bootloader Second Stage
;
; Called by the first stage, this stage will initialize the third stage,
; which is a small kernel - which will initialize the 32/64 bit kernel.
;
; Before initializing the third stage, A20 line needs to be activated first, then protected mode.

BITS 16

;
; Memory Offset is '0x00' on the current memory address.
;
; This is the same as shown in the long jmp function.
;

org 0x00


; Clear Interrupts
cli

; Reset memory locations
push cs
pop ds

; Set main label
GLOBAL start

; Jump to main label
jmp start

start:
	; Jump to boot label
	jmp boot

%include "src/util/string.asm"
%include "src/util/a20.asm"
%include "src/util/gdt.asm"
%include "src/util/idt.asm"
%include "src/util/mode.asm"

boot:
	; Clear screen
	call clear_screen_16

	push 0x0000
	call move_cursor_16

	; Experimental Message [Temporary]
	mov si, continue_key_press_msg_16
	call print_string_16

	xor ax, ax
	mov ds, ax

	cli

	call calc_gdt_base

	; Initialize the GDT (Global Descriptor Table)
	lgdt [gdtr]

	; Initialize the IDT (Interrupt Descriptor Table)
	lidt [idtr]

	call enable_a20_line_16

	;
	; If call fails to enable A20 line, system will reboot.
	;

	; Triple Fault when attempting to enter Protected Mode
	; Must be GDT or IDTR
	call mode_protected_enter

	mov ax, SEG_DS
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	mov esp, 0x9F000

	jmp dword SEG_CS:0x1000

BITS 32
protected_boot:
	
times 2048 - ($-$$) db 0 ; Fill rest of sector with empty data.