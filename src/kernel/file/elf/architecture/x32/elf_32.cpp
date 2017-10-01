/*
 * elf_32.cpp
 *
 *  Created on: 30/09/2017
 *      Author: Filip Jerkovic
 */

#include <elf_32.h>
#include <elf_header_32.h>
#include <elf_program_header_32.h>

#include <ioutil.h>

namespace elf
{
	static elf elf::readElf(void* elf)
	{
		elf_32* elf32 = elf_32();

		/*
		 * Set ELF file data.
		 */

		elf32->fileData = elf;

		/*
		 * Set up ELF header.
		 */

		void* header = malloc(ELF_32_HEADER_SIZE);
		memcpy(elf, header, 0, 0, ELF_32_HEADER_SIZE);
		this->header = elf_header_32::getElfHeader(header);

		void* programHeader = malloc(ELF_32_PROGRAM_HEADER_SIZE);
		memcpy(elf, programHeader, 0, 0, ELF_32_PROGRAM_HEADER_SIZE);
		this->programHeader = elf_program_header_32::getElfProgramHeader(programHeader);

		return elf32;
	}

	elf_header* elf::getHeader()
	{
		return this->header;
	}

	elf_program_header* elf::getProgramHeader()
	{
		return this->programHeader;
	}

	elf_32::elf_32()
	{

	}

	elf_32::~elf_32()
	{

	}
}
