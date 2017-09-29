;
; Bootloader Second Stage
;
; Called by the first stage, this stage will initialize the third stage,
; which is a small kernel - which will initialize the 32/64 bit kernel.
;
; Before initializing the third stage, A20 line needs to be activated first, then protected mode.

bits 16

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

	; Unsure about zeroing AX and resetting DS.
	xor ax, ax
	mov ds, ax

	call enable_a20_line_16

	;
	; If call fails to enable A20 line, system will reboot.
	;
	cli
	; Initialize the GDT (Global Descriptor Table)
	lgdt [gdt_basic_flat_model_descriptor]
	; Initialize the IDT (Interrupt Descriptor Table)
	lidt [idt]

	; Triple Fault when attempting to enter Protected Mode
	; Must be GDT or IDTR
	;call mode_protected_enter
	mov eax, cr0
	or eax, 0x1
	mov cr0, eax

	; Setting up registers for 32-bit access.
	;mov ax, SEG_DS
	;mov ds, ax
	;mov es, ax
	;mov fs, ax
	;mov gs, ax
	;mov ss, ax
	;mov esp, 0x9F000

	; Jumping to 32bit boot initialization, which prepares the C++ 32/64 bit kernel to load
	; long mode and initialize 64-bit mode if supported.
	;jmp dword SEG_CS:protected_boot
	;jmp 0x08:protected_boot
	jmp CODE_SEGMENT:protected_boot

BITS 32
protected_boot:
	mov ax, DATA_SEGMENT
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov ebp, 0x90000
	mov esp, ebp

	call protected_load

BITS 32
protected_load:
	jmp $

end:
	jmp end
times 2048 - ($-$$) db 0 ; Fill rest of sector with empty data.