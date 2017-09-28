jmp read_class

read_sectors_16:
	pusha
	mov si, 0x02	; max attempts - 1
.top:
	mov ah, 0x02	; read sectors into memory (int 0x13, ah = 0x02)

	int 0x13
	jnc .end		; exit if read succeeded

	dec si			; decrement remaining attempts
	jc .end			; exit if maximum attempts exceeded

	xor ah, ah		; reset disk system (inx 0x13, ah = 0x00)

	int 0x13		
	jnc .top		; retry if reset succeeded, otherwise exit
.end:
	popa
	retn

read_class: