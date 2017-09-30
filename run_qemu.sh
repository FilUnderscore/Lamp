echo "";
echo "Emulating bin/bootloader/boot.iso using qemu x86/64 bit system."
echo "";

qemu-system-x86_64 -drive format=raw,file=bin/bootloader/boot.iso 