jmp mode_class

mode_protected_enter:
	mov eax, cr0
	or eax, 1
	mov cr0, eax

mode_class: