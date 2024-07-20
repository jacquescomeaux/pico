DEVICE = /dev/ttyUSB0

objects = string.as data.as main.as

.PHONY: serial
serial: $(objects) slowcat
	cat $(objects) | tr "\n" "\r" | ./slowcat | picocom -b 115200 -q $(DEVICE)
	@echo
