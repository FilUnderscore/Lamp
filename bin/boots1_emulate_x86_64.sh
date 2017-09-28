echo "";
echo "Emulating bootloader/boots1.bin using qemu x86/64 bit system."
echo "";

qemu-system-x86_64 -drive format=raw,file=bootloader/boots1.bin 