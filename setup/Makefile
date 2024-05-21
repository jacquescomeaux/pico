all: build

build: setup.so

objects = xosc.o clocks.o gpio.o uart.o

setup.so: $(objects)
	arm-none-eabi-ld -r -T combine.ld -o setup.so $(objects)

$(objects): %.o: %.s
	arm-none-eabi-as -o $@ $<

clean:
	rm setup.so *.o
