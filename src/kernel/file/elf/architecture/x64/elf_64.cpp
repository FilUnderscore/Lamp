/*
 * elf_64.cpp
 *
 *  Created on: 30/09/2017
 *      Author: Filip Jerkovic
 */

#include <elf_64.h>
#include <elf_header_64.h>
#include <elf_program_header_64.h>

#include <ioutil.h>

namespace elf
{
	static elf elf::readElf(void* elf)
	{
		elf_64* elf64 = elf_64();

		/*
		 * Set ELF file data.
		 */

		elf64->fileData = elf;

	   /*
		* Set up ELF header.
		*/

		void* header = malloc(ELF_64_HEADER_SIZE);
		memcpy(elf, header, 0, 0, ELF_64_HEADER_SIZE);
		elf64->header = elf_header_64::getElfHeader(header);

		void* programHeader = malloc(ELF_64_PROGRAM_HEADER_SIZE);
		memcpy(elf, programHeader, 0, 0, ELF_64_PROGRAM_HEADER_SIZE);
		elf64->programHeader = elf_program_header_64::getElfProgramHeader(programHeader);

		return elf64;
	}

	elf_header* elf::getHeader()
	{
		return this->header;
	}

	elf_program_header* elf::getProgramHeader()
	{
		return this->programHeader;
	}

	elf_64::elf_64()
	{

	}

	elf_64::~elf_64()
	{

	}
}
