all: build

build: assemble.uf2

assemble.uf2: assemble.elf
	../elf/elf2uf2 assemble.elf assemble.uf2

objects = main.o uart.o assemble.o register.o octal.o opcode.o

assemble.elf: $(objects)
	arm-none-eabi-ld -T pico_ram_only.ld -o assemble.elf $(objects) ../setup/setup.so

$(objects): %.o: %.s
	arm-none-eabi-as -o $@ $<

clean:
	rm assemble.elf assemble.uf2 *.o

flash: assemble.uf2
	[ -h /dev/disk/by-label/RPI-RP2 ] || sleep 2s
	cat assemble.uf2 > /dev/disk/by-label/RPI-RP2
