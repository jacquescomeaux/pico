PICO = /dev/disk/by-label/RPI-RP2
DEVICE = /dev/ttyUSB0

.PHONY: build
build: parse.he

parse.he: parse.bin
	od -An -tx2 -v parse.bin | sed "s/^ //" | tr " " "\n" | tr [:lower:] [:upper:] | sed "s/^/0x/" > parse.he

parse.bin: parse.elf
	arm-none-eabi-objcopy -O binary parse.elf parse.bin

objects = main.o uart.o data.o string.o input.o

parse.elf: pico_bin.ld $(objects)
	arm-none-eabi-ld -T pico_bin.ld -o parse.elf $(objects)

$(objects): %.o: %.s
	arm-none-eabi-as -o $@ $<

.PHONY: clean
clean:
	rm -f parse.elf parse.bin parse.he slowcat $(objects)

.PHONY: dump
dump: parse.bin
	@od -Ax -tx2 -v parse.bin

.PHONY: serial
serial: $(DEVICE) parse.he slowcat
	cat parse.he | tr "\n" "\r" | ./slowcat | picocom -b 115200 -q $(DEVICE)
	@echo
	echo -n "G" | picocom -b 115200 -q $(DEVICE)
	@echo

$(DEVICE):
	@echo Serial device not found
	@echo Connect USB cable from USB-UART bridge
	@false
