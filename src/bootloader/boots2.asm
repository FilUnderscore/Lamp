;
; Bootloader Second Stage
;
; Called by the first stage, this stage will initialize the third stage,
; which is a small kernel - which will initialize the 32/64 bit kernel.
;
; Before initializing the third stage, A20 line needs to be activated first, then protected mode.
;

bits 16

; Must always be 10x the amount of STAGE2_OFFSET found in boots1.asm
org 0x0500

GLOBAL start

; Jumps to start label
jmp start

;
; INCLUDED FILES
;
%include "src/util/string.asm"
%include "src/util/a20.asm"
%include "src/util/gdt.asm"
%include "src/util/idt.asm"

; Main label
start:
	; Clears the screen from the first stage.
	call clear_screen_16

	; Moves the cursor to the top-left of the screen.
	push 0x0000
	call move_cursor_16

	; Experimental Message [Temporary]
	mov si, continue_key_press_msg_16
	call print_string_16

	; Makes sure CS and DS are the same.
	mov ax, cs
	mov ds, ax

	; Resets ES
	mov ax, 0x0
	mov es, ax

	; Enables A20 line through a series of different checks
	call enable_a20_line_16

	; Disables interrupts (until we get a functional IDT (Interrupt Descriptor Table))
	cli

	; Resets DS
	xor ax, ax
	mov ds, ax

	; Sets the GDT (Global Descriptor Table) as found in gdt.asm
	lgdt [gdt_desc]

	; Enables 32-bit (Protected) mode
	mov eax, cr0
	or eax, 1
	mov cr0, eax

	; Jumps to protected_boot which is 32-bit now.
	jmp code_segment:protected_boot

bits 32
protected_boot:
	; Resets the registers/pointers to the data_segment var.
	mov ax, data_segment
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	; Sets the stack pointer right at the top of the free space of memory
	mov ebp, 0x90000
	mov esp, ebp

	xchg bx, bx

	;lidt [empty_idt]

	xchg bx, bx

	; Re-enables Interrupts after a valid IDT (Interrupt Descriptor Table) has been set.
	;sti

	; Jumps to boot stage 3
	jmp 0x20000:0x0008