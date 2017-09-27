all: BOOTLOADER # Also add kernel for building.

BOOTLOADER: BOOT_STAGE_1 BOOT_STAGE_2
	@echo "\nBeginning assembly of the bootloader.\n"

	dd if=/dev/zero of="bootloader/bin/boot.iso" bs=1024 count=720 # Count determines amount of 512b sectors.
	dd if="bootloader/bin/boots1.bin" of="bootloader/bin/boot.iso" seek=0 conv=notrunc
	dd if="bootloader/bin/boots2.bin" of="bootloader/bin/boot.iso" bs=512 seek=1 conv=notrunc

	@echo "\nAssembly of boot image file complete. Can be found in bin directory.\n"

BOOT_STAGE_1:
	@echo "\nBeginning boot stage 1 assembly.\n"

	nasm -f bin bootloader/src/boots1.asm -o bootloader/bin/boots1.bin

	@echo "\nAssembled boot stage 1. Can be found in bin directory.\n"

BOOT_STAGE_2:
	@echo "\nBeginning boot stage 2 assembly and link to kernel.\n"

	nasm -f bin bootloader/src/boots2.asm -o bootloader/bin/boots2.bin

	@echo "\nAssembled boot stage 2. Can be found in bin directory.\n"

BOOT_STAGE_3:
	#Small kernel, which will initialize the main 32/64-bit kernel.