#include <vga.h>

void vga_write(const char *string, int color)
{
  volatile char *video = (volatile char*) 0xB8000;

  int i = 0;
  while(i < (80 * 25 * 2))
  {
    video[i] = 'G';
    video[i + 1] = 0x06;

    i += 2;
  }
}
