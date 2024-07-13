PICO = /dev/disk/by-label/RPI-RP2
DEVICE = /dev/ttyUSB0

.PHONY: build
build: hexedit.oe

hexedit.oe: hexedit.bin
	od -An -v hexedit.bin | sed "s/^ //" | tr " " "\n" > hexedit.oe

hexedit.bin: hexedit.elf
	arm-none-eabi-objcopy -O binary hexedit.elf hexedit.bin

hexedit.elf: pico_bin.ld hexedit.o
	arm-none-eabi-ld -T pico_bin.ld -o hexedit.elf hexedit.o

hexedit.o: hexedit.s
	arm-none-eabi-as -o hexedit.o hexedit.s

.PHONY: clean
clean:
	rm -f hexedit.elf hexedit.bin hexedit.oe hexedit.o slowcat

.PHONY: dump
dump: hexedit.bin
	@od hexedit.bin

.PHONY: serial
serial: $(DEVICE) hexedit.oe slowcat
	cat hexedit.oe | tr "\n" "\r" | ./slowcat | picocom -b 115200 -q $(DEVICE)
	@echo
	echo -n "G" | picocom -b 115200 -q $(DEVICE)
	@echo

$(DEVICE):
	@echo Serial device not found
	@echo Connect USB cable from USB-UART bridge
	@false
