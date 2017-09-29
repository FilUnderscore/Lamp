#ifndef ELF_HEADER_H
#define ELF_HEADER_H

#include <string>

using namespace std;

namespace elf
{
	class elf_header
	{
	public:
		uint16_t magicNumber; //Always 0x7F
		string magicName; //Always 'ELF' in ASCII
		char architecture; //1 = 32 bit, 2 = 64 bit
		char endianness; //1 = little endian, 2 = big endian
		char elfVersion; //ELF Version
		char osABI; //OS ABI - usually 0 for System V

		//position 8 -> 15 (unused / padding)

		char type; //1 = relocatable, 2 = executable, 3 = shared, 4 = core
		char instructionSet; //See table below.

		/**
		 * Instruction Set Architectures:
		 *
		 * ------------------------
		 * | Architecture | Value |
		 * |--------------|-------|
		 * | No Specific  | 0     |
		 * |--------------|-------|
		 * | x86	          | 0     |
		 * |--------------|-------|
		 * | MIPS         | 8     |
		 * |--------------|-------|
		 * | PowerPC      | 0x14  |
		 * |--------------|-------|
		 * | ARM          | 0x28  |
		 * |--------------|-------|
		 * | SuperH       | 0x2A  |
		 * |--------------|-------|
		 * | IA-64        | 0x32  |
		 * |--------------|-------|
		 * | x86-64       | 0x3E  |
		 * |--------------|-------|
		 * | AArch64      | 0xB7  |
		 * ------------------------
		 */

		char* elfVersion2; // ELF Version
		char* programEntryPosition; // Program entry position

		char* programHeaderTablePosition; //Program header table position
		char* sectionHeaderTablePosition; //Section header table position

		char* flags; //Flags - architecture dependent; see note below.

		/*
		 * The flags entry can probably be ignored for x86 ELFs, as no flags are actually defined.
		 */

		char* headerSize; //Header size

		char* sizeOfEntryInProgramHeaderTable; //Size of an entry in the program header table

		char* numberOfEntriesInProgramHeaderTable; //Number of entries in the program header table

		char* sizeOfEntryInSectionHeaderTable; //Size of an entry in the section header table

		char* numberOfEntriesInSectionHeaderTable; //Number of entries in the section header table

		char* indexInSectionHeaderTableWithSectionNames; //Index in section header table with the section names.

		char* getHeader();
	};
}
