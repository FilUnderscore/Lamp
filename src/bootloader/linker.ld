OUTPUT_FORMAT("elf32-x86-64")
ENTRY(start)
phys = 0x00020000;
SECTIONS
{
    . = phys;

    .text : AT(ADDR(.text) - phys) {
      _code = .;
      *(.text)
      *(.rodata*)
      . = ALIGN(4096);
    }
    .data : AT(ADDR(.data) - phys)
    {
      _data = .;
      *(.data)
      . = ALIGN(4096);
    }
    .bss : AT(ADDR(.bss) - phys)
    {
      _bss = .;
      *(.bss)
      *(COMMON)
      . = ALIGN(4096);
    }
    end = .;
}
