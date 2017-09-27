echo "";
echo "Emulating bin/boots1.bin using qemu x86/64 bit system."
echo "";

qemu-system-x86_64 -drive format=raw,file=bin/boots1.bin 