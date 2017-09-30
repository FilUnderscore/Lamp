/*
 * elf.h
 *
 *  Created on: 29/09/2017
 *      Author: filipjerkovic
 */

#ifndef ELF_H_
#define ELF_H_

#include <elf_header.h>

#include <string>

using namespace std;

namespace elf
{
	class elf
	{
	public:
		/*
		 * CONSTRUCTORS
		 */

		virtual elf();
		virtual ~elf();

		/*
		 * VARIABLES
		 */

		virtual void* fileData;

		virtual elf_header* header;

		/*
		 * METHODS
		 */

		/**
		 * Get the "ELF header" of the file.
		 *
		 * @return ELF header instance of the ELF file instance.
		 */
		virtual elf_header* getHeader();

		/**
		 * Read the data of an ELF file.
		 *
		 * @return ELF file instance, constructed from the ELF file data.
		 */
		static elf readElf(void* elf);
	};
} /* namespace elf */

#endif /* ELF_H_ */
