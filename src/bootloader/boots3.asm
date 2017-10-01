;
; Third stage of Bootloader (32-bit Kernel)
;
; The job of this stage is to load the filesystem so that it can locate ".kbin" (Kernel binary file) and load it.
;

bits 32

protected_load:
	hlt

filesystem_info:

system_load:
