PICO = /dev/disk/by-label/RPI-RP2

octedit.uf2: octedit.bin
	echo -ne "\x55\x46\x32\x0A" > octedit.uf2  # Magic 0
	echo -ne "\x57\x51\x5D\x9E" >> octedit.uf2 # Magic 1
	echo -ne "\x00\x20\x00\x00" >> octedit.uf2 # Flags
	echo -ne "\x00\x00\x00\x10" >> octedit.uf2 # Load address
	echo -ne "\x00\x01\x00\x00" >> octedit.uf2 # Data size
	echo -ne "\x00\x00\x00\x00" >> octedit.uf2 # Block number
	echo -ne "\x01\x00\x00\x00" >> octedit.uf2 # Number of blocks
	echo -ne "\x56\xFF\x8B\xE4" >> octedit.uf2 # RP2040 family ID
	cat octedit.bin >> octedit.uf2             # Data
	printf %220s | tr " " "\0" >> octedit.uf2  # 0 padding
	echo -ne "\x30\x6F\xB1\x0A" >> octedit.uf2 # Magic end

octedit.bin: octedit.elf crc32
	arm-none-eabi-objcopy -O binary octedit.elf octedit.bin
	./crc32 < octedit.bin >> octedit.bin

objects = setup.o octedit.o uart.o

octedit.elf: $(objects) pico_persist.ld
	arm-none-eabi-ld -T pico_persist.ld -o octedit.elf $(objects)

$(objects): %.o: %.s
	arm-none-eabi-as -o $@ $<

.PHONY: clean
clean:
	rm octedit.elf octedit.bin octedit.uf2 *.o crc32

.PHONY: flash
flash: $(PICO) octedit.uf2
	cat octedit.uf2 > $(PICO)

.PHONY: check
check: $(PICO)
	@echo Ready to flash

$(PICO):
	@echo "RPI-RP2 bootloader drive not found"
	@echo Connect the pico with USB cable while holding bootsel button
	@false
