BOOTCCFLAGS = -std=gnu2x -Oz -g0 -fno-inline-functions -fno-align-functions -fno-aligned-allocation -fno-allow-editor-placeholders -fno-data-sections -ffreestanding -fno-function-sections -fno-keep-static-consts -fmerge-all-constants -fpack-struct=1 -freg-struct-return -freroll-loops -fno-stack-protector -fstrict-enums -fno-trapping-math -fno-unroll-loops -funsafe-math-optimizations -fno-unwind-tables -fno-zero-initialized-in-bss -mstack-alignment=1 -mno-stackrealign -ffast-math -mregparm=3
CCFLAGS = -Wall -Wextra -Werror -pedantic -pedantic-errors
BOOTLLCFLAGS = -march=x86 -mattr=+16bit-mode -mcpu=i386
LLCFLAGS = 
BOOTASFLAGS = -32 -march=i386 -mtune=i8086
ASFLAGS = 
BOOTOPTFLAGS = -Oz

OPTLAGS = 
BOOTLDFLAGS = -melf_i386 --build-id=none -T linker.ld
LDFLAGS = 

all : os

os : bootloader
	@cat boot.bin > os.iso

bootloader : boot.c
	@clang $(CCFLAGS) $(BOOTCCFLAGS) -c -emit-llvm -m16 -o boot.ll boot.c
	@llc $(LLCFLAGS) $(BOOTLLCFLAGS) -o boot.s boot.ll
	@as $(ASFLAGS) $(BOOTASFLAGS) -o boot.o boot.s
	@objcopy -O binary boot.o boot.bin
	@echo -e \\x1b[32mBOOTLOADER SIZE: $$(cat boot.bin | wc -c)/510 \(~$$(($$(cat boot.bin | wc -c) * 100 / 510))%, $$(($$(cat boot.bin | wc -c) - 510))b\)\\x1b[m
	@ld $(LDFLAGS) $(BOOTLDFLAGS) -o boot-final.o boot.o
	@objcopy -O binary boot-final.o boot.bin

dbg :
	objdump -D -mi386 -Mintel,addr16,data16 boot.o

clean :
	rm boot.bin boot-final.o boot.ll boot.o boot.s 

emu : os
	@qemu-system-x86_64 -drive format=raw,file=os.iso -full-screen -no-reboot