all: build

build: octedit.uf2

octedit.uf2: octedit.elf
	../elf/elf2uf2 octedit.elf octedit.uf2

objects = uart.o main.o octedit.o

octedit.elf: $(objects)
	arm-none-eabi-ld -T pico_persist.ld -o octedit.elf $(objects) ../setup/setup.so
	./checksum_pico_elf.py octedit.elf

$(objects): %.o: %.s
	arm-none-eabi-as -o $@ $<

clean:
	rm octedit.elf octedit.uf2 *.o

flash: octedit.uf2
	[ -h /dev/disk/by-label/RPI-RP2 ] || sleep 3s
	cat octedit.uf2 > /dev/disk/by-label/RPI-RP2
