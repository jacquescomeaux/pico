PICO = /dev/disk/by-label/RPI-RP2

assemble.uf2: assemble.elf
	../elf/elf2uf2 assemble.elf assemble.uf2

objects = main.o uart.o assemble.o register.o octal.o opcode.o

assemble.elf: $(objects)
	arm-none-eabi-ld -T pico_ram_only.ld -o assemble.elf $(objects) ../setup/setup.so

$(objects): %.o: %.s
	arm-none-eabi-as -o $@ $<

.PHONY: clean
clean:
	rm assemble.elf assemble.uf2 *.o

.PHONY: flash
flash: $(PICO) assemble.uf2
	cat assemble.uf2 > $(PICO)

.PHONY: check
check: $(PICO)
	@echo Ready to flash

$(PICO):
	@echo "RPI-RP2 bootloader drive not found"
	@echo Connect the pico with USB cable while holding bootsel button
	@false
