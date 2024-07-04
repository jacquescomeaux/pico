.PHONY: hexedit
hexedit: octedit
	$(MAKE) -C hexedit serial

.PHONY: octedit
octedit:
	$(MAKE) -C octedit flash

