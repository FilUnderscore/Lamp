/*
 * elf_64.cpp
 *
 *  Created on: 30/09/2017
 *      Author: Filip Jerkovic
 */

#include <elf_64.h>
#include <elf_header_64.h>

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

		void* header = malloc(64);
		memcpy(elf, header, 0, 0, 64);
		elf64->header = elf_header_64::getElfHeader(header);

		return elf64;
	}

	elf_header* elf::getHeader()
	{
		return this->header;
	}

	elf_64::elf_64()
	{

	}

	elf_64::~elf_64()
	{

	}
}
