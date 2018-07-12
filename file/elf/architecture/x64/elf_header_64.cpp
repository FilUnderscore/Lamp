/*
 * elf_header_64.cpp
 *
 *  Created on: 30/09/2017
 *      Author: Filip Jerkovic
 */

#include <elf_header_64.h>

#include <ioutil.h>

namespace elf
{
	void* elf_header::getHeader()
	{
		void* header;

		header[0] = this->magicNumber;
		memcpy(&this->magicName, header, 0, 1, 3);

		header[4] = this->architecture;
		header[5] = this->endianness;
		header[6] = this->elfVersion;
		header[7] = this->osABI;

		memcpy(malloc(8), header, 0, 8, 8); //Reserved space, unused/padding

		memcpy(&this->type, header, 0, 16, 2);
		memcpy(&this->instructionSet, header, 0, 18, 2);
		memcpy(this->elfVersion2, header, 0, 20, 3);

		memcpy(this->programEntryPosition, header, 0, 24, 8);

		memcpy(this->programHeaderTablePosition, header, 0, 32, 8);
		memcpy(this->sectionHeaderTablePosition, header, 0, 40, 8);

		memcpy(this->flags, header, 0, 48, 3);
		memcpy(this->headerSize, header, 0, 52, 2);

		memcpy(this->sizeOfEntryInProgramHeaderTable, header, 0, 54, 2);
		memcpy(this->numberOfEntriesInProgramHeaderTable, header, 0, 56, 2);

		memcpy(this->sizeOfEntryInSectionHeaderTable, header, 0, 58, 2);
		memcpy(this->numberOfEntriesInSectionHeaderTable, header, 0, 60, 2);

		memcpy(this->indexInSectionHeaderTableWithSectionNames, header, 0, 62, 2);

		return header;
	}

	static elf_header* elf_header::getElfHeader(void* header)
	{
		elf_header_64* elfHeader = elf_header_64();

		elfHeader->magicNumber = header[0];
		memcpy(header, &elfHeader->magicName, 1, 0, 3);

		elfHeader->architecture = header[4];
		elfHeader->endianness = header[5];
		elfHeader->elfVersion = header[6];
		elfHeader->osABI = header[7];

		//Reserved space, unused/padding
		//bytes [8, 9, 10, 11, 12, 13, 14, 15]

		memcpy(header, elfHeader->type, 16, 0, 2);
		memcpy(header, elfHeader->instructionSet, 18, 0, 2);
		memcpy(header, elfHeader->elfVersion2, 20, 0, 3);

		memcpy(header, elfHeader->programEntryPosition, 24, 0, 8);

		memcpy(header, elfHeader->programHeaderTablePosition, 32, 0, 8);
		memcpy(header, elfHeader->sectionHeaderTablePosition, 40, 0, 8);

		memcpy(header, elfHeader->flags, 48, 0, 3);
		memcpy(header, elfHeader->headerSize, 52, 0, 2);

		memcpy(header, elfHeader->sizeOfEntryInProgramHeaderTable, 54, 0, 2);
		memcpy(header, elfHeader->numberOfEntriesInProgramHeaderTable, 56, 0, 2);

		memcpy(header, elfHeader->sizeOfEntryInSectionHeaderTable, 58, 0, 2);
		memcpy(header, elfHeader->numberOfEntriesInSectionHeaderTable, 60, 0, 2);

		memcpy(header, elfHeader->indexInSectionHeaderTableWithSectionNames, 62, 0, 2);

		return elfHeader;
	}
} /* namespace elf */
