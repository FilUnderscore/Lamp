/*
 * elf_32.cpp
 *
 *  Created on: 30/09/2017
 *      Author: Filip Jerkovic
 */

#include <elf_32.h>
#include <elf_header_32.h>

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

		void* header = malloc(52);
		memcpy(elf, header, 0, 0, 52);
		this->header = elf_header_32::getElfHeader(header);



		return elf32;
	}

	elf_header* elf::getHeader()
	{
		return this->header;
	}

	elf_32::elf_32()
	{

	}

	elf_32::~elf_32()
	{

	}
}
