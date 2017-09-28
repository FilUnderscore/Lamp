jmp mode_class

mode_protected_enter:
	mov eax, cr0
	or al, 1
	mov cr0, eax

mode_class: