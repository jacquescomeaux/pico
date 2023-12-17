all: build

build: blink.uf2

# convert ELF file to UF2 file
blink.uf2: blink.elf
	elf2uf2 blink.elf blink.uf2

# compile
blink.elf: blink.o
	arm-none-eabi-ld -T pico_ram_only.ld -o blink.elf blink.o

blink.o: blink.s
	arm-none-eabi-as -o blink.o blink.s

# flash: build/blink.uf2
# 	cp build/blink.uf2 /Volumes/RPI-RP2

clean:
	rm blink.elf blink.uf2 blink.o
