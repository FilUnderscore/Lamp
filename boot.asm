;
; Bootloader First Stage
;
; Handle startup and load second stage.
;
bits 16
;
; Real Mode
;
; The bootloader is a 16 bit environment, as the x86 processor boots us
; into real mode.
;
; Real mode is limited to 1MB (64k) of memory. There is no virtual memory
; or memory protection.
;
; This mode uses the native segment:offset memory model.
;

;
; Registers for Real Mode (16 bit)
;
; CS
; DS
; ES
; SS
;

org 0x7C00

;
; Absolute (Exact) Memory Address = (Segment Address * 16(decimal)) + Offset
;
; We use '* 16' because we are in real mode which is 16 bit.
;
; Example: 07C0:0000 	< 07C0 is the segment, and 0 is the offset.
;
; Converting the above to the absolute address (0x7C00) by using the formula:
;
; base address = base address * segment size (16) + offset
;
; Example:
; 07C0:0000 = 07C0 * 16 (decimal) + 0
;			= 07C00 + 0 = 0x7C00
;
;
; Different segment:offset pairs yield the same absolute address,
; because they both refer to the same memory location.
;

;
; x86 registers:
;
; CS (Code Segment) - Stores the base segment address for code
; DS (Data Segment) - Stores the base segment address for data
; ES (Extra Segment) - Stores the base segment address for anything
; SS (Stack Segment) - Stores the base segment address for the stack
;

;
; 5 different processor modes
;
; Protected Mode
;
; - 32 bit processor mode, allows 32 bit registers and access of up to
;   4 gigabytes of RAM.
;
; - No interrupts available, you will need to write them yourself.
;   The use of any interrupt - hardware/software will cause a Triple Fault
;
; - Slightest mistake can cause Triple Fault.
;
; - Requires the use of Descriptor Tables, such as the (GDT, LDT and IDT)
;   (Global Descriptor Table, Local Discriptor Table, Interrupt Discriptor Table)
;
; - Gives access to 4 gigabytes of memory, with memory protection.
;
; - Segment:Offset Addressing is used along with Linear Addressing
;
; - Access and use of 32-bit registers.
;
; Unreal Mode
;
; - Real Mode with the address space (4 gigabyte limit) of Protected Mode.
;
; Virtual 8086 Mode
;
; - Mode that represents Protected Mode with a 16-bit Real Mode emulated
;   environment. BIOS interrupts are only available in Real Mode. This mode
;   provides a way of executing BIOS interrupts from within Protected Mode.
;
; Long Mode
;
; Real Mode
;

STAGE2_OFFSET equ 0x0050

GLOBAL start

[section .data]
start:
	jmp 0x0000:loader

bootdisk db 0

loader:

	; Initialize registers (AX, DS, ES)
	xor ax, ax
	mov ds, ax
	mov es, ax

	; Set up stack
	cli
	mov ss, ax
	mov bp, 0x9000
	mov sp, bp
	sti

	; Clear Direction Flag
	cld

	mov [bootdisk], dl

	;
	; Start new screen
	;
	call clear_screen_16

	;
	; Set Cursor Position to Top-Left of screen, (Column: 0, Row: 0)
	;
	push 0x0000
	call move_cursor_16

	; Used for Debugging
	;mov si, msg
	;call PrintString
	;call PrintLine

	xor ax, ax 			; Return conventional memory size
	int 0x12

	; Begins loading of sector 2 (second stage of bootloader)
	call load_sector_2

%include "include/util/read.asm"

;
; BIOS Interrupt 13h (INT) Function 0 - Reset Disk Drive
;
; Parameters
;
; INT 0x13 / AH = 0x0 - DISK : RESET DISK SYSTEM
; AH = 0x0
; DL = Drive to Reset (0 = floppy drive, 7 = hard disk drive)
;
; Returns
;
; AH = Status Code
; CF (Carry Flag) is clear if the operation is successful,
; if it is set, the operation failed.
;

%include "include/util/string.asm"

boot_second_stage_msg db "Booting into second stage...", 0

error_drive_msg db "An error occurred while booting...", 0

load_sector_2:
	; Never mistake bx for ax. Otherwise the memory of the second sector won't be copied.
	;
	; If written as
	; mov ax, 0x1000
	; mov es, ax
	; xor bx, bx
	;
	; The code will not be read.

	; '0x1000' destination of data load

	mov bx, STAGE2_OFFSET
	mov es, bx
	xor bx, bx

	mov al, 0x16		; Number of sectors to read. (default: 0x01 - 1 sector)
						; Each sector is 512 bytes.
	mov ch, 1
	mov cl, 2

	mov cx, 0x0002 		; cylinder 0, track 2

	mov dl, [bootdisk]	; Boot Drive

	xor dh, dh 			; Head 0

	; Read sectors (INT 13h / AH = 02h)
	call read_sectors_16
	jnc .success 		; Jump if no carry flag.

	;
	; If the sectors were failed to be read, an error will be printed to the screen.
	;

	mov si, error_drive_msg
	call print_string_16

	; Print Error Code (hexadecimal)
	mov dl, ah
	call print_hex_16

	retn
.success:
		; Prints "Booting into second stage..." on screen (16-bit real mode)
		mov si, boot_second_stage_msg
		call print_string_16

		; Jumps to memory location [es:bx] '0x1000:0x0', where the second stage of the bootloader
		; is located at.
		jmp STAGE2_OFFSET:0x0

		;
		; Shouldn't reach this section.
		;

		call print_line_16
		mov si, error_drive_msg
		call print_string_16

		jmp halt

%include "include/util/halt.asm"

;
; BIOS Interrupt 13h (INT) Function 0x02 - Reading Sectors
;
; Parameters
;
; INT 0x13 / AH = 0x02 - DISK : READ SECTOR(S) INTO MEMORY
; AH = 0x02
; AL = Number of sectors to read
; CH = Low eight bits of cylinder number
; CL = Sector Number (Bits 0-5) [Bits 6-7 are for hard disks]
; DH = Head Number
; DL = Drive Number [Bit 7 set for hard disks]
; ES:BX = Buffer to read sectors to
;
; Returns
;
; AH = Status Code
; AL = Number of sectors read
; CF = Clear Flag: If the operation failed, the clear flag variable
; 				   will be set, if the operation is successful,
;                  the clear flag variable will be cleared.
;

;
; Cylinder
;
; A cylinder is a group of tracks (with the same radius) on the disk.
;
; - Each track is usually divided into 512 byte sectors.
;   On floppies, there are 18 sectors per track.
;
; - A cylinder is a group of tracks with the same radius
;
; - Floppy disks have two heads
;
; - There are 2880 sectors in total;
;

;
; Floppy Disk
;
; 512 bytes per sector, 18 sectors per track, 80 tracks per side
;
; CL parameter can be from 0 - 17 (because there are only 18 sectors per track)
;
; If the value is greater than 18, the floppy controller
; generates an exception, because the sector does not exist.
;
; Because there is no handler for the exception, the CPU will
; generate a second fault exception, which leads to a Triple Fault. (hard system reboot)
;
; Some floppy disks have two heads/sides. Head 0 is on the front side,
; where sector 0 is located. Because of this, start reading from Head 0.
;
; If the DH parameter is greater than 2, the floppy controller will
; generate an exception, because the head does not exist.
;
; Because there is no handler for the exception, the CPU will generate
; a second fault exception, which leads to a Triple Fault. (hard system reboot)
;

;
; Drive Number 0 usually represents a floppy drive.
; Drive Number 1 usually represents a 5-1/4" floppy drive.
; Drive Number 7 usually represents a hard disk drive.
;

; Support LFS

; Pad the rest of the file with zeros through to byte 510.
times 510 - ($ - $$)  db 0

;
; Boot sector
;
; Run by BIOS Interrupt 19h (INT), checking for boot signature (0xAA55)
;
; 0xAA55 makes sure that the file is a valid bootsector, as byte 511-512 are 0xAA 0x55
;
; If found, executes the bootloader at 0x7C00 memory location.
;
; Can either be 'dw 0xAA55' or 'db 0x55AA'

dw 0xAA55
