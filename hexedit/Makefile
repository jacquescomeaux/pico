all: build

build: echo.uf2

echo.uf2: echo.elf
	../elf/elf2uf2 echo.elf echo.uf2

objects = main.o xosc.o clocks.o gpio.o uart.o

echo.elf: $(objects)
	arm-none-eabi-ld -T pico_ram_only.ld -o echo.elf $(objects)

$(objects): %.o: %.s
	arm-none-eabi-as -o $@ $<

clean:
	rm echo.elf echo.uf2 *.o

flash: echo.uf2
	[ -h /dev/disk/by-label/RPI-RP2 ] || sleep 2s
	cat echo.uf2 > /dev/disk/by-label/RPI-RP2
