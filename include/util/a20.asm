; Used to check the status of the A20 line in a completely self-contained state-
; preserving way. The function can be modified as necessary by removing push's at the
; beginning and their respective pop's at the end if complete self-containment
; is not required.
;
; Returns: 0 in AX if the A20 line is siabled (memory wraps around)
; 		   1 in AX if the A20 line is enabled (memory does not wrap around)
;

jmp a20_class

check_a20_line_16:
	pushf
	push ds
	push es
	push di
	push si

	cli

	xor ax, ax ; Set ax to zero
	mov es, ax

	not ax ; ax = 0xFFFF
	mov ds, ax

	mov di, 0x0500
	mov si, 0x510

	mov al, byte [es:di]
	push ax

	mov al, byte [ds:si]
	push ax

	mov byte [es:di], 0x00
	mov byte [ds:si], 0xFF

	cmp byte [es:di], 0xFF

	pop ax
	mov byte [ds:si], al

	pop ax
	mov byte [es:di], al

	mov ax, 0
	je check_a20_exit

	mov ax, 1

check_a20_exit:
	pop si
	pop di
	pop es
	pop ds
	popf

	ret

;
; Checking the A20 line from Protected Mode. Returns to caller if A20 gate is cleared.
; Continues to A20_on if A20 line is set.
;
check_a20_line_32:
	pushad

	mov edi, 0x112345	; odd megabyte address
	mov esi, 0x012345	; even megabyte address

	mov [esi], esi		; making sure that both addresses contain different values
	mov [edi], edi		; (if A20 line is cleared, the two pointers would point to
						; the address 0x012345 that would contain 0x112345 (edit))

	cmpsd 				; Compare addresses to see if they're equivalent

	popad

	jne a20_line_enabled_32

	ret

a20_line_enabled_32:
	; TODO: Figure out a way for parent class including this file to override this label.
	retn

enable_a20_line_keyboard_controller_16:
	cli

	call .WaitKeyboardController
	mov al, 0xAD
	out 0x64, al

	call .WaitKeyboardController
	mov al, 0xD0
	out 0x64, al

	call .Wait2KeyboardController
	mov al, 0x60
	push eax

	call .WaitKeyboardController
	mov al, 0xD1
	out 0x64, al

	call .WaitKeyboardController
	pop eax
	or al, 2
	out 0x60, al

	call .WaitKeyboardController
	mov al, 0xAE
	out 0x64, al

	call .WaitKeyboardController
	sti
	ret
.WaitKeyboardController:
	in al, 0x64
	test al, 2
	jnz .WaitKeyboardController
	ret
.Wait2KeyboardController:
	in al, 0x64
	test al, 1
	jz .Wait2KeyboardController
	ret

enable_a20_line_fast_gate_16:
	in al, 0x92
	or al, 2
	out 0x92, al

enable_a20_line_bios_16:
	mov ax, 0x2401
	int 0x15

enable_a20_line_16:
	call check_a20_line_16
	cmp ax, 0
	jne .Done

	call enable_a20_line_bios_16

	call check_a20_line_16
	cmp ax, 0
	jne .Done

	;
	; Keyboard Controller Method crashes Emulator
	;

	;call enable_a20_line_keyboard_controller_16
	;call check_a20_line_16
	;cmp ax, 0
	;jne .Done

	call enable_a20_line_fast_gate_16

	call check_a20_line_16
	xchg bx, bx
	cmp ax, 0
	jne .Done
.Fail:
	jmp reboot_system_16
.Done:
	retn

%include "include/util/reboot.asm"

a20_class:
