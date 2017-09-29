/*
 * ioutil.cpp
 *
 *  Created on: 30/09/2017
 *      Author: Filip Jerkovic
 */

#include <ioutil.h>

namespace util
{
	int memcpy(char* source, char* dest, long sourceOffset, long destOffset, long sourceLength)
	{
		char* src;

		//Insert assertion to make sure that (sourceOffset + sourceLength) don't exceed sourceSize

		if((sourceOffset + sourceLength) > sizeof(source))
		{
			//Overflow.
			return 1;
		}

		for(long sI = sourceOffset; sI < sourceLength; sI++)
		{
			src[sI - sourceOffset] = source[sI];
		}

		//Insert assertion to make sure that (destOffset + sourceLength) don't exceed destSize
		if((destOffset + sourceLength) > sizeof(dest))
		{
			//Overflow.
			return 1;
		}

		for(long dI = destOffset; dI < sizeof(src); dI++)
		{
			dest[dI] = src[dI - destOffset];
		}

		return 0;
	}
}
