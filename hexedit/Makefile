all: build

build: hexedit.uf2

dump: hexedit.bin
	hexdump -o hexedit.bin

hexedit.bin: hexedit.o
	arm-none-eabi-ld -T pico_bin.ld -o hexedit.bin hexedit.o
	arm-none-eabi-objcopy -O binary hexedit.bin

hexedit.uf2: hexedit.elf
	../elf/elf2uf2 hexedit.elf hexedit.uf2

objects = hexedit.o main.o

hexedit.elf: $(objects)
	arm-none-eabi-ld -T pico_ram_only.ld -o hexedit.elf $(objects) ../setup/setup.so

$(objects): %.o: %.s
	arm-none-eabi-as -o $@ $<

clean:
	rm hexedit.elf hexedit.uf2 hexedit.bin *.o

flash: hexedit.uf2
	[ -h /dev/disk/by-label/RPI-RP2 ] || sleep 3s
	cat hexedit.uf2 > /dev/disk/by-label/RPI-RP2
