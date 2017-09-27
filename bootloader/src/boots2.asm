BITS 16

org 0x0

GLOBAL start

jmp start

start:
	cli
	push cs
	pop ds

	jmp boot

%include "bootloader/src/util/string.asm"

boot:
	call ClearScreen

	; Experimental Message [Temporary]
	mov si, continue_key_press_msg
	call PrintString

	cli
	hlt

times 512 - ($-$$) db 0 ; Fill rest of sector with empty data.