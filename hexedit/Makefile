PICO = /dev/disk/by-label/RPI-RP2
PICO_CONSOLE = /dev/ttyUSB0

.PHONY: build
build: hexedit.oe

hexedit.oe: hexedit.bin
	od -An -v hexedit.bin | sed "s/^ //" | tr " " "\n" > hexedit.oe

hexedit.bin: hexedit.o
	arm-none-eabi-ld -T pico_bin.ld -o hexedit.bin hexedit.o
	arm-none-eabi-objcopy -O binary hexedit.bin

objects = hexedit.o main.o

$(objects): %.o: %.s
	arm-none-eabi-as -o $@ $<

hexedit.uf2: hexedit.elf
	../elf/elf2uf2 hexedit.elf hexedit.uf2

hexedit.elf: $(objects)
	arm-none-eabi-ld -T pico_ram_only.ld -o hexedit.elf $(objects) ../setup/setup.so

.PHONY: clean
clean:
	rm -f hexedit.elf hexedit.uf2 hexedit.bin hexedit.oe *.o

.PHONY: dump
dump: hexedit.bin
	@od hexedit.bin

.PHONY: serial
serial: $(PICO_CONSOLE) hexedit.oe
	cat hexedit.oe | tr "\n" "\r" > PICO_CONSOLE
	echo -n "G" > PICO_CONSOLE

$(PICO_CONSOLE):
	@echo Serial device not found
	@echo Connect USB cable from USB-UART bridge
	@false

.PHONY: flash
flash: $(PICO) hexedit.uf2
	cat hexedit.uf2 > $(PICO)

$(PICO):
	@echo "RPI-RP2 bootloader drive not found"
	@echo Connect the pico with USB cable while holding bootsel button
	@false
