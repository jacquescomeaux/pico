DEVICE = /dev/ttyUSB0

.PHONY: build
build: assemble.he

assemble.he: assemble.bin
	od -An -tx2 -v assemble.bin | sed "s/^ //" | tr " " "\n" | tr [:lower:] [:upper:] | sed "s/^/0x/" > assemble.he

assemble.bin: assemble.elf
	arm-none-eabi-objcopy -O binary assemble.elf assemble.bin

objects = main.o uart.o assemble.o register.o octal.o opcode.o

assemble.elf: pico_bin.ld $(objects)
	arm-none-eabi-ld -T pico_bin.ld -o assemble.elf $(objects)

$(objects): %.o: %.s
	arm-none-eabi-as -o $@ $<

.PHONY: clean
clean:
	rm assemble.elf assemble.bin assemble.he *.o slowcat

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
