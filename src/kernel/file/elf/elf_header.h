#ifndef ELF_HEADER_H
#define ELF_HEADER_H

#include <string>

using namespace std;

namespace elf
{
	class elf_header
	{
	public:
		/*
		 * CONSTRUCTORS
		 */
		virtual elf_header();
		virtual ~elf_header();

		/*
		 * VARIABLES
		 */

		uint16_t magicNumber; //Always 0x7F
		string magicName; //Always 'ELF' in ASCII
		void architecture; //1 = 32 bit, 2 = 64 bit
		void endianness; //1 = little endian, 2 = big endian
		void elfVersion; //ELF Version
		void osABI; //OS ABI - usually 0 for System V

		//position 8 -> 15 (unused / padding)

		void* type; //1 = relocatable, 2 = executable, 3 = shared, 4 = core
		void* instructionSet; //See table below.

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

		void* elfVersion2; // ELF Version
		void* programEntryPosition; // Program entry position

		void* programHeaderTablePosition; //Program header table position
		void* sectionHeaderTablePosition; //Section header table position

		void* flags; //Flags - architecture dependent; see note below.

		/*
		 * The flags entry can probably be ignored for x86 ELFs, as no flags are actually defined.
		 */

		void* headerSize; //Header size

		void* sizeOfEntryInProgramHeaderTable; //Size of an entry in the program header table

		void* numberOfEntriesInProgramHeaderTable; //Number of entries in the program header table

		void* sizeOfEntryInSectionHeaderTable; //Size of an entry in the section header table

		void* numberOfEntriesInSectionHeaderTable; //Number of entries in the section header table

		void* indexInSectionHeaderTableWithSectionNames; //Index in section header table with the section names.

		/*
		 *	METHODS
		 */

		/**
		 * Read the ELF header instance into a pointer.
		 *
		 * @return ELF header data
		 */
		virtual void* getHeader();

		/**
		 * Read the ELF header data into an instance.
		 *
		 * @param header ELF header data
		 *
		 * @return ELF header instance
		 */
		static virtual elf_header* getElfHeader(void* header);
	};
}
