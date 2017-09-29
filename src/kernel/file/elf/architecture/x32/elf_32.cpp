/*
 * elf_32.cpp
 *
 *  Created on: 30/09/2017
 *      Author: Filip Jerkovic
 */

#include <elf_32.h>
#include <elf_header_32.h>

namespace elf
{
	static elf::elf readElf()
	{
		elf_32 elf32 = elf_32();

		return elf32;
	}

	elf_header* elf::getHeader()
	{
		elf_header_32 elfHeader32 = elf_header_32();

		return elfHeader32;
	}

	elf_32::elf_32()
	{

	}

	elf_32::~elf_32()
	{

	}
}
