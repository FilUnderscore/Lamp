; Make sure that we don't call the label beneath by mistake.
jmp string_class

;
; 16-bit (Real Mode) String labels
;

print_line_16:
	pusha

	mov ah, 0x0E       ;print new line sequence
	mov al, 0x0D
	int 0x10
	mov al, 0Ah
	int 0x10

	popa
	retn

print_string_16:
	pusha
	mov ah, 0x0E 	; teletype output (int 0x10, ah = 0x0E)
	mov bx, 0x0007 	; bh = page number (0), bl = foreground color (light grey)
.PrintChar:
	lodsb 			; al = [ds:si]++
	test al, al
	jz .End			; exit if null-terminator found
	int 0x10		; print character
	jmp .PrintChar	; repeat for next character
.End:
	popa
	retn

print_hex_16:
	pusha
	mov cx, 4
.CharLoop:
	dec cx

	mov ax, dx
	shr dx, 4
	and ax, 0xF

	mov bx, HEX_OUT_16
	add bx, 2
	add bx, cx

	cmp ax, 0xA
	jl .SetCharacter
	add byte [bx], 7

	jl .SetCharacter
.SetCharacter:
	add byte [bx], al

	cmp cx, 0
	je .End
	jmp .CharLoop
.End:
	mov bx, HEX_OUT_16
	call print_str_16

	popa
	ret

print_str_16:
	pusha
.StrLoop:
	mov al, [bx]
	cmp al, 0
	jne .PrintChar

	popa
	ret
.PrintChar:
	mov ah, 0x0E
	int 0x10
	add bx, 1
	jmp .StrLoop

clear_screen_16:
        push bp
        mov bp, sp
        pusha

        mov ah, 0x07        ; tells BIOS to scroll down window
        mov al, 0x00        ; clear entire window
        mov bh, 0x07        ; white on black
        mov cx, 0x00        ; specifies top left of screen as (0,0)
        mov dh, 0x18        ; 18h = 24 rows of chars
        mov dl, 0x4f        ; 4fh = 79 cols of chars
        int 0x10            ; calls video interrupt

        popa
        mov sp, bp
        pop bp
        ret

move_cursor_16:
        push bp
        mov bp, sp
        pusha

        mov dx, [bp+4]  ; get the argument from the stack. |bp| = 2, |arg| = 2
        mov ah, 0x02        ; set cursor position
        mov bh, 0x00        ; page 0 - doesn't matter, we're not using double-buffering
        int 0x10

        popa
        mov sp, bp
        pop bp
        ret

HEX_OUT_16: db '0x0000', 0

continue_key_press_msg_16 db "Press any key to continue...", 0

; Empty Label
string_class: