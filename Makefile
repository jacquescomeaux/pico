all: build

build: blink.uf2

blink.uf2: blink.elf
	./elf2uf2 blink.elf blink.uf2

objects = main.o blink.o clocks.o gpio.o pll.o uart.o xosc.o

blink.elf: $(objects)
	arm-none-eabi-ld -T pico_ram_only.ld -o blink.elf $(objects)

$(objects): %.o: %.s
	arm-none-eabi-as -o $@ $<

clean:
	rm blink.elf blink.uf2 *.o
