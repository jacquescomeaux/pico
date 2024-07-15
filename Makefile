.PHONY: assembler
assembler: hexedit
	sleep 1
	$(MAKE) -C assembler serial

.PHONY: hexedit
hexedit: octedit
	sleep 1
	$(MAKE) -C hexedit serial

.PHONY: octedit
octedit:
	$(MAKE) -C octedit flash

.PHONY: serial
serial:
	$(MAKE) -C hexedit serial
	$(MAKE) -C assembler serial
