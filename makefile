all: BOOTLOADER # Also add kernel for building.

dd=dd
asm=nasm
gcc=C:\cygwin64\home\Filip\opt\cross\bin\x86_64-elf-gcc

BOOTLOADER: BOOT_STAGE_1 BOOT_STAGE_2 KERNEL
	@echo "\nBeginning assembly of the bootloader.\n"

	#$(dd) if=/dev/zero of="bin/bootloader/boot.iso" bs=512 count=32 # Count determines amount of 512b sectors.
	#$(dd) if="bin/bootloader/boots1.bin" of="bin/bootloader/boot.iso" seek=0 conv=notrunc
	#$(dd) if="bin/bootloader/boots2.bin" of="bin/bootloader/boot.iso" seek=1 conv=notrunc

	$(gcc) -lgcc -Tlinker.ld -nostdlib -ffreestanding bin/bootloader/boots2.o bin/kernel/kernel.o -o kernel.bin

	$(dd) if=/dev/zero of="boot.bin" bs=512 count=32
	$(dd) if="bin/bootloader/boots1.bin" of="boot.bin" seek=0 conv=notrunc
	$(dd) if="kernel.bin" of="boot.bin" seek=1 conv=notrunc

	@echo "\nAssembly of boot image file complete. Can be found in bin directory.\n"

BOOT_STAGE_1:
	@echo "\nBeginning boot stage 1 assembly.\n"

	$(asm) -f bin src/bootloader/boots1.asm -o bin/bootloader/boots1.bin

	@echo "\nAssembled boot stage 1. Can be found in bin directory.\n"

BOOT_STAGE_2:
	@echo "\nBeginning boot stage 2 assembly and link to kernel.\n"

	$(asm) -f elf64 src/bootloader/boots2.asm -o bin/bootloader/boots2.o

	@echo "\nAssembled boot stage 2. Can be found in bin directory.\n"

KERNEL:
	$(gcc) -ffreestanding -nostdlib -nostdinc -fno-builtin -fno-stack-protector -mcmodel=large -mno-red-zone -mno-mmx -mno-sse -mno-sse2 -Wall -Wextra -Werror -c src/kernel/kernel/kernel.c -o bin/kernel/kernel.o
