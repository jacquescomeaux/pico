.PHONY: hexedit
hexedit: octedit
	sleep 1
	$(MAKE) -C hexedit serial

.PHONY: octedit
octedit:
	$(MAKE) -C octedit flash
