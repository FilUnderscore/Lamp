;
; TODO: Fetch drive information
;

;
; Make sure mov dl, [driveno] is done before calling this label.
;
get_drive_parameters:
	mov ah, 0x08
	mov [es:di], 0000h:0000h
	int 0x13

	; Failed if carry is set.
	jc .Failed

	mov [low_max_cyl_n], ch ; Low order 8 bits of the maximum
							; cylinder number.
	mov [no_hdd], dl

	mov [logic_last_index_of_heads], dh

	;Copy [0:5] and [5:7] using CL

	mov [drive_type], bl

	mov [ptr_to_drv_param_tbl], [es:di]
.failed:
	; Failed to get drive parameters

low_max_cyl_n equ 0
no_hdd equ 0
logic_last_index_of_heads equ 0
drive_type equ 0
ptr_to_drv_param_tbl equ 0

;
; Max Capacity of Drive
;
; MaxCapacity = (sector size) x (sectors per track) x (cylinders) x (heads)
;
; Example:
; 512 (sector size) x 63 (sectors per track) x 1024 (cylinders) x 256 (heads)
; = 8,455,716,864 bytes or 7.8 GB