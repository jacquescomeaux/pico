PICO_UART=/dev/ttyUSB0

all: build

build: hexedit.uf2

dump: hexedit.bin
	od hexedit.bin

serial: hexedit.oe
	[ -c PICO_UART ] && \
		(cat hexedit.oe | tr "\n" "\r" > PICO_UART ; echo -n "G" > PICO_UART) || \
		echo No serial device

hexedit.oe: hexedit.bin
	od -An -v hexedit.bin | sed "s/^ //" | tr " " "\n" > hexedit.oe

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
	rm -f hexedit.elf hexedit.uf2 hexedit.bin hexedit.oe *.o

flash: hexedit.uf2
	[ -h /dev/disk/by-label/RPI-RP2 ] || sleep 3s
	cat hexedit.uf2 > /dev/disk/by-label/RPI-RP2
