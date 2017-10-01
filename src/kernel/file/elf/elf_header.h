#ifndef ELF_HEADER_H
#define ELF_HEADER_H

#include <string>

using namespace std;

#define ELF_32_HEADER_SIZE 52
#define ELF_64_HEADER_SIZE 64

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

		/**
		 * Always 0x7F
		 */
		uint16_t magicNumber;

		/**
		 * Always 'ELF' in ASCII text
		 */
		string magicName;

		/**
		 * ELF architecture (32/64 bit)
		 *
		 * 1 = 32 bit
		 * 2 = 64 bit
		 */
		void architecture;

		/**
		 * Endianness of the ELF file (reverse order of bytes)
		 *
		 * 1 = little endian
		 * 2 = big endian
		 */
		void endianness;

		/**
		 * ELF version
		 */
		void elfVersion;

		/**
		 * OS ABI
		 *
		 * -> usually 0 for System V
		 */
		void osABI;

		/*
		 * Byte Position [8 -> 15] = unused/padding
		 *
		 * Should be empty (0x00) bytes.
		 */

		/**
		 * Type of ELF
		 *
		 * 1 = relocatable
		 * 2 = executable
		 * 3 = shared
		 * 4 = core
		 *
		 */
		void* type;

		/**
		 * Instruction set that the ELF uses.
		 *
		 * See table beneath.
		 */
		void* instructionSet;

		/*
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

		/**
		 * ELF Version as an array.
		 */
		void* elfVersion2;

		/**
		 * Program entry position.
		 */
		void* programEntryPosition;

		/**
		 * Program header table position.
		 */
		void* programHeaderTablePosition;

		/**
		 * Section header table position.
		 */
		void* sectionHeaderTablePosition;

		/**
		 * Flags (architecture dependent)
		 *
		 * See note beneath.
		 */
		void* flags;

		/*
		 * The flags entry can probably be ignored for x86 ELFs,
		 * as no flags are actually defined.
		 */

		/**
		 * Header size
		 */
		void* headerSize;

		/**
		 * Size of an entry in the program header table.
		 */
		void* sizeOfEntryInProgramHeaderTable;

		/**
		 * Number of entries in the program header table.
		 */
		void* numberOfEntriesInProgramHeaderTable;

		/**
		 * Size of entry in the section header table.
		 */
		void* sizeOfEntryInSectionHeaderTable;

		/**
		 * Number of entries in the section header table.
		 */
		void* numberOfEntriesInSectionHeaderTable;

		/**
		 * Index in the section header table with section names.
		 */
		void* indexInSectionHeaderTableWithSectionNames;

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
