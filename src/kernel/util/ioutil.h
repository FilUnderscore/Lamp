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

namespace util
{
	int memcpy(char* source, char* dest, long sourceOffset, long destOffset, long sourceLength);
}

#endif /* UTIL_IOUTIL_H_ */
