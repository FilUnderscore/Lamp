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

%include "bootloader/src/util/string.asm"

GLOBAL start

start:
	jmp 0x0000:loader

msg db "Booting...", 0

bootdisk db 0

loader:
	xor ax, ax
	mov ds, ax
	mov es, ax

	; Set up stack

	cli
	mov ss, ax
	mov sp, 0x7C00
	sti

	mov [bootdisk], dl

	call ClearScreen

	push 0x0000
	call MoveCursor

	mov si, msg
	call PrintStr
	call PrintLine

	;xor ax, ax
	;int 0x12

	;call reset_hard_disk_drive

	;call read_hard_disk_drive

	call load_sector_2

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


boot_second_stage_msg db "Booting into second stage.", 0

error_floppy_drive_msg db "An error occurred while attempting to boot from the floppy disk.", 0

error_hard_disk_drive_msg db "An error occurred while attempting to boot from the hard disk.", 0

load_sector_2:

	mov al, 0x01		; load sector 1
	mov bx, 0x7E00		; destination
	mov cx, 0x0002		; cylinder 0, sector 2
	mov dl, 0x80		; Boot Drive
	mov dh, 0x0
	mov es, bx
	mov bx, 0x0

	xor dh, dh			; Head 0

	call read_sectors
	jnc .success
	
	mov si, error_hard_disk_drive_msg
	call PrintStr

	mov dx, ax
	call PrintHex

	jmp halt
.success:
		mov si, boot_second_stage_msg
		call PrintStr

halt:
	cli
	hlt
	jmp halt

read_sectors:
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

read_floppy_drive:
	mov ah, 0x02 ; function 0x02 (2)
	mov al, 1 ; read 1 sector
	mov ch, 1 ; reading the second sector past, so still on track 1
	mov cl, 2 ; sector to read (second sector)
	mov dh, 0 ; head number
	mov dl, 0 ; drive number (drive 0 is the floppy drive)
	int 0x13 ; call BIOS interrupt - Read the sector
	jc read_floppy_drive

	mov si, boot_second_stage_msg
	call PrintString

	jmp 0x1000:0x0 ; Jump to execute the sector.
				   ;
				   ; If there is a problem reading the sectors
				   ; and attempts to jump to it to execute it are made,
				   ; the CPU will execute any instructions located at
				   ; that address, whether or not the sector was loaded.
				   ;
				   ; This means that the CPU will run into either an
				   ; invalid/unknown instruction, or the end of memory.
				   ;
				   ; Both will result in a Triple Fault.

read_hard_disk_drive:
	mov ah, 0x02
	mov al, 1
	mov ch, 1
	mov cl, 2
	mov dh, 0
	mov dl, 7
	int 0x13
	jc read_hard_disk_drive

	mov si, boot_second_stage_msg
	call PrintString

	jmp 0x1000:0x0


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