jmp reboot_class

reboot_system_16:
    db 0x0ea 
    dw 0x0000 
    dw 0xffff 

reboot_class: