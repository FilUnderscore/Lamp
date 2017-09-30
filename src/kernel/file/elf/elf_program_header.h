/*
 * elf_program_header.h
 *
 *  Created on: 1/10/2017
 *      Author: Filip Jerkovic
 */

#ifndef FILE_ELF_ELF_PROGRAM_HEADER_H_
#define FILE_ELF_ELF_PROGRAM_HEADER_H_

namespace elf
{
	class elf_program_header
	{
	public:
		/*
		 * CONSTRUCTORS
		 */
		virtual elf_program_header();
		virtual ~elf_program_header();

		/*
		 * VARIABLES
		 */

		/**
		 * Type of segment (see beneath)
		 */
		void* segmentType;

		/*
		 * 0 = null (ignore the entry)
		 * 1 = load (clear p_memsz bytes at p_vaddr to 0, then copy p_filez bytes from p_offset to p_vaddr)
		 * 2 = dynamic (requires dynamic linking)
		 * 3 = interp (contains a file path to an executable to use as an interpreter for the following segment)
		 * 4 = note section
		 *
		 * Note: There are more values, but mostly contain architecture/
		 * environment specific information, which is probably not required
		 * for the majority of ELF files.
		 */

		/**
		 * Flags (see beneath)
		 */
		void* flags;

		/*
		 * 1 = executable
		 * 2 = writable
		 * 4 = readable
		 */

		/**
		 * The offset in the file that the data for this segment can be found.
		 */
		void* p_offset;

		/**
		 * Where you should start to put this segment in virtual memory.
		 */
		void* p_vaddr;

		/**
		 * Undefined for System V ABI.
		 */
		void* undefForSystemVABI;

		/**
		 * Size of segment in the file.
		 */
		void* p_filesz;

		/**
		 * Size of the segment in memory.
		 */
		void* p_memsz;

		/**
		 * The required alignment for this section (must be a power of 2).
		 */
		void* requiredSectionAlignment;

		/*
		 * METHODS
		 */
		virtual void* getProgramHeader();

		static virtual elf_program_header* getElfProgramHeader(void* programHeader);
	};
}

#endif /* FILE_ELF_ELF_PROGRAM_HEADER_H_ */
