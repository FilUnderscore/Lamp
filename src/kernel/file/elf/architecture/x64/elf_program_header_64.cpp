/*
 * elf_program_header_64.cpp
 *
 *  Created on: 1/10/2017
 *      Author: Filip Jerkovic
 */

#include <elf_program_header_64.h>
#include <ioutil.h>

namespace elf
{
	void* elf_program_header::getProgramHeader()
	{
		void* programHeader = malloc(ELF_32_PROGRAM_HEADER_SIZE);

		memcpy(this->segmentType, programHeader, 0, 0, 4);
		memcpy(this->flags, programHeader, 0, 4, 4);
		memcpy(this->p_offset, programHeader, 0, 8, 8);
		memcpy(this->p_vaddr, programHeader, 0, 16, 8);
		memcpy(this->undefForSystemVABI, programHeader, 0, 24, 8);
		memcpy(this->p_filesz, programHeader, 0, 32, 8);
		memcpy(this->p_memsz, programHeader, 0, 40, 8);
		memcpy(this->requiredSectionAlignment, programHeader, 0, 48, 8);

		return programHeader;
	}

	static elf_program_header* elf_program_header::getElfProgramHeader(void* programHeader)
	{
		elf_program_header_64* elfProgramHeader = elf_program_header_64();

		memcpy(programHeader, elfProgramHeader->segmentType, 0, 0, 4);
		memcpy(programHeader, elfProgramHeader->flags, 4, 0, 4);
		memcpy(programHeader, elfProgramHeader->p_offset, 8, 0, 8);
		memcpy(programHeader, elfProgramHeader->p_vaddr, 16, 0, 8);
		memcpy(programHeader, elfProgramHeader->undefForSystemVABI, 24, 0, 8);
		memcpy(programHeader, elfProgramHeader->p_filesz, 32, 0, 8);
		memcpy(programHeader, elfProgramHeader->p_memsz, 40, 0, 8);
		memcpy(programHeader, elfProgramHeader->requiredSectionAlignment, 48, 0, 8);

		return elfProgramHeader;
	}
}
