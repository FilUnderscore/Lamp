/*
 * ioutil.cpp
 *
 *  Created on: 30/09/2017
 *      Author: Filip Jerkovic
 */

#include <ioutil.h>

int memcpy(void* source, void* dest, long sourceOffset, long destOffset, long sourceLength)
{
	void* src;

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

	/**
	 * If dest is null or doesn't have an allocated block size,
	 * allocate the length of the source being copied.
	 */
	if(!dest || sizeof(dest) <= 0)
	{
		dest = malloc(sourceLength);
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
