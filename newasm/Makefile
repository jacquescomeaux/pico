PICO = /dev/disk/by-label/RPI-RP2
DEVICE = /dev/ttyUSB0

.PHONY: build
build: assemble.he

assemble.he: assemble.bin
	od -An -tx2 -v assemble.bin | sed "s/^ //" | tr " " "\n" | tr [:lower:] [:upper:] | sed "s/^/0x/" > assemble.he

assemble.bin: assemble.elf
	arm-none-eabi-objcopy -O binary assemble.elf assemble.bin

objects = main.o uart.o data.o string.o input.o \
					statement.o optable.o \
					regreg.o regregimm.o regimm.o regregreg.o imm.o \
					parsers/whitespace.o \
					parsers/label.o \
					parsers/symbol.o \
					parsers/opcode.o \
					parsers/register.o \
					parsers/decimal.o \
					parsers/immediate.o

assemble.elf: pico_bin.ld $(objects)
	arm-none-eabi-ld -T pico_bin.ld -o assemble.elf $(objects)

$(objects): %.o: %.s
	arm-none-eabi-as -o $@ $<

.PHONY: clean
clean:
	rm -f assemble.elf assemble.bin assemble.he slowcat $(objects)

.PHONY: dump
dump: assemble.bin
	@od -Ax -tx2 -v assemble.bin

.PHONY: serial
serial: $(DEVICE) assemble.he slowcat
	cat assemble.he | tr "\n" "\r" | ./slowcat | picocom -b 115200 -q $(DEVICE)
	@echo
	echo -n "G" | picocom -b 115200 -q $(DEVICE)
	@echo

$(DEVICE):
	@echo Serial device not found
	@echo Connect USB cable from USB-UART bridge
	@false
