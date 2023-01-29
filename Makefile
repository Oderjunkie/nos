BOOTASFLAGS = -32 -march=i386 -mtune=i8086
ASFLAGS = 
BOOTLDFLAGS = -melf_i386 --build-id=none -T linker.ld
LDFLAGS = 

all : os

os : bootloader
	@cat boot.bin > os.iso

bootloader : boot.s
	@as $(ASFLAGS) $(BOOTASFLAGS) -o boot.o boot.s
	@objcopy -j .text -j .data -j .rodata -O binary boot.o boot.bin
	@echo -e \\x1b[32mBOOTLOADER SIZE: $$(cat boot.bin | wc -c)/510 \(~$$(($$(cat boot.bin | wc -c) * 100 / 510))%, $$(($$(cat boot.bin | wc -c) - 510))b\)\\x1b[m
	@ld $(LDFLAGS) $(BOOTLDFLAGS) -o boot2.o boot.o
	@objcopy -O binary boot2.o boot.bin

dbg :
	objdump -D -mi386 -Mintel,addr16,data16 boot.o

clean :
	rm boot.bin boot2.o boot.o

emu : os
	@qemu-system-x86_64 -drive format=raw,file=os.iso -full-screen -no-reboot