all: BOOTLOADER # Also add kernel for building.

dd=dd
asm=nasm
gpp=g++
cc=gcc

CFLAGS := -Wall -fno-builtin -nostdlib -ffreestanding -nostdinc -m32

BOOTLOADER: BOOT_STAGE_1 BOOT_STAGE_2 BOOT_STAGE_3
	@echo "\nBeginning assembly of the bootloader.\n"

	$(dd) if=/dev/zero of="bin/bootloader/boot.iso" bs=512 count=32 # Count determines amount of 512b sectors.
	$(dd) if="bin/bootloader/boots1.bin" of="bin/bootloader/boot.iso" seek=0 conv=notrunc
	$(dd) if="bin/bootloader/boots2.bin" of="bin/bootloader/boot.iso" seek=1 conv=notrunc
	$(dd) if="bin/bootloader/boots3.bin" of="bin/bootloader/boot.iso" seek=8 conv=notrunc

	@echo "\nAssembly of boot image file complete. Can be found in bin directory.\n"

BOOT_STAGE_1:
	@echo "\nBeginning boot stage 1 assembly.\n"

	$(asm) -f bin src/bootloader/boots1.asm -o bin/bootloader/boots1.bin

	@echo "\nAssembled boot stage 1. Can be found in bin directory.\n"

BOOT_STAGE_2:
	@echo "\nBeginning boot stage 2 assembly.\n"

	$(asm) -f bin src/bootloader/boots2.asm -o bin/bootloader/boots2.bin

	@echo "\nAssembled boot stage 2. Can be found in bin directory.\n"

BOOT_STAGE_3:
	@echo "\nBeginning boot stage 3 assembly.\n"

	$(asm) -f elf32 src/bootloader/boots3.asm -o bin/bootloader/boots3.o

	$(cc) $(CFLAGS) -c src/bootloader/bootkernel/bootmain.c -o bin/bootloader/bootkernel/bootmain.o

	$(cc) -T src/bootloader/linker.ld bin/bootloader/boots3.o bin/bootloader/bootkernel/bootmain.o -o bin/bootloader/boots3.bin

# Main 32/64 bit kernel.
KERNEL:
	@echo "\nBeginning kernel compile.\n"

	$(gpp) 

# Link all object files.
LINK:
	@echo "\nBeginning link.\n"

	# Link with ld/gcc

	@echo "\nLink finished.\n"

# Merge kernel and bootloader into HDD image, using LFS.
# C++ function
FILE_SYSTEM_MERGE_KERNEL_BOOTLOADER: