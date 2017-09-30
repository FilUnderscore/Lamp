/*
 * ioutil.h
 *
 *  Created on: 29/09/2017
 *      Author: Filip Jerkovic
 */

#ifndef UTIL_IOUTIL_H_
#define UTIL_IOUTIL_H_

#include <string>

using namespace std;

namespace sys
{
	/*
	 * METHODS
	 */

	/**
	 * Copy memory from the source to the destination using offsets and length.
	 *
	 * @param source Source
	 * @param dest Destination
	 * @param sourceOffset Offset from Source
	 * @param destOffset Offset from Destination
	 * @param sourceLength Length from Source to Length of Destination
	 *
	 * @return 0 if the operation was a success, 1 if the operation failed.
	 */
	int memcpy(void* source, void* dest, long sourceOffset, long destOffset, long sourceLength);
}

#endif /* UTIL_IOUTIL_H_ */
