jmp idt_class

idtr:
	dw idt_end - idt - 1
	dd idt

idt:
idt_end:

idt_class: