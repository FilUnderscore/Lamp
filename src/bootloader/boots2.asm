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

boot:
	; Clear screen
	call clear_screen_16

	push 0x0000
	call move_cursor_16

	; Experimental Message [Temporary]
	mov si, continue_key_press_msg_16
	call print_string_16

	call enable_a20_line_16

	;
	; If call fails to enable A20 line, system will reboot.
	;

	; Initialize the GDT (Global Descriptor Table)
	lgdt [gdt_descriptor]

times 2048 - ($-$$) db 0 ; Fill rest of sector with empty data.