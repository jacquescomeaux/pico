#include <stdio.h>
#include <unistd.h>
#include <stdint.h>

#define DATA_LEN 252
#define DIVISOR 0x04C11DB7

int main() {
  uint8_t data[DATA_LEN];
  read(STDIN_FILENO, data, DATA_LEN);
  uint32_t crc = 0xFFFFFFFF;
  for (size_t i = 0; i < DATA_LEN; i++) {
    crc ^= data[i] << 24;
    for (uint8_t j = 0; j < 8; j++) {
      uint8_t nskip = crc >> 31;
      crc <<= 1;
      if (nskip) crc ^= DIVISOR;
    }
  }
  write(STDOUT_FILENO, (uint8_t *) &crc, 4);
  return 0;
}
