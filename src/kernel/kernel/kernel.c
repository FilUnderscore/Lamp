/*
 * kernel.c
 *
 *  Created on: 30/09/2017
 *      Author: Filip Jerkovic
 */

#include <vga.h>
/**
 * Initializes 32-bit kernel
 */
int main (void)
{
	/*
	 * Kernel will be initialized in 32-bit protected mode.
	 *
	 * We will need to:
	 * - Be able to hop into 8086 emulated 16-bit real mode
	 *
	 * - Detect if the CPU is 64-bit, if it is - enable 64-bit long mode.
	 *
	 */

  // __asm__ volatile ("mov %cr4, %eax; bts $5, %eax; mov %eax, %cr4");

   return 0;
}
