OUTPUT_FORMAT("elf32-i386");

ENTRY(main);

SECTIONS
{
    . = 0x7C00;
    .text : {
        *(.text*);
    }

    .data : {
        *(.data*);
        *(.rodata*);
    }

    .sig 0x7DFE : {
        SHORT(0xaa55);
    }
}