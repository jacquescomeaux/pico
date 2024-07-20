#include <unistd.h>
#include <stdint.h>

int main() {
  uint8_t byte;
  while (read(STDIN_FILENO, &byte, 1)) {
    write(STDOUT_FILENO, &byte, 1);
    usleep(10000);
  }
  return 0;
}
