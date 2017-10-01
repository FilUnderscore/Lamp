/*
 * elf_program_header_32.cpp
 *
 *  Created on: 1/10/2017
 *      Author: Filip Jerkovic
 */

#include <elf_program_header_32.h>
#include <ioutil.h>

namespace elf
{
	void* elf_program_header::getProgramHeader()
	{
		void* programHeader = malloc(ELF_32_PROGRAM_HEADER_SIZE);

		memcpy(this->segmentType, programHeader, 0, 0, 4);
		memcpy(this->p_offset, programHeader, 0, 4, 4);
		memcpy(this->p_vaddr, programHeader, 0, 8, 4);
		memcpy(this->undefForSystemVABI, programHeader, 0, 12, 4);
		memcpy(this->p_filesz, programHeader, 0, 16, 4);
		memcpy(this->p_memsz, programHeader, 0, 20, 4);
		memcpy(this->flags, programHeader, 0, 24, 4);
		memcpy(this->requiredSectionAlignment, programHeader, 0, 28, 4);

		return programHeader;
	}

	static elf_program_header* elf_program_header::getElfProgramHeader(void* programHeader)
	{
		elf_program_header_32* elfProgramHeader = elf_program_header_32();

		memcpy(programHeader, elfProgramHeader->segmentType, 0, 0, 4);
		memcpy(programHeader, elfProgramHeader->p_offset, 4, 0, 4);
		memcpy(programHeader, elfProgramHeader->p_vaddr, 8, 0, 4);
		memcpy(programHeader, elfProgramHeader->undefForSystemVABI, 12, 0, 4);
		memcpy(programHeader, elfProgramHeader->p_filesz, 16, 0, 4);
		memcpy(programHeader, elfProgramHeader->p_memsz, 20, 0, 4);
		memcpy(programHeader, elfProgramHeader->flags, 24, 0, 4);
		memcpy(programHeader, elfProgramHeader->requiredSectionAlignment, 28, 0, 4);

		return elfProgramHeader;
	}
}
