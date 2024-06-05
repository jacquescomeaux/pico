all: build

build: hexedit.uf2

hexedit.uf2: hexedit.elf
	../elf/elf2uf2 hexedit.elf hexedit.uf2

objects = uart.o main.o hexedit.o

hexedit.elf: $(objects)
	arm-none-eabi-ld -T pico_persist.ld -o hexedit.elf $(objects) ../setup/setup.so
	./checksum_pico_elf.py hexedit.elf

$(objects): %.o: %.s
	arm-none-eabi-as -o $@ $<

clean:
	rm hexedit.elf hexedit.uf2 *.o

flash: hexedit.uf2
	[ -h /dev/disk/by-label/RPI-RP2 ] || sleep 3s
	cat hexedit.uf2 > /dev/disk/by-label/RPI-RP2
