all : os

os : bootloader
	@cat boot.bin > os.iso

bootloader : boot.c
	@nasm -fbin -o boot.bin boot.asm

clean :
	rm boot.bin

emu : os
	@qemu-system-x86_64 -drive format=raw,file=os.iso -full-screen -no-reboot