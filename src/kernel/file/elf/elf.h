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
		static elf readElf();

		virtual elf_header* header;

		virtual elf_header* getHeader();

		virtual elf();
		virtual ~elf();
	};
} /* namespace elf */

#endif /* ELF_H_ */
