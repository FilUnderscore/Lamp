;
; Bootloader Second Stage
;
; Called by the first stage, this stage will initialize the third stage,
; which is a small kernel - which will initialize the 32/64 bit kernel.
;
; Before initializing the third stage, A16

BITS 16

;
; Memory Offset is '0x0' on the current memory address.
;
; This is the same as shown in the long jmp function.
;

org 0x0

cli
push cs
pop ds

GLOBAL start

jmp start

start:
	jmp boot

%include "src/bootloader/util/string.asm"

boot:
	call ClearScreen

	; Experimental Message [Temporary]
	mov si, continue_key_press_msg
	call PrintString

	cli
	hlt

times 512 - ($-$$) db 0 ; Fill rest of sector with empty data.