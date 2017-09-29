/*
 * elf_header_64.cpp
 *
 *  Created on: 30/09/2017
 *      Author: filipjerkovic
 */

#include <elf_header_64.h>

#include <ioutil.h>

using namespace util;

namespace elf
{
	char* elf_header::getHeader()
	{
		char* header;

		header[0] = this->magicNumber;

		memcpy((char*)this->magicName, header, 0, 1, 3);

		header[4] = this->architecture;
		header[5] = this->endianness;
		header[6] = this->elfVersion;
		header[7] = this->osABI;

		memcpy((char*)malloc(8), header, 0, 8, 8);

		memcpy(&this->type, header, 0, 16, 2);
		memcpy(&this->instructionSet, header, 0, 18, 2);
		memcpy(this->elfVersion2, header, 0, 20, 3);

		memcpy(this->programEntryPosition, header, 0, 24, 3);

		memcpy(this->programHeaderTablePosition, header, 0, 28, 3);
		memcpy(this->sectionHeaderTablePosition, header, 0, 32, 3);

		memcpy(this->flags, header, 0, 36, 3);
		memcpy(this->headerSize, header, 0, 40, 2);

		memcpy(this->sizeOfEntryInProgramHeaderTable, header, 0, 42, 2);
		memcpy(this->numberOfEntriesInProgramHeaderTable, header, 0, 44, 2);

		memcpy(this->sizeOfEntryInSectionHeaderTable, header, 0, 46, 2);
		memcpy(this->numberOfEntriesInSectionHeaderTable, header, 0, 48, 2);

		memcpy(this->indexInSectionHeaderTableWithSectionNames, header, 0, 50, 2);

		return header;
	}
} /* namespace elf */
