/*
 * elf_64.cpp
 *
 *  Created on: 30/09/2017
 *      Author: filipjerkovic
 */

#include <elf_64.h>
#include <elf_header_64.h>

namespace elf
{
	static elf::elf readElf()
	{
		elf_64 elf64 = elf_64();

		return elf64;
	}

	elf_header* elf::getHeader()
	{
		elf_header_64 elfHeader64 = elf_header_64();

		return elfHeader64;
	}

	elf_64::elf_64()
	{

	}

	elf_64::~elf_64()
	{

	}
}
